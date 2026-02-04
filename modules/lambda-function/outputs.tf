output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.lambda_function.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.lambda_function.function_name
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.lambda_function.invoke_arn
}

output "lambda_execution_role_name" {
  description = "Name of the Lambda execution role"
  value       = aws_iam_role.lambda_role.name
}

output "lambda_execution_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_log_group_name" {
  description = "Name of the Lambda CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_log_group.name
}

output "lambda_log_group_arn" {
  description = "ARN of the Lambda CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_log_group.arn
}