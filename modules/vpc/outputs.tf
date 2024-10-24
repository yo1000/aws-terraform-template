output "vpc_id" {
  value = data.aws_vpc.main.id
}

output "subnet_pub_ids" {
  value = data.aws_subnets.main_pub.ids
}

output "subnet_pro_ids" {
  value = data.aws_subnets.main_pro.ids
}

output "subnet_pri_ids" {
  value = data.aws_subnets.main_pri.ids
}
