# RDS Security group
resource "aws_security_group" "rds_sg" {
  name        = "${var.env}_rds_sg"
  description = "allow from MySQL"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_rds_sg"
    }
  )
}

resource "aws_security_group_rule" "db_ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "mysql_to_web_sg" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
  security_group_id        = aws_security_group.rds_sg.id
}

# Webserver Security group
resource "aws_security_group" "web_sg" {
  name        = "${var.env}_web_sg"
  description = "Allow HTTP traffic"
  #vpc must be here if it is not default VPC. In our case, it is defulat VPC)
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_web_sg"
    }
  )
}

resource "aws_security_group_rule" "http_from_lb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "mysql_to_rds_sg" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.rds_sg.id
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
