terraform {
  backend "s3" {
    bucket = "nazy-tf-bucket"
    key    = "dev/instance.tfstate"
    region = "us-east-1"
  }
}