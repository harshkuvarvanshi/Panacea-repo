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

# ── NEW: IAM dependency ───────────────────────────────────
dependency "iam" {
  config_path = "../../iam/ec2-role"
}

inputs = {
  instance_name         = "panacea-bastion"
  instance_type         = "t3.micro"
  ami_id                = "ami-0f58b397bc5c1f2e8"

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
