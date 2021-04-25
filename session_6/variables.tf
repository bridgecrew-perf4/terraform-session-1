variable "instance_type" {
  type        = string
  description = "this is instance type"
  default = "t2.micro"
}

variable "env" {
  type        = string
  description = "name of the environment"
  default = "dev"
}