# General settings
project = "demo"
environment = "dev"
region      = "ap-northeast-1"

vpc_id         = "vpc-0123456789abcdef1"
subnet_pub_ids = ["subnet-0123456789abcdef1", "subnet-0123456789abcdef2"]
subnet_pro_ids = ["subnet-0123456789abcdef3", "subnet-0123456789abcdef4"]
subnet_pri_ids = ["subnet-0123456789abcdef5", "subnet-0123456789abcdef6"]

security_group_vpc_id  = "sg-0123456789abcdef1"
security_group_http_id = "sg-0123456789abcdef2"

# Database settings
db_username = "postgres"

# Event streaming settings
msk_cluster_arn = "arn:aws:kafka:ap-northeast-1:000000000000:cluster/demo/01234567-89ab-cdef-0123-456789abcdef-s1"

# Container settings - API
container_api_name          = "api"
container_api_version       = "latest"
container_api_exec_role_arn = "arn:aws:iam::000000000000:role/demo-ecsTaskExecutionRole"
container_api_count         = 2

#container_api_envvar_value_db_name   = "" # Default: "postgres"
#container_api_envvar_value_db_option = "" # Default: ""

# Container settings - Consumer
# TODO
