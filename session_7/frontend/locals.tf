locals {
  common_tags = {
    Environment = var.env
    Project     = "${var.env}-wordpress"
    Team        = "DevOps"
    Owner       = "Nazy"
  }
}