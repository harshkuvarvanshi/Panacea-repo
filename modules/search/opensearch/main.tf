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
# NETWORK POLICY (PUBLIC ACCESS)
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
    Name = var.name
  }
}

# ================================
# DATA ACCESS POLICY
# ================================
resource "aws_opensearchserverless_access_policy" "this" {
  name = var.access_policy_name
  type = "data"

  policy = jsonencode([
    {
      Rules = [
        # COLLECTION LEVEL
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

        # INDEX LEVEL (VERY IMPORTANT)
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

      Principal = var.principals
    }
  ])
}