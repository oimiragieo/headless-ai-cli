# 🤖 RooCode

**Version tested:** Latest (check with `roocode --version` or via package manager)  
**Risk level:** 🟠 Medium (autonomous coding agent, can modify files and execute commands)

**When NOT to use RooCode:**
- ❌ You need massive context windows (Gemini handles larger repos better)
- ❌ You need pure local/offline workflows (requires MCP server setup)
- ❌ You're working in a non-Git repository (RooCode works best with Git)
- ❌ You need deterministic, production-safe CI/CD runs (Droid is safer)

### Quick Nav
- [Start Here](#-start-here)
- [Why Use RooCode](#-why-use-roocode)
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

RooCode is an autonomous coding agent that can read files, write and modify code, execute terminal commands, and interact with development environments using natural language. It uses the Model Context Protocol (MCP) server for headless operations and includes a Memory Bank feature for tracking project context and decisions.

**Key Characteristics:**
- Autonomous coding agents
- Model Context Protocol (MCP) server integration
- Memory Bank for project context tracking
- Natural language interaction
- File reading, writing, and code modification
- Terminal command execution
- Git integration

## Installation

**Using npm (if available):**
```bash
npm install -g roocode
```

**Using pip (if available):**
```bash
pip install roocode
```

**Using RooCode Workspace (recommended):**
```bash
# Clone the RooCode workspace template
git clone https://github.com/enescingoz/roocode-workspace.git
cd roocode-workspace

# Install dependencies
npm install
# or
pip install -r requirements.txt
```

**System Requirements:**
- Node.js or Python (depending on installation method)
- Git repository (for best experience)
- MCP server setup (for headless mode)
- API key for LLM provider (OpenAI, Anthropic, etc.)

## 🚀 Start Here

```bash
# Install RooCode
npm install -g roocode
# or
pip install roocode

# Set API key
export OPENAI_API_KEY=your_key
# or
export ANTHROPIC_API_KEY=your_key

# Start RooCode
roocode
```

## Headless Mode

**Non-interactive execution for automation, scripting, and CI/CD pipelines:**

**MCP Server Setup (Required for Headless Mode):**
```bash
# Install MCP server dependencies
npm install -g @modelcontextprotocol/server
# or
pip install mcp-server

# Configure MCP server
roocode mcp setup

# Start MCP server in background
roocode mcp start --daemon
```

**Basic Headless Usage:**
```bash
# Non-interactive mode with prompt
roocode --prompt "Review this code for bugs" --file src/main.py

# With multiple files
roocode --prompt "Refactor code" --files src/main.py src/utils.py

# Using stdin
echo "Add error handling" | roocode --file src/api.py

# Directory-based processing
roocode --prompt "Analyze codebase" --directory src/

# With output file
roocode --prompt "Generate documentation" --file src/api.py --output docs/api.md
```

**Headless Mode with MCP Server:**
```bash
# Ensure MCP server is running
roocode mcp status

# Run in headless mode
roocode --headless --prompt "Your task" --file src/main.py

# With MCP server connection
roocode --headless --mcp-server localhost:8080 --prompt "Your task"
```

**Memory Bank Integration (Headless):**
```bash
# Use Memory Bank context
roocode --prompt "Continue from previous context" --memory-bank .memory-bank

# Update Memory Bank
roocode --prompt "Update project context" --update-memory-bank
```

**Key Headless Flags:**
- `--prompt, -p TEXT`: Provide prompt directly (headless mode)
- `--file, -f FILE`: Include file in context
- `--files, -F FILES`: Include multiple files (space-separated)
- `--directory, -d DIR`: Include directory in context
- `--output, -o FILE`: Save output to file
- `--headless`: Enable headless mode
- `--mcp-server URL`: Specify MCP server URL
- `--memory-bank PATH`: Use Memory Bank directory

**Limitations:**
- Requires MCP server setup for full headless functionality
- Best used in Git repositories
- May require user confirmation for file edits (use `--yes` if available)

## Available Models

RooCode supports multiple LLM providers through MCP server:

| Provider | Models | Description |
|----------|--------|-------------|
| OpenAI | `gpt-4o`, `gpt-4o-mini`, `o1`, `o3-mini`, `gpt-3.5-turbo` | Default provider, excellent code generation |
| Anthropic | `claude-3.7-sonnet`, `claude-3-opus`, `claude-3.5-sonnet`, `claude-3-haiku` | Strong reasoning, excellent for refactoring |
| DeepSeek | `deepseek-r1`, `deepseek-chat`, `deepseek-v3` | Alternative with strong reasoning |
| Google | `gemini-pro`, `gemini-1.5-pro` | Alternative option |
| Local | Various via Ollama | Run models locally (requires Ollama setup) |

**Model Selection:**
```bash
# Use specific model
roocode --model gpt-4o --prompt "Your task"

# Use Anthropic Claude
roocode --model claude-3.7-sonnet --prompt "Your task"

# Configure default model via environment variable
export ROOCODE_MODEL=gpt-4o
roocode --prompt "Your task"
```

**Default Model:**
- If no model is specified, RooCode uses the default from your configuration or environment
- Set default via `ROOCODE_MODEL` environment variable or config file

## CLI Syntax

**Basic usage:**
```bash
roocode [options] [command]
```

**Common options:**
- `--prompt, -p TEXT`: Provide prompt directly (headless mode)
- `--file, -f FILE`: Include file in context
- `--files, -F FILES`: Include multiple files (space-separated)
- `--directory, -d DIR`: Include directory in context
- `--output, -o FILE`: Save output to file
- `--model, -m MODEL`: Specify LLM model
- `--headless`: Enable headless mode
- `--mcp-server URL`: Specify MCP server URL
- `--memory-bank PATH`: Use Memory Bank directory
- `--yes, -y`: Auto-accept all changes (if available)
- `--version`: Show version
- `--help`: Show help message

**MCP Server Commands:**
```bash
# Setup MCP server
roocode mcp setup

# Start MCP server
roocode mcp start

# Stop MCP server
roocode mcp stop

# Check MCP server status
roocode mcp status

# Start MCP server in background
roocode mcp start --daemon
```

**Memory Bank Commands:**
```bash
# Initialize Memory Bank
roocode memory-bank init

# Update Memory Bank
roocode memory-bank update

# View Memory Bank contents
roocode memory-bank view
```

## Configuration

**Environment Variables:**
```bash
export OPENAI_API_KEY=your_key
export ANTHROPIC_API_KEY=your_key
export ROOCODE_MODEL=gpt-4o
export ROOCODE_MCP_SERVER=localhost:8080
```

**Config file:**
- Location: `~/.roocode/config.json` or `.roocode/config.json` in project
- Format: JSON configuration

**Example config:**
```json
{
  "model": "gpt-4o",
  "mcp_server": "localhost:8080",
  "memory_bank_path": ".memory-bank",
  "auto_accept": false
}
```

**Memory Bank Structure:**
The Memory Bank directory typically contains:
- `activeContext.md`: Current project context
- `decisionLog.md`: Decision tracking
- `productContext.md`: Product requirements
- `progress.md`: Progress tracking
- `systemPatterns.md`: System patterns and conventions

## Examples

**Code Review (Headless):**
```bash
# Review code file
roocode --prompt "Review this code for bugs, security issues, and best practices" --file src/main.py

# Review multiple files
roocode --prompt "Review these changes for potential issues" --files src/main.py src/utils.py

# Review directory
roocode --prompt "Analyze codebase for security vulnerabilities" --directory src/
```

**Code Transformation (Headless):**
```bash
# Modernize legacy code
roocode --prompt "Convert this code to use async/await patterns" --file legacy.py

# Refactor codebase
roocode --prompt "Refactor to apply SOLID principles and improve maintainability" --directory src/

# Add error handling
roocode --prompt "Add comprehensive error handling and input validation" --file src/api.py
```

**Code Generation (Headless):**
```bash
# Generate unit tests
roocode --prompt "Generate comprehensive unit tests with 80%+ coverage" --file src/calculator.py --output tests/test_calculator.py

# Generate documentation
roocode --prompt "Generate API documentation following OpenAPI 3.0 specification" --file src/api.py --output docs/api.md

# Add type hints
roocode --prompt "Add type hints to all functions and classes" --file src/main.py
```

**Codebase Analysis (Headless):**
```bash
# Analyze entire codebase
roocode --prompt "Analyze codebase structure, identify technical debt, and suggest improvements" --directory . --output analysis.md

# Security audit
roocode --prompt "Perform security audit: identify vulnerabilities, insecure patterns, and suggest fixes" --directory src/
```

**With Memory Bank:**
```bash
# Use Memory Bank context
roocode --prompt "Continue development based on previous context" --memory-bank .memory-bank --file src/main.py

# Update Memory Bank with new decisions
roocode --prompt "Document architectural decision" --update-memory-bank
```

**Interactive Mode:**
```bash
# Start interactive session
roocode

# In RooCode prompt:
# > Review src/main.py for bugs
# > Generate tests for src/calculator.py
# > Refactor src/api.py to use async/await
# > exit
```

## CI/CD Integration

**Headless automation for CI/CD pipelines:**

**Basic CI/CD Pattern:**
```bash
#!/bin/bash
set -e

# Set API key
export OPENAI_API_KEY=$OPENAI_API_KEY
# or
export ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY

# Start MCP server
roocode mcp start --daemon

# Run RooCode in headless mode
roocode --headless --prompt "Fix linting issues and add type hints" --directory src/

# Check exit code
if [ $? -eq 0 ]; then
  echo "✅ RooCode completed successfully"
else
  echo "❌ RooCode failed"
  exit 1
fi
```

**GitHub Actions Example:**
```yaml
name: RooCode Code Review

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

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install RooCode
        run: |
          npm install -g roocode
          npm install -g @modelcontextprotocol/server

      - name: Setup MCP Server
        run: |
          roocode mcp setup
          roocode mcp start --daemon

      - name: Run RooCode Code Review
        id: roocode_review
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        run: |
          # Get changed files
          CHANGED_FILES=$(git diff --name-only origin/${{ github.base_ref }}...HEAD | grep -E '\.(py|js|ts|java)$' || true)
          
          if [ -z "$CHANGED_FILES" ]; then
            echo "No code files to review."
            echo "review_output=No code files to review." >> $GITHUB_OUTPUT
            echo "has_review=false" >> $GITHUB_OUTPUT
          else
            REVIEW_OUTPUT=$(roocode --headless --prompt "Review these code changes for potential bugs, security vulnerabilities, and adherence to best practices. Provide actionable suggestions." --files $CHANGED_FILES 2>&1 || echo "Review completed")
            
            echo "review_output<<EOF" >> $GITHUB_OUTPUT
            echo "$REVIEW_OUTPUT" >> $GITHUB_OUTPUT
            echo "EOF" >> $GITHUB_OUTPUT
            echo "has_review=true" >> $GITHUB_OUTPUT
          fi

      - name: Post Review Comment
        if: github.event_name == 'pull_request' && steps.roocode_review.outputs.has_review == 'true'
        uses: actions/github-script@v7
        with:
          script: |
            const reviewOutput = `${{ steps.roocode_review.outputs.review_output }}`;
            const prNumber = context.issue.number;
            const owner = context.repo.owner;
            const repo = context.repo.repo;

            if (reviewOutput && reviewOutput.trim() !== '' && reviewOutput !== 'Review completed') {
              const body = `## 🤖 Automated Code Review by RooCode\n\n${reviewOutput}\n\n---\n*Generated by RooCode in CI/CD*`;
              
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

roocode-review:
  stage: review
  image: node:20
  before_script:
    - npm install -g roocode @modelcontextprotocol/server
    - roocode mcp setup
    - roocode mcp start --daemon
  script:
    - roocode --headless --prompt "Review code changes for issues" --directory .
  only:
    - merge_requests
```

**Best Practices for CI/CD:**
- Always use `--headless` flag for non-interactive execution
- Set appropriate API keys as secrets
- Start MCP server before running RooCode commands
- Use `--output` flag to save results as artifacts
- Handle exit codes properly (non-zero indicates failure)
- Consider timeouts for long-running operations
- Use Memory Bank for context persistence across runs

## Limitations

- **MCP Server Required:** Full headless functionality requires MCP server setup
- **Git dependency:** Works best in Git repositories
- **Context limits:** Depends on selected LLM provider
- **File editing focus:** May require approval for changes
- **Memory Bank setup:** Requires initial configuration for context tracking

## References

- **RooCode Workspace:** [roocode-workspace](https://github.com/enescingoz/roocode-workspace)
- **Model Context Protocol:** [MCP Documentation](https://modelcontextprotocol.io/)
- **Automation Guide:** [Automating with RooCode and GitHub Copilot](https://www.tanyongsheng.com/blog/automating-a-data-science-project-with-roocode-and-github-copilot-step-by-step-guide/)

**Note:** RooCode is actively developed. Check the GitHub repository and documentation for the latest features, CLI commands, and integration options. CLI commands and syntax may vary based on the specific implementation.

