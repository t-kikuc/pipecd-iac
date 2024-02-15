resource "aws_secretsmanager_secret" "secret_piped_config" {
  name        = "piped-config-${var.suffix}"
  description = "The piped config encoded by base64."
}
resource "aws_secretsmanager_secret_version" "secret_version_piped_config" {
  secret_id     = aws_secretsmanager_secret.secret_piped_config.id
  secret_string = var.piped_config
}
