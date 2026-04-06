include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/storage/s3-bucket"
}

inputs = {
  name = "panacea-artifacts-bucket-dev"
  enable_alb_logs   = true  
  enable_acl      = true        # IMPORTANT
  is_logs_bucket  = true 

  versioning_enabled = true
  force_destroy      = true

#   # Security
#   block_public_access = true
#   enable_encryption   = true
#   enable_versioning   = true

  # Lifecycle (cost optimization)
  enable_lifecycle = true

  lifecycle_rules = [
    {
      id              = "expire-logs"
      enabled         = true
      expiration_days = 30
    }
  ]

  tags = {
    Environment = "dev"
    Project     = "panacea"
    Name        = "artifacts-bucket"
  }
}




