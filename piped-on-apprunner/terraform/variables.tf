variable "aws_region" {
  description = "The AWS region to deploy the resources."
  type        = string
}

variable "suffix" {
  description = "The common suffix of the resource names. '-' is automatically added before the suffix."
  type        = string
}

variable "piped_image_version" {
  description = "The version of the piped image."
  type        = string
}

variable "piped_config" {
  description = "The piped config encoded by base64."
  type        = string
}

variable "apprunner_cpu" {
  description = "The CPU size of the piped on AppRunner"
  default     = "1024"
  type        = string
}

variable "apprunner_memory" {
  description = "The memory size of the piped on AppRunner"
  default     = "2048"
  type        = string
}
