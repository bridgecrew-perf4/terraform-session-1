resource "aws_instance" "wordpress_db" {
  ami                         = data.aws_ami.amazon_linux2.image_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.wordpress_db_sg.id]
  subnet_id                   = aws_subnet.private_subnet_1.id
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = aws_key_pair.terraform_server_key.key_name
  user_data                   = data.template_file.sql_userdata.rendered

  tags = {
    Name        = "${var.env}_wordpress_db"
    Environment = var.env
    Project     = var.project_name
  }
}

data "template_file" "sql_userdata" {
  template = file("./sql_userdata.sh")
  vars = {
    wordpress_private_ip = aws_instance.wordpress_web.private_ip
    description       = "variable named wordpress_private_ip will get the private_ip of wordpress_web"
  }
}