resource "aws_vpc" "custom_vpc" {
  cidr_block       = var.aws_vpc_cidr_block

  tags = {
    Name = "${var.aws_network_name}-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}