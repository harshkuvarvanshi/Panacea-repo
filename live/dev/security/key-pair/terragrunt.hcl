include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/security/key-pair"
}

inputs = {
  key_name        = "panacea-common-key"
  public_key_path = "C:/Users/your-user/.ssh/id_rsa.pub"
}