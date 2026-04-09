

terraform {
  backend "s3" {}
}

resource "aws_opensearchserverless_collection" "this" {
  name = var.collection_name
  type = "SEARCH"

  depends_on = [
    aws_opensearchserverless_security_policy.encryption,
    aws_opensearchserverless_security_policy.network
  ]

}

#  Encryption Policy
resource "aws_opensearchserverless_security_policy" "encryption" {
  name = "${var.collection_name}-encryption"
  type = "encryption"

  policy = jsonencode({
    Rules = [
      {
        ResourceType = "collection"
        Resource     = ["collection/${var.collection_name}"]
      }
    ]
    AWSOwnedKey = true
  })
}

#  Network Policy (Public Access)
resource "aws_opensearchserverless_security_policy" "network" {
  name = "${var.collection_name}-network"
  type = "network"

  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "collection"
          Resource     = ["collection/${var.collection_name}"]
        }
      ]
      AllowFromPublic = true
    }
  ])
}

# Access Policy (MOST IMPORTANT)
resource "aws_opensearchserverless_access_policy" "data" {
  name = "${var.collection_name}-access"
  type = "data"

  policy = jsonencode([
    {
      Description = "Collection access",
      Rules = [
        {
          ResourceType = "collection",
          Resource     = ["collection/${var.collection_name}"],
          Permission = [
            "aoss:DescribeCollectionItems",
              
          ]
        }
      ],
     "Principal": [
      "arn:aws:iam::203221446879:user/HarshK"
    ] 
    },
    {
      Description = "Index access",
      Rules = [
        {
          ResourceType = "index",
          Resource     = ["index/${var.collection_name}/*"],
          Permission = [
            "aoss:CreateIndex",
            "aoss:DescribeIndex",
            "aoss:ReadDocument",
            "aoss:WriteDocument"
          ]
        }
      ],
      "Principal": [
      "arn:aws:iam::203221446879:user/HarshK"
    ]
    }
  ])
}