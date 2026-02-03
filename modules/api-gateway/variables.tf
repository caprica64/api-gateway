variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "stage_name" {
  description = "Stage name for API Gateway deployment"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Prime Lambda function"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Prime Lambda function"
  type        = string
}

variable "factorial_lambda_function_arn" {
  description = "ARN of the Factorial Lambda function"
  type        = string
}

variable "factorial_lambda_function_name" {
  description = "Name of the Factorial Lambda function"
  type        = string
}

variable "enable_xray_tracing" {
  description = "Enable X-Ray tracing for API Gateway"
  type        = bool
  default     = true
}