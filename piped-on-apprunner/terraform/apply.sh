#!/bin/bash

# Required param. VAR_FILE: your tfvars file path.
VAR_FILE=$1

# FIXME: Ideally, we want to complete the deployment by `terraform apply` only once.
# [1] Create pre-requisite resources to avoid error when creating the App Runner service.
#    1. Create an ECR repository
#    2. Push a piped image to it
#    3. Create an IAM role for ECR access:  to avoid 'InvalidRequestException: Error in assuming access role' when creating the App Runner service.
terraform apply -var-file=$VAR_FILE -target=aws_ecr_repository.ecr_piped_repo --target=null_resource.push_image --target=aws_iam_role.piped_ecr_access_role

# [2] Create other resources, including App Runner
terraform apply -var-file=$VAR_FILE