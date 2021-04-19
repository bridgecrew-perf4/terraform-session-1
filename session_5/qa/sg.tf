resource "aws_security_group" "web_sg" {
  name        = var.sg_name
  description = "this is security group for web instance"
  
  tags = {
    Name = "${var.env}-sg"
  }
}

resource "aws_security_group_rule" "web_ingress" {
  count = length(var.web_sg_tcp_ports)
  type = "ingress"
  protocol = "tcp"
  from_port = element(var.web_sg_tcp_ports, count.index)
  to_port = element(var.web_sg_tcp_ports, count.index)
  cidr_blocks = [element(var.web_sg_tcp_ports_cidr, count.index)]
  security_group_id = aws_security_group.web_sg.id
}