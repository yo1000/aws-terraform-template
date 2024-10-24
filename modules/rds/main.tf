# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "main" {
  name       = var.db_subnet_group_name
  subnet_ids = var.db_subnet_group_subnet_ids
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster
resource "aws_rds_cluster" "main" {
  cluster_identifier = var.db_cluster_id
  engine             = "aurora-postgresql"
  # When using serverless-v2, set ‘provisioned’.
  engine_mode       = "provisioned"
  engine_version    = var.db_engine_version
  master_username   = var.db_username
  master_password   = var.db_password
  database_name     = var.db_name
  storage_encrypted = true

  # Networking
  db_subnet_group_name = aws_db_subnet_group.main.name

  # Delete config
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.db_cluster_id}-final-snapshot"

  serverlessv2_scaling_configuration {
    max_capacity = 1
    min_capacity = 0.5
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance
resource "aws_rds_cluster_instance" "main" {
  count              = 2
  identifier         = "${var.db_cluster_id}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.main.id
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version
  instance_class     = "db.serverless"

  # Networking
  db_subnet_group_name = aws_db_subnet_group.main.name
}
