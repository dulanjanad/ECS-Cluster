output "vpc_id" {
  value = module.vpc.vpc_id
}

output "repository-url" {
  value = aws_ecr_repository.aws-ecr.repository_url
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.master.db_instance_address
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.master.db_instance_availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.master.db_instance_endpoint
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.master.db_instance_id
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.master.db_instance_username
  sensitive   = true
}

output "db_instance_password" {
  description = "The database password (this password may be old, because Terraform doesn't track it after initial creation)"
  value       = module.master.db_instance_password
  sensitive   = true
}

output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.master.db_subnet_group_id
}

output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.master.db_parameter_group_id
}