output "db_writer_endpoint" {
  value = aws_rds_cluster.main.endpoint
}

output "db_writer_port" {
  value = aws_rds_cluster.main.port
}

output "db_reader_endpoint" {
  value = aws_rds_cluster.main.reader_endpoint
}

output "db_reader_port" {
  value = aws_rds_cluster.main.port
}
