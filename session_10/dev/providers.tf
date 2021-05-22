provider "aws" {
  region = "us-east-1"
}

provider "aws" {
    alias = "oregon"
    region = "us-west-2"
}

terraform {
  required_version = "~>0.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.38.0"
    }
  }
}