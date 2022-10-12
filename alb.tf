resource "aws_lb" "application_load_balancer" {

  name               = "${var.app_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name        = "${var.app_name}-alb"
    Environment = var.environment
  }

}

resource "aws_lb_target_group" "target_group" {

  name        = "${var.app_name}-${var.environment}-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/v1/status"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_name}-loadbalancer-target-group"
    Environment = var.environment
  }

}

resource "aws_lb_listener" "listener" {

  load_balancer_arn = aws_lb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }

  depends_on = [aws_lb.application_load_balancer]

}