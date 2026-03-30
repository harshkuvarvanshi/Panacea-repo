
include {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path = "../../vpc"
}
#Backend EC2 ko direct kisi ko access nahi dena hai
#Taaki backend EC2 sirf ALB aur Bastion se hi access ho
dependency "alb_sg" {
  config_path = "../alb-sg"
}

dependency "bastion_sg" {
  config_path = "../bastion-sg"
}





# terraform {
#   source = "../../../../modules/security/security-groups"
# }

terraform {
  source = "${get_repo_root()}/modules/networking/security-groups"
}
# dependency "alb_sg" {
#   config_path = "../alb-sg"
# }

# dependency "bastion_sg" {
#   config_path = "../bastion-sg"
# }


inputs = {
  name        = "panacea-dfb-sg"
  description = "Backend"
  #vpc_id      = "vpc-xxxx"
  vpc_id = dependency.vpc.outputs.vpc_id

ingress_rules = [
  {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    sg_id     = dependency.alb_sg.outputs.security_group_id
  },
  {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    sg_id     = dependency.bastion_sg.outputs.security_group_id
  }
]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"] # abhi temporay h 
    }
  ]
}