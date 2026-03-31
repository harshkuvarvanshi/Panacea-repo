# ==========================================================
# OUTPUTS
# ==========================================================

# ----------------------------------------------------------
# EC2 INSTANCE ID
# Used by:
# - ALB target group attachment
# - Other dependencies
# ----------------------------------------------------------
output "instance_id" {
  value = aws_instance.this.id
}


# ----------------------------------------------------------
# PUBLIC IP
# Available only if associate_public_ip = true
# Used for:
# - Bastion SSH access
# ----------------------------------------------------------
output "public_ip" {
  value = aws_instance.this.public_ip
}

# ----------------------------------------------------------
# PRIVATE IP
# Used for internal communication (ALB → Backend)
# ----------------------------------------------------------
output "private_ip" {
  value = aws_instance.this.private_ip
}


