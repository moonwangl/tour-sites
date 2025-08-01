# Victor Harbor Tour Site

A beautiful static website showcasing a tour of the Fleurieu Peninsula, featuring Port Noarlunga, McLaren Vale, and Victor Harbor.

## Features

- Interactive timeline with smooth scrolling navigation
- Image carousel with lazy loading
- Responsive design for all devices
- Detailed itinerary sections with map links
- Modern UI with hover effects and animations

## Local Development

### Using Python HTTP Server
```bash
cd victor-harbour
python3 -m http.server 8081
```

### Using Docker
```bash
# Create a simple Dockerfile if needed
echo 'FROM nginx:alpine
COPY . /usr/share/nginx/html
EXPOSE 80' > Dockerfile

# Build and run
docker build -t victor-harbor-site .
docker run -p 8081:80 victor-harbor-site
```

## Deployment

This project includes multiple deployment options:

### Option 1: Render (Recommended for Beginners)
**Free, automatic deployment from GitHub with global CDN**

#### Quick Start with Render

1. **Test locally first:**
   ```bash
   ./render-deploy.sh test
   ```
   Visit http://localhost:8082 to test your site

2. **Push to GitHub:**
   ```bash
   ./render-deploy.sh push
   ```

3. **Deploy to Render:**
   - Go to [render.com](https://render.com) and sign up with GitHub
   - Click "New" → "Static Site"
   - Connect your GitHub repository
   - Configure:
     - **Name**: `victor-harbour-tour`
     - **Branch**: `main`
     - **Build Command**: (leave empty)
     - **Publish Directory**: (leave empty)
   - Click "Create Static Site"
   - Your site will be live at: `https://your-site-name.onrender.com`

4. **Automatic updates:**
   Every push to your GitHub repository automatically updates your live site!

#### Render Features
- ✅ **Free hosting** with global CDN
- ✅ **Automatic HTTPS** certificates
- ✅ **Custom domains** support
- ✅ **Preview deployments** for pull requests
- ✅ **Zero-downtime** deployments
- ✅ **DDoS protection** included

#### Helper Commands
```bash
./render-deploy.sh check   # Check prerequisites
./render-deploy.sh start   # Start local server (background)
./render-deploy.sh stop    # Stop local server
./render-deploy.sh test    # Start server for testing
./render-deploy.sh deploy  # Show deployment checklist
```

📖 **Detailed Guide**: See `render-deployment-guide.md` for complete instructions

---

### Option 2: AWS S3 (Advanced)
**Self-hosted with full control and optional CloudFront CDN**

This project includes multiple deployment options for AWS S3 static website hosting.

### Prerequisites

1. **AWS Account** with S3 access
2. **IAM User** with S3 deployment permissions
3. **S3 Bucket** configured for static website hosting
4. **Docker** installed (for Docker-based deployment)

### Quick Setup

1. **Configure AWS S3 Bucket** (see `deploy-guide.md` for detailed instructions)
2. **Copy environment file**:
   ```bash
   cp .env.example .env
   ```
3. **Edit `.env`** with your AWS credentials and bucket details
4. **Deploy using the script**:
   ```bash
   ./deploy.sh
   ```

### Deployment Options

#### Option 1: Automated Script (Recommended)
```bash
# Make sure .env is configured
./deploy.sh
```

#### Option 2: Docker Compose Commands
```bash
# Test AWS credentials
docker-compose -f docker-compose.deploy.yml --profile test run --rm test-aws

# Deploy to S3
docker-compose -f docker-compose.deploy.yml --profile deploy run --rm deploy-s3

# Invalidate CloudFront (if using CDN)
docker-compose -f docker-compose.deploy.yml --profile cloudfront run --rm invalidate-cloudfront
```

#### Option 3: GitHub Actions (CI/CD)
1. Push your code to GitHub
2. Add these secrets to your GitHub repository:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_S3_BUCKET`
   - `AWS_REGION`
   - `AWS_CLOUDFRONT_DISTRIBUTION_ID` (optional)
3. The workflow in `.github/workflows/deploy-to-s3.yml` will automatically deploy on push to main branch

### Environment Variables

Create a `.env` file with these variables:

```bash
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=us-east-1
AWS_S3_BUCKET=your-bucket-name
AWS_CLOUDFRONT_DISTRIBUTION_ID=your_distribution_id  # Optional
```

### File Structure

```
victor-harbour/
├── index.html              # Main website file
├── assets/                 # Images and media
│   ├── 1.jpg
│   ├── 2.jpg
│   └── ...
├── .github/
│   └── workflows/
│       └── deploy-to-s3.yml    # GitHub Actions workflow
├── docker-compose.deploy.yml    # Docker deployment config
├── deploy.sh                    # Deployment script
├── .env.example                 # Environment template
├── deploy-guide.md              # Detailed deployment guide
└── README.md                    # This file
```

### Security Notes

- Never commit your `.env` file to version control
- Use IAM users with minimal required permissions
- Enable MFA on your AWS account
- Regularly rotate access keys
- Use HTTPS in production (CloudFront)

### Troubleshooting

**Deployment fails with 403 error:**
- Check S3 bucket policy allows public read access
- Verify IAM user has correct S3 permissions

**Website shows 404:**
- Ensure S3 static website hosting is enabled
- Check index document is set to `index.html`

**Images not loading:**
- Verify all image files are in the `assets/` folder
- Check file paths in HTML are correct

**GitHub Actions failing:**
- Verify all required secrets are set in GitHub
- Check AWS credentials are valid

### Cost Estimation

- **S3 Storage**: ~$0.023/GB/month
- **S3 Requests**: ~$0.0004/1000 requests
- **CloudFront**: 1TB free tier, then ~$0.085/GB
- **GitHub Actions**: 2000 minutes free/month

For a typical static site, monthly costs should be under $1.

### Performance Optimization

- Images are lazy-loaded for faster initial page load
- CloudFront CDN for global content delivery
- Gzip compression enabled in S3
- Optimized image formats (WebP where supported)

### Support

For detailed setup instructions, see `deploy-guide.md`.

For issues with AWS setup, refer to the [AWS S3 Static Website Hosting documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html).