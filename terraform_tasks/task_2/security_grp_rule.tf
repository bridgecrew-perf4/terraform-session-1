# Wordpress web security group
resource "aws_security_group" "wordpress_sg" {
  name        = "${var.env}_wordpress_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_wp_sg"
    }
  )
}

resource "aws_security_group_rule" "wordpress_web_ingress" {
  count             = length(var.web_sg_tcp_ports)
  type              = var.in_traffic_type
  protocol          = var.ingress_protocol
  from_port         = element(var.web_sg_tcp_ports, count.index)
  to_port           = element(var.web_sg_tcp_ports, count.index)
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.wordpress_sg.id
}

resource "aws_security_group_rule" "mysql_to_wpdb_sg" {
  count                    = length(var.webdb_sg_tcp_ports)
  security_group_id        = aws_security_group.wordpress_sg.id
  type                     = var.in_traffic_type
  from_port                = element(var.webdb_sg_tcp_ports, 0)
  to_port                  = element(var.webdb_sg_tcp_ports, 0)
  protocol                 = var.ingress_protocol
  source_security_group_id = aws_security_group.wordpress_db_sg.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = var.egress_port
  to_port           = var.egress_port
  protocol          = var.egress_protocol
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.wordpress_sg.id
}

# Wordpress database security group
resource "aws_security_group" "wordpress_db_sg" {
  name        = "${var.env}_wordpress_db_sg"
  description = "Allow inbound traffic to wordpress database"
  vpc_id      = aws_vpc.my_vpc.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_wpdb_sg"
    }
  )
}

resource "aws_security_group_rule" "mysql_to_wp_sg" {
  count                    = length(var.webdb_sg_tcp_ports)
  security_group_id        = aws_security_group.wordpress_db_sg.id
  type                     = var.in_traffic_type
  from_port                = element(var.webdb_sg_tcp_ports, 0)
  to_port                  = element(var.webdb_sg_tcp_ports, 0)
  protocol                 = var.ingress_protocol
  source_security_group_id = aws_security_group.wordpress_sg.id
}

resource "aws_security_group_rule" "egress_for_wpdb" {
  type              = var.out_traffic_type
  from_port         = var.egress_port
  to_port           = var.egress_port
  protocol          = var.egress_protocol
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.wordpress_db_sg.id
}