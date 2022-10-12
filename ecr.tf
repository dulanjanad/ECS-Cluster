resource "aws_ecr_repository" "aws-ecr" {

  name = "${var.app_name}-${var.environment}-ecr"

  tags = {
    Name        = "${var.app_name}-ecr"
    Environment = var.environment
  }

}