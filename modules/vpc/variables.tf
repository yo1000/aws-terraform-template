variable "vpc_id" {
  type = string
}

variable "subnet_pub_ids" {
  type = list(string)
}

variable "subnet_pro_ids" {
  type = list(string)
}

variable "subnet_pri_ids" {
  type = list(string)
}
