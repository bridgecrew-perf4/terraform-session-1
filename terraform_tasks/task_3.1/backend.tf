terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "session_6/frontend.tfstate"
    region = "us-east-1"
  }
}