terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "session_7/backend.tfstate"
    region = "us-east-1"
  }
}