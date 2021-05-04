locals {
  common_tags = {
    Environment = var.env
    Project     = "${var.env}-wordpress"
    Team        = "DevOps"
    Owner       = "Nazy"
  }
}

locals {
  public_subnet = {
    1 = { availability_zone = "us-east-1a", cidr_block = "10.0.1.0/24" },
    2 = { availability_zone = "us-east-1b", cidr_block = "10.0.2.0/24" },
    3 = { availability_zone = "us-east-1c", cidr_block = "10.0.3.0/24" }
  }
}

locals {
  private_subnet = {
    1 = { availability_zone = "us-east-1a", cidr_block = "10.0.11.0/24" },
    2 = { availability_zone = "us-east-1b", cidr_block = "10.0.12.0/24" },
    3 = { availability_zone = "us-east-1c", cidr_block = "10.0.13.0/24" }
  }
}

locals {
  ingress_rules = {
    1 = { from_port = 443,
      to_port     = 443,
      protocol    = "tcp",
      cidr_block  = "0.0.0.0/0",
      description = "https_ingress",
    type = "ingress" },
    2 = { from_port = 80,
      to_port     = 80,
      protocol    = "tcp",
      cidr_block  = "0.0.0.0/0",
      description = "http_ingress",
    type = "ingress" },
  }
}