terraform {
  backend "s3" {}
}

# =========================================
# CLOUDWATCH LOG GROUP
# =========================================
resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group_name
  retention_in_days = var.retention_days

  tags = {
    Name        = var.log_group_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# =========================================
# IAM ROLE — CloudWatch → Firehose
# CloudWatch Logs needs permission to put
# records into Firehose on your behalf.
# =========================================
resource "aws_iam_role" "cloudwatch_to_firehose" {
  name = "${replace(var.log_group_name, "/", "-")}-cw-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "logs.${var.aws_region}.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringLike = {
            "aws:SourceArn" = "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_to_firehose" {
  name = "allow-firehose-put"
  role = aws_iam_role.cloudwatch_to_firehose.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ]
        Resource = var.firehose_arn
      }
    ]
  })
}

# =========================================
# SUBSCRIPTION FILTER (CloudWatch → Firehose)
# Routes all log events to Firehose stream.
# filter_pattern = "" means ALL log events.
# =========================================
resource "aws_cloudwatch_log_subscription_filter" "this" {
  name            = "${var.log_group_name}-to-firehose"
  log_group_name  = aws_cloudwatch_log_group.this.name
  filter_pattern  = var.filter_pattern
  destination_arn = var.firehose_arn
  role_arn        = aws_iam_role.cloudwatch_to_firehose.arn

  depends_on = [
    aws_cloudwatch_log_group.this,
    aws_iam_role_policy.cloudwatch_to_firehose
  ]
}
