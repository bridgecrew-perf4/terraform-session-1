resource "aws_db_instance" "rds_db" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "${var.env}-instance"
  name                 = "wordpress_db" # don't use variable
  username             = "admin" # don't use variable
  password             = random_password.password.result
  skip_final_snapshot  = var.snapshot 
  final_snapshot_identifier = var.snapshot == true ? null : "${var.env}-snapshot"
  vpc_security_group_ids = [ aws_security_group.rds_sg.id ]
  publicly_accessible = var.env == "dev" ? true : false  # = false, same thing
}


resource "aws_security_group" "rds_sg" {
  name        = "${var.env}_rds_sg"
  description = "allow from MySQL"

  tags = {
    Name = "${var.env}_rds_sg"
  }
}

resource "aws_security_group_rule" "db_ingress" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "local_laptop" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_sg.id
}