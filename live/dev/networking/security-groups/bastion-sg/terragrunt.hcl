include {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../../vpc"
}

# terraform {
#   source = "../../../../modules/security/security-groups"  # check name
# }

terraform {
  source = "${get_repo_root()}/modules/networking/security-groups"
}

inputs = {
  name        = "panacea-bastion-sg"
  description = "Bastion access"
  #vpc_id      = "vpc-xxxx" # dummy
  vpc_id = dependency.vpc.outputs.vpc_id


  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # abhi temporry ke liye all diya h baad me change kerna h 
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}