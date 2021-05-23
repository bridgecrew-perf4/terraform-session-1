locals {
  tags = {
    Name        = "${var.env}-s3"
    environment = var.env
    project     = "${var.env}-s3-bucket"
  }
}