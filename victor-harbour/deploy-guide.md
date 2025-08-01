# Automated Deployment to AWS S3

This guide will help you set up automatic deployment of your static website to AWS S3 using GitHub Actions.

## Prerequisites

1. AWS Account
2. GitHub repository for your code
3. Basic knowledge of AWS S3 and GitHub Actions

## Step 1: Create S3 Bucket

1. **Login to AWS Console** and navigate to S3
2. **Create a new bucket**:
   - Choose a unique bucket name (e.g., `your-site-name-bucket`)
   - Select your preferred region
   - Uncheck "Block all public access"
   - Acknowledge the warning about public access

3. **Enable Static Website Hosting**:
   - Go to Properties tab
   - Scroll to "Static website hosting"
   - Enable it and set:
     - Index document: `index.html`
     - Error document: `index.html` (for SPA routing)

4. **Set Bucket Policy**:
   - Go to Permissions tab
   - Edit Bucket Policy and paste:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "PublicReadGetObject",
         "Effect": "Allow",
         "Principal": "*",
         "Action": "s3:GetObject",
         "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
       }
     ]
   }
   ```
   Replace `YOUR-BUCKET-NAME` with your actual bucket name.

## Step 2: Create IAM User for GitHub Actions

1. **Go to IAM** in AWS Console
2. **Create a new user**:
   - User name: `github-actions-s3-deploy`
   - Access type: Programmatic access

3. **Attach Policy**:
   - Create a custom policy with these permissions:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "s3:PutObject",
           "s3:PutObjectAcl",
           "s3:GetObject",
           "s3:DeleteObject",
           "s3:ListBucket"
         ],
         "Resource": [
           "arn:aws:s3:::YOUR-BUCKET-NAME",
           "arn:aws:s3:::YOUR-BUCKET-NAME/*"
         ]
       }
     ]
   }
   ```

4. **Save Access Keys**: Note down the Access Key ID and Secret Access Key

## Step 3: Set up GitHub Repository

1. **Create GitHub Repository** and push your code
2. **Add GitHub Secrets**:
   - Go to Settings > Secrets and variables > Actions
   - Add these secrets:
     - `AWS_ACCESS_KEY_ID`: Your IAM user's access key
     - `AWS_SECRET_ACCESS_KEY`: Your IAM user's secret key
     - `AWS_S3_BUCKET`: Your S3 bucket name
     - `AWS_REGION`: Your S3 bucket region (e.g., `us-east-1`)

## Step 4: Create GitHub Actions Workflow

Create `.github/workflows/deploy.yml` in your repository:

```yaml
name: Deploy to S3

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ secrets.AWS_REGION }}
    
    - name: Sync files to S3
      run: |
        aws s3 sync . s3://${{ secrets.AWS_S3_BUCKET }} --delete --exclude ".git/*" --exclude ".github/*" --exclude "*.md" --exclude "deploy-guide.md"
    
    - name: Invalidate CloudFront (optional)
      run: |
        # Uncomment if you're using CloudFront
        # aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths "/*"
```

## Step 5: Test the Deployment

1. **Push your code** to the main branch
2. **Check GitHub Actions** tab to see the workflow running
3. **Visit your S3 website URL** to verify deployment

## Optional: Add CloudFront CDN

For better performance and HTTPS support:

1. **Create CloudFront Distribution**:
   - Origin: Your S3 bucket website endpoint
   - Default root object: `index.html`
   - Enable HTTPS redirect

2. **Update GitHub workflow** to invalidate CloudFront cache:
   - Add `AWS_CLOUDFRONT_DISTRIBUTION_ID` to GitHub secrets
   - Uncomment the CloudFront invalidation step in the workflow

## Alternative: Using Docker Compose

Since you prefer Docker, here's a Docker-based approach:

```yaml
# docker-compose.deploy.yml
version: '3.8'
services:
  deploy:
    image: amazon/aws-cli:latest
    volumes:
      - .:/workspace
    working_dir: /workspace
    environment:
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
      - AWS_DEFAULT_REGION=${AWS_REGION}
    command: >
      sh -c "aws s3 sync . s3://${AWS_S3_BUCKET} --delete 
             --exclude '.git/*' 
             --exclude '.github/*' 
             --exclude '*.md' 
             --exclude 'docker-compose*'"
```

Run with:
```bash
docker-compose -f docker-compose.deploy.yml run --rm deploy
```

## Cost Considerations

- **S3 Storage**: Very low cost for static files
- **Data Transfer**: First 1GB free per month
- **GitHub Actions**: 2000 minutes free per month
- **CloudFront**: 1TB free data transfer per month

## Security Best Practices

1. Use IAM roles with minimal permissions
2. Enable MFA on your AWS account
3. Regularly rotate access keys
4. Monitor AWS CloudTrail for access logs
5. Use HTTPS (CloudFront) for production

## Troubleshooting

- **403 Forbidden**: Check bucket policy and public access settings
- **404 Not Found**: Verify index document configuration
- **GitHub Actions failing**: Check AWS credentials and permissions
- **Files not updating**: Clear browser cache or CloudFront cache

Your website will be automatically deployed every time you push to the main branch!