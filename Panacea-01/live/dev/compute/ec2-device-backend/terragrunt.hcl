terraform {
  source = "../../../../infrastructure-modules/compute/ec2"
}

inputs = {
  instance_name       = "panacea-dfb-machine"
  instance_type       = "t3.medium"
  subnet_id           = "subnet-private-a"
  vpc_id              = "vpc-id"
  associate_public_ip = false
  volume_size         = 60

  ingress_rules = [
    {
      description     = "App traffic from ALB"
      from_port       = 8000
      to_port         = 8000
      protocol        = "tcp"
      security_groups = ["sg-alb"]
    },
    {
      description     = "SSH from Bastion"
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      security_groups = ["sg-bastion"]
    }
  ]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              EOF
}