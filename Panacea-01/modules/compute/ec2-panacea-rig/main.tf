##################################################
# Security Group for EC2 Rig
##################################################

resource "aws_security_group" "rig_sg" {
  name   = "panacea-rig-sg"
  vpc_id = var.vpc_id


##################################################
  # Allow SSH only from your IP (secure access)
##################################################


  ingress {
    description = "SSH access from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip] # Example: "49.xx.xx.xx/32"
  }

########################################################################
  # Allow all outbound traffic (required for updates, internet access)
########################################################################

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##################################################
# EC2 Instance (Panacea Rig)
##################################################

resource "aws_instance" "rig" {
  ami           = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2023 (ap-south-1)
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

##################################################
  # Enable public IP (since it's in public subnet)
##################################################

  associate_public_ip_address = true

##################################################
  # Attach security group
##################################################

  vpc_security_group_ids = [aws_security_group.rig_sg.id]
##################################################
# Root volume configuration
##################################################

  root_block_device {
    volume_size = 30       # 30 GB storage
    volume_type = "gp3"    # Modern SSD
  }

  tags = {
    Name = var.instance_name
  }
}