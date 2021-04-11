resource "aws_security_group" "web_sg" {
  name        = var.sg_name
  description = "this is security group for web instance"

  ingress {
    description = "http ingress"
    from_port   = var.http_inbound_rule
    to_port     = var.http_inbound_rule
    protocol    = var.ingress_protocol
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    description = "ssh ingress"
    from_port   = var.ssh_inbound_rule
    to_port     = var.ssh_inbound_rule
    protocol    = var.ingress_protocol
    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port   = var.outbound_rule
    to_port     = var.outbound_rule
    protocol    = var.egress_protocol
    cidr_blocks = var.cidr_blocks
  }

  tags = {
    Name = "${var.env}-sg"
  }
}