# ==========================================================
# S3 Frontend Bucket
# ==========================================================


# 🔽 FUTURE DEPENDENCY (CloudFront attach hoga)

# dependency "cloudfront" {
#   config_path = "../../cdn/cloudfront"
# }

include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/storage/s3-bucket"
}

dependency "cloudfront" {
  config_path = "../../cdn/cloudfront"

  mock_outputs = {
    distribution_arn = "dummy-arn"
  }
}


inputs = {
  bucket_name = "panacea-frontend-bucket-dev"

  # Static Website Hosting
  enable_static_website = true
  index_document        = "index.html"
  error_document        = "index.html"

  # Security (dev me temporarily open)
  block_public_access = false   # ⚠️ Later CloudFront ke sath private karna

  # 🔐 Encryption
  enable_encryption = true

  # 🔁 Versioning
  enable_versioning = true

  # Real value (auto replace hoga)
  cloudfront_distribution_arn = dependency.cloudfront.outputs.distribution_arn


  # 🌍 CORS (Frontend → API Gateway calls)
  cors_rules = [
    {
      allowed_methods = ["GET", "POST", "PUT", "DELETE"]
      allowed_origins = ["*"]   # ⚠️ Later restrict karna
      allowed_headers = ["*"]
      max_age_seconds = 3000
    }
  ]



  tags = {
    Environment = "dev"
    Project     = "panacea"
    Name        = "frontend-bucket"
  }
}



















# include {
#   path = find_in_parent_folders("root.hcl")
# }

# terraform {
#   source = "${get_repo_root()}/modules/storage/s3"
# }

# inputs = {
#   name               = "panacea-frontend"
#   force_destroy      = true
#   versioning_enabled = false
# }