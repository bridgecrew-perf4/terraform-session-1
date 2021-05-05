resource "aws_db_instance" "rds_db" {
  allocated_storage         = 10
  storage_type              = "gp2"
  engine                    = "mysql"
  engine_version            = "5.7"
  instance_class            = "db.t2.micro"
  identifier                = "${var.env}-instance"
  name                      = "wordpress_db" # don't use variables
  username                  = "admin"        # don't use variables
  password                  = random_password.password.result
  skip_final_snapshot       = var.snapshot
  final_snapshot_identifier = var.snapshot == true ? null : "${var.env}-snapshot"
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]
  publicly_accessible       = var.env == "dev" ? true : false # = false, same thing
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_rds_db"
    }
  )
}

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

resource "aws_security_group_rule" "db_sg_to_web_sg" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.source_sg_for_rds_sg.web_sg_id
  security_group_id        = aws_security_group.rds_sg.id
}

module "source_sg_for_rds_sg" {
  source = "../frontend/"
  
  aws_region        = "us-east-1"
  instance_type     = "t2.micro"
  env               = "dev"
}

# resource "aws_security_group_rule" "egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.rds_sg.id
# }