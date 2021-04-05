resource "aws_instance" "task_instance" {
  ami = data.aws_ami.centos_7.id
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  user_data = data.template_file.user_data.rendered 

  tags = var.tags
}