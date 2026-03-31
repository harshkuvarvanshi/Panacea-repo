
# ==========================================================
# EC2 INSTANCE RESOURCE
# ==========================================================
resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip

  key_name = var.key_name

  # ----------------------------------------------------------
  # TAGS
  # Name → main identifier
  # Additional tags → environment, role, etc.
  # ----------------------------------------------------------
  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp3"
  }

# ==========================================================
# EC2 INSTANCE RESOURCE
# ==========================================================

  tags = merge(
    {
      Name = var.instance_name
    },
    var.tags
  )
}




















# # 🔐 Security Group (dynamic rules)
# resource "aws_security_group" "ec2_sg" {
#   name   = "${var.instance_name}-sg"
#   vpc_id = var.vpc_id

#   # Dynamic ingress rules (IMPORTANT)
#   dynamic "ingress" {
#     for_each = var.ingress_rules
#     content {
#       description = ingress.value.description
#       from_port   = ingress.value.from_port
#       to_port     = ingress.value.to_port
#       protocol    = ingress.value.protocol

#       # Use either CIDR or SG
#       cidr_blocks     = lookup(ingress.value, "cidr_blocks", null)
#       security_groups = lookup(ingress.value, "security_groups", null)
#     }
#   }

#   # Allow all outbound traffic
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# #EC2 Instance
# resource "aws_instance" "ec2" {
#   ami           = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2023 (ap-south-1)
#   instance_type = var.instance_type
#   subnet_id     = var.subnet_id

#   # Public or private instance
#   associate_public_ip_address = var.associate_public_ip

#   # Attach security group
#   vpc_security_group_ids = [aws_security_group.ec2_sg.id]

#   # Storage config
#   root_block_device {
#     volume_size = var.volume_size
#     volume_type = "gp3"
#   }

#   # Optional user data
#   user_data = var.user_data

#   tags = {
#     Name = var.instance_name
#   }
# }