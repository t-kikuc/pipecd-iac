resource "aws_apprunner_service" "piped_service" {
  service_name = "piped-service-${var.suffix}"

  source_configuration {
    image_repository {
      image_repository_type = "ECR" // private ECR
      image_identifier      = aws_ecr_repository.ecr_repo.repository_url
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
    cpu               = "1024" // Default value
    memory            = "2048" // Default value
    instance_role_arn = aws_iam_role.piped_instance_role.arn
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.auto_scaling_config_piped.arn

  // Health check via piped's admin server.
  health_check_configuration {
    path     = "/healthz"
    protocol = "HTTP"
  }

  network_configuration {
    ingress_configuration {
      // Piped does not require inbound requests.
      is_publicly_accessible = false
    }
    egress_configuration {
      // Piped accesses to Git Repositories and the PipeCD Control Plane.
      egress_type = "DEFAULT"
    }
  }

  tags = {
    Name = "piped-service"
  }
}

resource "aws_apprunner_auto_scaling_configuration_version" "auto_scaling_config_piped" {
  auto_scaling_configuration_name = "piped-auto-scaling-config-${var.suffix}"
  // Piped must not scale out/in. It must be always 1.
  min_size        = 1
  max_size        = 1
  max_concurrency = 1 // Piped does not require inbound requests.

  tags = {
    Name = "piped-auto-scaling-config"
  }
}

// A VPC endpoint is requied to limit the access to the AppRunner service.
resource "aws_apprunner_vpc_ingress_connection" "example" {
  name        = "example"
  service_arn = aws_apprunner_service.example.arn

  ingress_vpc_configuration {
    vpc_id          = aws_default_vpc.default.id
    vpc_endpoint_id = aws_vpc_endpoint.apprunner.id
  }

  tags = {
    foo = "bar"
  }
}
