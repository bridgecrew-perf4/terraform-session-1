terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "session_7/frontend.tfstate"
    region = "us-east-1"
  }
}