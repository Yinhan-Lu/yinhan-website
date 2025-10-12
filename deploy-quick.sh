#!/bin/bash

# Quick deploy script for yinhan-website
# This script commits all changes and pushes to GitHub for automatic deployment

set -e  # Exit on error

echo "🚀 Quick Deploy Script for yinhan-website"
echo "=========================================="
echo ""

# Check if there are any changes
if [[ -z $(git status -s) ]]; then
    echo "✅ No changes to deploy. Working directory is clean."
    exit 0
fi

# Security check: Look for sensitive files in wrong locations
echo "🔒 Checking for sensitive files..."
SENSITIVE_FILES_FOUND=0

# Check for PDFs in root directory
if ls *.pdf 2>/dev/null; then
    echo "⚠️  WARNING: Found PDF files in root directory:"
    ls *.pdf 2>/dev/null
    SENSITIVE_FILES_FOUND=1
fi

# Check for transcript files anywhere
if find . -maxdepth 2 \( -name "transcript*.pdf" -o -name "*_transcript.pdf" \) 2>/dev/null | grep -q .; then
    echo "⚠️  WARNING: Found transcript files:"
    find . -maxdepth 2 \( -name "transcript*.pdf" -o -name "*_transcript.pdf" \) 2>/dev/null
    SENSITIVE_FILES_FOUND=1
fi

# Check for backup files
if find . -name "*.bak" -o -name "*.json.bak" 2>/dev/null | grep -q .; then
    echo "⚠️  WARNING: Found backup files:"
    find . -name "*.bak" -o -name "*.json.bak" 2>/dev/null
    SENSITIVE_FILES_FOUND=1
fi

if [ $SENSITIVE_FILES_FOUND -eq 1 ]; then
    echo ""
    echo "❌ SECURITY WARNING: Sensitive files detected!"
    echo ""
    echo "📋 These files are in .gitignore and won't be uploaded, but you should:"
    echo "  ✓ Move CVs to: assets/pdf/"
    echo "  ✓ Delete or move transcripts outside the repo"
    echo "  ✓ Delete backup files"
    echo ""
    read -p "Continue deployment anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Deployment cancelled for safety."
        exit 1
    fi
fi

echo "✅ Security check passed."
echo ""

# Show what will be committed
echo "📝 Changes to be deployed:"
git status -s
echo ""

# Ask for confirmation
read -p "Deploy these changes? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled."
    exit 1
fi

# Ask for commit message (or use default)
echo ""
echo "Enter commit message (or press Enter for default):"
read -r COMMIT_MSG

if [[ -z "$COMMIT_MSG" ]]; then
    COMMIT_MSG="Update website content

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
fi

# Add all changes
echo ""
echo "📦 Adding all changes..."
git add -A

# Commit
echo "💾 Creating commit..."
git commit -m "$COMMIT_MSG"

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Successfully pushed to GitHub!"
echo ""
echo "🔄 GitHub Actions is now building and deploying your site..."
echo "📊 Check progress: https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/actions"
echo ""
echo "🌐 Your site will be live at: https://yinhanlu.me"
echo "⏱️  Deployment usually takes 5-10 minutes"
echo ""
echo "💡 Tip: Run 'gh run watch' to monitor the deployment progress"
