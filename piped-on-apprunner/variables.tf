variable "aws_region" {
  description = "The AWS region to deploy the resources."
  type        = string
}

variable "suffix" {
  description = "The common suffix of the resource names. '-' is automatically added before the suffix."
  type        = string
}

variable "piped_config" {
  description = "The piped config encoded by base64."
  type        = string
}
