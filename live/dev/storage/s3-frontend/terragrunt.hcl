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

  #cloudfront_distribution_arn = dependency.cloudfront.outputs.distribution_arn # it enable when we use oai



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








