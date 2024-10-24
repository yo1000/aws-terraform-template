# 新規リソースの構築 => resource
# 既存リソースの解決 => data

# https://registry.terraform.io/providers/hashicorp/aws/4.1.0/docs/data-sources/vpc
data "aws_vpc" "main" {
  id = var.vpc_id
}

# https://registry.terraform.io/providers/hashicorp/aws/4.1.0/docs/data-sources/subnets
data "aws_subnets" "main_pub" {
  filter {
    name   = "subnet-id"
    values = var.subnet_pub_ids
  }
}

data "aws_subnets" "main_pro" {
  filter {
    name   = "subnet-id"
    values = var.subnet_pro_ids
  }
}

data "aws_subnets" "main_pri" {
  filter {
    name   = "subnet-id"
    values = var.subnet_pri_ids
  }
}
