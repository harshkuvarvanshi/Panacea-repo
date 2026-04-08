include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/cdn/cloudfront"
}


dependency "s3_frontend" {
  config_path = "../../storage/s3-frontend"

  mock_outputs = {
    bucket_name                  = "mock-bucket-name"
    bucket_arn                   = "arn:aws:s3:::mock-bucket-name"
    bucket_domain_name           = "mock-bucket-name.s3.amazonaws.com"
    bucket_regional_domain_name  = "mock-bucket-name.s3.ap-south-1.amazonaws.com"
  }

  mock_outputs_allowed_terraform_commands = ["init", "plan"]
}

# dependency "s3_artifacts" {
#   config_path = "../../storage/s3-artifact-bucket"
# }

inputs = {
  name = "panacea-cloudfront-dev"

  bucket_domain_name = dependency.s3_frontend.outputs.bucket_regional_domain_name
  #logs_bucket_domain_name = dependency.s3_artifacts.outputs.bucket_regional_domain_name


  tags = {
    Environment = "dev"
    Project     = "panacea"
  }
}






# include {
#   path = find_in_parent_folders("root.hcl")
# }

# terraform {
#   source = "${get_repo_root()}/modules/cdn/cloudfront"
# }


# dependency "s3_frontend" {
#   config_path = "../../storage/s3-frontend"
# }

# dependency "s3_artifacts" {
#   config_path = "../../storage/s3-artifact-bucket"
# }

# inputs = {
#   name = "panacea-cloudfront-dev"

#   bucket_domain_name = dependency.s3_frontend.outputs.bucket_regional_domain_name
#   #logs_bucket_domain_name = dependency.s3_artifacts.outputs.bucket_regional_domain_name


#   tags = {
#     Environment = "dev"
#     Project     = "panacea"
#   }
# }












# include {
#   path = find_in_parent_folders("root.hcl")
# }

# terraform {
#   source = "${get_repo_root()}/modules/cdn/cloudfront"
# }

# # 🔗 S3 dependency
# dependency "s3_frontend" {
#   config_path = "../../storage/s3-frontend"
# }

# inputs = {
#   name = "panacea-frontend-bucket-dev"

#   block_public_access = false   # temporary
#    # bucket_domain_name = dependency.s3_frontend.outputs.bucket_regional_domain_name


#   enable_versioning = true

#   tags = {
#     Environment = "dev"
#     Project     = "panacea"
#   }
# }














# terraform {
#   source = "${get_repo_root()}/modules/cdn/cloudfront"
# }

# include {
#   path = find_in_parent_folders("root.hcl")
# }

# # 🔗 Dependency: S3 Frontend Bucket
# dependency "s3_frontend" {
#   config_path = "../../storage/s3-frontend"

# }


# inputs = {
#   name = "panacea-frontend-bucket-dev"

#   block_public_access = false  # temporary

#   enable_versioning = true

#    tags = {
#     Environment = "dev"
#     Project     = "panacea"
#   }
# }