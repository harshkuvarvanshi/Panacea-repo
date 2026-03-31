# ==========================================
# INCLUDE ROOT CONFIG (Backend + Provider)
# ==========================================
include {
  path = find_in_parent_folders("root.hcl")
}

# ==========================================
# MODULE SOURCE (ALB MODULE)
# ==========================================
terraform {
  source = "../../../../modules/networking/alb"
}

# ==========================================
# DEPENDENCY: VPC (for subnets + vpc_id)
# ==========================================
dependency "vpc" {
  config_path = "../../networking/vpc"
}

# ==========================================
# DEPENDENCY: ALB SECURITY GROUP
# ==========================================
dependency "alb_sg" {
  config_path = "../../networking/security-groups/alb-sg"
}

# ==========================================
# DEPENDENCY: DFB EC2 (Target Instance)
# ==========================================
dependency "dfb_ec2" {
  config_path = "../../compute/ec2-device-backend"
}

# ==========================================
# INPUTS (ACTUAL CONFIGURATION)
# ==========================================
inputs = {

  # ------------------------------------------
  # BASIC DETAILS
  # ------------------------------------------
  name        = "panacea-alb"
  environment = "dev"

  # ------------------------------------------
  # VPC
  # ------------------------------------------
  vpc_id = dependency.vpc.outputs.vpc_id

  # ------------------------------------------
  # PUBLIC SUBNETS (IMPORTANT)
  # ALB always in PUBLIC subnets
  # ------------------------------------------
  subnets = [
    dependency.vpc.outputs.public_subnet_ids[0],
    dependency.vpc.outputs.public_subnet_ids[1]
  ]

  # ------------------------------------------
  # SECURITY GROUP
  # ------------------------------------------
  security_groups = [
    dependency.alb_sg.outputs.security_group_id
  ]

  # ------------------------------------------
  # TARGET GROUP NAME
  # ------------------------------------------
  target_group_name = "panacea-dfb-tg"

  # ------------------------------------------
  # TARGET INSTANCES (DFB EC2)
  # ------------------------------------------
  instance_ids = [
    dependency.dfb_ec2.outputs.instance_id
  ]
}