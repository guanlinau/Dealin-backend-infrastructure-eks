resource "aws_secretsmanager_secret" "secret_metadata" {
  name                    = var.secret_name
  kms_key_id              = var.kms_key_id
  description             = "The ${var.secret_name}'s secret data for ${var.app_name}."
  recovery_window_in_days = 0
  tags = {
    Name = "${var.app_name}-secret-key"
  }
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret_metadata.id
  secret_string = var.secret_value
}