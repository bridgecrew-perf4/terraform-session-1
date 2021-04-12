variable "cidr_vpc" {
  type = string
  description = "CIDR block for the VPC"
}

variable "pub_cidr1_subnet" {
  type = string  
  description = "CIDR block for the  1st public subnet"
}

variable "pub_cidr2_subnet" {
  type = string
  description = "CIDR block for the 2nd public subnet"
}

variable "priv_cidr1_subnet" {
  type = string
  description = "CIDR block for the 1st private subnet"
}

variable "priv_cidr2_subnet" {
  type = string
  description = "CIDR block for the 2nd private subnet"
}

variable "region_1a" {
  type = string
  description = "The region Terraform deploys your instance"
}

variable "region_1b" {
  type = string
  description = "The region Terraform deploys your instance"
}

variable "env" {
    type = string
    description = "name of the environment"
    
}

variable "instance_type" {
    type = string
    description = "instance type"
}

variable "tags" {
  type = map
  
  default = {
      "Name" = "wordpress_web"
  }
}

variable "my_key"{
  description = "my laptop's public key"
  type = string

}

variable "zone_name" {
  description = "Name of route 53 zone"
  type        = string
}