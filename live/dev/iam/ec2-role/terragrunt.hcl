include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/iam/ec2-role"
}

inputs = {
  role_name = "panacea-ec2-role"
}