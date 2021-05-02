# Application load balancer
resource "aws_lb" "web_lb" {
  name               = "${var.env}-web-lb"
  internal           = false # internet-facing = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets = data.aws_subnet_ids.default.ids

  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}-web-lb"
    }
  )
}

# Target group
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
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}-web-tg"
    }
  )
}

resource "aws_lb_listener" "http_listener" {
  depends_on = [  ]
  load_balancer_arn = aws_lb.web_lb.arn
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
  vpc_id      = data.aws_vpc.default.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_web_lb_sg"
    }
  )
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