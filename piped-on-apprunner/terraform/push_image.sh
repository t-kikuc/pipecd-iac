#!/bin/bash

# Required envs: AWS_REGION, ECR_REPO_URL, PIPED_IMAGE_VERSION
# check if required envs are set
if [ -z "$AWS_REGION" ] || [ -z "$ECR_REPO_URL" ] || [ -z "$PIPED_IMAGE_VERSION" ]; then
  echo "Required envs are not set"
  exit 1
fi

PIPED_IMAGE_URL=ghcr.io/pipe-cd/launcher

# login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${ECR_REPO_URL%%/*}
# pull piped image from ghcr.io
docker pull $PIPED_IMAGE_URL:$PIPED_IMAGE_VERSION
# tag and push to ECR
docker tag $PIPED_IMAGE_URL:$PIPED_IMAGE_VERSION ${ECR_REPO_URL}:latest
docker push ${ECR_REPO_URL}:latest