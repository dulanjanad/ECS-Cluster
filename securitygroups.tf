resource "aws_security_group" "service_security_group" {

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    description     = "Allow Traffic from load balancer security group"
    protocol        = "-1"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-service-security-group"
    Environment = var.environment
  }
}

resource "aws_security_group" "load_balancer_security_group" {

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port        = 80
    to_port          = 80
    description      = "Allow HTTP Traffic from any host"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.app_name}-alb-security-group"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_security_group" {

  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "MySQL access from within VPC"
    cidr_blocks = [var.cidr]
  }

  tags = {
    Name        = "${var.app_name}-rds-security-group"
    Environment = var.environment
  }
}