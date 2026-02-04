variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = ""
}

variable "deployment_package_path" {
  description = "Path to the Lambda deployment package (zip file)"
  type        = string
}

variable "handler" {
  description = "Lambda function handler"
  type        = string
  default     = "bootstrap"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "provided.al2"
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 128
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

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 14
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "api_gateway_source_arn" {
  description = "Source ARN for API Gateway permission (optional)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}