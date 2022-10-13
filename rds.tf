resource "aws_db_subnet_group" "rds-subnet-group" {

  name       = "rds-${lower(var.vpc_name)}-subnet-group"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  tags = {
    Name = "rds-${lower(var.vpc_name)}-subnet-group"
    Environment = var.environment
  }
}

resource "random_password" "master" {

  length = 10

}

module "aurora" {

  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.5.1"

  name           = "${var.app_name}-rds-cluster"
  engine         = var.engine
  engine_version = var.engine_version
  instances = {
    1 = {
      instance_class      = var.instance_class
      publicly_accessible = false
    }
    2 = {
      identifier     = "${var.app_name}-rds-instance"
      instance_class = var.instance_class
    }
  }

  vpc_id                 = module.vpc.vpc_id
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  create_db_subnet_group = false
  create_security_group  = false
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  iam_database_authentication_enabled = true
  create_random_password              = true

  apply_immediately   = true
  skip_final_snapshot = true

  database_name = var.db_name

  create_db_cluster_parameter_group      = true
  db_cluster_parameter_group_name        = "${var.app_name}-rds-cluster-parameter-group"
  db_cluster_parameter_group_family      = var.family
  db_cluster_parameter_group_description = "${var.app_name} rds cluster parameter group"
  db_cluster_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 120
      apply_method = "immediate"
      }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
      }, {
      name         = "log_output"
      value        = "FILE"
      apply_method = "immediate"
      }, {
      name         = "max_allowed_packet"
      value        = "67108864"
      apply_method = "immediate"
      }, {
      name         = "aurora_parallel_query"
      value        = "OFF"
      apply_method = "pending-reboot"
      }, {
      name         = "binlog_format"
      value        = "ROW"
      apply_method = "pending-reboot"
      }, {
      name         = "log_bin_trust_function_creators"
      value        = 1
      apply_method = "immediate"
      }, {
      name         = "require_secure_transport"
      value        = "ON"
      apply_method = "immediate"
      }, {
      name         = "tls_version"
      value        = "TLSv1.2"
      apply_method = "pending-reboot"
    }
  ]

  create_db_parameter_group      = true
  db_parameter_group_name        = "${var.app_name}-rds-instance-parameter-group"
  db_parameter_group_family      = var.family
  db_parameter_group_description = "${var.app_name} rds instance parameter group"
  db_parameter_group_parameters = [
    {
      name         = "connect_timeout"
      value        = 60
      apply_method = "immediate"
      }, {
      name         = "general_log"
      value        = 0
      apply_method = "immediate"
      }, {
      name         = "innodb_lock_wait_timeout"
      value        = 300
      apply_method = "immediate"
      }, {
      name         = "log_output"
      value        = "FILE"
      apply_method = "pending-reboot"
      }, {
      name         = "long_query_time"
      value        = 5
      apply_method = "immediate"
      }, {
      name         = "max_connections"
      value        = 2000
      apply_method = "immediate"
      }, {
      name         = "slow_query_log"
      value        = 1
      apply_method = "immediate"
      }, {
      name         = "log_bin_trust_function_creators"
      value        = 1
      apply_method = "immediate"
    }
  ]

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  security_group_use_name_prefix  = false

  tags = {
    Name        = "${var.vpc_name}-RDS"
    Environment = var.environment
  }
}