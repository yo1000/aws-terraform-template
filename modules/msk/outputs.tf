output "kafka_bootstrap_brokers" {
  value = data.aws_msk_bootstrap_brokers.main.bootstrap_brokers
}
