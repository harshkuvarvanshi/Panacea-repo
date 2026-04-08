# ====================================================
# This Terragrunt configuration deploys the CloudFront CDN module, 
# inherits common settings from root.hcl, 
# and connects it to the frontend S3 bucket (as origin) using its regional domain name to serve static content globally with low latency.

include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/cdn/cloudfront"
}


# Dependency is used to get outputs from another module (S3 frontend bucket)
# so that CloudFront can dynamically use the bucket's domain name as origin
dependency "s3_frontend" {
  config_path = "../../storage/s3-frontend"
}

# dependency "s3_artifacts" {
#   config_path = "../../storage/s3-artifact-bucket"
# }

inputs = {
  name = "panacea-cloudfront-dev"

  bucket_domain_name = dependency.s3_frontend.outputs.bucket_regional_domain_name
  #logs_bucket_domain_name = dependency.s3_artifacts.outputs.bucket_regional_domain_name


  tags = {
    Environment = "dev"
    Project     = "panacea"
  }
}




 