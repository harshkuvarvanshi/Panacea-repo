include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/storage/s3-bucket"
}

# dependency "cloudfront" {
#   config_path = "../../cdn/cloudfront"
# }

inputs = {
  name = "panacea-frontend-bucket-dev"
  enable_acl      = false
  is_logs_bucket  = false

  enable_cloudfront_access = true
  cloudfront_distribution_arn = ""


  enable_static_website = true
  index_document        = "index.html"
  error_document        = "index.html"

  block_public_access = false

  enable_encryption = true
  enable_versioning = true

  tags = {
    Environment = "dev"
    Project     = "panacea"
  }
}








