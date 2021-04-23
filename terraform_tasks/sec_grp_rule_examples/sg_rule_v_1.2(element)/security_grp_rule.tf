# Webserver security group
resource "aws_security_group" "web_sg" {
  name        = "${var.env}_web_sg"
  description = "Allow inbound traffic"
  #vpc_id      = aws_vpc.my_vpc.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_web_sg"
    }
  )
}

resource "aws_security_group_rule" "web_ingress" {
  count             = length(var.web_sg_tcp_ports)
  type              = var.in_traffic_type
  protocol          = var.ingress_protocol
  from_port         = element(var.web_sg_tcp_ports, count.index)
  to_port           = element(var.web_sg_tcp_ports, count.index)
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = var.egress_port
  to_port           = var.egress_port
  protocol          = var.egress_protocol
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.web_sg.id
}