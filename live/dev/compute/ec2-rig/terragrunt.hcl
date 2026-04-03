include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/compute/ec2-instance"
}

dependency "network" {
  config_path = "../../networking/vpc"
}

dependency "rig_sg" {
  config_path = "../../networking/security-group/ec2-rig"
}

inputs = {
  instance_name = "panacea-rig"   #panacea-rig
  instance_type = "t3.medium"

  ami_id = "ami-0f58b397bc5c1f2e8"


##############################
  # Public subnet
##############################

  subnet_id = dependency.network.outputs.public_subnet_ids[0]

  security_group_ids = [
    dependency.rig_sg.outputs.security_group_id
  ]

  associate_public_ip = true
  volume_size         = 30
  key_name            = "panacea-key"

  tags = {
    Name        = "panacea-rig"
    Environment = "dev"
    Role        = "rig"
  }
}












# include {
#   path = find_in_parent_folders("root.hcl")
# }

# terraform {
#   source = "../../../../modules/compute/ec2-instance"
# }

# dependency "network" {
#   config_path = "../../networking/vpc"
# }

# dependency "rig_sg" {
#   config_path = "../../networking/security-groups/rig-sg"
# }

# inputs = {
#   instance_name         = "panacea-rig-1"
#   instance_type         = "t3.medium"
#   ami_id                = "ami-xxxxxxxx" # Amazon Linux 2023
#   subnet_id             = dependency.network.outputs.public_subnet_a_id
#   security_group_ids    = [dependency.rig_sg.outputs.sg_id]
#   associate_public_ip   = true
#   volume_size           = 30
#   key_name              = "panacea-common-key"

#   tags = {
#     Environment = "dev"
#     Project     = "panacea"
#   }
# }
















#
#  terraform {
#   source = "../../../../infrastructure-modules/compute/ec2"
# }

# inputs = {
#   instance_name       = "panacea-rig-1"
#   instance_type       = "t3.medium"
#   subnet_id           = "subnet-public-a"
#   vpc_id              = "vpc-id"
#   associate_public_ip = true
#   volume_size         = 30

#   ingress_rules = [
#     {
#       description = "SSH from my IP"
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       cidr_blocks = ["49.xx.xx.xx/32"]
#     }
#   ]
# }