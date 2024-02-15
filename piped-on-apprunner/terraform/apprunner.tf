resource "aws_apprunner_service" "piped_service" {
  service_name = "piped-service-${var.suffix}"

  source_configuration {
    image_repository {
      image_repository_type = "ECR" // private ECR
      image_identifier      = data.aws_ecr_image.launcher_image.image_uri
      image_configuration {
        port          = "9085" // Piped listens on this port for health check.
        start_command = "launcher --config-from-aws-secret=true --aws-secret-id=${aws_secretsmanager_secret.secret_piped_config.arn}"
      }
    }
    auto_deployments_enabled = true
    authentication_configuration {
      access_role_arn = aws_iam_role.piped_ecr_access_role.arn
    }
  }

  instance_configuration {
    cpu               = var.apprunner_cpu
    memory            = var.apprunner_memory
    instance_role_arn = aws_iam_role.piped_instance_role.arn
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.auto_scaling_config.arn

  // Health check via piped's admin server.
  health_check_configuration {
    path     = "/healthz"
    protocol = "HTTP"
  }

  network_configuration {
    ingress_configuration {
      // Piped does not require inbound requests.
      // We can make this service private without either a VPC endpoint or a WAF.
      is_publicly_accessible = false
    }
    egress_configuration {
      // Piped accesses to Git Repositories and the PipeCD Control Plane.
      egress_type = "DEFAULT"
    }
  }
}

resource "aws_apprunner_auto_scaling_configuration_version" "auto_scaling_config" {
  auto_scaling_configuration_name = "piped-asc-${var.suffix}"
  // Piped must not scale out/in. It must be always 1.
  min_size        = 1
  max_size        = 1
  max_concurrency = 1 // Piped does not require inbound requests.

}
