include "root"{
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../../vpc"

  mock_outputs = {
    vpc_id = "vpc-12345678"
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

terraform {
  source = "${get_repo_root()}/modules/networking/security-group"
}

inputs = {
  name        = "panacea-alb-sg"
  description = "ALB SG"

  vpc_id = dependency.vpc.outputs.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP from internet"
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