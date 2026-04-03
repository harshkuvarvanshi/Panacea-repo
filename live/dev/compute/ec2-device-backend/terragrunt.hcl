include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/compute/ec2-instance"
}


dependency "network" {
  config_path = "../../networking/vpc"
}

dependency "dfb_sg" {
  config_path = "../../networking/security-group/ec2-device-backend"
}

inputs = {
  instance_name       = "panacea-dfb-machine" 
  instance_type       = "t3.medium"
  ami_id              = "ami-0f58b397bc5c1f2e8"

######################
# Private subnet
######################
  subnet_id           = dependency.network.outputs.private_subnet_ids[0]  
  security_group_ids  = [dependency.dfb_sg.outputs.security_group_id]    

  associate_public_ip = false
  volume_size         = 60
  key_name            = "panacea-key"

  tags = {
    Name        = "panacea-dfb-machine"
    Environment = "dev"
    Role        = "backend"
  }
}















