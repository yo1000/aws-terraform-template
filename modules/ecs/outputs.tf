output "container_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "container_cluster_id" {
  value = aws_ecs_cluster.main.id
}
