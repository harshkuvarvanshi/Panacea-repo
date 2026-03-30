include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/compute/ec2-instance"
}

dependency "network" {
  config_path = "../../networking/vpc"
}

dependency "bastion_sg" {
  config_path = "../../networking/security-groups/bastion-sg"
}

inputs = {
  instance_name         = "panacea-bastion"
  instance_type         = "t3.micro"
  ami_id                = "ami-xxxxxxxx"
  subnet_id             = dependency.network.outputs.public_subnet_a_id
  security_group_ids    = [dependency.bastion_sg.outputs.sg_id]
  associate_public_ip   = true
  volume_size           = 20
  key_name              = "panacea-common-key"

  tags = {
    Environment = "dev"
    Role        = "bastion"
  }
}










# 
# terraform {
#   source = "../../../../infrastructure-modules/compute/ec2"
# }

# inputs = {
#   instance_name       = "panacea-bastion"
#   instance_type       = "t3.micro"
#   subnet_id           = "subnet-public-a"
#   vpc_id              = "vpc-id"
#   associate_public_ip = true
#   volume_size         = 20

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