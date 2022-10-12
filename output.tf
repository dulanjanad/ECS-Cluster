output "vpc_id" {
  value = module.vpc.vpc_id
}

output "repository-url" {
  value = aws_ecr_repository.aws-ecr.repository_url
}