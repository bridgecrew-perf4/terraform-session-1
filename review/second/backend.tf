terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "review/second/terraform.tfstate"
    region = "us-east-1"
  }
}