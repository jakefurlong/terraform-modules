resource "aws_vpc" "custom_vpc" {
  cidr_block = var.aws_vpc_cidr_block

  tags = {
    Name = "${var.aws_network_name}-vpc"
  }
}

resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "${var.aws_network_name}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }

  tags = {
    Name = "${var.aws_network_name}-rt-public"
  }
}

resource "aws_route_table" "private_rt" {
  for_each = aws_nat_gateway.nat

  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.id
  }

  tags = {
    Name = "${var.aws_network_name}-rt-private-${each.key}"
  }
}

resource "aws_subnet" "public" {
  for_each = toset(var.azs)

  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = cidrsubnet(var.aws_vpc_cidr_block, 8, index(var.azs, each.key))
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.aws_network_name}-subnet-public-${each.key}"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private" {
  for_each = toset(var.azs)

  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = cidrsubnet(var.aws_vpc_cidr_block, 8, 100 + index(var.azs, each.key))
  availability_zone = each.key

  tags = {
    Name = "${var.aws_network_name}-subnet-private-${each.key}"
  }
}

resource "aws_eip" "nat" {
  for_each = aws_subnet.public

  domain = "vpc"

  tags = {
    Name = "${var.aws_network_name}-eip-nat-${each.key}"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each = aws_subnet.public

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "${var.aws_network_name}-nat-gateway-${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt[each.key].id
}

resource "aws_security_group" "default_sg" {
  name        = "${var.aws_network_name}-default-sg"
  description = "Default SG allowing all traffic within the VPC"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.aws_vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.aws_network_name}-default-sg"
  }
}