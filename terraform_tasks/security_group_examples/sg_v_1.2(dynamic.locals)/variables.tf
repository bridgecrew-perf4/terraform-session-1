# Providers variables
variable "aws_region" {
  type        = string
  description = "The region Terraform deploys your infra"
}

# Security group variables
variable "web_ingress_ports" {
  type = list(any)
  default = [{
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidrs     = ["0.0.0.0/0"]
    },
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidrs     = ["0.0.0.0/0"]
    }
  ]
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