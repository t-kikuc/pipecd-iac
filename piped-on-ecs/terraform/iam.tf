// 1. Task Execution Role:  Fetch a secret and start a task 
resource "aws_iam_role" "task_execution_role"{
  name = "piped-task-execution-role-${var.suffix}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_task_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.task_execution_role.name
}

resource "aws_iam_role_policy" "policy_secrets" {
  name = "piped-task-execution-policy-secrets-${var.suffix}"
  role = aws_iam_role.task_execution_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Effect   = "Allow",
        Resource = "${aws_secretsmanager_secret.piped_config_secret.arn}"
      },
      {
        Action = ["kms:Decrypt"],
        Effect   = "Allow",
        # Resource = "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_secretsmanager_secret.piped_config_secret.kms_key_id}"
        Resource = "*"
      },
      {
        Action = ["logs:CreateLogGroup"],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

// 2. Task Role: deploy applications
resource "aws_iam_role" "task_role" {
  name = "piped-task-role-${var.suffix}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
      }
    ]
  })
}

// NOTE: If you do not deploy Lambda applications, this attachment is not necessary. 
// To be exact, FullAccess is too much, so you should create a custom limited policy.
resource "aws_iam_role_policy_attachment" "attatch_lambda" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  role       = aws_iam_role.task_role.name
}

// NOTE: If you do not deploy ECS applications, this attachment is not necessary. 
// To be exact, FullAccess is too much, so you should create a custom limited policy.
resource "aws_iam_role_policy_attachment" "attatch_ecs" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
  role       = aws_iam_role.task_role.name
}

resource "aws_iam_role_policy" "policy_logs" {
  name = "piped-task-role-policy-logs-${var.suffix}"
  role = aws_iam_role.task_role.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}
