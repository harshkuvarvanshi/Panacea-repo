# ==========================================================
# CLOUD FRONT DISTRIBUTION
# ==========================================================
# This distribution serves frontend from S3 securely

# ======================================================
# OAC ADDED 
# ======================================================
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.name}-oac"
  description                       = "OAC for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}



resource "aws_cloudfront_distribution" "this" {

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  # ----------------------------------------------------------
  # COST OPTIMIZATION (optional but recommended)
  # ----------------------------------------------------------
  price_class = "PriceClass_100"

  # ==========================================================
  # OAI (S3 BUCKET)
  # ==========================================================
  origin {
  domain_name = var.bucket_domain_name
  origin_id   = "s3-origin"

  origin_access_control_id = aws_cloudfront_origin_access_control.this.id
}

  # ==========================================================
  # DEFAULT CACHE BEHAVIOR
  # ==========================================================
  default_cache_behavior {
    target_origin_id = "s3-origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    # 👉 NEW WAY (instead of forwarded_values)
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    # AWS Managed: CachingOptimized

    compress = true
  }

  # ==========================================================
  # VIEWER CERTIFICATE
  # ==========================================================
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # ==========================================================
  # RESTRICTIONS
  # ==========================================================
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


 

  # ==========================================================
  # TAGS
  # ==========================================================
  tags = {
    Name       = var.name
    Deployment = "manual"
  }
}