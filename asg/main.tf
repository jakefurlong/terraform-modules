resource "aws_security_group" "terraform_sg" {
  name   = "${var.asg_name}-sg"
  vpc_id = var.aws_vpc_id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = var.asg_sg_ingress
  }
}

resource "aws_launch_template" "terraform_lt" {
  name                   = "${var.asg_name}-template"
  image_id               = var.machine_image
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]

  user_data = base64encode(templatefile("user-data.sh", {
    server_port = var.server_port
  }))
}

resource "aws_autoscaling_group" "terraform_asg" {
  name                = "${var.asg_name}-asg"
  vpc_zone_identifier = var.aws_vpc_zone_identifier
  desired_capacity    = 2
  max_size            = var.max_size
  min_size            = var.min_size
  target_group_arns   = var.aws_target_group_arn != null ? [var.aws_target_group_arn] : null
  force_delete        = true

  launch_template {
    id      = aws_launch_template.terraform_lt.id
    version = aws_launch_template.terraform_lt.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.asg_name}-instance"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_template.terraform_lt]
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count                  = var.enable_autoscaling ? 1 : 0
  scheduled_action_name  = "${var.asg_name}-scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.terraform_asg.name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count                  = var.enable_autoscaling ? 1 : 0
  scheduled_action_name  = "${var.asg_name}-scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = aws_autoscaling_group.terraform_asg.name
}