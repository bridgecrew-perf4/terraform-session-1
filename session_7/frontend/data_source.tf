data "template_file" "webserver" {
  template = file("user_data.sh")
  vars = {
    env = var.env
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = "nazy-tf-bucket"
    key    = "session_7/backend.tfstate"
    region = "us-east-1"
  }
}