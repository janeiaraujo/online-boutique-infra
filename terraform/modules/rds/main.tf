resource "aws_db_subnet_group" "rds" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = merge(
    {
      Name        = var.subnet_group_name
      Environment = var.environment
      FinOps      = "cost-center:12345"
    },
    var.additional_tags
  )
}

resource "aws_db_instance" "postgres" {
  identifier                 = var.db_identifier
  allocated_storage          = var.allocated_storage
  engine                     = var.engine
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  //name                       = var.db_name
  username                   = var.db_username
  password                   = var.db_password
  backup_retention_period    = var.backup_retention_period
  multi_az                   = var.multi_az
  publicly_accessible        = false
  vpc_security_group_ids     = var.security_group_ids
  db_subnet_group_name       = aws_db_subnet_group.rds.name
  skip_final_snapshot        = true   # Pular snapshot final
  tags = merge(
    {
      Name        = var.db_name
      Environment = var.environment
      FinOps      = "cost-center:12345"
    },
    var.additional_tags
  )
}

output "endpoint" {
  value = aws_db_instance.postgres.endpoint
}
