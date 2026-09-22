resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-rds-subnets"
  subnet_ids = data.aws_subnets.private.ids

  lifecycle {
    precondition {
      condition     = length(distinct([for s in data.aws_subnet.private : s.availability_zone])) >= 2
      error_message = "Esperado subnets ${var.project_name}-private-* em pelo menos 2 AZs, criadas pelo repo K8S."
    }
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.project_name}-postgres"
  engine                  = "postgres"
  instance_class          = var.rds_instance_class
  allocated_storage       = var.rds_allocated_storage
  storage_type            = "gp3"
  db_name                 = var.rds_db_name
  username                = var.rds_username
  password                = var.rds_password
  port                    = 5432
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = false
  multi_az                = false
  deletion_protection     = false
  skip_final_snapshot     = true
  backup_retention_period = 0
  apply_immediately       = true
  storage_encrypted       = true
}
