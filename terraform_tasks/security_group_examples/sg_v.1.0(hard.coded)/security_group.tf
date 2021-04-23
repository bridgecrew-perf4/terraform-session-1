# This security group is the most simple version of how you can configure your sg 
# resource block. But it makes your template not reusable, because everything is
# hard coded.  If you would like to do some changes, you have to go over all your code
# and there's a big chance that you make the changes you didnt' mean to. Our mission
# using IaaC is to automate provisioning our resources and avoid human error. That's why
# try to make our code reusable, and when we write our code once we don't touch it, 
# for that we use variables.

# Security group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "http_ingress"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh_ingress"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "web_sg"
    Environment = "dev"
    Project     = "application"
  }
}