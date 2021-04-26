resource "aws_lb" "web_lb" {
  name               = "${var.env}-web-lb"
  internal           = false # you don't make variables
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = data.aws_subnet_ids.default_subnet.ids
}

resource "aws_lb_target_group" "web_tg" {
  name     = "${var.env}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  
  health_check {
    path    = "/"
    port    = 80
    matcher = "200"
    }
}

resource "aws_lb_listener" "web_listener" {
  depends_on = [  ]
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80" 
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_security_group" "lb_sg" {
  name = "${var.env}_lb_sg"
  description = "allow http traffic"
  #vpc must be here if it's not default
}

resource "aws_security_group_rule" "lb_ingress" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "lb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"  # -1 means everything
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}