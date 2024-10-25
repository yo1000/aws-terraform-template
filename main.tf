## VPC
module "vpc" {
  source = "./modules/vpc"

  vpc_id         = var.vpc_id
  subnet_pub_ids = var.subnet_pub_ids
  subnet_pro_ids = var.subnet_pro_ids
  subnet_pri_ids = var.subnet_pri_ids
}

module "secrets" {
  source = "./modules/secrets"

  secret_name = "${var.project}-rds-credentials"
  db_username = var.db_username
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret
data "aws_secretsmanager_secret" "rds_credentials" {
  arn = module.secrets.secret_arn
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version
data "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = data.aws_secretsmanager_secret.rds_credentials.id
}

locals {
  rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_credentials_version.secret_string)
}

module "rds" {
  source = "./modules/rds"

  db_cluster_id = var.project
  db_username   = local.rds_credentials["username"]
  db_password   = local.rds_credentials["password"]

  db_subnet_group_name       = var.project
  db_subnet_group_subnet_ids = var.subnet_pri_ids
}

module "msk" {
  source = "./modules/msk"

  msk_cluster_arn = var.msk_cluster_arn
}

module "ecs" {
  source = "./modules/ecs"

  container_cluster_name = var.project
}

module "ecs_api" {
  source = "./modules/ecs_api"

  # General settings
  region = var.region
  vpc_id = var.vpc_id

  # Container settings
  container_cluster_name = module.ecs.container_cluster_name
  container_cluster_id   = module.ecs.container_cluster_id

  # Container settings - API
  container_name                     = var.container_api_name
  container_version                  = var.container_api_version
  container_exec_role_arn            = var.container_api_exec_role_arn
  container_count                    = var.container_api_count
  container_envvar_value_db_endpoint = module.rds.db_writer_endpoint
  container_envvar_value_db_port     = module.rds.db_writer_port
  container_envvar_value_db_name     = var.container_api_envvar_value_db_name
  container_envvar_value_db_option   = var.container_api_envvar_value_db_option
  container_envvar_from_db_username  = "${module.secrets.secret_arn}:username::"
  container_envvar_from_db_password  = "${module.secrets.secret_arn}:password::"

  container_lb_security_group_ids = [var.security_group_vpc_id, var.security_group_http_id]
  container_lb_subnet_ids         = var.subnet_pub_ids

  container_service_subnet_ids = var.subnet_pro_ids
  container_port               = var.container_api_port
  container_health_port        = var.container_api_health_port
}

module "ecs_consumer" {
  source = "./modules/ecs_consumer"

  # General settings
  region = var.region
  vpc_id = var.vpc_id

  # Container settings
  container_cluster_name = module.ecs.container_cluster_name
  container_cluster_id   = module.ecs.container_cluster_id

  # Container settings - Consumer
  container_name                                 = var.container_consumer_name
  container_version                              = var.container_consumer_version
  container_exec_role_arn                        = var.container_consumer_exec_role_arn
  container_role_arn                             = var.container_consumer_role_arn
  container_count                                = var.container_consumer_count
  container_envvar_value_point_api_baseurl       = var.container_consumer_envvar_value_point_api_baseurl
  container_envvar_value_kafka_bootstrap_servers = var.container_consumer_envvar_value_kafka_bootstrap_servers
  container_envvar_value_kafka_topic_name        = var.container_consumer_envvar_value_kafka_topic_name
  container_envvar_value_kafka_consumer_group_id = var.container_consumer_envvar_value_kafka_consumer_group_id

  container_lb_security_group_ids = [var.security_group_vpc_id, var.security_group_http_id]
  container_lb_subnet_ids         = var.subnet_pub_ids

  container_service_subnet_ids = var.subnet_pro_ids
  container_port               = var.container_consumer_port
  container_health_port        = var.container_consumer_health_port
}
