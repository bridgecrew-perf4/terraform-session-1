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
resource "aws_security_group_rule" "http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpress_sg.id
}
resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
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

resource "aws_security_group_rule" "db_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.wordpress_db_sg.id
}