# ==========================================================
# API ENDPOINT (Invoke URL)
# ==========================================================
output "api_endpoint" {
  value = aws_apigatewayv2_api.this.api_endpoint
}

# ==========================================================
# API ID
# ==========================================================
output "api_id" {
  value = aws_apigatewayv2_api.this.id
}