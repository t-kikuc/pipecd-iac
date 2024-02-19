# Push the piped image to ECR right after the ECR repository is created in order to avoid error when creating AppRunner service.
resource "null_resource" "push_image" {
  triggers = {
    ecr_repo_is_created = "${aws_ecr_repository.ecr_piped_repo.repository_url}"
  }

  # The push command is based on https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/docker-push-ecr-image.html
  provisioner "local-exec" {
    command = "sh ${path.module}/push_image.sh"
    environment = {
      AWS_REGION          = var.aws_region
      ECR_REPO_URL        = aws_ecr_repository.ecr_piped_repo.repository_url
      PIPED_IMAGE_VERSION = var.piped_image_version
    }
  }
}
