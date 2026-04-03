resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.name}-oac"
  description                       = "OAC for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {

  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = var.bucket_domain_name
    origin_id   = "s3-origin"

      origin_access_control_id = aws_cloudfront_origin_access_control.this.id

  }


  

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

#  ADD THIS
#   logging_config {
#     bucket          = var.logs_bucket_domain_name
#     include_cookies = false
#     prefix          = "cloudfront/"
#   }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}











# # ==========================================================
# # CLOUD FRONT DISTRIBUTION
# # ==========================================================
# # This distribution serves frontend from S3 securely

# # ==========================================
# # OAC (Origin Access Control)
# # ==========================================
# resource "aws_cloudfront_origin_access_control" "this" {
#   name                              = "panacea-oac"
#   description                       = "OAC for S3 frontend"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }

# # terraform {
# #   backend "s3" {}
# # }

# # resource "aws_cloudfront_origin_access_control" "this" {
# #   name                              = "${var.name}-oac"
# #   description                       = "OAC for S3"
# #   origin_access_control_origin_type = "s3"
# #   signing_behavior                  = "always"
# #   signing_protocol                  = "sigv4"
# # }



# resource "aws_cloudfront_distribution" "this" {

#   enabled             = true
#   is_ipv6_enabled     = true
#   default_root_object = "index.html"

#   # ----------------------------------------------------------
#   # COST OPTIMIZATION (optional but recommended)
#   # ----------------------------------------------------------
#   price_class = "PriceClass_100"

#   # ==========================================================
#   # OAI (S3 BUCKET)
#   # ==========================================================
#   origin {
#   domain_name = var.bucket_domain_name
#   origin_id   = "s3-origin"

#  # origin_access_control_id = aws_cloudfront_origin_access_control.this.id
# }

#   # ==========================================================
#   # DEFAULT CACHE BEHAVIOR
#   # ==========================================================
#   default_cache_behavior {
#     target_origin_id = "s3-origin"

#     viewer_protocol_policy = "redirect-to-https"

#     allowed_methods = ["GET", "HEAD"]
#     cached_methods  = ["GET", "HEAD"]

#     # 👉 NEW WAY (instead of forwarded_values)
#     cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
#     # AWS Managed: CachingOptimized

#     compress = true
#   }

#   # ==========================================================
#   # VIEWER CERTIFICATE
#   # ==========================================================
#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   # ==========================================================
#   # RESTRICTIONS
#   # ==========================================================
#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }


 

#   # ==========================================================
#   # TAGS
#   # ==========================================================
#   tags = {
#     Name       = var.name
#     Deployment = "manual"
#   }
# }