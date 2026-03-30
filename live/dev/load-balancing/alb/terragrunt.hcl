# include {
#   path = find_in_parent_folders()
# }

# terraform {
#   source = "../../../infrastructure-modules/load-balancing/alb"
# }

# # ✅ Dependencies (mock for now)
# dependency "vpc" {
#   config_path = "../../networking/vpc"

#   mock_outputs = {
#     vpc_id = "vpc-dummy"
#   }
# }

# dependency "subnets" {
#   config_path = "../../networking/subnets"

#   mock_outputs = {
#     public_subnets = [
#       "subnet-public-a-dummy",
#       "subnet-public-b-dummy"
#     ]
#   }
# }

# dependency "ec2" {
#   config_path = "../../compute/ec2"

#   mock_outputs = {
#     instance_ids = ["i-dfb-1", "i-dfb-2"]
#   }
# }

# dependency "sg" {
#   config_path = "../../networking/security-group"

#   mock_outputs = {
#     alb_sg_id = "sg-alb-dummy"
#   }
# }

# inputs = {
#   name               = "panacea-alb"
#   environment        = "dev"
#   target_group_name  = "panacea-dfb-tg"

#   vpc_id = dependency.vpc.outputs.vpc_id
#   # 🔴 AUTO-REPLACE WHEN READY

#   subnets = dependency.subnets.outputs.public_subnets
#   # 🔴 MUST BE PUBLIC SUBNETS

#   security_groups = [dependency.sg.outputs.alb_sg_id]
#   # 🔴 Should allow 80 from 0.0.0.0/0

#   instance_ids = dependency.ec2.outputs.instance_ids
#   # 🔴 DFB EC2 (PRIVATE)
# }