include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/database/aurora"
}

# dependency on VPC
dependency "vpc" {
  config_path = "../../networking/vpc"
}

inputs = {
  name = "dev-aurora"

  vpc_id = dependency.vpc.outputs.vpc_id

  subnet_ids = dependency.vpc.outputs.private_subnet_ids

  allowed_cidr_blocks = ["10.0.0.0/16"]

  db_username = "admin"
  db_password = "StrongPassword123!"
}