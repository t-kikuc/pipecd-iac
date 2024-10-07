resource "aws_secretsmanager_secret" "piped_config_secret" {
  name        = "piped-config-${var.suffix}"
  description = "The piped config encoded by base64."
}
resource "aws_secretsmanager_secret_version" "piped_config_secret_version" {
  secret_id     = aws_secretsmanager_secret.piped_config_secret.id
  secret_string = var.piped_config
}
