# This Terragrunt configuration attaches an S3 bucket policy to allow CloudFront to securely access 
# the frontend bucket using OAC. It uses dependencies to fetch S3 bucket details and CloudFront 
# distribution ARN dynamically, avoiding hardcoding and ensuring proper integration between services.

include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/integration/s3-cloudfront-policy"
}

# Dependency is used to get S3 bucket details (ID and ARN) for applying the policy
dependency "s3" {
  config_path = "../../storage/s3-frontend"
}

# Dependency is used to get CloudFront distribution ARN so access can be restricted to this specific CDN
dependency "cloudfront" {
  config_path = "../../cdn/cloudfront"
}

inputs = {
  bucket_id                   = dependency.s3.outputs.bucket_id
  bucket_arn                  = dependency.s3.outputs.bucket_arn
  cloudfront_distribution_arn = dependency.cloudfront.outputs.distribution_arn
}