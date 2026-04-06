include {
  path = find_in_parent_folders("root.hcl")
}

dependency "iam" {
  config_path = "../../iam/ec2-role"

  mock_outputs = {
    role_arn = "arn:aws:iam::123456789012:role/mock-role"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

# ← firehose dependency completely removed

terraform {
  source = "${get_repo_root()}/modules/search/opensearch"
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

inputs = {
  name        = "panacea"
  environment = local.env.locals.environment

  network_policy_name = "panacea-aoss-network"
  access_policy_name  = "panacea-aoss-log-access"

  # Only EC2 role here — Firehose role added separately below
  principals = [
    dependency.iam.outputs.role_arn
  ]
}