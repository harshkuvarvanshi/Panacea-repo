# include {
#   path = find_in_parent_folders("root.hcl")
# }

# terraform {
#   source = "${get_repo_root()}/modules/logging/firehose"
# }

# locals {
#   env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
# }

# dependency "opensearch" {
#   config_path = "../../search/opensearch"

#   mock_outputs = {
#     collection_arn      = "arn:aws:aoss:ap-south-1:123456789012:collection/mock"
#     collection_endpoint = "https://mockid.ap-south-1.aoss.amazonaws.com"
#   }
#   mock_outputs_allowed_terraform_commands = ["validate", "plan"]
# }

# dependency "s3_artifacts" {
#   config_path = "../../storage/s3-artifact-bucket"

#   mock_outputs = {
#     bucket_arn = "arn:aws:s3:::mock-artifacts-bucket"
#   }
#   mock_outputs_allowed_terraform_commands = ["validate", "plan"]
# }

# inputs = {
#   name            = "panacea-log-stream"
#   environment     = local.env.locals.environment
#   aws_region      = local.env.locals.aws_region
#   aws_account_id  = local.env.locals.aws_account_id

#   collection_name     = "panacea"
#   collection_arn      = dependency.opensearch.outputs.collection_arn
#   collection_endpoint = dependency.opensearch.outputs.collection_endpoint
#   index_name          = "panacea-logs"

#   backup_bucket_arn = dependency.s3_artifacts.outputs.bucket_arn
# }