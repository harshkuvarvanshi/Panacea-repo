include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/integration/s3-cloudfront-policy"
}

dependency "s3" {
  config_path = "../../storage/s3-frontend"

  mock_outputs = {
    bucket_id  = "mock-bucket-name"
    bucket_arn = "arn:aws:s3:::mock-bucket-name"
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

dependency "cloudfront" {
  config_path = "../../cdn/cloudfront"

  mock_outputs = {
    distribution_arn = "arn:aws:cloudfront::123456789012:distribution/EDFDVBD6EXAMPLE"
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

inputs = {
  bucket_id                   = dependency.s3.outputs.bucket_id
  bucket_arn                  = dependency.s3.outputs.bucket_arn
  cloudfront_distribution_arn = dependency.cloudfront.outputs.distribution_arn
}