terraform {
  backend "s3" {
    bucket               = "nazy-tf-bucket"
    key                  = "main.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "session_11"
  }
}