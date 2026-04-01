include "root"{
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../../modules/networking/security-group"
}

dependency "vpc" {
  config_path = "../../vpc"
}
inputs = {
  name        = "aurora-sg"
  description = "Aurora DB SG"

  vpc_id = dependency.vpc.outputs.vpc_id

  ingress_rules = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]   # later SG to SG 
      description = "MySQL access"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All traffic"
    }
  ]
}