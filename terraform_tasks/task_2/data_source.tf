# AMI for web-server
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

data "template_file" "sql_userdata" {
  template = file("./sql_userdata.sh")
  vars = {
    wordpress_private_ip = aws_instance.wordpress_web.private_ip
    description          = "variable named wordpress_private_ip will get the private_ip of wordpress_web"
  }
}