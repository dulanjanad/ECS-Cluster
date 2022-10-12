resource "aws_db_subnet_group" "rds-subnet-group" {

  name       = "rds-${lower(var.vpc_name)}-subnet-group"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  tags = {
    Name = "My DB subnet group"
  }
}

module "master" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.1.0"

  identifier = "${var.app_name}-rds-master"

  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family
  major_engine_version = var.major_engine_version
  instance_class       = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  db_name  = var.db_name
  username = var.db_username
  port     = var.port

  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  # Backups are required in order to create a replica
  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name        = "${var.vpc_name}-RDS-Master"
    Environment = var.environment
  }
}

module "replica" {

  source  = "terraform-aws-modules/rds/aws"
  version = "5.1.0"

  identifier = "${var.app_name}-replica"

  # Source database. For cross-region use db_instance_arn
  replicate_source_db    = module.master.db_instance_id
  create_random_password = false

  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family
  major_engine_version = var.major_engine_version
  instance_class       = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  port = var.port

  multi_az               = false
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  maintenance_window              = "Tue:00:00-Tue:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name        = "${var.vpc_name}-RDS-Replica"
    Environment = var.environment
  }
}