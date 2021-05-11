resource "aws_launch_configuration" "web_lc" {
  name            = "${var.env}_web_lc"
  image_id        = data.aws_ami.amazon_linux2.id
  instance_type   = var.instance_type
  user_data       = data.template_file.user_data.rendered
  security_groups = [data.terraform_remote_state.rds.outputs.web_sg_id]
}