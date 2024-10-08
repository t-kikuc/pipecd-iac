variable "aws_region" {
  description = "AWS region to deploy the resources."
  type        = string
  default = "ap-northeast-1"
}

variable "suffix" {
  description = "Common suffix of the resource names. '-' is automatically added before the suffix."
  type        = string
  default = "piped-on-ecs"
}

variable "piped_image_version" {
  description = "Version of the piped image."
  type        = string
  default = "v0.49.0"
}

variable "piped_config" {
  description = "The piped config encoded by base64."
  type        = string
}

variable "vpc_id" {
  description = "ID of VPC where the ECS service will be located."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ECS service."
  type        = list(string)
}
