# Public IP (for SSH access)
output "public_ip" {
  value = aws_instance.rig.public_ip
}

# Instance ID
output "instance_id" {
  value = aws_instance.rig.id
}