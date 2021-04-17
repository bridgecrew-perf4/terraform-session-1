resource "aws_security_group" "wordpress_sg" {
  name        = "${var.env}_wordpress_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "http_ingress"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.ingress_protocol
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    description = "ssh_ingress"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    =  var.ingress_protocol
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    description = "myslq_ingress"
    from_port   = var.mysql_port
    to_port     = var.mysql_port
    protocol    =  var.ingress_protocol
    security_groups = [aws_security_group.wordpress_db_sg.id]
  }

  egress {
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = var.egress_protocol
    cidr_blocks = [var.cidr_block]
  }

  tags = {
    Name        = "${var.env}_wp_sg"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_security_group" "wordpress_db_sg" {
  name        = "${var.env}_wordpress_db_sg"
  description = "Allow inbound traffic to wordpress database"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "ssh_ingress-to_db"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.ingress_protocol
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = var.egress_protocol
    cidr_blocks = [var.cidr_block]
  }

  tags = {
    Name        = "${var.env}_wpdb_sg"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_security_group_rule" "from_wpdb-sg_to_wp-web-sg" {
  security_group_id        = aws_security_group.wordpress_db_sg.id
  type                     = var.traffic_type
  from_port                = var.mysql_port
  to_port                  = var.mysql_port
  protocol                 = var.ingress_protocol
  source_security_group_id = aws_security_group.wordpress_sg.id
}