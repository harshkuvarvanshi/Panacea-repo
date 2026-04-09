terraform {
  backend "s3" {}
}

resource "aws_iam_user" "tester" {
  name = var.user_name
}

resource "aws_iam_policy" "opensearch_access" {
  name = "${var.user_name}-opensearch-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "aoss:APIAccessAll",
          "aoss:DashboardsAccessAll"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.tester.name
  policy_arn = aws_iam_policy.opensearch_access.arn
}

output "user_arn" {
  value = aws_iam_user.tester.arn
}