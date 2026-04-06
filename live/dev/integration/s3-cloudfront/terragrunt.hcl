include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/integration/s3-cloudfront-policy"
}

dependency "s3" {
  config_path = "../../storage/s3-frontend"
}

dependency "cloudfront" {
  config_path = "../../cdn/cloudfront"
}

inputs = {
  bucket_id                   = dependency.s3.outputs.bucket_id
  bucket_arn                  = dependency.s3.outputs.bucket_arn
  cloudfront_distribution_arn = dependency.cloudfront.outputs.distribution_arn
}