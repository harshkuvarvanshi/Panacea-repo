include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/database/postgres"
}

dependency "vpc" {
  config_path = "../../networking/vpc"

  mock_outputs = {
    vpc_id              = "vpc-12345678"
    private_subnet_ids  = ["subnet-11111111", "subnet-22222222"]
    public_subnet_ids   = ["subnet-33333333", "subnet-44444444"]
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

dependency "postgres_sg" {
  config_path = "../../networking/security-group/postgres-sg"

  mock_outputs = {
    security_group_id = "sg-00000000"
  }
  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

inputs = {
  name        = "panacea-dev-postgres"
  environment = "dev"

  # ── Network ────────────────────────────────────────────────
  subnet_ids = dependency.vpc.outputs.private_subnet_ids

  security_group_ids = [
    dependency.postgres_sg.outputs.security_group_id
  ]

  # ── Engine ─────────────────────────────────────────────────
  engine_version = "15.14"
  instance_class = "db.t3.medium"

  # ── Storage ────────────────────────────────────────────────
  allocated_storage     = 20
  max_allocated_storage = 100

  # ── Database ───────────────────────────────────────────────
  db_name     = "panaceadb"
  db_username = "dbadmin"
  # 🔐 Pass via env var: export TF_VAR_db_password="..."
  # Never hardcode passwords here
  # db_password = get_env("TF_VAR_db_password") -- this is auto generate by terragrunt

  # ── Backups ────────────────────────────────────────────────
  backup_retention_period = 7

  # ── Protection ─────────────────────────────────────────────
  # Set to false in dev if you need to destroy freely
  deletion_protection = false
}
