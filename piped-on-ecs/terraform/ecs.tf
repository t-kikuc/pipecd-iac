// TaskDefinition
resource "aws_ecs_task_definition" "piped_taskdef" {
  family                   = "piped-${var.suffix}"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "piped"
      essential = true
      image     = "ghcr.io/pipe-cd/piped:${var.piped_image_version}"
      entryPoint = [
        "sh",
        "-c"
      ]
      // TODO: Use --aws-secret-id and --config-from-aws-secret instead.
      command = [
        "/bin/sh -c \"piped piped --config-data=$(echo $CONFIG_DATA)\""
      ]
      secrets = [
        {
          valueFrom = aws_secretsmanager_secret.piped_config_secret.arn
          name      = "CONFIG_DATA"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_group.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "piped-"
        }
      }
    }
  ])
}

// Run a Service
resource "aws_ecs_service" "piped_service" {
  name            = "piped-${var.suffix}"
  cluster         = aws_ecs_cluster.piped_cluster.id
  task_definition = aws_ecs_task_definition.piped_taskdef.arn
  desired_count   = 1 // Only one piped instance is needed. Piped must not be scaled out.
  launch_type     = "FARGATE"

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.piped_sg.id]
    assign_public_ip = true
  }

  scheduling_strategy = "REPLICA"
}

resource "aws_ecs_cluster" "piped_cluster" {
  name = "piped-${var.suffix}"
}
