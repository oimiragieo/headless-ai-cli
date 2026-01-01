# ☁️ Amazon Q Developer

> ⚠️ **DEPRECATION NOTICE (November 2025)**
>
> Amazon Q Developer CLI has been **deprecated** and migrated to **Kiro CLI** as of November 17, 2025.
> - The CLI will only receive critical security fixes going forward
> - New users should use [Kiro CLI](kiro.md) instead
> - Existing installations will continue to work but are not actively maintained
> - See: [GitHub - aws/amazon-q-developer-cli](https://github.com/aws/amazon-q-developer-cli) for migration details

**Version tested:** Latest (check with `q --version`)
**Risk level:** 🟢 Low (AWS service integration, controlled access)

**When NOT to use Amazon Q:**
- ❌ You're not using AWS services
- ❌ You need massive context windows (Gemini handles larger repos better)
- ❌ You need pure local/offline workflows
- ❌ You don't have AWS account access

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Amazon Q](#-why-use-amazon-q)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Headless Mode](#-headless-mode)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [Configuration](#-configuration)
- [Examples](#-examples)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Amazon Q Developer is an AI coding assistant developed by AWS, designed to assist developers with code reviews, transformations, and development tasks. It integrates with AWS services and GitHub, providing AI-powered assistance for modernizing legacy systems and enhancing development workflows.

**Key Characteristics:**
- AWS service integration
- GitHub integration for code reviews
- Legacy system modernization
- Code transformation capabilities
- Enterprise-grade security

## Installation

**Install Amazon Q Developer CLI:**

**macOS:**
```bash
# Using Homebrew
brew install amazon-q-developer-cli

# Or download from GitHub releases
# Visit: https://github.com/aws/amazon-q-developer-cli/releases
```

**Linux:**
```bash
# Download and install from GitHub releases
# Visit: https://github.com/aws/amazon-q-developer-cli/releases

# Or use zip file for headless installation
wget https://github.com/aws/amazon-q-developer-cli/releases/latest/download/amazon-q-developer-cli-linux.zip
unzip amazon-q-developer-cli-linux.zip
cd amazon-q-developer-cli-linux
./install.sh
```

**Windows:**
```bash
# Download installer from GitHub releases
# Visit: https://github.com/aws/amazon-q-developer-cli/releases
```

**Verify Installation:**
```bash
q --version
```

**Authenticate:**
```bash
# Login to Amazon Q Developer
q login

# This will open a browser for authentication
# Or use headless authentication (see Headless Mode section)
```

## 🚀 Start Here

```bash
# Install Amazon Q Developer CLI
# See Installation section above

# Authenticate
q login

# Start chat session
q chat

# Or use in headless mode (see Headless Mode section)
```

## Headless Mode

**Non-interactive execution for automation, scripting, and CI/CD pipelines:**

**Basic Headless Usage:**
```bash
# Chat in headless mode (non-interactive)
q chat --prompt "Review this code for security issues"

# With file input
q chat --file src/main.py --prompt "Add error handling"

# Using stdin
echo "Generate unit tests for this function" | q chat --file src/calculator.py

# Batch processing
q chat --prompt "Refactor to use async/await" --files src/*.py
```

**Headless Authentication:**
```bash
# For CI/CD, pre-authenticate and store credentials
# Copy authentication files into Docker/CI environment
# See Docker/CI examples below
```

**Docker/Container Headless Setup:**
```bash
# Build Docker image with pre-authenticated CLI
# 1. Authenticate locally: q login
# 2. Copy ~/.amazonq/ directory to Docker context
# 3. Build image with authentication files
# 4. Run container in headless mode

# Example Dockerfile:
# FROM ubuntu:latest
# COPY amazon-q-developer-cli /usr/local/bin/q
# COPY .amazonq /root/.amazonq
# ENTRYPOINT ["q"]
```

**GitHub Integration (Headless):**
- Automated code reviews on PRs via GitHub Actions
- Code suggestions and improvements
- Legacy system modernization suggestions
- Use GitHub Marketplace integration for automated workflows

**API Integration:**
- Use AWS SDK for programmatic access
- Integrate with CI/CD pipelines
- Automated code analysis via AWS Bedrock APIs

## Available Models

Amazon Q Developer uses AWS Bedrock models:

| Model | Description | Provider | Context |
|-------|-------------|----------|---------|
| **Claude 3.7 Sonnet** | Latest Claude Sonnet, balanced performance | AWS Bedrock | ~200K tokens |
| **Claude 3.5 Sonnet** | Strong reasoning, good for refactoring | AWS Bedrock | ~200K tokens |
| **Claude 3 Opus** | Deep reasoning, complex tasks | AWS Bedrock | ~200K tokens |
| **Claude 3 Haiku** | Fast, cost-effective | AWS Bedrock | ~200K tokens |
| **Titan Text** | AWS native models | AWS Bedrock | Varies |
| **Titan Text G1** | Latest Titan model | AWS Bedrock | Varies |

**Model Selection:**
- Models are configured through AWS Bedrock
- Region-specific availability (check AWS Bedrock availability)
- Enterprise model options available
- Model selection may be automatic or configurable via AWS Console
- Default model typically uses Claude 3.7 Sonnet or latest available

**Note:** Model availability depends on your AWS account, region, and Bedrock access permissions.

## CLI Syntax

**Basic usage:**
```bash
q [command] [options]
```

**Main commands:**
- `q login`: Authenticate with Amazon Q Developer
- `q chat`: Start interactive chat or headless chat session
- `q chat --prompt "text"`: Non-interactive chat with prompt
- `q chat --file <file>`: Chat with file context
- `q --version`: Show version
- `q --help`: Show help

**Chat command options:**
- `--prompt, -p TEXT`: Provide prompt directly (headless mode)
- `--file, -f FILE`: Include file in context
- `--files, -F FILES`: Include multiple files (space-separated)
- `--directory, -d DIR`: Include directory in context
- `--output, -o FILE`: Save output to file

**Headless Mode Examples:**
```bash
# Basic headless chat
q chat --prompt "Review this code for bugs"

# With file context
q chat --prompt "Add error handling" --file src/main.py

# Multiple files
q chat --prompt "Refactor code" --files src/main.py src/utils.py

# Directory-based
q chat --prompt "Analyze codebase" --directory src/

# Save output
q chat --prompt "Generate documentation" --file src/api.py --output docs/api.md
```

**GitHub Integration:**
- Automated PR reviews via GitHub Actions
- Code suggestions in comments
- Transformation recommendations
- Use GitHub Marketplace: https://github.com/marketplace/amazon-q-developer

## Configuration

**Authentication:**
```bash
# Interactive login (opens browser)
q login

# Headless authentication (for CI/CD)
# Pre-authenticate and copy ~/.amazonq/ directory
# Or use AWS credentials if supported
```

**AWS Credentials (if using AWS SDK integration):**
```bash
# Configure AWS credentials
aws configure

# Or use environment variables
export AWS_ACCESS_KEY_ID=your_key
export AWS_SECRET_ACCESS_KEY=your_secret
export AWS_DEFAULT_REGION=us-east-1
```

**Environment Variables:**
```bash
# Amazon Q Developer CLI
export AMAZONQ_REGION=us-east-1
export AMAZONQ_PROFILE=default

# AWS credentials (if needed)
export AWS_ACCESS_KEY_ID=your_key
export AWS_SECRET_ACCESS_KEY=your_secret
export AWS_DEFAULT_REGION=us-east-1
```

**Config File Location:**
- Authentication: `~/.amazonq/`
- Config: `~/.amazonq/config.json` (if applicable)

**GitHub Integration:**
- Configure in AWS Console
- Link GitHub repositories
- Set up webhooks for PR reviews
- Use GitHub Marketplace integration: https://github.com/marketplace/amazon-q-developer

**IAM Permissions:**
- Require appropriate IAM roles
- AWS Bedrock access permissions
- Code review permissions
- GitHub integration permissions (if using GitHub integration)

## Examples

**Code Review (Headless):**
```bash
# Review code file
q chat --prompt "Review this code for bugs, security issues, and best practices" --file src/main.py

# Review multiple files
q chat --prompt "Review these changes for potential issues" --files src/main.py src/utils.py

# Review directory
q chat --prompt "Analyze codebase for security vulnerabilities" --directory src/
```

**Code Transformation (Headless):**
```bash
# Modernize legacy code
q chat --prompt "Convert this code to use async/await patterns" --file legacy.py

# Refactor codebase
q chat --prompt "Refactor to apply SOLID principles and improve maintainability" --directory src/

# Add error handling
q chat --prompt "Add comprehensive error handling and input validation" --file src/api.py
```

**Code Generation (Headless):**
```bash
# Generate unit tests
q chat --prompt "Generate comprehensive unit tests with 80%+ coverage" --file src/calculator.py --output tests/test_calculator.py

# Generate documentation
q chat --prompt "Generate API documentation following OpenAPI 3.0 specification" --file src/api.py --output docs/api.md

# Add type hints
q chat --prompt "Add type hints to all functions and classes" --file src/main.py
```

**Codebase Analysis (Headless):**
```bash
# Analyze entire codebase
q chat --prompt "Analyze codebase structure, identify technical debt, and suggest improvements" --directory . --output analysis.md

# Security audit
q chat --prompt "Perform security audit: identify vulnerabilities, insecure patterns, and suggest fixes" --directory src/
```

**Interactive Chat:**
```bash
# Start interactive chat session
q chat

# In chat:
# > Review src/main.py for bugs
# > Generate tests for src/calculator.py
# > Refactor src/api.py to use async/await
# > exit
```

## CI/CD Integration

**GitHub Actions Workflow:**
```yaml
name: Amazon Q Code Review

on:
  pull_request:
    types: [opened, synchronize, reopened]
  workflow_dispatch:

jobs:
  code_review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write

    steps:
      - name: Checkout code
        uses: actions/checkout@v5
        with:
          fetch-depth: 0

      - name: Install Amazon Q Developer CLI
        run: |
          # Download and install CLI
          wget https://github.com/aws/amazon-q-developer-cli/releases/latest/download/amazon-q-developer-cli-linux.zip
          unzip amazon-q-developer-cli-linux.zip
          cd amazon-q-developer-cli-linux
          sudo ./install.sh
          cd ..

      - name: Setup Authentication
        run: |
          # For headless mode, use pre-authenticated credentials
          # Copy authentication files from secrets or use AWS credentials
          mkdir -p ~/.amazonq
          echo "${{ secrets.AMAZONQ_AUTH }}" > ~/.amazonq/auth.json
          # Or configure AWS credentials if using AWS SDK
          aws configure set aws_access_key_id ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws configure set aws_secret_access_key ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws configure set region us-east-1

      - name: Run Amazon Q Code Review
        id: q_review
        run: |
          # Get changed files
          CHANGED_FILES=$(git diff --name-only origin/${{ github.base_ref }}...HEAD | grep -E '\.(py|js|ts|java)$' || true)
          
          if [ -z "$CHANGED_FILES" ]; then
            echo "No code files to review."
            echo "review_output=No code files to review." >> $GITHUB_OUTPUT
            echo "has_review=false" >> $GITHUB_OUTPUT
          else
            # Run review on changed files
            REVIEW_OUTPUT=$(q chat --prompt "Review these code changes for bugs, security issues, and best practices. Provide actionable suggestions." --files $CHANGED_FILES || echo "Review completed")
            
            echo "review_output<<EOF" >> $GITHUB_OUTPUT
            echo "$REVIEW_OUTPUT" >> $GITHUB_OUTPUT
            echo "EOF" >> $GITHUB_OUTPUT
            echo "has_review=true" >> $GITHUB_OUTPUT
          fi

      - name: Post Review Comment
        if: github.event_name == 'pull_request' && steps.q_review.outputs.has_review == 'true'
        uses: actions/github-script@v7
        with:
          script: |
            const reviewOutput = `${{ steps.q_review.outputs.review_output }}`;
            const prNumber = context.issue.number;
            const owner = context.repo.owner;
            const repo = context.repo.repo;

            if (reviewOutput && reviewOutput.trim() !== '' && reviewOutput !== 'Review completed') {
              const body = `## 🤖 Automated Code Review by Amazon Q Developer\n\n${reviewOutput}\n\n---\n*Generated by Amazon Q Developer CLI in CI/CD*`;
              
              await github.rest.issues.createComment({
                issue_number: prNumber,
                owner: owner,
                repo: repo,
                body: body
              });
            }
```

**GitLab CI/CD:**
```yaml
stages:
  - review

amazon-q-review:
  stage: review
  image: ubuntu:latest
  before_script:
    - apt-get update && apt-get install -y wget unzip
    - wget https://github.com/aws/amazon-q-developer-cli/releases/latest/download/amazon-q-developer-cli-linux.zip
    - unzip amazon-q-developer-cli-linux.zip
    - cd amazon-q-developer-cli-linux && ./install.sh && cd ..
    - mkdir -p ~/.amazonq
    - echo "$AMAZONQ_AUTH" > ~/.amazonq/auth.json
  script:
    - q chat --prompt "Review code changes for issues" --directory .
  only:
    - merge_requests
```

**Docker Headless Setup:**
```dockerfile
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y wget unzip

# Install Amazon Q Developer CLI
RUN wget https://github.com/aws/amazon-q-developer-cli/releases/latest/download/amazon-q-developer-cli-linux.zip && \
    unzip amazon-q-developer-cli-linux.zip && \
    cd amazon-q-developer-cli-linux && \
    ./install.sh && \
    cd .. && \
    rm -rf amazon-q-developer-cli-linux*

# Copy authentication (pre-authenticated)
COPY .amazonq /root/.amazonq

# Set entrypoint
ENTRYPOINT ["q"]
```

**Best Practices for CI/CD:**
- Pre-authenticate and store credentials securely
- Use secrets management for authentication files
- Handle authentication errors gracefully
- Use `--output` flag to save results as artifacts
- Set appropriate timeouts for long-running operations
- Use GitHub Marketplace integration for easier setup

## Limitations

- **AWS dependency:** Requires AWS account and services
- **Region availability:** May not be available in all regions
- **GitHub integration:** Primary integration method
- **Cost:** AWS service costs apply
- **Enterprise focus:** Designed for enterprise workflows

## References

- **Official Documentation:** [Amazon Q Developer User Guide](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/what-is.html)
- **CLI Documentation:** [Amazon Q Developer CLI](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html)
- **GitHub Repository:** [amazon-q-developer-cli](https://github.com/aws/amazon-q-developer-cli)
- **GitHub Marketplace:** [Amazon Q Developer](https://github.com/marketplace/amazon-q-developer)
- **AWS Documentation:** [Amazon Q Developer](https://aws.amazon.com/q/developer/)
- **AWS Bedrock:** [Amazon Bedrock](https://aws.amazon.com/bedrock/)
- **Docker Guide:** [Putting Amazon Q Developer in a Docker Container](https://community.aws/content/2uZYCp6BNJJgBaRnw3Nie6i8r0l/putting-amazon-q-developer-in-a-docker-container)

**Note:** Amazon Q Developer is an AWS service. Check AWS documentation and the GitHub repository for the latest features, CLI commands, and integration options. The CLI is actively developed and commands may change.

