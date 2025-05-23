variable "aws_vpc_cidr_block" {
  description = "The cidr range of the VPC"
  type        = string
}

variable "aws_network_name" {
  description = "Default name for network resources"
  type        = string
}

variable "azs" {
  type    = list(string)
  default = ["us-west-1b", "us-west-1c"]
}
