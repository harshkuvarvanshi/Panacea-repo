# ================================
# INCLUDE ROOT CONFIG (backend, provider, etc.)
# ================================
include {
  path = find_in_parent_folders()
}

# ================================
# MODULE SOURCE
# ================================
terraform {
  source = "../../../infrastructure-modules/api/api-gateway"
}

# ================================
# INPUT VALUES (ACTUAL VALUES YAHA DETE HAIN)
# ================================
inputs = {
  name = "panacea-http-api"
  # 👉 API Gateway ka naam (requirement ke according)

  # 👉 Koi dependency nahi hai
  # 👉 Direct create ho jayega
}