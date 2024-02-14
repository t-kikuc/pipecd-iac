resource "aws_wafv2_web_acl" "piped_apprunner_waf" {
  name        = "piped-apprunner-waf-test"
  description = "Deny all inbound traffic to the piped running on AppRunner."
  scope       = "REGIONAL"

  default_action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "piped-apprunner-waf-metric-test"
    sampled_requests_enabled   = false
  }
}
