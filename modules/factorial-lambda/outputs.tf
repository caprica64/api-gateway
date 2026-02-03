output "lambda_function_arn" {
  description = "ARN of the Factorial Lambda function"
  value       = aws_lambda_function.factorial_calculator.arn
}

output "lambda_function_name" {
  description = "Name of the Factorial Lambda function"
  value       = aws_lambda_function.factorial_calculator.function_name
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Factorial Lambda function"
  value       = aws_lambda_function.factorial_calculator.invoke_arn
}

output "lambda_execution_role_name" {
  description = "Name of the Factorial Lambda execution role"
  value       = aws_iam_role.factorial_lambda_role.name
}

output "lambda_execution_role_arn" {
  description = "ARN of the Factorial Lambda execution role"
  value       = aws_iam_role.factorial_lambda_role.arn
}