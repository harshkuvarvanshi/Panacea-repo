include {
  path = find_in_parent_folders("root.hcl")
}

dependency "iam" {
  config_path = "../../iam/ec2-role"
}

terraform {
  source = "${get_repo_root()}/modules/search/opensearch"
}
inputs = {
  name                = "panacea"
  network_policy_name = "auto-aoss-panacea"
  access_policy_name  = "panacea-aoss-log-access"

  principals = [
    "arn:aws:iam::123456789012:role/panacea-ec2-role"
  ]
}