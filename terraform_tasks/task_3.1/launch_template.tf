# Launch Template
resource "aws_launch_template" "web_template" {
  name_prefix   = "${var.env}_web_template"
  image_id      = data.aws_ami.amazon_linux2.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  lifecycle {
    create_before_destroy = true
  }
  user_data       = filebase64("${path.module}/user_data.sh")

  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_web_lt"
    }
  )
}

# Security group for webserver
resource "aws_security_group" "web_sg" {
  name        = "${var.env}_web_sg"
  description = "allow http traffic"
  vpc_id      = aws_vpc.my_vpc.id
  
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_web_sg"
    }
  )
}

resource "aws_security_group_rule" "http_from_lb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb_sg.id
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