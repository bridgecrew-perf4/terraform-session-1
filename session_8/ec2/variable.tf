variable "instance_type" {
  type        = string
  description = "this is instance type of EC2"
}

variable "key_name" {
  type        = string
  description = "this is a key name for EC2 instance"
}

variable "env" {
  type        = string
  description = "cloud environment"
}

variable "http_inbound_rule" {
  type        = string
  description = "http inbound rule of sg"
}

variable "ssh_inbound_rule" {
  type        = string
  description = "ssh inbound rule of sg"
}

variable "outbound_rule" {
  type        = string
  description = "outbound rule of sg"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "cidr block of ingress/egress"
}

variable "sg_name" {
  type        = string
  description = "the name of the sec grp"
}

variable "ingress_protocol" {
  type        = string
  description = "ingress protocol"
}

variable "egress_protocol" {
  type        = string
  description = "egress protocol"
}