resource "aws_instance" "first" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "${var.env}_instance"
  }
}