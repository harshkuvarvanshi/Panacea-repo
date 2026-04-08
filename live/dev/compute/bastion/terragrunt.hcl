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

  mock_outputs = {
    vpc_id              = "vpc-12345678"
    private_subnet_ids  = ["subnet-11111111", "subnet-22222222"]
    public_subnet_ids   = ["subnet-33333333", "subnet-44444444"]
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

dependency "bastion_sg" {
  config_path = "../../networking/security-group/bastion-sg"

  mock_outputs = {
    security_group_id = "sg-12345678"
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

# ── NEW: IAM dependency ───────────────────────────────────
dependency "iam" {
  config_path = "../../iam/ec2-role"

  mock_outputs = {
    instance_profile_name = "mock-instance-profile"
    role_arn              = "arn:aws:iam::123456789012:role/mock-role"
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

inputs = {
  instance_name         = "panacea-bastion"
  instance_type         = "t3.micro"
  ami_id                = "ami-0e7ff22101b84bcff"

# FIXED SUBNET
# subnet_id = "subnet-00e5953105decbc08"         # temp testing 
# security_group_ids = ["sg-06a3dc435a82e56ec"]  # temp testing

  subnet_id             = dependency.network.outputs.public_subnet_ids[0]
  security_group_ids    = [dependency.bastion_sg.outputs.security_group_id]

  associate_public_ip   = true
  volume_size           = 20
  key_name              = "panacea-key"

  # ── Attach IAM profile ────────────────────────────────────
  iam_instance_profile_name = dependency.iam.outputs.instance_profile_name

  tags = {
    Environment = "dev"
    Role        = "bastion"
  }
}
