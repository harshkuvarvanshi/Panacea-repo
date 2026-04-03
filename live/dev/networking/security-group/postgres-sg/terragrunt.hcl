include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/networking/security-group"
}

dependency "vpc" {
  config_path = "../../vpc"
}

dependency "ec2_backend_sg" {
  config_path = "../ec2-device-backend"

  mock_outputs = {
    security_group_id = "sg-00000000"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "bastion_sg" {
  config_path = "../bastion-sg"

  mock_outputs = {
    security_group_id = "sg-11111111"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  name        = "panacea-postgres-sg"
  description = "Security Group for PostgreSQL RDS - allows only app layer and bastion"

  vpc_id = dependency.vpc.outputs.vpc_id

  ingress_rules = [
    {
      # App EC2 backend → Postgres (SG to SG, no CIDR)
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = dependency.ec2_backend_sg.outputs.security_group_id
      cidr_blocks              = []
      description              = "Allow PostgreSQL from app backend EC2"
    },
    {
      # Bastion → Postgres for direct DB access / migrations
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = dependency.bastion_sg.outputs.security_group_id
      cidr_blocks              = []
      description              = "Allow PostgreSQL from bastion for admin access"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}
