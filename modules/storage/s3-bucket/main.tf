# ## Tag name change kerna h sab me 



# # ================================
# # S3 BUCKET
# # ================================

# resource "aws_s3_bucket" "this" {
#   bucket        = var.name
#   force_destroy = var.force_destroy

#   tags = {
#     Name       = var.name
#     Deployment = "manual"
#     # 👉 Requirement ke according tag
#   }
# }

# # ================================
# # OBJECT OWNERSHIP (ACL DISABLED)
# # ================================

# resource "aws_s3_bucket_ownership_controls" "this" {
#   bucket = aws_s3_bucket.this.id

#   rule {
#     object_ownership = "BucketOwnerEnforced"
#     # 👉 ACL completely disable ho jati hai
#   }
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
#   # 👉 Fully private bucket (requirement)
# }

# # ================================
# # VERSIONING
# # ================================

# resource "aws_s3_bucket_versioning" "this" {
#   bucket = aws_s3_bucket.this.id

#   versioning_configuration {
#     status = var.versioning_enabled ? "Enabled" : "Suspended"
#   }
# }

# # ================================
# # ENCRYPTION (SSE-S3)
# # ================================

# resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
#   bucket = aws_s3_bucket.this.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#       # 👉 SSE-S3 (Amazon managed key)
#     }
#   }
# }