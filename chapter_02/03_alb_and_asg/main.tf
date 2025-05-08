provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "test_sg" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "test_lt" {
  name                   = "terraform_launch_template"
  image_id               = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.test_sg.id]

  user_data = filebase64("${path.module}/server_config.sh")
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 2
  max_size           = 5
  min_size           = 2
  target_group_arns  = [aws_alb_target_group.test_tg.arn]

  launch_template {
    id      = aws_launch_template.test_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_lb" "test_lb" {
  name               = "terraform-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_listener" "test-listener" {
  load_balancer_arn = aws_lb.test_lb.arn
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

resource "aws_lb_listener_rule" "test-lb-rule" {
  listener_arn = aws_lb_listener.test-listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.test_tg.arn
  }
}

resource "aws_security_group" "alb_sg" {
  name = "terraform-example-alb-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb_target_group" "test_tg" {
  name     = "terraform-tg"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

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

output "alb_dns_name" {
  value       = aws_lb.test_lb.dns_name
  description = "The domain name of the load balancer"
}