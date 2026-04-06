terraform {
  backend "s3" {}
}

# =========================================
# IAM ROLE (EC2 TRUST)
# =========================================
resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name      = var.role_name
    ManagedBy = "terraform"
  }
}

# =========================================
# IAM POLICY — OpenSearch Serverless Access
# Allows EC2 to sign requests to AOSS
# =========================================
resource "aws_iam_policy" "opensearch" {
  name        = "${var.role_name}-opensearch-policy"
  description = "Allow EC2 to call OpenSearch Serverless APIs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAOSSAPIAccess"
        Effect = "Allow"
        Action = [
          "aoss:APIAccessAll"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowAOSSDescribe"
        Effect = "Allow"
        Action = [
          "aoss:ListCollections",
          "aoss:BatchGetCollection",
          "aoss:GetSecurityPolicy",
          "aoss:ListSecurityPolicies"
        ]
        Resource = "*"
      }
    ]
  })
}

# =========================================
# IAM POLICY — CloudWatch Logs Agent
# EC2 needs this to push app logs to CW
# =========================================
resource "aws_iam_policy" "cloudwatch_logs" {
  name        = "${var.role_name}-cloudwatch-logs-policy"
  description = "Allow EC2 CloudWatch agent to create and push logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Sid    = "AllowCloudWatchMetrics"
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
}

# =========================================
# ATTACH POLICIES TO ROLE
# =========================================
resource "aws_iam_role_policy_attachment" "opensearch" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.opensearch.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
}

# AWS managed policy for SSM Session Manager
# (lets you shell into EC2 without a bastion if needed)
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# =========================================
# INSTANCE PROFILE (REQUIRED FOR EC2)
# =========================================
resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.this.name
}
