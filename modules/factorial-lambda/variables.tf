variable "function_name" {
  description = "Name of the Factorial Lambda function"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "enable_xray_tracing" {
  description = "Enable X-Ray tracing for Lambda function"
  type        = bool
  default     = true
}