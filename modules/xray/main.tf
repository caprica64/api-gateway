# X-Ray tracing configuration for API Gateway and Lambda

# IAM role for X-Ray tracing
resource "aws_iam_role" "xray_role" {
  count = var.enable_xray_tracing ? 1 : 0
  
  name = "${var.function_name}-xray-role"

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

  tags = var.tags
}

# IAM policy for X-Ray write access
resource "aws_iam_policy" "xray_policy" {
  count = var.enable_xray_tracing ? 1 : 0
  
  name        = "${var.function_name}-xray-policy"
  description = "IAM policy for X-Ray tracing"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

# Attach X-Ray policy to Lambda execution role
resource "aws_iam_role_policy_attachment" "xray_policy_attachment" {
  count = var.enable_xray_tracing ? 1 : 0
  
  role       = var.lambda_execution_role_name
  policy_arn = aws_iam_policy.xray_policy[0].arn
}

# CloudWatch Log Group for X-Ray traces
resource "aws_cloudwatch_log_group" "xray_log_group" {
  count = var.enable_xray_tracing ? 1 : 0
  
  name              = "/aws/xray/${var.function_name}"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# X-Ray sampling rule for the API
resource "aws_xray_sampling_rule" "api_sampling_rule" {
  count = var.enable_xray_tracing ? 1 : 0
  
  rule_name      = "${var.function_name}-sampling-rule"
  priority       = 9000
  version        = 1
  reservoir_size = 1
  fixed_rate     = var.xray_sampling_rate
  url_path       = "*"
  host           = "*"
  http_method    = "*"
  service_type   = "*"
  service_name   = "*"
  resource_arn   = "*"

  tags = var.tags
}