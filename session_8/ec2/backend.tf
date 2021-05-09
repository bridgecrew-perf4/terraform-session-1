terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "session_8/ec2.tfstate"
    region = "us-east-1"
  }
}