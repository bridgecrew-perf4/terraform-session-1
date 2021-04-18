resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux2.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.tf_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = data.template_file.user_data.rendered
  tags = {
    Name  = "${var.env}-instance"
    Name2 = format("%s-instance", var.env)
  }
}