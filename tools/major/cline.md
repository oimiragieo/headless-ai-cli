# 🤖 Cline CLI

**Version tested:** Latest (check with `cline --version`)  
**Risk level:** 🟠 Medium (CLI tool with autonomous task execution)

**Note:** Cline CLI supports headless mode for automation and CI/CD integration. It uses instances and tasks for organizing work, with the `-y` flag enabling autonomous execution.

**When NOT to use Cline:**
- ❌ You need massive context windows (Gemini CLI handles larger repos better)
- ❌ You need read-only analysis by default (Cline executes tasks autonomously)
- ❌ You need deterministic, production-safe runs (Cline makes changes autonomously)
- ❌ You're working with very small codebases (overkill for simple tasks)

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Cline](#-why-use-cline)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Headless Mode](#-headless-mode)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [Workflows](#-workflows)
- [CI/CD Integration](#-cicd-integration)
- [Examples](#-examples)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Cline is an AI-powered CLI tool designed for autonomous task execution and code generation. It uses an instance-based architecture for organizing work and supports headless mode for automation and CI/CD integration.

**Key Characteristics:**
- Headless mode for automation
- Instance-based organization
- Autonomous task execution with `-y` flag
- Multiple model provider support
- Workflow automation via markdown files
- Integrated code review capabilities

## Installation

**Using npm:**
```bash
npm install -g cline
```

**System Requirements:**
- Node.js 18 or later
- API keys for selected model providers

**Authentication:**
```bash
# Authenticate and configure providers
cline auth

# Follow prompts to:
# 1. Select provider (Anthropic, OpenAI, Google Gemini, etc.)
# 2. Enter API keys
# 3. Configure additional settings
```

## 🚀 Start Here

```bash
# Initialize a new instance
cline instance new --default

# Create and execute a task in headless mode
cline task new -y "Your task here"
```

## Headless Mode

**Non-interactive execution for automation, scripting, and CI/CD pipelines:**

```bash
# Step 1: Initialize a new instance (required first step)
cline instance new --default

# Step 2: Create and execute a task autonomously (headless mode)
cline task new -y "Generate unit tests for all Go files"

# View task status
cline task view --follow

# List all instances
cline instance list

# Switch between instances
cline instance switch <instance-id>
```

**The `-y` flag (YOLO mode):**
- Enables autonomous planning and execution
- No user interaction required
- Ideal for CI/CD and automation
- Cline plans and executes tasks automatically

**Exit codes:**
- `0` = Success
- Non-zero = Error

**Instance Management:**
- Instances organize work into separate contexts
- Use `--default` flag to set as default instance
- Switch between instances for different projects
- Each instance maintains its own task history

## Available Models

Cline supports multiple AI model providers:

| Provider | Models | Description |
|----------|--------|-------------|
| **Anthropic** | Claude 3 Opus, Claude 3 Sonnet, Claude 3 Haiku | Strong reasoning, code analysis |
| **OpenAI** | GPT-4, GPT-4 Turbo, GPT-3.5-turbo | Code generation, general tasks |
| **OpenRouter** | Various models | Access to multiple models via OpenRouter |
| **X AI (Grok)** | Grok models | Alternative option |
| **AWS Bedrock** | Claude models via Bedrock | Enterprise AWS integration |
| **Google Gemini** | Gemini Pro, Gemini Flash | Large context support |
| **Ollama** | Local models | Self-hosted, privacy-focused |
| **Cerebras** | Cerebras models | High-performance option |
| **OpenAI Compatible** | Any OpenAI-compatible API | Flexible provider support |

**Model Configuration:**
```bash
# Authenticate and configure provider
cline auth

# Follow prompts to:
# - Select provider
# - Enter API keys
# - Configure model preferences
# - Set up multiple providers if needed
```

**Provider Selection:**
- Configure during `cline auth` setup
- Supports multiple providers simultaneously
- Switch between providers as needed
- API keys stored securely in configuration

## CLI Syntax

**Basic usage:**
```bash
cline [command] [options] [arguments]
```

**Core Commands:**

**Instance Management:**
```bash
# Create new instance
cline instance new [--default]

# List all instances
cline instance list

# Switch to instance
cline instance switch <instance-id>

# Delete instance
cline instance delete <instance-id>
```

**Task Management:**
```bash
# Create new task (interactive)
cline task new "Your prompt here"

# Create new task (headless/autonomous)
cline task new -y "Your prompt here"

# View task status
cline task view [--follow]

# List all tasks
cline task list

# Delete task
cline task delete <task-id>
```

**Code Review:**
```bash
# Run code review
cline review

# Run code review with output file
cline review --output=review.md
```

**Authentication:**
```bash
# Authenticate and configure providers
cline auth

# Non-interactive auth (for CI/CD)
cline auth --non-interactive
```

**Common Options:**
- `-y, --yolo`: Autonomous execution (headless mode)
- `--default`: Set as default instance
- `--follow`: Follow task progress in real-time
- `--output`: Specify output file for reviews

## Workflows

**Create workflows for automation:**

Workflows are markdown files stored in `.clinerules/workflows/` directory.

**Creating a Workflow:**
```bash
# Create workflow directory
mkdir -p .clinerules/workflows

# Create workflow markdown file
cat > .clinerules/workflows/deploy.md <<EOF
# Deploy Workflow
1. Run tests: npm test
2. Build project: npm run build
3. Deploy to staging: npm run deploy:staging
4. Run smoke tests: npm run smoke-tests
EOF
```

**Invoke Workflows:**
- Use `/workflow-filename.md` command in Cline chat
- Workflows are markdown files in `.clinerules/workflows/`
- Can be shared across team members
- Support for complex multi-step automation

**Example Workflows:**
- Deploy workflows for automated deployment
- Code review workflows for PR analysis
- Test generation workflows for unit tests
- Refactoring workflows for code improvements

## CI/CD Integration

**GitHub Actions workflow:**
```yaml
name: Cline Code Review

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  cline-review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - name: Checkout code
        uses: actions/checkout@v5

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Cline CLI
        run: npm install -g cline

      - name: Authenticate Cline
        env:
          CLINE_API_KEY: ${{ secrets.CLINE_API_KEY }}
        run: |
          cline auth --non-interactive || echo "Auth may require manual setup"

      - name: Initialize Cline instance
        run: cline instance new --default

      - name: Run Cline Code Review
        id: cline_review
        run: |
          cline review --output=review.md || echo "Review failed" > review.md

      - name: Post Review Comment
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            let review = 'Code review completed.';
            try {
              review = fs.readFileSync('review.md', 'utf8');
            } catch (e) {
              console.log('Review file not found, using default message');
            }
            
            await github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## 🤖 Cline Code Review\n\n${review}\n\n---\n*Generated by Cline CLI*`
            });
```

**Direct CLI usage in CI/CD:**
```bash
#!/bin/bash
set -e

# Install Cline CLI
npm install -g cline

# Initialize instance
cline instance new --default

# Run task in headless mode
cline task new -y "Review code changes for bugs and security issues"

# Error handling
if [ $? -eq 0 ]; then
  echo "✅ Task completed"
else
  echo "❌ Task failed"
  exit 1
fi
```

**Best practices for CI/CD:**
- Use `-y` flag for autonomous execution (headless mode)
- Initialize instance with `cline instance new --default` before tasks
- Store API keys as secrets, never hardcode
- Use `cline review` for automated code reviews
- Workflows stored in `.clinerules/workflows/` directory
- Cline makes changes autonomously (review before committing)
- Use `--non-interactive` flag for `cline auth` in CI/CD

## Examples

**Generate unit tests:**
```bash
cline instance new --default
cline task new -y "Generate unit tests for all Go files"
```

**Code review:**
```bash
cline instance new --default
cline review --output=review.md
```

**Refactoring task:**
```bash
cline instance new --default
cline task new -y "Refactor authentication module to use modern patterns"
```

**Batch processing:**
```bash
cline instance new --default
for file in src/*.js; do
  cline task new -y "Review and improve: $file"
done
```

**Multi-instance workflow:**
```bash
# Create instance for frontend
cline instance new --name frontend --default
cline task new -y "Review frontend code"

# Create instance for backend
cline instance new --name backend
cline instance switch backend
cline task new -y "Review backend code"
```

## Limitations

- **Instance required:** Must initialize instance before tasks
- **Autonomous execution:** Cline makes changes autonomously (review before committing)
- **Context limits:** Depends on selected model provider (not as large as Gemini's 1M tokens)
- **Model provider dependency:** Requires API keys for selected providers
- **Workflow complexity:** Workflows are markdown-based, may require IDE for complex editing

## References

- Official Documentation: [docs.cline.bot](https://docs.cline.bot)
- CLI Overview: [docs.cline.bot/cline-cli/overview](https://docs.cline.bot/cline-cli/overview)
- Three Core Flows: [docs.cline.bot/cline-cli/three-core-flows](https://docs.cline.bot/cline-cli/three-core-flows)
- Workflows: [docs.cline.bot/features/slash-commands/workflows](https://docs.cline.bot/features/slash-commands/workflows)

**Note:** Cline is actively developed. Check the official documentation for the latest features, CLI capabilities, and workflow examples.

