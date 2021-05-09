# EC2
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux2.image_id # data source reference
  instance_type          = var.instance_type                   # variable
  key_name               = aws_key_pair.tf_key.key_name        # reference to key pair
  vpc_security_group_ids = [aws_security_group.web_sg.id]      # reference to security group 

  tags = local.common_tags
}

# Key Pair
resource "aws_key_pair" "tf_key" {
  key_name   = "${var.env}-tf_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Security group
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