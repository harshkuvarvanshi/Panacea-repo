include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/iam/opensearch-tester"
}

inputs = {
  user_name = "tester-user" 
}