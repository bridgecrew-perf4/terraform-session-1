resource "aws_instance" "wordpress_web" {
  ami                         = data.aws_ami.amazon_linux2.image_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = file("web_userdata.sh")
  key_name                    = aws_key_pair.terraform_server_key.key_name

  tags = {
    Name        = "${var.env}_wordpress_web"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_key_pair" "terraform_server_key" {
  key_name   = "${var.env}-terraform_server_key"
  public_key = file("~/.ssh/id_rsa.pub")
}