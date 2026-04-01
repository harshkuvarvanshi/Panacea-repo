terraform {
  source = "../../../infrastructure-modules/cdn/cloudfront"
}

include {
  path = find_in_parent_folders()
}

# 🔗 Dependency: S3 Frontend Bucket
dependency "s3_frontend" {
  config_path = "../../storage/s3-frontend"

  # 👉 Dummy values (jab tak S3 apply nahi hota)
  mock_outputs = {
    bucket_domain_name = "dummy-bucket.s3.amazonaws.com"
  }
}

inputs = {
  name = "panacea-cloudfront-dev"

  # 🔽 S3 se aa raha hai (IMPORTANT)
  bucket_domain_name = dependency.s3_frontend.outputs.bucket_domain_name

  # 🔐 Dummy OAI (replace later)
  origin_access_identity = "origin-access-identity/cloudfront/DUMMY"

  tags = {
    Environment = "dev"
    Project     = "panacea"
  }
}