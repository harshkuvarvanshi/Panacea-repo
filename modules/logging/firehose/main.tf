terraform {
  backend "s3" {}
}

# =========================================
# IAM ROLE — Firehose Service Role
# Firehose assumes this role to write to
# OpenSearch Serverless and S3 (backup).
# =========================================
resource "aws_iam_role" "firehose" {
  name = "${var.name}-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.aws_account_id
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.name}-firehose-role"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# =========================================
# IAM POLICY — Firehose Permissions
# Needs: OpenSearch (aoss), S3 (backup),
# CloudWatch Logs (error logging),
# Kinesis (if reading from a stream)
# =========================================
resource "aws_iam_role_policy" "firehose" {
  name = "${var.name}-firehose-policy"
  role = aws_iam_role.firehose.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ── OpenSearch Serverless ──────────────────────────────
      {
        Sid    = "AllowOpenSearchServerless"
        Effect = "Allow"
        Action = [
          "aoss:APIAccessAll"
        ]
        Resource = var.collection_arn
      },

      # ── S3 (backup for failed records) ────────────────────
      {
        Sid    = "AllowS3Backup"
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Resource = [
          var.backup_bucket_arn,
          "${var.backup_bucket_arn}/*"
        ]
      },

      # ── CloudWatch Logs (Firehose error logs) ─────────────
      {
        Sid    = "AllowCloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:/aws/kinesisfirehose/${var.name}:*"
      }
    ]
  })
}

# =========================================
# CLOUDWATCH LOG GROUP — Firehose errors
# Firehose uses this to report delivery
# failures (e.g. OpenSearch rejects a doc)
# =========================================
resource "aws_cloudwatch_log_group" "firehose_errors" {
  name              = "/aws/kinesisfirehose/${var.name}"
  retention_in_days = 7

  tags = {
    Name        = "/aws/kinesisfirehose/${var.name}"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_stream" "opensearch_delivery" {
  name           = "opensearch-delivery"
  log_group_name = aws_cloudwatch_log_group.firehose_errors.name
}

resource "aws_cloudwatch_log_stream" "s3_backup" {
  name           = "s3-backup-delivery"
  log_group_name = aws_cloudwatch_log_group.firehose_errors.name
}

# =========================================
# KINESIS FIREHOSE DELIVERY STREAM
# Source  : CloudWatch Logs (via subscription filter)
# Dest    : OpenSearch Serverless
# Backup  : S3 (for ALL records — useful for reindex)
# Buffering: 5 MB or 60s (whichever hits first)
# =========================================
resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = var.name
  destination = "opensearchserverless"

  # ── OpenSearch Serverless destination ──────────────────────
  opensearchserverless_configuration {
    collection_endpoint = var.collection_endpoint
    index_name          = var.index_name
    role_arn            = aws_iam_role.firehose.arn

    # Buffering — flush every 5 MB or 60 seconds
    buffering_size     = 5
    buffering_interval = 60

    # Retry for 300 seconds before sending to S3
    retry_duration = 300

    # ── S3 backup config (ALL records, not just failed) ──────
    # Keeping all records lets you re-index later without loss
    s3_backup_mode = "AllDocuments"

    s3_configuration {
      role_arn           = aws_iam_role.firehose.arn
      bucket_arn         = var.backup_bucket_arn
      prefix             = "firehose/opensearch-backup/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
      error_output_prefix = "firehose/opensearch-errors/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/"
      buffering_size     = 10
      buffering_interval = 300
      compression_format = "GZIP"

      cloudwatch_logging_options {
        enabled         = true
        log_group_name  = aws_cloudwatch_log_group.firehose_errors.name
        log_stream_name = aws_cloudwatch_log_stream.s3_backup.name
      }
    }

    # ── Firehose error log delivery ───────────────────────────
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose_errors.name
      log_stream_name = aws_cloudwatch_log_stream.opensearch_delivery.name
    }

    # ── Document ID — optional, let OpenSearch auto-generate
    # Uncomment to use a field from the log as the doc ID:
    # document_id_options {
    #   default_document_id_format = "FIREHOSE_DEFAULT"
    # }
  }

  tags = {
    Name        = var.name
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  depends_on = [
    aws_iam_role_policy.firehose,
    aws_cloudwatch_log_stream.opensearch_delivery,
    aws_cloudwatch_log_stream.s3_backup
  ]
}

# =========================================
# OPENSEARCH DATA ACCESS POLICY — Firehose
# Separate from the EC2 policy in the
# opensearch module to avoid circular deps.
# Firehose role needs index write access.
# =========================================
resource "aws_opensearchserverless_access_policy" "firehose" {
  name = "${var.name}-fh-access"
  type = "data"

  policy = jsonencode([
    {
      Rules = [
        {
          Resource     = ["collection/${var.collection_name}"]
          Permission   = [
            "aoss:CreateCollectionItems",
            "aoss:DescribeCollectionItems"
          ]
          ResourceType = "collection"
        },
        {
          Resource = ["index/${var.collection_name}/*"]
          Permission = [
            "aoss:CreateIndex",
            "aoss:DescribeIndex",
            "aoss:UpdateIndex",
            "aoss:ReadDocument",
            "aoss:WriteDocument"
          ]
          ResourceType = "index"
        }
      ]
      Principal = [aws_iam_role.firehose.arn]
    }
  ])
}