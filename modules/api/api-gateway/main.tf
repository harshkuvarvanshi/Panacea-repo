terraform {
  backend "s3" {}
}

# ==========================================================
# API GATEWAY (HTTP API)
# ==========================================================
resource "aws_apigatewayv2_api" "this" {

  name = var.name
  protocol_type = "HTTP"
  ip_address_type = "ipv4"
 
  tags = {
    Deployment = "manual"
  }
}

# ==========================================================
# DEFAULT STAGE ($default)
# ==========================================================
resource "aws_apigatewayv2_stage" "default" {

  # Attach to API
  api_id = aws_apigatewayv2_api.this.id

  # Default stage (auto-created endpoint)
  name = "$default"

  # Auto deploy enabled (no manual deployment needed)
  auto_deploy = true

  tags = {
    Name = "${var.name}-default-stage"
  }
}