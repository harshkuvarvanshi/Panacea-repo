terraform {
  source = "../../../../modules/api/api-gateway"
}

include {
  path = find_in_parent_folders("root.hcl")
}

# VPC
dependency "vpc" {
  config_path = "../../networking/vpc"
}

# ALB
dependency "alb" {
  config_path = "../../load-balancing/alb"
}

dependency "sg" {
  config_path = "../../networking/security-group/alb-sg"
}

inputs = {
  name = "panacea-api"

  # private subnets
  subnet_ids = dependency.vpc.outputs.private_subnet_ids

  security_group_ids = [
    dependency.sg.outputs.security_group_id
  ]

  # ALB listener ARN
  alb_listener_arn = dependency.alb.outputs.alb_listener_arn
}