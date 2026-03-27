# ================================
# API GATEWAY (HTTP API)
# ================================

resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  # 👉 API ka naam (panacea-http-api)

  protocol_type = "HTTP"
  # 👉 HTTP API (lightweight + fast)

  ip_address_type = "IPV4"
  # 👉 Requirement ke according IPv4

  tags = {
    Deployment = "manual"
    # 👉 Requirement me given tag
  }
}


# ================================
# DEFAULT STAGE ($default)
# ================================

resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.this.id
  # 👉 Ye API ke sath attach hoga

  name = "$default"
  # 👉 Default stage (requirement me diya hai)

  auto_deploy = true
  # 👉 Har change pe auto deploy (requirement)

  tags = {
    Name = "default-stage"
  }
}