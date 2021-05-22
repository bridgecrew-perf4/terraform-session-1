terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "session_9/qa/ec2.tfstate"
    region = "us-east-1"
  }
}