# IAM role for Factorial Lambda function
resource "aws_iam_role" "factorial_lambda_role" {
  name = "${var.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy attachment for Lambda basic execution
resource "aws_iam_role_policy_attachment" "factorial_lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.factorial_lambda_role.name
}

# Factorial Lambda function
resource "aws_lambda_function" "factorial_calculator" {
  filename         = "${path.module}/factorial_function.zip"
  function_name    = var.function_name
  role            = aws_iam_role.factorial_lambda_role.arn
  handler         = "bootstrap"
  runtime         = "provided.al2"
  timeout         = 30
  memory_size     = 128

  source_code_hash = filebase64sha256("${path.module}/factorial_function.zip")

  # Enable X-Ray tracing
  tracing_config {
    mode = var.enable_xray_tracing ? "Active" : "PassThrough"
  }

  depends_on = [
    aws_iam_role_policy_attachment.factorial_lambda_basic_execution,
  ]
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "factorial_api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.factorial_calculator.function_name
  principal     = "apigateway.amazonaws.com"
}