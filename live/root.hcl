locals {
  aws_region = "ap-south-1"

  azs = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}









# --------------------------------------------
# 🌍 REMOTE STATE CONFIGURATION (GLOBAL)
# --------------------------------------------
# This tells Terragrunt:
# - Where to store Terraform state (S3)
# - How to lock state (DynamoDB)
# - Applies to ALL modules automatically

remote_state {
  backend = "s3"

  config = {
    bucket         = "panacea-terraform-state-unique-12345"   # 🪣 From bootstrap
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true

    dynamodb_table = "panacea-terraform-locks"  # 🔒 From bootstrap
  }
}




# --------------------------------------------
# 🔧 PROVIDER + VERSION CONTROL (GLOBAL)
# --------------------------------------------
# This block ensures:
# - Same Terraform version for all team members
# - Same AWS provider version (no mismatch issues)
# - Automatically generates provider.tf in every module

generate "provider" {
  path      = "provider.tf"  # File that will be generated in each module
  if_exists = "overwrite"     # Overwrite if already exists
  contents  = <<EOF
terraform {
  required_version = "= 1.6.0"    # Lock Terraform version (same for all)

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.30.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"   # ✅ FIXED (NO var)
}
EOF
}




# --------------------------------------------
# 🗄️ BACKEND CONFIGURATION (REMOTE STATE)
# --------------------------------------------
# This block ensures:
# - Terraform knows to use S3 backend
# - Required for Terragrunt remote_state to work
# - Without this, you get "no backend block" error
generate "backend" {
  path      = "backend.tf"     # File generated in each module
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "s3" {}              # Required empty block (Terragrunt fills config)
}
EOF
}

# inputs = {
#   aws_region = "ap-south-1"
# }
# 
# Pass globals to all modules
inputs = {
  aws_region = local.aws_region
  azs        = local.azs
}