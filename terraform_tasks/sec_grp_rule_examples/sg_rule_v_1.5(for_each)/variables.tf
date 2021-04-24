# Providers variables
variable "aws_region" {
  type        = string
  description = "The region Terraform deploys your infra"
}
# Security group rule variables

# Tags variables
variable "env" {
  type        = string
  description = "name of the environment"
}

variable "project_name" {
  type        = string
  description = "name of the project"
}