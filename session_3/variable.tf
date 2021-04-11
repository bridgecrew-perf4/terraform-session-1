variable "image_id" {
  type        = string
  description = "this is ami of the EC2 instance"
}

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
