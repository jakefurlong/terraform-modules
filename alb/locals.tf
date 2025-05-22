locals {
  effective_vpc_id = var.vpc_id != null ? var.vpc_id : data.aws_vpc.default.id
}

locals {
  effective_subnets = length(var.subnet_ids) > 0 ? var.subnet_ids : data.aws_subnets.default.ids
}