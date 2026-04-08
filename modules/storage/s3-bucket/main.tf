
terraform {
  backend "s3" {}
}


# ================================
# S3 BUCKET
# ================================
resource "aws_s3_bucket" "this" {
  bucket        = var.name
  force_destroy = var.force_destroy

  tags = {
    Name       = var.name
    Deployment = "terragrunt"
  }
}

# ================================
# OWNERSHIP (DYNAMIC)
# ================================
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# =================================
# OBJECT OWNERSHIP (ACL DISABLED)
# =================================
# resource "aws_s3_bucket_ownership_controls" "this" {
#   bucket = aws_s3_bucket.this.id

#   rule {
#     object_ownership =  "ObjectWriter"    #"BucketOwnerEnforced"
#   }
# }

# resource "aws_s3_bucket_acl" "this" {
#   bucket = aws_s3_bucket.this.id
#   acl    = "log-delivery-write"
# }


# # ================================
# # PUBLIC ACCESS BLOCK (ALL TRUE)
# # ================================
# resource "aws_s3_bucket_public_access_block" "this" {
#   bucket = aws_s3_bucket.this.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
#   # Fully private bucket (requirement)
# }
# ================================
# PUBLIC ACCESS BLOCK (DYNAMIC)
# ================================
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.enable_acl ? false : true
  ignore_public_acls      = var.enable_acl ? false : true
  block_public_policy     = true
  restrict_public_buckets = true
}

# ================================
# VERSIONING
# ================================
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}


# # ===============================
# # VERSIONING
# # ===============================
# resource "aws_s3_bucket_versioning" "this" {
#   bucket = aws_s3_bucket.this.id

#   versioning_configuration {
#     status = var.versioning_enabled ? "Enabled" : "Suspended"
#   }
# }


# ================================
# ENCRYPTION
# ================================
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
# # ================================
# # ENCRYPTION (SSE-S3)
# # ================================
# resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
#   bucket = aws_s3_bucket.this.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#       # SSE-S3 (Amazon managed key)
#     }
#   }
# }


# ====================================
# Bucket policy
# ====================================
locals {
  policy_statements = concat(

    # 1. CloudFront → S3 Read
   var.cloudfront_distribution_arn != null && var.cloudfront_distribution_arn != "" ? [{
      Sid    = "AllowCloudFrontRead"
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.this.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = var.cloudfront_distribution_arn
        }
      }
    }] : [],

    # 2. ALB → write logs
    var.enable_alb_logs ? [{
      Sid    = "AllowALBLogs"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::203221446879:root"
      }
      Action   = "s3:PutObject"
      Resource = "${aws_s3_bucket.this.arn}/alb/*"
    }] : [],

    # 3. CloudFront → write logs
    var.enable_alb_logs ? [{
      Sid    = "AllowCloudFrontLogs"
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:PutObject"
      Resource = "${aws_s3_bucket.this.arn}/cloudfront/*"
    }] : []
  )
}

# only creates policy if there are actual statements
resource "aws_s3_bucket_policy" "this" {
  count  = length(local.policy_statements) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.policy_statements
  })
}