#!/bin/bash

# Script to deploy static website to AWS S3 using Docker Compose

# Check if .env file exists
if [ ! -f ".env" ]; then
  echo "Error: .env file not found!"
  echo "Please create a .env file with your AWS credentials and settings."
  echo "You can copy .env.example and fill in your values."
  exit 1
fi

# Load environment variables
set -a
source .env
set +a

# Check required variables
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_S3_BUCKET" ]; then
  echo "Error: Missing required environment variables!"
  echo "Please make sure AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and AWS_S3_BUCKET are set in your .env file."
  exit 1
fi

# Set default AWS region if not provided
if [ -z "$AWS_REGION" ]; then
  export AWS_REGION="us-east-1"
  echo "AWS_REGION not set, using default: us-east-1"
fi

# Test AWS credentials
echo "Testing AWS credentials and S3 bucket access..."
docker-compose -f docker-compose.deploy.yml --profile test run --rm test-aws

# Check if test was successful
if [ $? -ne 0 ]; then
  echo "Error: AWS credentials test failed!"
  echo "Please check your AWS credentials and S3 bucket access."
  exit 1
fi

# Deploy to S3
echo "Deploying to S3 bucket: $AWS_S3_BUCKET"
docker-compose -f docker-compose.deploy.yml --profile deploy run --rm deploy-s3

# Invalidate CloudFront if distribution ID is provided
if [ -n "$AWS_CLOUDFRONT_DISTRIBUTION_ID" ]; then
  echo "Invalidating CloudFront distribution: $AWS_CLOUDFRONT_DISTRIBUTION_ID"
  docker-compose -f docker-compose.deploy.yml --profile cloudfront run --rm invalidate-cloudfront
fi

echo "Deployment completed!"
echo "Your website should now be available at: http://$AWS_S3_BUCKET.s3-website-$AWS_REGION.amazonaws.com"