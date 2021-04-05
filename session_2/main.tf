resource "aws_instance" "first" {
  ami           = "ami-0742b4e673072066f"
  instance_type = "t2.micro"

  tags = {
    Name = "instance"
  }
}