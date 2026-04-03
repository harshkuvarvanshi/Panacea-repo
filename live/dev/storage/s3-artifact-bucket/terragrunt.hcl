include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/storage/s3-bucket"
}

inputs = {
  name = "panacea-artifacts-bucket-dev"

  # Security
  block_public_access = true
  enable_encryption   = true
  enable_versioning   = true

  # Lifecycle (cost optimization)
  enable_lifecycle = true

  lifecycle_rules = [
    {
      id              = "expire-logs"
      enabled         = true
      expiration_days = 30
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "panacea"
    Name        = "artifacts-bucket"
  }
}











# # ==========================================================
# # S3 Artifact Bucket (Private)
# # ==========================================================
# terraform {
#   source = "../../../modules/storage/s3-bucket"
# }

# include {
#   path = find_in_parent_folders("root.hcl")
# }

# inputs = {
#   bucket_name = "panacea-logs-bucket-dev"

# # =============================================================
# # Security
# # =============================================================
#   block_public_access = true
#   enable_encryption   = true

#   # 🔁 Lifecycle (Cost optimization)
#   enable_lifecycle = true
#   lifecycle_rules = [
#     {
#       id              = "log-expiration"
#       enabled         = true
#       expiration_days = 30
#     }
#   ]

#   # ======================================================
#   # Folder structure (prefixes)
#   # ======================================================
#   log_prefixes = {
#     alb         = "alb/"
#     cloudfront  = "cloudfront/"
#     api_gateway = "api-gateway/"
#     ec2         = "ec2/"
#     rigs        = "device-rigs/"
#   }

#   # ======================================================
#   #  Dummy dependencies (REPLACE LATER)
#   # ======================================================
#   dependencies = {
#     alb = {
#       arn  = "dummy-alb-arn"   # 🔁 Replace with real ALB ARN
#       name = "dummy-alb-name"
#     }

#     cloudfront = {
#       distribution_id = "dummy-cf-id"   # 🔁 Replace with CloudFront Distribution ID
#     }

#     api_gateway = {
#       rest_api_id = "dummy-api-id"   # 🔁 Replace with API Gateway ID
#     }

#     ec2 = {
#       instance_role = "dummy-ec2-role"   # 🔁 Replace with IAM Role attached to EC2
#     }

#     rigs = {
#       iam_role = "dummy-rigs-role"   # 🔁 Replace with IAM Role for Local Rigs
#     }
#   }

#   tags = {
#     Environment = "dev"
#     Project     = "panacea"
#     Name        = "logs-bucket"
#   }
# }

# 🔽 FUTURE REAL DEPENDENCIES (Uncomment later)

# dependency "alb" {
#   config_path = "../../networking/alb"
# }

# dependency "cloudfront" {
#   config_path = "../../cdn/cloudfront"
# }

# dependency "api_gateway" {
#   config_path = "../../networking/api-gateway"
# }

# dependency "ec2" {
#   config_path = "../../compute/ec2-device-backend"
# }

# dependency "rigs" {
#   config_path = "../../compute/ec2-rig"
# }
















# include {
#   path = find_in_parent_folders("root.hcl")
# }

# terraform {
#   source = "${get_repo_root()}/modules/storage/s3-bucket"
# }

# inputs = {
#   name               = "panacea-artifact-dev-2026"
#   force_destroy      = false
#   versioning_enabled = true
# }