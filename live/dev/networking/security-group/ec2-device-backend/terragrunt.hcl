include "root" {
  path = find_in_parent_folders("root.hcl")
}



# ─── Dependencies ────────────────────────────────────────────────

dependency "vpc" {
  config_path = "../../vpc"
}

dependency "alb_sg" {
  config_path = "../alb-sg"

}

# ─── Module Source ────────────────────────────────────────────────

terraform {
  source = "${get_repo_root()}/modules/networking/security-group"
}

# ─── Inputs ───────────────────────────────────────────────────────
inputs = {
  name        = "panacea-ec2-backend-sg"
  description = "Security Group for Device Farm Backend EC2"
  vpc_id      = dependency.vpc.outputs.vpc_id

  # ─── Ingress ──────────────────────────────────────────────────
  ingress_rules = [
    {
      from_port                = 8000
      to_port                  = 8000
      protocol                 = "tcp"
      source_security_group_id = dependency.alb_sg.outputs.security_group_id
      cidr_blocks              = []
      description              = "Allow app traffic only from ALB"
    }
  ]

  # ─── Egress ───────────────────────────────────────────────────
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}