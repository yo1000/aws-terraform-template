# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
resource "aws_ecs_cluster" "main" {
  name = var.container_cluster_name

  #setting {
  #  name  = "containerInsights"
  #  value = "enabled"
  #}
}
