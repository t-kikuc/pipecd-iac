#!/bin/bash

# Required param. VAR_FILE: your tfvars file path.
VAR_FILE=$1

# [1] Create an ECR repository and push a piped image to it so that the AppRunner service can use it.
terraform apply -var-file=$VAR_FILE -target=aws_ecr_repository.ecr_piped_repo --target=null_resource.push_image

# [2] Create an IAM role for ECR access in advance to avoid 'InvalidRequestException: Error in assuming access role'
terraform apply -var-file=$VAR_FILE --target=aws_iam_role.piped_ecr_access_role

# [3] Create other resources
terraform apply -var-file=$VAR_FILE