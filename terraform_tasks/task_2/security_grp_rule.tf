# Wordpress web security group
resource "aws_security_group" "wordpress_sg" {
  name        = "${var.env}_wordpress_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name        = "${var.env}_wp_sg"
    Environment = var.env
    Project     = var.project_name
  }
}
resource "aws_security_group_rule" "http_ingress_to_alb-sg" {
  source_security_group_id  = aws_security_group.wordpress_alb_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.wordpress_sg.id
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["108.210.198.102/32"]
  security_group_id = aws_security_group.wordpress_sg.id
}

resource "aws_security_group_rule" "mysql_to_wpdb-sg" {
  security_group_id        = aws_security_group.wordpress_sg.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.wordpress_db_sg.id 
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpress_sg.id
}

# Wordpress database security group
resource "aws_security_group" "wordpress_db_sg" {
  name        = "${var.env}_wordpress_db_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  
  tags = {
    Name        = "${var.env}_wpdb_sg"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_security_group_rule" "ssh_ingress-to_db" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpress_db_sg.id
}

resource "aws_security_group_rule" "mysql_to_wp-sg" {
  security_group_id        = aws_security_group.wordpress_db_sg.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.wordpress_sg.id 
}

# Application load balancer security group
resource "aws_security_group" "wordpress_alb_sg" {
  name        = "${var.env}-app_alb_sg"
  description = "Allow http and https inbound traffic"
  tags = {
    Name  = "${var.env}-alb-sg"
    Environment = var.env
    Project     = var.project_name
  }
}
resource "aws_security_group_rule" "wordpress_alb_sg_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpess_alb_sg.id
}
resource "aws_security_group_rule" "webserver_lb_sg_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpess_alb_sg.id
}
resource "aws_security_group_rule" "wordpress_alb_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpess_alb_sg.id
}