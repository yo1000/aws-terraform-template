# General settings
variable "project" {
  type = string
}

variable "region" {
  description = "Region where to deploy the resources"
  type        = string
}

variable "environment" {
  type        = string
  description = "The environment where to deploy the solution"
}

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

variable "security_group_vpc_id" {
  type = string
}

variable "security_group_http_id" {
  type = string
}

# Database settings
variable "db_username" {
  type    = string
  default = "postgres"
}

# Event streaming settings
variable "msk_cluster_arn" {
  type = string
}

# Container settings - API
variable "container_api_name" {
  type = string
}

variable "container_api_version" {
  type = string
}

variable "container_api_exec_role_arn" {
  type = string
}

variable "container_api_count" {
  type    = string
  default = 1
}

variable "container_api_envvar_value_db_name" {
  type    = string
  default = "postgres"
}

variable "container_api_envvar_value_db_option" {
  type    = string
  default = ""
}

variable "container_api_port" {
  type    = number
  default = 8080
}

variable "container_api_health_port" {
  type    = number
  default = 8080
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

variable "container_consumer_port" {
  type    = number
  default = 8080
}

variable "container_consumer_health_port" {
  type    = number
  default = 8080
}
