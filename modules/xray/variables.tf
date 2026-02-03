# X-Ray module variables

variable "enable_xray_tracing" {
  description = "Enable X-Ray tracing for API Gateway and Lambda"
  type        = bool
  default     = true
}

variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "lambda_execution_role_name" {
  description = "Lambda execution role name"
  type        = string
}

variable "xray_sampling_rate" {
  description = "X-Ray sampling rate (0.0 to 1.0)"
  type        = number
  default     = 0.1
  
  validation {
    condition     = var.xray_sampling_rate >= 0.0 && var.xray_sampling_rate <= 1.0
    error_message = "X-Ray sampling rate must be between 0.0 and 1.0."
  }
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}

variable "tags" {
  description = "Tags to apply to X-Ray resources"
  type        = map(string)
  default     = {}
}