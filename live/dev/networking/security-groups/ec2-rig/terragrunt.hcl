include {
  path = find_in_parent_folders("root.hcl")
}

# VPC dependency (only one)
dependency "vpc" {
  config_path = "../../vpc"
}

terraform {
  source = "${get_repo_root()}/modules/networking/security-groups"
}

inputs = {
  name        = "panacea-rig-sg"
  description = "Rig Security Group"

  # Real VPC
  vpc_id = dependency.vpc.outputs.vpc_id

  # SSH from your IP
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # abhi temporary h baad me change kerna h 
    }
  ]

  # Allow all outbound
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
























# include {
#   path = find_in_parent_folders("root.hcl")
# }


# # --------------------------------------------
# # DEPENDENCY: VPC (for subnet + vpc_id)
# # --------------------------------------------
# # dependency "vpc" {
# #   #config_path = "../../networking/vpc"
# #   config_path = "../../vpc"
# # }

# # --------------------------------------------
# # DEPENDENCY: SECURITY GROUP (rig-sg)
# # --------------------------------------------
# dependency "rig_sg" {
#   #config_path = "../../security-groups/ec2-rig"
#   config_path = "../ec2-rig"
# }

# # --------------------------------------------
# # TERRAFORM MODULE SOURCE
# # --------------------------------------------


# dependency "vpc" {
#   config_path = "../../vpc"
# }

# # terraform {
# #   source = "../../../../modules/networking/security-groups"  # check name
# # }
# terraform {
#   source = "${get_repo_root()}/modules/networking/security-groups"
# }
# # --------------------------------------------
# # INPUTS (ACTUAL CONFIG)
# # --------------------------------------------
# inputs = {
#   instance_name       = "panacea-rig-1"
#   instance_type       = "t3.medium"

#   #  Networking
#   subnet_id           = dependency.vpc.outputs.public_subnet_id
#   vpc_id              = dependency.vpc.outputs.vpc_id

#   associate_public_ip = true
#   # Public instance (SSH from your system)

#   # Storage
#   volume_size         = 30
#   # 30 GB gp3

#   # Attach existing Security Group
#   security_group_ids = [
#     dependency.rig_sg.outputs.security_group_id
#   ]

#   # Optional (good practice)
#   user_data = <<-EOF
#               #!/bin/bash
#               yum update -y
#               EOF
# }