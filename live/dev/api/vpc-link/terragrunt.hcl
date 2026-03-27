# ================================
# INCLUDE ROOT CONFIG
# ================================
include {
  path = find_in_parent_folders()
}

# ================================
# MODULE SOURCE
# ================================
terraform {
  source = "../../../infrastructure-modules/api/vpc-link"
}

# ================================
# INPUT VALUES
# ================================
inputs = {
  name = "panacea-vpc-link"

  subnet_ids = [
    "subnet-123456",
    "subnet-789012"
  ]
  # 👉 Dummy private subnet IDs
  # 👉 Replace later with:
  # dependency.subnets.outputs.private_subnets

  security_group_ids = [
    "sg-123456"
  ]
  # 👉 Dummy SG
  # 👉 Replace later with real SG from Person 1
}