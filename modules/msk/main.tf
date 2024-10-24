# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/msk_bootstrap_brokers
data "aws_msk_bootstrap_brokers" "main" {
  cluster_arn = var.msk_cluster_arn
}
