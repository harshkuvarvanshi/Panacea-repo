# ================================
# API-Gateway
# ================================
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
    Deployment = "Auto"
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

# ==========================================================
# VPC LINK (NEW)
# ==========================================================
resource "aws_apigatewayv2_vpc_link" "this" {
  name               = "${var.name}-vpc-link"
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}

# ==========================================================
# INTEGRATION (API → ALB)
# ==========================================================
resource "aws_apigatewayv2_integration" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "HTTP_PROXY"

  integration_method = "ANY"

  # ALB Listener ARN
  integration_uri = var.alb_listener_arn

  connection_type = "VPC_LINK"
  connection_id   = aws_apigatewayv2_vpc_link.this.id
}


# ==========================================================
# ROUTE
# ==========================================================
resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.this.id}"
}