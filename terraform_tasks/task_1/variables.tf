variable "region" {
  type = string
  default = "us-west-2"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "tags" {
  type = map

  default = {
      Name = "web-instance"
      Environment = "dev"
  }
}
variable "availability_zone" {
  type = string
  default = "us-west-2b"
}
 