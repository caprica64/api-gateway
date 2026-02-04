# Unified Lambda Function Module

This is a reusable Terraform module for creating AWS Lambda functions with comprehensive features including CloudWatch logging, X-Ray tracing, and IAM roles.

## Features

- **Flexible Configuration**: Supports any Lambda runtime and handler
- **CloudWatch Integration**: Automatic log group creation with configurable retention
- **X-Ray Tracing**: Optional distributed tracing support
- **IAM Management**: Automatic IAM role and policy creation
- **API Gateway Integration**: Built-in permission for API Gateway invocation
- **Tagging Support**: Comprehensive resource tagging
- **Environment Variables**: Support for Lambda environment variables

## Usage

```hcl
module "my_lambda_function" {
  source = "./modules/lambda-function"
  
  function_name           = "my-function"
  description            = "My Lambda function description"
  deployment_package_path = "./path/to/deployment.zip"
  
  # Optional configurations
  handler                = "bootstrap"           # Default for custom runtime
  runtime                = "provided.al2"       # Default for Swift/custom runtime
  timeout                = 30                   # Default: 30 seconds
  memory_size            = 128                  # Default: 128 MB
  
  # Observability
  enable_xray_tracing    = true                 # Default: true
  log_retention_days     = 14                   # Default: 14 days
  
  # Environment variables (optional)
  environment_variables = {
    ENV = "production"
    DEBUG = "false"
  }
  
  # Tagging
  tags = {
    Project     = "My Project"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
```

## Directory Structure

```
modules/lambda-function/
├── main.tf              # Main Terraform configuration
├── variables.tf         # Input variables
├── outputs.tf          # Output values
├── README.md           # This documentation
└── functions/          # Function source code and packages
    ├── prime-checker/
    │   ├── src/        # Swift source code
    │   └── lambda_function.zip
    └── factorial-calculator/
        ├── src/        # Swift source code
        └── factorial_function.zip
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| function_name | Name of the Lambda function | `string` | n/a | yes |
| deployment_package_path | Path to the Lambda deployment package (zip file) | `string` | n/a | yes |
| description | Description of the Lambda function | `string` | `""` | no |
| handler | Lambda function handler | `string` | `"bootstrap"` | no |
| runtime | Lambda runtime | `string` | `"provided.al2"` | no |
| timeout | Lambda function timeout in seconds | `number` | `30` | no |
| memory_size | Lambda function memory size in MB | `number` | `128` | no |
| aws_region | AWS region | `string` | n/a | yes |
| enable_xray_tracing | Enable X-Ray tracing for Lambda function | `bool` | `true` | no |
| log_retention_days | CloudWatch log retention period in days | `number` | `14` | no |
| environment_variables | Environment variables for the Lambda function | `map(string)` | `{}` | no |
| api_gateway_source_arn | Source ARN for API Gateway permission (optional) | `string` | `""` | no |
| tags | Tags to apply to resources | `map(string)` | `{"Environment" = "dev", "ManagedBy" = "Terraform"}` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda_function_arn | ARN of the Lambda function |
| lambda_function_name | Name of the Lambda function |
| lambda_invoke_arn | Invoke ARN of the Lambda function |
| lambda_execution_role_name | Name of the Lambda execution role |
| lambda_execution_role_arn | ARN of the Lambda execution role |
| lambda_log_group_name | Name of the Lambda CloudWatch log group |
| lambda_log_group_arn | ARN of the Lambda CloudWatch log group |

## Resources Created

- **AWS Lambda Function**: The main Lambda function
- **IAM Role**: Execution role for the Lambda function
- **IAM Role Policy Attachment**: Basic execution policy attachment
- **CloudWatch Log Group**: Log group with configurable retention
- **Lambda Permission**: API Gateway invoke permission

## Examples

### Swift Custom Runtime Lambda
```hcl
module "swift_lambda" {
  source = "./modules/lambda-function"
  
  function_name           = "swift-prime-checker"
  description            = "Swift Lambda for prime checking"
  deployment_package_path = "./functions/prime-checker/lambda_function.zip"
  runtime                = "provided.al2"
  handler                = "bootstrap"
  
  aws_region             = "us-east-1"
  enable_xray_tracing    = true
  log_retention_days     = 14
}
```

### Node.js Lambda
```hcl
module "nodejs_lambda" {
  source = "./modules/lambda-function"
  
  function_name           = "nodejs-api"
  description            = "Node.js API Lambda"
  deployment_package_path = "./functions/nodejs-api/function.zip"
  runtime                = "nodejs18.x"
  handler                = "index.handler"
  
  environment_variables = {
    NODE_ENV = "production"
  }
}
```

### Python Lambda
```hcl
module "python_lambda" {
  source = "./modules/lambda-function"
  
  function_name           = "python-processor"
  description            = "Python data processor"
  deployment_package_path = "./functions/python-processor/function.zip"
  runtime                = "python3.9"
  handler                = "lambda_function.lambda_handler"
  memory_size            = 256
  timeout                = 60
}
```

## Benefits of Unified Module

1. **Code Reusability**: Single module for all Lambda functions
2. **Consistency**: Standardized configuration across functions
3. **Maintainability**: Single place to update Lambda infrastructure
4. **Flexibility**: Supports any runtime and configuration
5. **Best Practices**: Built-in logging, tracing, and security
6. **Scalability**: Easy to add new Lambda functions