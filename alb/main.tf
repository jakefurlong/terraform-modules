resource "aws_security_group" "terraform_alb_sg" {
  name   = "${var.stack_name}-alb-sg"
  vpc_id = var.aws_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_sg_ingress_cidr_range
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "terraform_alb" {
  name               = "${var.stack_name}-alb"
  load_balancer_type = "application"
  subnets            = local.effective_subnets
  security_groups    = [aws_security_group.terraform_alb_sg.id]
}

resource "aws_lb_listener" "terraform_listener" {
  load_balancer_arn = aws_lb.terraform_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "terraform_alb_rule" {
  listener_arn = aws_lb_listener.terraform_listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.terraform_tg.arn
  }
}

resource "aws_alb_target_group" "terraform_tg" {
  name     = "${var.stack_name}-tg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}