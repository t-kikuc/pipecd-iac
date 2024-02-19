// ECR repository for piped or launcher 
resource "aws_ecr_repository" "ecr_piped_repo" {
  name                 = "piped-launcher-${var.suffix}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_image" "launcher_image" {
  repository_name = aws_ecr_repository.ecr_piped_repo.name
  image_tag       = "latest"

  // Wait until the image is pushed to the ECR repository.
  depends_on = [
    null_resource.push_image
  ]
}
