# This security group contains a "dynamic block"  and locals which contains all the 
# attributes needed for creation of two inbound rules 22 and 80. "for_each"
# meta-argument is itirating and getting the attributes for each security roup rule. 
# Which makes our security group reusable, all the attributes can be changed in locals.tf

resource "aws_security_group" "web_sg" {
  name        = "${var.env}_web_sg"
  description = "allow inbound/outbound traffic"

  dynamic "ingress" {
    for_each = local.rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.env}_web_sg"
    Environment = var.env
    Project     = var.project_name
  }
}