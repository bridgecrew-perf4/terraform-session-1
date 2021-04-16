# Application load balancer
resource "aws_lb" "web_alb" {
  name        = "${var.env}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_alb_sg.id]
  subnets            = aws_subnet.public.*.id
  enable_deletion_protection = true

  tags = {
    Name  = "${var.env}-web_alb"
    Environment = var.env
    Project     = var.project_name    
  }
}

# Target group
resource "aws_lb_target_group" "web_tg" {
  name     = "tf-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
  load_balancing_algorithm_type = "least_outstanding_requests"
  health_check {
    path    = "/"
    port    = 80
    matcher = "200"
  }
}

# Instance attachment
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.wordpress_web.id
  port             = 80
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.webserver_alb.arn
  port              = "443" 
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.amazon_issued.arn # aws_alb_certificate.domain_certificate.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_listener" "http_listener" {
  depends_on = [  ]
  load_balancer_arn = aws_lb.webserver_alb.arn
  port              = "80" 
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}