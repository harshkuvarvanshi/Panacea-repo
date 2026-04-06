# ================================
# ENCRYPTION POLICY (MUST FIRST)
# ================================


terraform {
  backend "s3" {}
}

resource "aws_opensearchserverless_security_policy" "encryption" {
  name = "${var.name}-encryption"
  type = "encryption"

  policy = jsonencode({
    Rules = [
      {
        Resource     = ["collection/${var.name}"]
        ResourceType = "collection"
      }
    ]
    AWSOwnedKey = true
  })
}

# ================================
# NETWORK POLICY
# Allows both public access AND
# future VPC endpoint (additive)
# ================================
resource "aws_opensearchserverless_security_policy" "network" {
  name = var.network_policy_name
  type = "network"

  policy = jsonencode([
    {
      Rules = [
        {
          Resource     = ["collection/${var.name}"]
          ResourceType = "collection"
        }
      ]
      AllowFromPublic = true
    }
  ])
}

# ================================
# COLLECTION (MAIN RESOURCE)
# ================================
resource "aws_opensearchserverless_collection" "this" {
  name = var.name
  type = "SEARCH"

  depends_on = [
    aws_opensearchserverless_security_policy.encryption,
    aws_opensearchserverless_security_policy.network
  ]

  tags = {
    Name        = var.name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# ================================
# DATA ACCESS POLICY
# Grants EC2 role + Firehose role
# full index r/w access
# ================================
resource "aws_opensearchserverless_access_policy" "this" {
  name = var.access_policy_name
  type = "data"

  policy = jsonencode([
    {
      Rules = [
        # ── Collection level ─────────────────
        {
          Resource = ["collection/${var.name}"]
          Permission = [
            "aoss:CreateCollectionItems",
            "aoss:DeleteCollectionItems",
            "aoss:UpdateCollectionItems",
            "aoss:DescribeCollectionItems"
          ]
          ResourceType = "collection"
        },

        # ── Index level (required for read/write) ─
        {
          Resource = ["index/${var.name}/*"]
          Permission = [
            "aoss:CreateIndex",
            "aoss:DeleteIndex",
            "aoss:UpdateIndex",
            "aoss:DescribeIndex",
            "aoss:ReadDocument",
            "aoss:WriteDocument"
          ]
          ResourceType = "index"
        }
      ]

      # All principals (EC2 role + Firehose role) in one policy
      Principal = var.principals
    }
  ])
}
