locals {
  common_tags = {
    Environment = var.env
    Project     = "${var.env}-wordpress"
    Team        = "DevOps"
    Owner       = "Nazy"
  }
}

locals {
  ingress_rules = {
    http = { from_port = 80,
      to_port     = 80,
      protocol    = "tcp",
      cidr_block  = "0.0.0.0/0",
      description = "http_ingress",
    type = "ingress" },
  }
}