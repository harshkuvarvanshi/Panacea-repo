include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/database/aurora"
}

dependency "vpc" {
  config_path = "../../networking/vpc"
}

dependency "aurora_sg" {
  config_path = "../../networking/security-group/aurora-sg"
}

inputs = {
  name        = "dev-aurora"
  environment = "dev"

  vpc_id = dependency.vpc.outputs.vpc_id

  subnet_ids = dependency.vpc.outputs.private_subnet_ids

  security_group_ids = [
    dependency.aurora_sg.outputs.security_group_id
  ]

  db_name     = "mydb"
  db_username = "admin"
  db_password = "StrongPassword123!"

  instance_count = 2   
}