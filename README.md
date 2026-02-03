# Prime Checker API

A production-ready Terraform-based AWS infrastructure that creates an API Gateway connected to a Swift Lambda function to check if numbers are prime. Built with modular Terraform architecture for scalability and maintainability.

## 🚀 Live API Endpoint

**Base URL**: `https://w3172e9z33.execute-api.us-east-1.amazonaws.com/dev`  
**Prime Checker**: `POST /prime`

## 🏗️ Architecture

- **API Gateway**: Regional REST API with `/prime` endpoint and CORS support
- **Lambda Function**: Swift custom runtime with efficient prime checking algorithm
- **X-Ray Tracing**: Distributed tracing for API Gateway and Lambda with 10% sampling rate
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
- Docker installed (for Swift Lambda compilation)
- Valid AWS credentials

### Quick Start
1. **Clone and configure**:
   ```bash
   git clone <repository-url>
   cd api-gateway
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your preferred values
   ```

2. **Build Swift Lambda function**:
   ```bash
   cd modules/lambda/src
   ./build.sh
   cd ../../..
   ```

3. **Deploy infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Test the deployment**:
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

# X-Ray Tracing Configuration
enable_xray_tracing  = true               # Enable distributed tracing
xray_sampling_rate   = 0.1                # Sample 10% of requests (0.0 to 1.0)
log_retention_days   = 14                 # CloudWatch log retention in days
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
│   │   └── src/            # Swift Lambda source code
│   │       ├── Package.swift           # Swift package definition
│   │       ├── build.sh               # Docker-based build script
│   │       ├── bootstrap              # Lambda runtime bootstrap (generated)
│   │       ├── lambda-deployment.zip  # Deployment package (generated)
│   │       └── Sources/
│   │           └── PrimeChecker/
│   │               └── main.swift     # Swift prime checker implementation
│   ├── api-gateway/        # API Gateway module
│   │   ├── main.tf         # API Gateway resources
│   │   ├── variables.tf    # API Gateway variables
│   │   └── outputs.tf      # API Gateway outputs
│   └── xray/               # X-Ray tracing module
│       ├── main.tf         # X-Ray resources and IAM policies
│       ├── variables.tf    # X-Ray variables
│       └── outputs.tf      # X-Ray outputs
```

## ⚡ Swift Lambda Function Features

### Runtime Implementation
- **Custom Runtime**: Uses AWS Lambda Runtime for Swift (provided.al2)
- **Cross-Compilation**: Docker-based build for Amazon Linux compatibility
- **Static Linking**: Self-contained binary with minimal dependencies
- **Performance**: Native compiled code for optimal execution speed

### Prime Algorithm
- **Efficient Implementation**: Uses square root optimization with stride iteration
- **Edge Case Handling**: Properly handles 0, 1, 2, and negative numbers
- **Performance**: O(√n) time complexity with optimized loop structure
- **Type Safety**: Swift's strong typing prevents runtime errors

### Build Process
- **Docker Integration**: Uses `swift:5.9-amazonlinux2` for consistent builds
- **Static Compilation**: `--static-swift-stdlib` flag for standalone deployment
- **Architecture Targeting**: Cross-compiles from ARM64 to x86_64 for Lambda
- **Automated Packaging**: Creates deployment-ready ZIP with bootstrap executable

### Error Handling
- **Input Validation**: Robust JSON parsing and type checking
- **Graceful Failures**: Returns structured error responses with proper HTTP status codes
- **CORS Integration**: Built-in CORS headers for all responses including errors
- **Logging**: CloudWatch integration for monitoring and debugging

### CORS Support
- **Cross-Origin Requests**: Enabled for web applications
- **Proper Headers**: Access-Control-Allow-Origin, Methods, Headers
- **OPTIONS Method**: Pre-flight request support with dedicated handler
- **Error Responses**: CORS headers included in all response types

## 🔧 Infrastructure Details

### AWS Resources Created
- **API Gateway REST API**: Regional endpoint with custom domain support
- **API Gateway Resource**: `/prime` path
- **API Gateway Methods**: POST and OPTIONS (CORS)
- **API Gateway Integration**: Lambda proxy integration
- **API Gateway Deployment**: Automated deployment
- **API Gateway Stage**: Environment-specific stage (dev/prod) with X-Ray tracing
- **Lambda Function**: Swift custom runtime (provided.al2) with X-Ray tracing
- **IAM Role**: Lambda execution role with X-Ray permissions
- **IAM Policy**: Basic execution and X-Ray tracing permissions
- **Lambda Permission**: API Gateway invoke permission
- **X-Ray Sampling Rule**: Configurable sampling rate for distributed tracing
- **CloudWatch Log Group**: X-Ray trace storage and retention

### Security Features
- **Least Privilege IAM**: Minimal required permissions
- **No Hardcoded Secrets**: Uses AWS IAM for authentication
- **Input Validation**: Prevents injection attacks
- **Error Sanitization**: No sensitive data in error responses

## 📊 Monitoring and Observability

### X-Ray Distributed Tracing
- **End-to-End Visibility**: Track requests from API Gateway through Lambda execution
- **Performance Analysis**: Identify bottlenecks and latency issues
- **Error Tracking**: Detailed error analysis with stack traces
- **Service Map**: Visual representation of service dependencies
- **Sampling Configuration**: 10% sampling rate (configurable) to balance cost and visibility

### X-Ray Features
- **Request Tracing**: Complete request lifecycle from API Gateway to Lambda
- **Subsegment Analysis**: Detailed breakdown of Lambda execution phases
- **Error Analysis**: Automatic error detection and categorization
- **Performance Metrics**: Response times, throughput, and error rates
- **Custom Annotations**: Searchable metadata for filtering traces

### CloudWatch Integration
- **Lambda Logs**: Automatic logging to CloudWatch
- **API Gateway Logs**: Request/response logging available
- **X-Ray Traces**: Stored in dedicated CloudWatch log group
- **Metrics**: Built-in AWS metrics for performance monitoring
- **Alarms**: Can be configured for error rates and latency

### Accessing X-Ray Data
1. **AWS Console**: Navigate to X-Ray service in AWS Console
2. **Service Map**: Visual overview of request flow and dependencies
3. **Traces**: Detailed individual request traces
4. **Analytics**: Query and filter traces by various criteria
5. **CloudWatch**: Integrated metrics and log correlation

### Performance Characteristics
- **Cold Start**: ~200-300ms for Swift Lambda (includes runtime initialization)
- **Warm Execution**: <1ms for prime calculations (native compiled performance)
- **Memory Usage**: 128MB allocated (adjustable, efficient due to compiled nature)
- **Timeout**: 30 seconds (configurable)
- **Binary Size**: ~21MB deployment package (includes Swift runtime)

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

## 🔄 Swift Migration

### Why Swift?
This project was migrated from Node.js to Swift to demonstrate:
- **Performance**: Native compiled code execution
- **Type Safety**: Compile-time error detection
- **Memory Efficiency**: Lower runtime memory footprint
- **AWS Integration**: Seamless integration with AWS Lambda Runtime

### Migration Details
- **Runtime Change**: From Node.js 18.x to Swift custom runtime (provided.al2)
- **Build Process**: Docker-based cross-compilation for Amazon Linux
- **API Compatibility**: Maintains identical REST API interface
- **Error Handling**: Enhanced with Swift's robust error handling
- **CORS Support**: Improved CORS implementation with proper OPTIONS handling

### Build Requirements
The Swift Lambda requires Docker for cross-compilation:
```bash
# Build the Swift Lambda function
cd modules/lambda/src
./build.sh

# This creates:
# - bootstrap: The Lambda runtime executable
# - lambda-deployment.zip: Ready-to-deploy package
```

### Development Workflow
1. **Modify Swift Code**: Edit `Sources/PrimeChecker/main.swift`
2. **Update Dependencies**: Modify `Package.swift` if needed
3. **Build**: Run `./build.sh` to create deployment package
4. **Deploy**: Run `terraform apply` to update Lambda function

## 🔄 CI/CD Integration

### GitHub Actions Ready
```yaml
# Example workflow step for Swift Lambda
- name: Build Swift Lambda
  run: |
    cd modules/lambda/src
    ./build.sh
    
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