# Application load balancer
resource "aws_lb" "web_lb" {
  for_each          = local.public_subnet
  name               = "${var.env}-web-lb"
  internal           = false # you don't make variables
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet[each.key].id]
}

# Target group
resource "aws_lb_target_group" "web_tg" {
  name     = "${var.env}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path    = "/"
    port    = 80
    matcher = "200"
  }
}

# HTTP listeners rule
resource "aws_lb_listener" "web_listener" {
  for_each          = local.public_subnet
  depends_on        = []
  load_balancer_arn = aws_lb.web_lb[each.key].arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# ALB security group
resource "aws_security_group" "lb_sg" {
  name        = "${var.env}_lb_sg"
  description = "allow http traffic"
  vpc_id      = aws_vpc.my_vpc.id
}

resource "aws_security_group_rule" "lb_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "lb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # -1 means everything
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}