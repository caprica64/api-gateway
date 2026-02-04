#!/bin/bash

# Build script for Swift Factorial Lambda function
set -e

echo "Building Swift Factorial Lambda function..."

# Clean previous builds
rm -f bootstrap factorial-deployment.zip

# Build the Swift package for Amazon Linux 2 x86_64 with static linking
docker run --rm --platform linux/amd64 -v "$PWD":/workspace -w /workspace swift:5.9-amazonlinux2 bash -c "
    yum update -y && \
    yum install -y zip && \
    swift build --product FactorialCalculator -c release --static-swift-stdlib && \
    cp .build/release/FactorialCalculator bootstrap && \
    zip factorial-deployment.zip bootstrap
"

echo "Build complete. Deployment package: factorial-deployment.zip"