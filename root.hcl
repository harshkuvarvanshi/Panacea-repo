remote_state {
  backend = "s3"

  config = {
    bucket         = "my-terraform-state-unique-534278"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

inputs = {
  aws_region = "ap-south-1"
}