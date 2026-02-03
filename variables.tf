variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "prime-checker-api"
}

variable "stage_name" {
  description = "Stage name for API Gateway deployment"
  type        = string
  default     = "dev"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "prime-checker"
}

variable "factorial_function_name" {
  description = "Name of the Factorial Lambda function"
  type        = string
  default     = "factorial-calculator"
}

variable "enable_xray_tracing" {
  description = "Enable X-Ray distributed tracing for API Gateway and Lambda"
  type        = bool
  default     = true
}

variable "xray_sampling_rate" {
  description = "X-Ray sampling rate (0.0 to 1.0) - percentage of requests to trace"
  type        = number
  default     = 0.1
  
  validation {
    condition     = var.xray_sampling_rate >= 0.0 && var.xray_sampling_rate <= 1.0
    error_message = "X-Ray sampling rate must be between 0.0 and 1.0."
  }
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 14
  
  validation {
    condition = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "Log retention days must be one of: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653."
  }
}