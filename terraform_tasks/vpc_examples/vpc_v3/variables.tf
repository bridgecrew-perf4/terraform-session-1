# Providers variables
variable "aws_region" {
  type        = string
  description = " aws region to deploys your infra"
}

# VPC variables
variable "vpc_cidr_block" {
  type        = string
  description = "cidr block for the vpc"
}

variable "instance_tenancy" {
  type        = string
  description = "the tenancy of existing VPCs from dedicated to default instantly"
}

variable "is_enabled_dns_support" {
  type        = bool
  description = "enabling dns support"
}

variable "is_enabled_dns_hostnames" {
  type        = bool
  description = "enabling dns hostnames"
}

variable "rt_cidr_block" {
  type        = string
  description = "route table cidr block"
}

# Subnet variables
variable "pub_cidr_subnet" {
  type        = map(any)
  description = "The availabitily zones where terraform deploys your infra"
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
    "us-east-1c" = "10.0.3.0/24"
  }
}

#variable "priv_cidr_subnet" {
#  type        = list(any)
#  description = "cidr blocks for the private subnets"
#    default = {
#    "us-east-1a" = "10.0.11.0/24"
#    "us-east-1b" = "10.0.12.0/24"
#    "us-east-1c" = "10.0.13.0/24"
#  }
#}

# Tags variables
variable "env" {
  type        = string
  description = "name of the environment"
}

variable "project_name" {
  type        = string
  description = "name of the project"
}