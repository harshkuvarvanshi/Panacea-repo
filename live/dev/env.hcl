locals {
  environment           = "dev"
  aws_region            = "ap-southeast-1"
  ec2_instance_type     = "t3.medium"
  vpc_cidr              = "10.0.0.0/16"
  aws_account_id        = get_aws_account_id()
  availability_zones    = ["ap-southeast-1a", "ap-southeast-1b"]

  enable_deletion_protection = false
  multi_az                   = false
  min_capacity               = 1
  max_capacity               = 2
}