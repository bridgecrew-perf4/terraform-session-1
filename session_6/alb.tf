# Application load balancer
resource "aws_lb" "web_lb" {
  name               = "${var.env}-web-lb"
  internal           = false # you don't make variables
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet[1].id, aws_subnet.public_subnet[2].id, aws_subnet.public_subnet[3].id,]
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
resource "aws_lb_listener" "http_listener" {
  depends_on        = []
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# HTTPS listeners rule
resource "aws_lb_listener" "https_listener" {
  depends_on        = []
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = data.aws_acm_certificate.my_certificate.arn
  
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
  for_each          = local.ingress_rules
  type              = each.value.type
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_blocks       = [each.value.cidr_block]
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