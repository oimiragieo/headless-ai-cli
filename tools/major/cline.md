# 🤖 Cline CLI

**Version tested:** Latest (check with `cline --version`)  
**Risk level:** 🟠 Medium (CLI tool with autonomous task execution)

**Note:** Cline CLI provides both interactive and non-interactive modes. Use direct prompts with `--yolo` flag for autonomous execution in CI/CD pipelines, or leverage advanced instance/task management for complex workflows.

**When NOT to use Cline:**
- ❌ You need massive context windows (Gemini CLI handles larger repos better)
- ❌ You need read-only analysis by default (Cline executes tasks autonomously with YOLO mode)
- ❌ You need deterministic, production-safe runs (Cline makes changes autonomously)
- ❌ You're working with very small codebases (overkill for simple tasks)

### Quick Nav
- [Start Here](#-start-here)
- [Installation](#-installation)
- [Interactive Mode](#interactive-mode)
- [Non-Interactive Mode](#non-interactive-mode-headless)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [Output Formats](#output-formats)
- [Workflows](#-workflows)
- [CI/CD Integration](#-cicd-integration)
- [Examples](#-examples)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Cline is a command-line interface for interacting with Cline AI coding assistant. It provides both interactive and non-interactive modes for task execution, with support for autonomous execution, task management, and CI/CD integration.

**Key Characteristics:**
- Interactive and non-interactive modes
- Autonomous task execution with `-y/--yolo` flag
- Multiple model provider support (Anthropic, OpenAI, Google Gemini, etc.)
- Task and instance management
- File and image attachments
- Multiple output formats (rich, json, plain)
- Two modes: act and plan

**Three Ways to Start:**
1. **With a prompt**: `cline "Create a new Python script"`
2. **Via stdin**: `echo "Create a todo app" | cline`
3. **Interactive mode**: `cline` (no arguments)

**Modes:**
- **Act mode** (default): Execute changes immediately
- **Plan mode**: Create a plan before execution

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

**Interactive mode (default):**
```bash
cline
```

**Start with a prompt (one-shot):**
```bash
cline "Create a new Python script that prints hello world"
```

**Autonomous mode (YOLO):**
```bash
cline "Create a todo app" --yolo
# or shorthand
cline "Create a todo app" -y
```

## Interactive Mode

**Start interactive session:**
```bash
# Start interactive mode (no arguments)
cline

# Start with initial prompt
cline "Create a new Python script"

# With file attachments
cline "Review this code" -f src/main.py

# With image attachments
cline "Recreate this UI" -i screenshot.png

# With multiple files and images
cline "Analyze these files" -f file1.py -f file2.py -i diagram.png

# In plan mode (default)
cline "Design the architecture" --mode plan

# In act mode (execute immediately)
cline "Fix the bug" --mode act
```

Interactive mode allows you to have a conversational session with Cline for exploratory work and iterative development.

## Non-Interactive Mode (Headless)

**Non-interactive execution for automation, scripting, and CI/CD pipelines:**

```bash
# Direct prompt with YOLO mode (fully autonomous)
cline "Generate unit tests for all Go files" --yolo
# or shorthand
cline "Create a todo app" -y

# Pipe via stdin with YOLO mode
echo "Create a todo app" | cline --yolo
cat prompt.txt | cline --yolo

# One-shot mode (full autonomous execution)
cline "Fix all linting issues" --oneshot
# or shorthand
cline "Fix all linting issues" -o

# No interactive prompts
cline "Refactor this module" --no-interactive

# With file attachments
cline "Review this code" -f src/main.py --yolo

# With image attachments
cline "Recreate this UI" -i screenshot.png --yolo

# With specific mode
cline "Design the architecture" --mode plan --yolo
cline "Fix the bug" --mode act --yolo

# With JSON output
cline "Analyze codebase" --output-format json --yolo
```

**Key Flags for Headless Mode:**
- `-y, --yolo`: YOLO mode - enables autonomous planning and execution
- `-o, --oneshot`: Full autonomous mode - complete task without interaction
- `--no-interactive`: Suppress all interactive prompts
- `-F, --output-format`: Specify output format (`rich`, `json`, `plain`)

**Exit codes:**
- `0` = Success
- Non-zero = Error

**Advanced: Task and Instance Management**

For advanced workflows with multiple contexts:

```bash
# Create new instance
cline instance new [--default]

# List all instances
cline instance list

# Switch to instance
cline instance switch <instance-id>

# Create new task (headless)
cline task new -y "Your prompt here"

# View task status
cline task view [--follow]

# List all tasks
cline task list
```

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
# Start with a prompt
cline "Your prompt here" [options]

# Pipe via stdin
echo "Your prompt" | cline [options]

# Interactive mode
cline [options]

# Run commands
cline <command> [options]
```

**Core Options:**

```bash
--address <ADDRESS>           Cline Core gRPC address [env: CLINE_CORE_ADDRESS=]
-f, --file <FILE>...          Attach files to the initial prompt
-i, --image <IMAGE>...        Attach images to the initial prompt
-m, --mode <MODE>             Mode: act (default) or plan [possible values: act, plan]
--no-interactive              Disable interactive mode
-y, --yolo                    YOLO mode - auto-approve all actions
-o, --oneshot                 One-shot mode - full autonomous execution
-F, --output-format <FORMAT>  Output format [default: rich] [possible values: rich, json, plain]
-s, --setting <SETTING>...    Task settings in KEY=VALUE format
-v, --verbose                 Enable verbose logging
-h, --help                    Print help
-V, --version                 Print version
```

**Commands:**

**Authentication:**
```bash
# Authenticate and configure providers
cline auth

# Non-interactive auth (for CI/CD)
cline auth --non-interactive
```

**Shell Completion:**
```bash
# Generate shell completion scripts
cline completion <SHELL>      # bash, zsh, fish, powershell, elvish
```

**Configuration:**
```bash
# View and manage Cline configuration
cline config [options]
```

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

**Logs:**
```bash
# View Cline logs
cline logs [options]
```

**Help:**
```bash
# Print help information
cline help [command]
```

## Output Formats

Cline supports three output formats for different use cases:

**Rich (default):**
```bash
cline "Explain this code"
# or explicitly
cline "Explain this code" --output-format rich
```

Rich format provides formatted, colorized output for human readability. Best for interactive use and terminal displays.

**JSON (for automation):**
```bash
cline "Analyze codebase" --output-format json
```

JSON format provides structured, machine-parseable output ideal for CI/CD pipelines and automation scripts. Parse with `jq` or other JSON tools.

**Plain (simple text):**
```bash
cline "Generate documentation" --output-format plain
```

Plain format provides simple text output without formatting or colors. Useful for logging, piping to files, or environments without terminal formatting support.

**Example with JSON parsing:**
```bash
result=$(cline "Generate code" --output-format json --yolo)
if command -v jq &> /dev/null; then
  echo "$result" | jq -r '.result // "Task completed"'
else
  echo "$result"
fi
```

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

# Run task in headless mode with YOLO flag
cline "Review code changes for bugs and security issues" --yolo --output-format json > review.json

# Error handling
if [ $? -eq 0 ]; then
  echo "✅ Task completed"
  # Parse JSON results
  if command -v jq &> /dev/null; then
    jq -r '.result // "Review completed"' review.json
  fi
else
  echo "❌ Task failed"
  exit 1
fi
```

**Best practices for CI/CD:**
- Use `-y/--yolo` flag for autonomous execution (headless mode)
- Use `--output-format json` for structured, parseable output
- Store API keys as secrets, never hardcode
- Use `--no-interactive` flag to suppress all prompts
- Workflows stored in `.clinerules/workflows/` directory
- Cline makes changes autonomously (review before committing)
- Use `--non-interactive` flag for `cline auth` in CI/CD
- For advanced workflows, use instance/task commands

## Examples

**Generate unit tests:**
```bash
cline "Generate unit tests for all Go files" --yolo
```

**Code review with file attachment:**
```bash
cline "Review this code for bugs and security issues" -f src/auth.py --yolo
```

**Refactoring task:**
```bash
cline "Refactor authentication module to use modern patterns" --yolo
```

**Batch processing:**
```bash
for file in src/*.js; do
  cline "Review and improve: $file" -f "$file" --yolo
done
```

**With JSON output:**
```bash
cline "Analyze the codebase structure" --output-format json --yolo > analysis.json
```

**Pipe from stdin:**
```bash
git diff | cline "Review these changes and suggest improvements" --yolo
```

**Image-based UI recreation:**
```bash
cline "Recreate this UI in React" -i screenshot.png --yolo
```

**Plan mode (architecture design):**
```bash
cline "Design a microservices architecture for this monolith" --mode plan --yolo
```

**Advanced: Multi-instance workflow:**
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

- **Autonomous execution:** Cline makes changes autonomously with `-y/--yolo` flag (review before committing)
- **Context limits:** Depends on selected model provider (not as large as Gemini's 1M tokens)
- **Model provider dependency:** Requires API keys for selected providers
- **Workflow complexity:** Workflows are markdown-based, may require IDE for complex editing
- **Instance management:** Advanced task/instance features require additional setup

## References

- Official Documentation: [docs.cline.bot](https://docs.cline.bot)
- CLI Overview: [docs.cline.bot/cline-cli/overview](https://docs.cline.bot/cline-cli/overview)
- Three Core Flows: [docs.cline.bot/cline-cli/three-core-flows](https://docs.cline.bot/cline-cli/three-core-flows)
- Workflows: [docs.cline.bot/features/slash-commands/workflows](https://docs.cline.bot/features/slash-commands/workflows)

**Note:** Cline is actively developed. Check the official documentation for the latest features, CLI capabilities, and workflow examples.

