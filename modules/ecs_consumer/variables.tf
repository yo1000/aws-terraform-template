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
variable "container_consumer_name" {
  type = string
}

variable "container_consumer_version" {
  type = string
}

variable "container_consumer_exec_role_arn" {
  type = string
}

variable "container_consumer_role_arn" {
  type = string
}

variable "container_consumer_count" {
  type    = string
  default = 1
}

variable "container_consumer_envvar_value_point_api_baseurl" {
  type = string
}

variable "container_consumer_envvar_value_kafka_bootstrap_servers" {
  type = string
}

variable "container_consumer_envvar_value_kafka_topic_name" {
  type = string
}

variable "container_consumer_envvar_value_kafka_consumer_group_id" {
  type = string
}

variable "container_consumer_lb_security_group_ids" {
  type = list(string)
}

variable "container_consumer_lb_subnet_ids" {
  type = list(string)
}

variable "container_consumer_service_subnet_ids" {
  type = list(string)
}

variable "container_consumer_port" {
  type    = number
  default = 8080
}

variable "container_consumer_health_port" {
  type    = number
  default = 8080
}
