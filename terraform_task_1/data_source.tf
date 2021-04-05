data "aws_ami" "centos_7" {
  most_recent      = true
  owners           = ["679593333241"]

  filter { 
    name   = "name"
    values = ["CentOS Linux 7 x86_64*"]
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
    name =   "root-device-type"
    values = ["ebs"]
  }
}

data "template_file" "user_data" {
  template = file("user_data.sh")
}