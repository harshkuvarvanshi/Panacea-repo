# ==========================================================
# EC2 INSTANCE RESOURCE
# ==========================================================
terraform {
  backend "s3" {}   # Store Terraform state remotely in S3
} 

# ==================================
# Create EC2 instance with required configurations
# ==================================
resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip

  key_name = var.key_name

  # ── IAM Instance Profile ──────────────────────────────────
  # Required for EC2 to call AWS APIs (OpenSearch, SSM, etc.)
  iam_instance_profile = var.iam_instance_profile_name

  # ── Storage ───────────────────────────────────────────────
  root_block_device {
    volume_size = var.volume_size      # Disk size in GB  
    volume_type = "gp3"                # General Purpose SSD
  }

  # ── Tags ──────────────────────────────────────────────────
  tags = merge(
    {
      Name = var.instance_name
    },
    var.tags
  )
}
