terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "qa/instance.tfstate"
    region = "us-east-1"
  }
}