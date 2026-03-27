output "api_id" {
  value = aws_apigatewayv2_api.this.id
  # 👉 API ID (later integration me use hoga)
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.this.api_endpoint
  # 👉 Invoke URL milega (https://xxxxx.execute-api...)
}