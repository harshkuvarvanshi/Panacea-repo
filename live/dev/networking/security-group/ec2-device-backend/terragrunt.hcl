include {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../../vpc"
}

terraform {
  source = "${get_repo_root()}/modules/networking/security-groups"
}

inputs = {
  name        = "panacea-dfb-sg"
  description = "Backend SG"

  vpc_id = dependency.vpc.outputs.vpc_id

  ingress_rules = [
    {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block]  # 🔥 KEY
      description = "App access from VPC"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block]
      description = "SSH from Bastion (via VPC)"
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