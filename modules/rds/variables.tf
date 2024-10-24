variable "db_cluster_id" {
  type = string
}

variable "db_name" {
  type    = string
  default = "postgres"
}

variable "db_username" {
  type    = string
  default = "postgres"
}

variable "db_password" {
  type = string
}

variable "db_engine_version" {
  type    = string
  default = "15.4"
}

variable "db_subnet_group_name" {
  type = string
}

variable "db_subnet_group_subnet_ids" {
  type = list(string)
}
