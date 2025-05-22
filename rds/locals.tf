locals {
  effective_vpc_id     = var.vpc_id != null ? var.vpc_id : data.aws_vpc.default.id
  effective_subnet_ids = var.subnet_ids != null ? var.subnet_ids : data.aws_subnets.default.ids
}
