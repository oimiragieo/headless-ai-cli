# 🤖 OpenCode

**Version tested:** Latest (check with `opencode --version`)  
**Risk level:** 🟠 Medium (autonomous coding agent, can modify files and execute commands)

**When NOT to use OpenCode:**
- ❌ You need massive context windows (Gemini handles larger repos better)
- ❌ You need pure local/offline workflows (may require API access)
- ❌ You're working in a non-Git repository (OpenCode works best with Git)
- ❌ You need deterministic, production-safe CI/CD runs (Droid is safer)

### Quick Nav
- [Start Here](#-start-here)
- [Why Use OpenCode](#-why-use-opencode)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Headless Mode](#-headless-mode)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [Configuration](#-configuration)
- [Examples](#-examples)
- [CI/CD Integration](#-cicd-integration)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

OpenCode is an AI coding assistant that can read files, write and modify code, execute terminal commands, and interact with development environments using natural language. It supports headless mode for automation and CI/CD integration.

**Key Characteristics:**
- Autonomous coding agent
- Headless mode for automation
- Natural language interaction
- File reading, writing, and code modification
- Terminal command execution
- Git integration
- CI/CD pipeline support

## Installation

**Using npm:**
```bash
npm install -g open-code
```



**System Requirements:**
- Node.js (for npm installation)
- Git repository (for best experience)
- API key for LLM provider (OpenAI, Anthropic, etc.)

## 🚀 Start Here

```bash
# Install OpenCode
npm install -g open-code

# Authenticate with provider
opencode auth login

# Start OpenCode TUI (interactive mode)
opencode

# Or run with a message (headless)
opencode run "Review this code for bugs"
```

## Headless Mode

**Non-interactive execution for automation, scripting, and CI/CD pipelines:**

**Basic Headless Usage:**
```bash
# Run with a message (single command execution)
opencode run "Review this code for bugs"

# Run with multiple message arguments
opencode run "Analyze" "the codebase" "for security issues"

# Start headless server
opencode serve

# Start headless web server
opencode web

# With specific model
opencode run "Generate tests" --model anthropic/claude-3.5-sonnet

# Continue last session
opencode run "Add error handling" --continue

# Continue specific session
opencode run "Refactor code" --session <session-id>

# With custom agent
opencode run "Review PR" --agent code-reviewer

# With specific port and hostname
opencode serve --port 3000 --hostname 0.0.0.0
```

**Key Commands for Headless Mode:**
- `opencode run [message..]` - Run opencode with a message
- `opencode serve` - Start headless opencode server
- `opencode web` - Start headless opencode web server
- `opencode attach <url>` - Attach to a running opencode server

**Key Options:**
- `-m, --model` - Model to use in format provider/model
- `-c, --continue` - Continue the last session
- `-s, --session` - Session ID to continue
- `-p, --prompt` - Prompt to use
- `--agent` - Agent to use
- `--port` - Port to listen on (default: 0)
- `--hostname` - Hostname to listen on (default: 127.0.0.1)

## Available Models

**List all available models:**
```bash
opencode models
```

**OpenCode Models:**
- `opencode/gpt-5-nano`
- `opencode/big-pickle`
- `opencode/grok-code`

**GitHub Copilot Models** (available after authenticating with GitHub Copilot):
- `github-copilot/grok-code-fast-1`
- `github-copilot/gpt-5.1-codex`
- `github-copilot/claude-haiku-4.5`
- `github-copilot/gemini-3-pro-preview`
- `github-copilot/oswe-vscode-prime`
- `github-copilot/gpt-5.1-codex-mini`
- `github-copilot/gpt-5.1`
- `github-copilot/gpt-5-codex`
- `github-copilot/gpt-4o`
- `github-copilot/gpt-4.1`
- `github-copilot/claude-opus-41`
- `github-copilot/gpt-5-mini`
- `github-copilot/gemini-2.5-pro`
- `github-copilot/claude-sonnet-4`
- `github-copilot/gpt-5`
- `github-copilot/claude-opus-4.5`
- `github-copilot/claude-sonnet-4.5`

**Supported Providers** (from `opencode auth login`):

| Provider | Description |
|----------|-------------|
| **OpenCode Zen** | Recommended default provider |
| **Anthropic** | Claude models (Sonnet, Opus, Haiku) |
| **GitHub Copilot** | GitHub's AI assistant models |
| **OpenAI** | GPT models (GPT-4, GPT-3.5-turbo, etc.) |
| **Google** | Gemini models |
| **OpenRouter** | Access to multiple models via OpenRouter |
| **Vercel AI Gateway** | Vercel's AI model gateway |

**Model Selection:**
```bash
# Use specific model (format: provider/model)
opencode run "Your task" --model github-copilot/gpt-5.1-codex

# Use Claude via GitHub Copilot
opencode run "Generate tests" --model github-copilot/claude-sonnet-4.5

# Use Gemini via GitHub Copilot
opencode run "Review code" --model github-copilot/gemini-3-pro-preview

# Use default OpenCode models
opencode run "Analyze code" --model opencode/big-pickle

# Use fast model for quick tasks
opencode run "Fix typo" --model github-copilot/grok-code-fast-1

# Use GPT-5 for advanced reasoning
opencode run "Design architecture" --model github-copilot/gpt-5.1
```

**Authentication:**
```bash
# Log in to a provider
opencode auth login

# List configured providers
opencode auth list
# or shorthand
opencode auth ls

# Log out from a provider
opencode auth logout
```

## CLI Syntax

**Commands:**
```bash
opencode acp                 # Start ACP (Agent Client Protocol) server
opencode [project]           # Start opencode TUI (default)
opencode attach <url>        # Attach to a running opencode server
opencode run [message..]     # Run opencode with a message
opencode auth                # Manage credentials
opencode agent               # Manage agents
opencode upgrade [target]    # Upgrade opencode to the latest or specific version
opencode serve               # Start a headless opencode server
opencode web                 # Start a headless opencode web server
opencode models              # List all available models
opencode stats               # Show token usage and cost statistics
opencode export [sessionID]  # Export session data as JSON
opencode import <file>       # Import session data from JSON file or URL
opencode github              # Manage GitHub agent
```

**Positionals:**
```bash
project  # Path to start opencode in [string]
```

**Options:**
```bash
-h, --help        # Show help [boolean]
-v, --version     # Show version number [boolean]
--print-logs      # Print logs to stderr [boolean]
--log-level       # Log level [choices: "DEBUG", "INFO", "WARN", "ERROR"]
-m, --model       # Model to use in format of provider/model [string]
-c, --continue    # Continue the last session [boolean]
-s, --session     # Session ID to continue [string]
-p, --prompt      # Prompt to use [string]
--agent           # Agent to use [string]
--port            # Port to listen on [number] [default: 0]
--hostname        # Hostname to listen on [string] [default: "127.0.0.1"]
```

**Auth Commands:**
```bash
opencode auth login [url]  # Log in to a provider
opencode auth logout       # Log out from a configured provider
opencode auth list         # List providers [aliases: ls]
```

**Interactive Mode:**
```bash
# Start interactive TUI (default)
opencode

# Start in specific project directory
opencode /path/to/project
```

## Configuration

**Authentication:**
```bash
# Log in to a provider (interactive)
opencode auth login

# Select from providers:
# - OpenCode Zen (recommended)
# - Anthropic
# - GitHub Copilot
# - OpenAI
# - Google
# - OpenRouter
# - Vercel AI Gateway

# List configured providers
opencode auth list

# Log out
opencode auth logout
```

**Session Management:**
```bash
# Export session data as JSON
opencode export [sessionID]

# Import session data from JSON file or URL
opencode import <file>

# View token usage and cost statistics
opencode stats
```

**Agent Management:**
```bash
# Manage agents
opencode agent

# Use specific agent
opencode run "Review code" --agent code-reviewer
```

## Examples

**Code Review:**
```bash
# Run code review with message
opencode run "Review this code for bugs, security issues, and best practices"

# Review with specific model
opencode run "Review code changes for potential issues" --model anthropic/claude-3.5-sonnet

# Continue previous review session
opencode run "Apply the suggested fixes" --continue
```

**Code Transformation:**
```bash
# Refactor code
opencode run "Refactor to apply SOLID principles and improve maintainability"

# Modernize code with specific model
opencode run "Convert this code to use async/await patterns" --model openai/gpt-4

# Add error handling
opencode run "Add comprehensive error handling and input validation"
```

**Code Generation:**
```bash
# Generate unit tests
opencode run "Generate comprehensive unit tests with 80%+ coverage"

# Generate documentation
opencode run "Generate API documentation following OpenAPI 3.0 specification"

# Add type hints
opencode run "Add type hints to all functions and classes"
```

**Headless Server:**
```bash
# Start headless server
opencode serve

# Start headless server on custom port
opencode serve --port 3000 --hostname 0.0.0.0

# Start web server
opencode web

# Attach to running server
opencode attach http://localhost:3000
```

**Session Management:**
```bash
# Continue last session
opencode run "Continue the refactoring task" --continue

# Continue specific session
opencode run "Apply fixes" --session abc123

# Export session data
opencode export abc123 > session.json

# Import session data
opencode import session.json

# View statistics
opencode stats
```

## CI/CD Integration

**Headless automation for CI/CD pipelines:**

**Basic CI/CD Pattern:**
```bash
#!/bin/bash
set -e

# Authenticate OpenCode (run once to set up credentials)
# opencode auth login

# Run OpenCode with a message
opencode run "Fix linting issues and add type hints"

# Check exit code
if [ $? -eq 0 ]; then
  echo "✅ OpenCode completed successfully"
else
  echo "❌ OpenCode failed"
  exit 1
fi
```

**GitHub Actions Example:**
```yaml
name: OpenCode Code Review

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

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install OpenCode CLI
        run: npm install -g open-code

      - name: Setup OpenCode Authentication
        run: |
          # Note: Authentication required - configure credentials before running
          # opencode auth login (must be done interactively beforehand)
          echo "Ensure OpenCode credentials are configured"

      - name: Run OpenCode Code Review
        id: opencode_review
        run: |
          REVIEW_OUTPUT=$(opencode run "Review this pull request for bugs, security issues, and best practices. Provide actionable feedback." 2>&1 || echo "Review completed")

          echo "review_output<<EOF" >> $GITHUB_OUTPUT
          echo "$REVIEW_OUTPUT" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Post Review Comment
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v7
        with:
          script: |
            const reviewOutput = `${{ steps.opencode_review.outputs.review_output }}`;

            if (reviewOutput && reviewOutput.trim() !== '' && reviewOutput !== 'Review completed') {
              await github.rest.issues.createComment({
                issue_number: context.issue.number,
                owner: context.repo.owner,
                repo: context.repo.repo,
                body: `## 🤖 Automated Code Review by OpenCode\n\n${reviewOutput}\n\n---\n*Generated by OpenCode CLI in CI/CD*`
              });
            }
```

**GitLab CI/CD:**
```yaml
stages:
  - review

opencode-review:
  stage: review
  image: node:20
  before_script:
    - npm install -g open-code
  script:
    - opencode run "Review code changes for issues and provide feedback"
  only:
    - merge_requests
```

**Best Practices for CI/CD:**
- Use `opencode run` for one-off command execution
- Use `opencode serve` for persistent server-based workflows
- Set up authentication with `opencode auth login` (required before CI/CD runs)
- Handle exit codes properly (non-zero indicates failure)
- Consider timeouts for long-running operations
- Use `--model` flag to specify which model to use
- Use `--continue` or `--session` for multi-step workflows

## Limitations

- **Authentication Required:** Must authenticate with `opencode auth login` before use
- **Provider Dependency:** Requires API key from supported providers (OpenCode Zen, Anthropic, OpenAI, etc.)
- **Context Limits:** Depends on selected LLM provider and model
- **TUI by Default:** Default mode is interactive TUI; use `opencode run` for headless execution
- **Session-Based:** Works best with session management for multi-step workflows

## References

- **OpenCode Documentation:** Check official OpenCode documentation for latest features
- **GitHub Repository:** Search for OpenCode repositories on GitHub
- **Community Forums:** Engage with OpenCode community for support and updates

**Note:** OpenCode is actively developed. Check the official documentation and GitHub repositories for the latest features, CLI commands, and integration options. CLI commands and syntax may vary based on the specific implementation.

