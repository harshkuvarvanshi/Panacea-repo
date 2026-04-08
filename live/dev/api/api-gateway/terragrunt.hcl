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

  mock_outputs = {
    alb_arn           = "arn:aws:elasticloadbalancing:ap-south-1:123456789012:loadbalancer/app/mock-alb/123abc"
    alb_dns_name      = "mock-alb-123456.ap-south-1.elb.amazonaws.com"
    target_group_arn  = "arn:aws:elasticloadbalancing:ap-south-1:123456789012:targetgroup/mock-tg/abc123"
    alb_listener_arn      = "arn:aws:elasticloadbalancing:ap-south-1:123456789012:listener/app/mock-alb/123abc/456def"

  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

dependency "sg" {
  config_path = "../../networking/security-group/alb-sg"

  mock_outputs = {
    security_group_id = "sg-87654321"
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
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