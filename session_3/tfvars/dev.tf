env           = "dev"
instance_type = "t2.micro"
image_id      = "ami-0742b4e673072066f"
key_name      = "my_tf_key"
http_inbound_rule = "80"
ssh_inbound_rule = "22"
outbound_rule = "0"
cidr_blocks = ["0.0.0.0/0"]
sg_name = "web_sg"
ingress_protocol = "tcp"
egress_protocol = "-1"