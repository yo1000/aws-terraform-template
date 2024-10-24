# 新規リソースの構築 => resource
# 既存リソースの解決 => data

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
resource "random_password" "db_password" {
  length  = 32
  special = true
  # Not usable characters are `@` `/` `"` ` `
  override_special = "!#$%^&*()-_=+[]{}<>?"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret
resource "aws_secretsmanager_secret" "rds_credentials" {
  name = var.secret_name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version
resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}
