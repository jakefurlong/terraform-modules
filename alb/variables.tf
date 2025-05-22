variable "vpc_id" {
  description = "VPC ID to use. Defaults to the default VPC if not set."
  type        = string
  default     = null
}

variable "stack_name" {
  description = "Name of stack resource prefix"
  type        = string
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
  type        = number
}

variable "subnet_ids" {
  description = "List of subnet IDs to use. Defaults to subnets in default VPC if not set."
  type        = list(string)
}

variable "alb_sg_ingress_cidr_range" {
  description = "Allow CIDR range for ALB ingress"
  type        = list(string)
}

variable "aws_vpc_id" {
  description = "VPC ID"
  type        = string
}
