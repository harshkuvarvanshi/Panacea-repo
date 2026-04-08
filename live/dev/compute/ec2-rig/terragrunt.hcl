include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/compute/ec2-instance"
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

dependency "rig_sg" {
  config_path = "../../networking/security-group/ec2-rig"

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
  instance_name = "panacea-rig"
  instance_type = "t3.medium"
  ami_id        = "ami-0f58b397bc5c1f2e8"

  subnet_id = dependency.network.outputs.public_subnet_ids[0]

  security_group_ids = [
    dependency.rig_sg.outputs.security_group_id
  ]

  associate_public_ip = true
  volume_size         = 30
  key_name            = "panacea-key"

  # ── Attach IAM profile ────────────────────────────────────
  iam_instance_profile_name = dependency.iam.outputs.instance_profile_name

  tags = {
    Name        = "panacea-rig"
    Environment = "dev"
    Role        = "rig"
  }
}
