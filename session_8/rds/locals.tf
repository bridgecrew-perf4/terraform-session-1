locals {
  common_tags = {
    environment = var.env
    project     = "${var.env}-wordpress"
  }
}

output "tag" {
  value = local.common_tags
}