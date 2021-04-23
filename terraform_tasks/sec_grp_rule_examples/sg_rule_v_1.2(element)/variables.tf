# Providers variables
variable "aws_region" {
  type        = string
  description = "The region Terraform deploys your infra"
}
# Security group rule variables
variable "web_sg_tcp_ports" {
  type = list(string)
}

variable "egress_port" {
  description = "incoming port"
  type        = number
}

variable "ingress_protocol" {
  description = "intbound network"
  type        = string
}

variable "egress_protocol" {
  description = "outbound network"
  type        = string
}

variable "cidr_block" {
  description = "ingress/egress cidr block"
  type        = string
}

variable "in_traffic_type" {
  description = "ingress type"
  type        = string
}

variable "out_traffic_type" {
  description = "ingress type"
  type        = string
}

# Tags variables
variable "env" {
  type        = string
  description = "name of the environment"
}

variable "project_name" {
  type        = string
  description = "name of the project"
}