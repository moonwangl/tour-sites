#!/bin/bash

# Render Deployment Helper Script
# This script helps prepare and test your site before deploying to Render

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists docker; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command_exists git; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    print_success "All prerequisites are met."
}

# Function to validate project structure
validate_project() {
    print_status "Validating project structure..."
    
    if [ ! -f "index.html" ]; then
        print_error "index.html not found in current directory."
        exit 1
    fi
    
    if [ ! -d "assets" ]; then
        print_warning "assets directory not found. This is optional but recommended."
    fi
    
    print_success "Project structure is valid."
}

# Function to check git status
check_git_status() {
    print_status "Checking Git status..."
    
    if [ ! -d ".git" ]; then
        print_error "This is not a Git repository. Initialize with 'git init' first."
        exit 1
    fi
    
    # Check if there are uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        print_warning "You have uncommitted changes. Consider committing them before deployment."
        git status --short
    else
        print_success "Git repository is clean."
    fi
    
    # Check if remote origin exists
    if ! git remote get-url origin >/dev/null 2>&1; then
        print_warning "No remote origin found. You'll need to push to GitHub for Render deployment."
    else
        print_success "Remote origin configured: $(git remote get-url origin)"
    fi
}

# Function to start local test server
start_local_server() {
    print_status "Starting local test server..."
    
    # Stop any existing containers
    docker compose -f docker-compose.render.yml down >/dev/null 2>&1 || true
    
    # Start the server
    docker compose -f docker-compose.render.yml up -d
    
    # Wait for server to be ready
    print_status "Waiting for server to be ready..."
    sleep 3
    
    # Check if server is responding
    if curl -s http://localhost:8082/health >/dev/null 2>&1; then
        print_success "Local server is running at: http://localhost:8082"
        print_status "Your site is ready for testing!"
    else
        print_error "Server failed to start properly."
        docker compose -f docker-compose.render.yml logs
        exit 1
    fi
}

# Function to stop local server
stop_local_server() {
    print_status "Stopping local server..."
    docker compose -f docker-compose.render.yml down
    print_success "Local server stopped."
}

# Function to show deployment checklist
show_deployment_checklist() {
    echo
    print_status "Render Deployment Checklist:"
    echo
    echo "1. ✅ Ensure your code is committed and pushed to GitHub"
    echo "2. ✅ Create a Render account at https://render.com"
    echo "3. ✅ Connect your GitHub repository to Render"
    echo "4. ✅ Configure deployment settings:"
    echo "   - Name: victor-harbour-tour (or your preferred name)"
    echo "   - Branch: main"
    echo "   - Build Command: (leave empty)"
    echo "   - Publish Directory: (leave empty)"
    echo "5. ✅ Click 'Create Static Site'"
    echo "6. ✅ Wait for deployment to complete"
    echo "7. ✅ Test your live site"
    echo
    print_status "For detailed instructions, see: render-deployment-guide.md"
}

# Function to push to GitHub
push_to_github() {
    print_status "Preparing to push to GitHub..."
    
    # Check if there are changes to commit
    if git diff-index --quiet HEAD --; then
        print_status "No changes to commit."
    else
        print_status "Committing changes..."
        git add .
        read -p "Enter commit message: " commit_message
        git commit -m "$commit_message"
    fi
    
    # Push to GitHub
    print_status "Pushing to GitHub..."
    git push origin main
    print_success "Code pushed to GitHub successfully!"
}

# Main function
main() {
    echo
    print_status "Render Deployment Helper"
    echo "========================="
    echo
    
    case "${1:-}" in
        "check")
            check_prerequisites
            validate_project
            check_git_status
            ;;
        "start")
            check_prerequisites
            validate_project
            start_local_server
            ;;
        "stop")
            stop_local_server
            ;;
        "push")
            check_prerequisites
            check_git_status
            push_to_github
            ;;
        "deploy")
            check_prerequisites
            validate_project
            check_git_status
            show_deployment_checklist
            ;;
        "test")
            check_prerequisites
            validate_project
            start_local_server
            echo
            print_status "Test your site at: http://localhost:8082"
            print_status "Press Ctrl+C to stop the server when done."
            echo
            # Keep the script running
            trap stop_local_server EXIT
            while true; do
                sleep 1
            done
            ;;
        *)
            echo "Usage: $0 {check|start|stop|push|deploy|test}"
            echo
            echo "Commands:"
            echo "  check   - Check prerequisites and project structure"
            echo "  start   - Start local test server (background)"
            echo "  stop    - Stop local test server"
            echo "  push    - Commit and push changes to GitHub"
            echo "  deploy  - Show deployment checklist"
            echo "  test    - Start server and keep running for testing"
            echo
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"