include {
  path = find_in_parent_folders("root.hcl")
}

# dependency "firehose" {
#   config_path = "../firehose"
# }

terraform {
  source = "${get_repo_root()}/modules/logging/cloudwatch"
}

inputs = {
  log_group_name = "/panacea/ec2/logs"
  environment    = "dev"
  retention_days = 7

  firehose_arn = dependency.firehose.outputs.firehose_arn
}