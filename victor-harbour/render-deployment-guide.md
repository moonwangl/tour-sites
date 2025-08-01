# Render Static Site Deployment Guide

This guide will help you deploy your static site to Render with automatic deployment from your GitHub repository.

## Why Render?

- **Free static site hosting** with global CDN
- **Automatic deployments** from GitHub/GitLab/Bitbucket
- **Custom domains** support (up to 25 domains per site)
- **HTTPS/TLS certificates** automatically managed
- **Preview deployments** for pull requests
- **Zero-downtime deployments**
- **DDoS protection** included
- **HTTP/2 and Brotli compression** for better performance

## Prerequisites

1. A GitHub account with your project repository
2. Your static site code pushed to GitHub
3. A Render account (free)

## Step 1: Prepare Your Repository

### 1.1 Ensure Your Code is on GitHub

Make sure your project is pushed to GitHub:

```bash
# If not already a git repository
git init
git add .
git commit -m "Initial commit"

# Add your GitHub repository as origin
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git push -u origin main
```

### 1.2 Project Structure

Your project should have this structure:
```
your-repo/
├── index.html          # Main HTML file
├── assets/            # Images, CSS, JS files
├── README.md          # Project documentation
└── other files...
```

## Step 2: Create a Render Account

1. Go to [render.com](https://render.com)
2. Click "Get Started For Free"
3. **Sign up with your GitHub account** (recommended for easy integration)
4. Complete the sign-up process
5. Verify your email address

## Step 3: Deploy Your Static Site

### 3.1 Create New Static Site

1. In your Render Dashboard, click **"New"** → **"Static Site"**
2. Select **"Build and deploy from Git repository"**
3. Click **"Next"**

### 3.2 Connect Your GitHub Repository

1. If first time: Click **"+ Connect account"** under GitHub
2. Install Render to your GitHub account
3. Grant access to your repositories
4. Find your repository and click **"Connect"**

### 3.3 Configure Deployment Settings

**Basic Settings:**
- **Name**: Give your site a unique name (e.g., `victor-harbour-tour`)
- **Branch**: Select `main` (or your default branch)
- **Root Directory**: Leave empty (uses repository root)

**Build Settings:**
- **Build Command**: Leave empty (no build process needed for static HTML)
- **Publish Directory**: Leave empty (uses repository root)

**Advanced Settings (Optional):**
- **Auto-Deploy**: Enabled by default ✅
- **Pull Request Previews**: Enable for testing changes

### 3.4 Deploy

1. Click **"Create Static Site"**
2. Render will start the initial deployment
3. Wait for deployment to complete (usually 1-2 minutes)
4. Your site will be available at: `https://YOUR_SITE_NAME.onrender.com`

## Step 4: Configure Custom Domain (Optional)

### 4.1 Add Custom Domain

1. Go to your site's **Settings** page in Render Dashboard
2. Scroll to **"Custom Domains"** section
3. Click **"Add Custom Domain"**
4. Enter your domain (e.g., `yourdomain.com`)

### 4.2 Update DNS Settings

Add these DNS records with your domain provider:

**For root domain (yourdomain.com):**
```
Type: A
Name: @
Value: 216.24.57.1
```

**For www subdomain:**
```
Type: CNAME
Name: www
Value: YOUR_SITE_NAME.onrender.com
```

## Step 5: Automatic Deployment Setup

### 5.1 How It Works

Render automatically:
- **Monitors your GitHub repository** for changes
- **Deploys on every push** to your selected branch
- **Invalidates CDN cache** after successful deployment
- **Sends notifications** about deployment status

### 5.2 Deployment Triggers

**Automatic deployment happens when:**
- You push commits to the deployed branch
- You merge pull requests to the deployed branch
- You create releases/tags (if configured)

**Manual deployment:**
- Click **"Manual Deploy"** in Render Dashboard
- Select **"Deploy latest commit"**

## Step 6: Environment Variables (If Needed)

For static sites, you typically don't need environment variables, but if you do:

1. Go to **Settings** → **Environment Variables**
2. Click **"Add Environment Variable"**
3. Add your variables (e.g., `NODE_ENV=production`)

## Step 7: Preview Deployments

### 7.1 Enable PR Previews

1. Go to **Settings** → **Pull Request Previews**
2. Toggle **"Create previews for pull requests"**
3. Each PR will get a unique preview URL

### 7.2 Using PR Previews

1. Create a pull request on GitHub
2. Render automatically creates a preview deployment
3. Test your changes on the preview URL
4. Merge when satisfied

## Step 8: Monitoring and Maintenance

### 8.1 Deployment Logs

- View deployment logs in Render Dashboard
- Check for any errors or warnings
- Monitor deployment times

### 8.2 Performance Monitoring

- Monitor bandwidth usage
- Check CDN cache hit rates
- Review site performance metrics

### 8.3 Notifications

Set up notifications for:
- Deployment success/failure
- Service health alerts
- Bandwidth usage alerts

## Troubleshooting

### Common Issues

**Deployment Failed:**
- Check deployment logs for errors
- Ensure all files are committed and pushed
- Verify repository permissions

**Site Not Loading:**
- Check if `index.html` exists in repository root
- Verify file paths and case sensitivity
- Check browser console for errors

**Custom Domain Issues:**
- Verify DNS settings with your provider
- Allow 24-48 hours for DNS propagation
- Check SSL certificate status

**Performance Issues:**
- Optimize images (use WebP format)
- Minify CSS and JavaScript
- Enable Brotli compression (automatic on Render)

### Getting Help

- [Render Documentation](https://render.com/docs)
- [Render Community Forum](https://community.render.com)
- [Render Support](https://render.com/support)

## Cost Information

**Free Tier Includes:**
- Unlimited static sites
- 100GB bandwidth per month
- Global CDN
- Custom domains
- SSL certificates
- Basic DDoS protection

**Paid Plans:**
- Additional bandwidth
- Priority support
- Advanced features

## Security Best Practices

1. **Repository Security:**
   - Don't commit sensitive data
   - Use `.gitignore` for sensitive files
   - Review repository permissions

2. **Domain Security:**
   - Use HTTPS (automatic on Render)
   - Configure security headers
   - Regular security updates

3. **Access Control:**
   - Limit repository access
   - Use branch protection rules
   - Review deployment permissions

## Next Steps

1. **Set up monitoring** for your site
2. **Configure analytics** (Google Analytics, etc.)
3. **Optimize performance** (image compression, etc.)
4. **Set up backup strategy** for your repository
5. **Plan for scaling** if traffic grows

---

**Your site is now automatically deployed to Render!** 🎉

Every time you push changes to your GitHub repository, Render will automatically update your live site.