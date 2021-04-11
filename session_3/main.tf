resource "aws_instance" "web" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = <<EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install -y httpd 
        sudo systemctl start httpd
        sudo systemctl enable httpd
        echo "Welcome" > /var/www/html/index.html
  EOF
  tags = {
    Name = "${var.env}-instance"
  }
}