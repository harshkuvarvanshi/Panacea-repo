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
  config_path = "../../networking/security-group/bastion-sg"
}

inputs = {
  instance_name         = "panacea-bastion-harsh" #change kerna h baad me 
  instance_type         = "t3.micro"

  # FIXED AMI (update once verified)
  ami_id                = "ami-0f58b397bc5c1f2e8"

  # FIXED SUBNET
  subnet_id             = dependency.network.outputs.public_subnet_ids[0]

  # FIXED SG OUTPUT
  security_group_ids    = [dependency.bastion_sg.outputs.security_group_id]

  associate_public_ip   = true
  volume_size           = 20
  key_name              = "panacea-common-key"

  tags = {
    Environment = "dev"
    Role        = "bastion"
  }
}






