locals {
  tags = {
    Name        = "${var.env}-main"
    environment = var.env
    project     = "${var.env}-wordpress"

  }
}