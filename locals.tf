locals {
  name = "${lower(var.environment)}-${var.project}"

  tags = {
    name        = local.name
    environment = var.environment
  }
}
