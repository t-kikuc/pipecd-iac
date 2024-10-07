// create a log group
resource "aws_cloudwatch_log_group" "log_group" {
    name              = "/piped-${var.suffix}"
    retention_in_days = 90
}
