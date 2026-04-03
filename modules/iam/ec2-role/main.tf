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
}

# =========================================
# IAM POLICY (OpenSearch Access)
# =========================================
resource "aws_iam_policy" "opensearch" {
  name = "${var.role_name}-opensearch-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "aoss:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# =========================================
# ATTACH POLICY TO ROLE
# =========================================
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.opensearch.arn
}

# =========================================
# INSTANCE PROFILE (REQUIRED FOR EC2)
# =========================================
resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.this.name
}