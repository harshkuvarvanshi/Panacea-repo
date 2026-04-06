include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/Monitoring/CloudWatch"
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# ── Dependencies ──────────────────────────────────────────

dependency "firehose" {
  config_path = "../logging/firehose"

  mock_outputs = {
    firehose_arn = "arn:aws:firehose:ap-south-1:123456789012:deliverystream/mock"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

# ── Inputs ────────────────────────────────────────────────
inputs = {
  log_group_name = "/panacea/ec2/logs"
  aws_account_id = local.env.locals.aws_account_id
  aws_region     = local.env.locals.aws_region
  environment    = local.env.locals.environment

  retention_days = 7
  filter_pattern = ""
  firehose_arn   = dependency.firehose.outputs.firehose_arn
}
