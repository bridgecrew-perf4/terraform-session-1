resource "aws_instance" "wordpress_db" {
  ami                         = data.aws_ami.amazon_linux2.image_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.wordpress_db_sg.id]
  subnet_id                   = aws_subnet.private_subnet_1.id
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = aws_key_pair.terraform_server_key.key_name
  user_data                   = file("sql_userdata.sh")

  tags = {
    Name        = "${var.env}_wordpress_db"
    Environment = var.env
    Project     = var.project_name
  }
}