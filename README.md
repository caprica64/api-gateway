# Prime Checker API

A production-ready Terraform-based AWS infrastructure that creates an API Gateway connected to a Lambda function to check if numbers are prime. Built with modular Terraform architecture for scalability and maintainability.

## 🚀 Live API Endpoint

**Base URL**: `https://w3172e9z33.execute-api.us-east-1.amazonaws.com/dev`  
**Prime Checker**: `POST /prime`

## 🏗️ Architecture

- **API Gateway**: Regional REST API with `/prime` endpoint and CORS support
- **Lambda Function**: Node.js 18.x function with efficient prime checking algorithm
- **IAM Roles**: Least-privilege security with proper execution permissions
- **Modular Structure**: Organized using Terraform modules for reusability

## 📡 API Usage

### Endpoint
```
POST https://w3172e9z33.execute-api.us-east-1.amazonaws.com/dev/prime
```

### Request Format
```json
{
  "number": 17
}
```

### Success Response
```json
{
  "number": 17,
  "isPrime": true,
  "message": "17 is a prime number"
}
```

### Error Response
```json
{
  "error": "Invalid input. Please provide a valid number."
}
```

## 🧪 Testing Examples

### Test Prime Numbers
```bash
# Test with prime number
curl -X POST https://w3172e9z33.execute-api.us-east-1.amazonaws.com/dev/prime \
  -H "Content-Type: application/json" \
  -d '{"number": 17}'

# Test with composite number
curl -X POST https://w3172e9z33.execute-api.us-east-1.amazonaws.com/dev/prime \
  -H "Content-Type: application/json" \
  -d '{"number": 25}'

# Test edge cases
curl -X POST https://w3172e9z33.execute-api.us-east-1.amazonaws.com/dev/prime \
  -H "Content-Type: application/json" \
  -d '{"number": 2}'

# Test large prime
curl -X POST https://w3172e9z33.execute-api.us-east-1.amazonaws.com/dev/prime \
  -H "Content-Type: application/json" \
  -d '{"number": 97}'

# Test error handling
curl -X POST https://w3172e9z33.execute-api.us-east-1.amazonaws.com/dev/prime \
  -H "Content-Type: application/json" \
  -d '{"number": "invalid"}'
```

## 🛠️ Deployment

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform >= 1.5.7 installed
- Valid AWS credentials

### Quick Start
1. **Clone and configure**:
   ```bash
   git clone <repository-url>
   cd api-gateway
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your preferred values
   ```

2. **Deploy infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Test the deployment**:
   ```bash
   # Use the API Gateway URL from terraform output
   curl -X POST $(terraform output -raw api_gateway_url)/prime \
     -H "Content-Type: application/json" \
     -d '{"number": 17}'
   ```

### Configuration Variables
```hcl
aws_region           = "us-east-1"        # AWS region for deployment
api_name            = "prime-checker-api" # API Gateway name
stage_name          = "dev"               # API Gateway stage
lambda_function_name = "prime-checker"    # Lambda function name
```

## 📁 Project Structure

```
├── main.tf                    # Root Terraform configuration
├── variables.tf              # Input variables
├── outputs.tf               # Output values
├── terraform.tfvars.example # Example configuration
├── .terraform.lock.hcl      # Provider version lock
├── modules/
│   ├── lambda/              # Lambda function module
│   │   ├── main.tf         # Lambda resources
│   │   ├── variables.tf    # Lambda variables
│   │   ├── outputs.tf      # Lambda outputs
│   │   └── src/            # Lambda source code
│   │       ├── index.js    # Node.js prime checker
│   │       ├── Package.swift # Swift implementation (alternative)
│   │       └── build.sh    # Build script for Swift
│   └── api-gateway/        # API Gateway module
│       ├── main.tf         # API Gateway resources
│       ├── variables.tf    # API Gateway variables
│       └── outputs.tf      # API Gateway outputs
```

## ⚡ Lambda Function Features

### Prime Algorithm
- **Efficient Implementation**: Uses square root optimization
- **Edge Case Handling**: Properly handles 0, 1, 2, and negative numbers
- **Performance**: O(√n) time complexity

### Error Handling
- **Input Validation**: Checks for valid numeric input
- **Graceful Failures**: Returns structured error responses
- **Logging**: CloudWatch integration for monitoring

### CORS Support
- **Cross-Origin Requests**: Enabled for web applications
- **Proper Headers**: Access-Control-Allow-Origin, Methods, Headers
- **OPTIONS Method**: Pre-flight request support

## 🔧 Infrastructure Details

### AWS Resources Created
- **API Gateway REST API**: Regional endpoint with custom domain support
- **API Gateway Resource**: `/prime` path
- **API Gateway Methods**: POST and OPTIONS (CORS)
- **API Gateway Integration**: Lambda proxy integration
- **API Gateway Deployment**: Automated deployment
- **API Gateway Stage**: Environment-specific stage (dev/prod)
- **Lambda Function**: Node.js 18.x runtime
- **IAM Role**: Lambda execution role
- **IAM Policy**: Basic execution permissions
- **Lambda Permission**: API Gateway invoke permission

### Security Features
- **Least Privilege IAM**: Minimal required permissions
- **No Hardcoded Secrets**: Uses AWS IAM for authentication
- **Input Validation**: Prevents injection attacks
- **Error Sanitization**: No sensitive data in error responses

## 📊 Monitoring and Observability

### CloudWatch Integration
- **Lambda Logs**: Automatic logging to CloudWatch
- **API Gateway Logs**: Request/response logging available
- **Metrics**: Built-in AWS metrics for performance monitoring
- **Alarms**: Can be configured for error rates and latency

### Performance Characteristics
- **Cold Start**: ~100-200ms for Node.js Lambda
- **Warm Execution**: ~1-5ms for prime calculations
- **Memory Usage**: 128MB allocated (adjustable)
- **Timeout**: 30 seconds (configurable)

## 🚀 Production Considerations

### Scaling
- **Lambda Concurrency**: Automatic scaling up to account limits
- **API Gateway**: Handles 10,000 requests per second by default
- **Regional Deployment**: Single region for low latency

### Cost Optimization
- **Pay-per-Use**: Only charged for actual requests
- **Minimal Memory**: 128MB for cost efficiency
- **Short Timeout**: 30 seconds to prevent runaway costs

### Security Enhancements
- **API Keys**: Can be added for access control
- **Rate Limiting**: API Gateway throttling available
- **WAF Integration**: Web Application Firewall support
- **VPC Integration**: Private subnet deployment option

## 🔄 CI/CD Integration

### GitHub Actions Ready
```yaml
# Example workflow step
- name: Deploy Infrastructure
  run: |
    terraform init
    terraform plan
    terraform apply -auto-approve
```

### Terraform State Management
- **Remote State**: Configure S3 backend for team collaboration
- **State Locking**: DynamoDB table for concurrent access protection
- **Workspaces**: Support for multiple environments

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues and questions:
1. Check the [Issues](../../issues) page
2. Review CloudWatch logs for runtime errors
3. Verify AWS permissions and quotas
4. Test with curl commands provided above