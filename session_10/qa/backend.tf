terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "session_10/qa/s3.tfstate"
    region = "us-east-1"
  }
}