// Authorization for pulling the image from the ECR repository when starting the App Runner service.
resource "aws_iam_role" "piped_ecr_access_role" {
  name = "PipedECRAccessRole-${var.suffix}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        },
        Action = "sts:AssumeRole",
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "piped_ecr_access_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
  role       = aws_iam_role.piped_ecr_access_role.name
}

// Instance role to authorize for deploying applications and fetching a secret of the piped config.
resource "aws_iam_role" "piped_instance_role" {
  name = "PipedInstanceRole-${var.suffix}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        },
      }
    ]
  })
}

// If you do not deploy to Lambda, this resource is not necessary. 
// To be exact, FullAccess is too much, so you should create a custom limited policy.
resource "aws_iam_role_policy_attachment" "piped_instance_policy_attatch_lambda" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  role       = aws_iam_role.piped_instance_role.name
}

// If you deploy to ECS, you need to attach policy like this. 
// To be exact, FullAccess is too much, so you should create a custom limited policy.
# resource "aws_iam_role_policy_attachment" "piped_instance_policy_attatch_ecs" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
#   role       = aws_iam_role.piped_instance_role.name
# }

resource "aws_iam_role_policy_attachment" "piped_instance_policy_attatch_secrets" {
  policy_arn = aws_iam_policy.piped_instance_secrets_policy.arn
  role       = aws_iam_role.piped_instance_role.name
}

resource "aws_iam_policy" "piped_instance_secrets_policy" {
  name = "PipedInstanceSecretsPolicy-${var.suffix}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "kms:Decrypt*"
        ]
        Effect   = "Allow",
        Resource = "${aws_secretsmanager_secret.secret_piped_config.arn}"
      }
    ]
  })
}
