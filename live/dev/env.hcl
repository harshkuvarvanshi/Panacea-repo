locals {
  environment           = "dev"
  aws_region            = "ap-south-1"
  ec2_instance_type     = "t3.medium"
  aurora_instance_class = "db.t3.medium"
  vpc_cidr              = "10.0.0.0/16"
  availability_zones    = ["ap-south-1a", "ap-south-1b"]

  enable_deletion_protection = false
  multi_az                   = false
  min_capacity               = 1
  max_capacity               = 2
}