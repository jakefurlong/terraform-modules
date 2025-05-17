# vpc/test/main.tf
provider "aws" {
  region = "us-west-1"
}

module "custom_vpc" {
  source = "../../network/vpc"

  aws_vpc_cidr_block = "10.0.0.0/16"
  aws_network_name   = "nimbusdevops-test"
}