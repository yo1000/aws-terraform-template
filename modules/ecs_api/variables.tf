# General settings
variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

# Container settings
variable "container_cluster_name" {
  type = string
}

variable "container_cluster_id" {
  type = string
}

# Container settings - API
variable "container_name" {
  type = string
}

variable "container_version" {
  type = string
}

variable "container_exec_role_arn" {
  type = string
}

variable "container_count" {
  type    = string
  default = 1
}

variable "container_envvar_value_db_endpoint" {
  type = string
}

variable "container_envvar_value_db_port" {
  type = number
}

variable "container_envvar_value_db_name" {
  type    = string
  default = "postgres"
}

variable "container_envvar_value_db_option" {
  type    = string
  default = ""
}

variable "container_envvar_from_db_username" {
  type = string
}

variable "container_envvar_from_db_password" {
  type = string
}

variable "container_lb_security_group_ids" {
  type = list(string)
}

variable "container_lb_subnet_ids" {
  type = list(string)
}

variable "container_service_subnet_ids" {
  type = list(string)
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "container_health_port" {
  type    = number
  default = 8080
}
