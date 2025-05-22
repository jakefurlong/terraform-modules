output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}

output "vpc_name" {
  value = aws_vpc.custom_vpc.tags["Name"]
}

output "internet_gateway_name" {
  value = aws_internet_gateway.custom_igw.tags["Name"]
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}

output "route_table_association_ids" {
  value = [for rta in aws_route_table_association.public : rta.id]
}

output "security_group_name" {
  value = aws_security_group.default_sg.tags["Name"]
}

output "aws_route_table_public_name" {
  value = aws_route_table.public_rt.tags["Name"]
}
