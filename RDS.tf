resource "aws_db_parameter_group" "example" {
  family = "mysql5.7"
  name = "example"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

resource "aws_db_option_group" "example" {
  engine_name          = "mysql"
  major_engine_version = "5.7"
  name = "example"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}

resource "aws_db_subnet_group" "example" {
  subnet_ids = [aws_subnet.private_0.id, aws_subnet.private_1.id]
  name = "example"
}

resource "aws_db_instance" "example" {
  instance_class = "db.t3.small"
  identifier = "example"
  engine = "mysql"
  engine_version = "5.7.44"
  allocated_storage = 20
  max_allocated_storage = 100
  storage_type = "gp2"
  storage_encrypted = true
  kms_key_id = aws_kms_key.example.arn
  username = "admin"
  password = "VeryStrongPassword!"
  multi_az = true
  publicly_accessible = false
  backup_window = "09:10-09:40"
  backup_retention_period = 30
  maintenance_window = "mon:10:10-mon:10:40"
  auto_minor_version_upgrade = false
  deletion_protection = false
  skip_final_snapshot = true
  port = 3306
  apply_immediately = false
  vpc_security_group_ids = [module.mysql_sg.security_group_id]
  parameter_group_name = aws_db_parameter_group.example.name
  option_group_name = aws_db_option_group.example.name
  db_subnet_group_name = aws_db_subnet_group.example.name

  lifecycle {
    ignore_changes = [password]
  }
}