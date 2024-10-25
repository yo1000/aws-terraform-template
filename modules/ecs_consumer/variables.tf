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

# Container settings - Consumer
variable "container_name" {
  type = string
}

variable "container_version" {
  type = string
}

variable "container_exec_role_arn" {
  type = string
}

variable "container_role_arn" {
  type = string
}

variable "container_count" {
  type    = string
  default = 1
}

variable "container_envvar_value_point_api_baseurl" {
  type = string
}

variable "container_envvar_value_kafka_bootstrap_servers" {
  type = string
}

variable "container_envvar_value_kafka_topic_name" {
  type = string
}

variable "container_envvar_value_kafka_consumer_group_id" {
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
