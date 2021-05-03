resource "aws_launch_configuration" "web_lc" {
  name            = "${var.env}_web_lc"
  image_id        = data.aws_ami.amazon_linux2.id
  instance_type   = var.instance_type
  user_data       = data.template_file.user_data.rendered
  security_groups = [aws_security_group.web_sg.id]
}

resource "aws_security_group" "web_sg" {
  name        = "${var.env}_web_sg"
  description = "Allow HTTP traffic"
  #vpc must be here if it is not default VPC. In our case, it is defulat VPC)
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_web_sg"
    }
  )
}

resource "aws_security_group_rule" "http_from_lb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "mysql_to_db" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = data.terraform_remote_state.rds.outputs.rds_sg_id
  security_group_id        = aws_security_group.web_sg.id
}
resource "aws_security_group_rule" "web_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}