include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  modules_path = "${get_repo_root()}/modules"
}

terraform {
  source = "${local.modules_path}/compute/ec2-instance" 
}

dependency "network" {
  config_path = "../../networking/vpc"
}

dependency "bastion_sg" {
 config_path = "../../networking/security-group/bastion-sg"
}

inputs = {
  instance_name         = "panacea-bastion" 
  instance_type         = "t3.micro"

  # FIXED AMI (update once verified)
  ami_id                = "ami-0f58b397bc5c1f2e8"

# FIXED SUBNET
# subnet_id = "subnet-00e5953105decbc08"         # temp testing 
# security_group_ids = ["sg-06a3dc435a82e56ec"]  # temp testing

  subnet_id             = dependency.network.outputs.public_subnet_ids[0]

  # FIXED SG OUTPUT
  security_group_ids    = [dependency.bastion_sg.outputs.security_group_id]

  associate_public_ip   = true
  volume_size           = 20
  key_name              = "panacea-key"

  tags = {
    Environment = "dev"
    Role        = "bastion"
  }
}






