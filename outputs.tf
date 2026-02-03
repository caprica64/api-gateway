output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = module.prime_api_gateway.api_gateway_url
}

output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = module.prime_api_gateway.api_gateway_id
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.prime_checker_lambda.lambda_function_arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = module.prime_checker_lambda.lambda_function_name
}

output "factorial_lambda_function_arn" {
  description = "ARN of the Factorial Lambda function"
  value       = module.factorial_calculator_lambda.lambda_function_arn
}

output "factorial_lambda_function_name" {
  description = "Name of the Factorial Lambda function"
  value       = module.factorial_calculator_lambda.lambda_function_name
}

output "xray_enabled" {
  description = "Whether X-Ray tracing is enabled"
  value       = module.xray_tracing.xray_enabled
}

output "xray_sampling_rule_name" {
  description = "Name of the X-Ray sampling rule"
  value       = module.xray_tracing.xray_sampling_rule_name
}

output "xray_log_group_name" {
  description = "Name of the X-Ray CloudWatch log group"
  value       = module.xray_tracing.xray_log_group_name
}