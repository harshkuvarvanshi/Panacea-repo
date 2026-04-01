remote_state {
  backend = "s3"

  config = {
    bucket         = "panacea-terraform-state-file-534278"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "panacea-terraform-locks"
    encrypt        = true
  }
}

inputs = {
  aws_region = "ap-south-1"
}