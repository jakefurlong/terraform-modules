variable "aws_vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "asg_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
  type        = number
}

variable "asg_sg_ingress" {
  description = "Allowed ingress traffic for ASG security group"
  type        = list(string)
}

variable "machine_image" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to run"
  type        = string
}

variable "max_size" {
  description = "The maximum number of EC2 instances in the ASG"
}

variable "min_size" {
  description = "The minimum number of EC2 instances in the ASG"
  type        = number
}

variable "enable_autoscaling" {
  description = "Boolean value to enable autoscaling"
  type        = bool
  default     = true
}

variable "aws_target_group_arn" {
  description = "Optional target group ARN to attach to ASG"
  type        = string
  default     = null
}

variable "aws_vpc_zone_identifier" {
  description = "private subnets for ASG"
  type        = list(string)
}