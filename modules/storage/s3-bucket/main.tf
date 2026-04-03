## Tag name change kerna h sab me 

# terraform {
#   backend "s3" {}
# }


# ================================
# S3 BUCKET
# ================================
resource "aws_s3_bucket" "this" {
  bucket        = var.name
  force_destroy = var.force_destroy

  tags = {
    Name       = var.name
    Deployment = "manual"
    # Requirement ke according tag
  }
}


resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # 1. CloudFront → S3 Read (frontend serve)
      {
        Sid    = "AllowCloudFrontRead"
        Effect = "Allow"

        Principal = {
          Service = "cloudfront.amazonaws.com"
        }

        Action = "s3:GetObject"

        Resource = "${aws_s3_bucket.this.arn}/*"

        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_distribution_arn
          }
        }
      },

      # 2. ALB → write logs
      {
        Sid    = "AllowALBLogs"
        Effect = "Allow"

        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }

        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.this.arn}/alb/*"
      },

      #  3. CloudFront → write logs
      {
        Sid    = "AllowCloudFrontLogs"
        Effect = "Allow"

        Principal = {
          Service = "cloudfront.amazonaws.com"
        }

        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.this.arn}/cloudfront/*"
      }

    ]
  })
}
# ###################################
# # Bucket Policy
# ###################################
# resource "aws_s3_bucket_policy" "cloudfront_access" {
#   bucket = aws_s3_bucket.this.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowCloudFrontAccess"
#         Effect = "Allow"

#         Principal = {
#           Service = "cloudfront.amazonaws.com"
#         }

#         Action = "s3:GetObject"

#         Resource = "${aws_s3_bucket.this.arn}/*"

#         Condition = {
#           StringEquals = {
#             "AWS:SourceArn" = var.cloudfront_distribution_arn
#           }
#         }
#       }
#     ]
#   })
# }

# # #################################
# # Bucket policy for alb
# # #################################
# resource "aws_s3_bucket_policy" "alb_logs" {
#   bucket = aws_s3_bucket.this.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid    = "AllowALBLogs"
#         Effect = "Allow"

#         Principal = {
#           Service = "logdelivery.elasticloadbalancing.amazonaws.com"
#         }

#         Action = "s3:PutObject"

#         Resource = "${aws_s3_bucket.this.arn}/alb/*"
#       }
#     ]
#   })
# }

# # ###########################################
# # Bucket Policy for Cloud front 
# # ###########################################
# resource "aws_s3_bucket_policy" "logs_policy" {
#   bucket = aws_s3_bucket.this.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid = "AllowALBLogs"
#         Effect = "Allow"
#         Principal = {
#           Service = "logdelivery.elasticloadbalancing.amazonaws.com"
#         }
#         Action   = "s3:PutObject"
#         Resource = "${aws_s3_bucket.this.arn}/alb/*"
#       },
#       {
#         Sid = "AllowCloudFrontLogs"
#         Effect = "Allow"
#         Principal = {
#           Service = "cloudfront.amazonaws.com"
#         }
#         Action   = "s3:PutObject"
#         Resource = "${aws_s3_bucket.this.arn}/cloudfront/*"
#       }
#     ]
#   })
# }

# =================================
# OBJECT OWNERSHIP (ACL DISABLED)
# =================================
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
# resource "aws_s3_bucket_ownership_controls" "this" {
#   bucket = aws_s3_bucket.this.id

#   rule {
#     object_ownership = "BucketOwnerEnforced"
#     # ACL completely disable ho jati hai
#   }
# }

# ================================
# PUBLIC ACCESS BLOCK (ALL TRUE)
# ================================
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  # Fully private bucket (requirement)
}

# ===============================
# VERSIONING
# ===============================
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# ================================
# ENCRYPTION (SSE-S3)
# ================================
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
      # SSE-S3 (Amazon managed key)
    }
  }
}