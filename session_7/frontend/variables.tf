# Providers variables
variable "aws_region" {
  type        = string
  description = "the region where resources will be provisioned"
}
# Launch configuration variables
variable "instance_type" {
  type = string
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