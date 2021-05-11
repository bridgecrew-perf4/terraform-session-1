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