// ECR repository for piped or launcher 
resource "aws_ecr_repository" "ecr_repo" {
  name                 = "piped-launcher-${var.suffix}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
