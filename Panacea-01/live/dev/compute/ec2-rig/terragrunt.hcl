terraform {
  source = "../../../../infrastructure-modules/compute/ec2"
}

inputs = {
  instance_name       = "panacea-rig-1"
  instance_type       = "t3.medium"
  subnet_id           = "subnet-public-a"
  vpc_id              = "vpc-id"
  associate_public_ip = true
  volume_size         = 30

  ingress_rules = [
    {
      description = "SSH from my IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["49.xx.xx.xx/32"]
    }
  ]
}