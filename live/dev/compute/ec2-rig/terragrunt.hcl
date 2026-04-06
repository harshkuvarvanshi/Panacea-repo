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

# ── NEW: IAM dependency ───────────────────────────────────
dependency "iam" {
  config_path = "../../iam/ec2-role"
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
