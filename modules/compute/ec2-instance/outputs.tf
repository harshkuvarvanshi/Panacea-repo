# ==========================================================
# OUTPUTS
# ==========================================================

# --------------------------
# EC2 INSTANCE ID
# --------------------------
output "instance_id" {
  value = aws_instance.this.id
}

# --------------------------
# PUBLIC IP
# --------------------------
output "public_ip" {
  value = aws_instance.this.public_ip
}

# --------------------------
# PRIVATE IP
# --------------------------
output "private_ip" {
  value = aws_instance.this.private_ip
}


