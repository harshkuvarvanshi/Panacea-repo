# This creates a CloudFront distribution connected to an S3 bucket using Origin Access Control (OAC), 
#ensuring secure access where CloudFront serves content over HTTPS and directly reads from S3 without making the bucket public.


# ==========================================
# Create Origin Access Control (OAC) to securely connect CloudFront with S3 (private bucket access)
# ===========================================
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
    domain_name = var.bucket_domain_name    # S3 bucket domain name
    origin_id   =  var.name                 # Unique identifier for this origin

    # Attach OAC so CloudFront can securely access private S3 bucket
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id

  }

  default_cache_behavior {
    target_origin_id       = var.name
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]       # Allow only read operations
    cached_methods  = ["GET", "HEAD"]       # Cache only GET and HEAD responses

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

 viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = var.name
  }
}




