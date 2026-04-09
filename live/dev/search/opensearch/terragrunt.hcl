

include {
  path = find_in_parent_folders("root.hcl")
}
dependency "tester" {
  config_path = "../../iam/opensearch-tester"
}
terraform {
  source = "${get_repo_root()}/modules/search/opensearch"
}

# dependency "tester" {
#   config_path = "../../iam/ec2-role"

inputs = {
  collection_name = "logs-collection"

  principals = [
    "arn:aws:iam::203221446879:user/HarshK",       #Tester iam arn 
     
  ]

  
}









 