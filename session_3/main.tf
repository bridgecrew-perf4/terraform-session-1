resource "aws_instance" "web" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.tf_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = file("user_data.sh")
  tags = {
    Name = "${var.env}-instance"
  }
}

resource "aws_key_pair" "tf_key" {
  key_name = "${var.env}-tf_key"
  public_key = file("~/.ssh/id_rsa.pub") 
}