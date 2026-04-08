remote_state {
  backend = "s3"

  config = {
    bucket         = "panacea-terraform-state-file-203221446879"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "panacea-terraform-locks"
    encrypt        = true
  }
}

inputs = {
  aws_region = "ap-southeast-1"
}