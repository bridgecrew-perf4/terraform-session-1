locals {
  common_tags = {
    Environment = var.env
    Project     = "${var.env}-web"
  }
}