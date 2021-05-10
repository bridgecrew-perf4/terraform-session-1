terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "session_8/rds.tfstate"
    region = "us-east-1"
  }
}