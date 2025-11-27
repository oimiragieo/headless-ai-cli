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

**Using npm (if available):**
```bash
npm install -g opencode
```

**Using pip (if available):**
```bash
pip install opencode
```

**Using Homebrew (macOS, if available):**
```bash
brew install opencode
```

**System Requirements:**
- Node.js or Python (depending on installation method)
- Git repository (for best experience)
- API key for LLM provider (OpenAI, Anthropic, etc.)

## 🚀 Start Here

```bash
# Install OpenCode
npm install -g opencode
# or
pip install opencode

# Set API key
export OPENAI_API_KEY=your_key
# or
export ANTHROPIC_API_KEY=your_key

# Start OpenCode
opencode
```

## Headless Mode

**Non-interactive execution for automation, scripting, and CI/CD pipelines:**

**Basic Headless Usage:**
```bash
# Non-interactive mode with prompt
opencode --headless --prompt "Review this code for bugs" --file src/main.py

# With multiple files
opencode --headless --prompt "Refactor code" --files src/main.py src/utils.py

# Using stdin
echo "Add error handling" | opencode --headless --file src/api.py

# Directory-based processing
opencode --headless --prompt "Analyze codebase" --directory src/

# With output file
opencode --headless --prompt "Generate documentation" --file src/api.py --output docs/api.md
```

**Headless Mode with Config:**
```bash
# Use config file for headless mode
opencode --headless --config config.json --prompt "Your task"

# Headless mode with specific model
opencode --headless --model gpt-4o --prompt "Your task" --file src/main.py
```

**Key Headless Flags:**
- `--headless`: Enable headless mode (required for automation)
- `--prompt, -p TEXT`: Provide prompt directly
- `--file, -f FILE`: Include file in context
- `--files, -F FILES`: Include multiple files (space-separated)
- `--directory, -d DIR`: Include directory in context
- `--output, -o FILE`: Save output to file
- `--config FILE`: Use configuration file
- `--model, -m MODEL`: Specify LLM model

**Limitations:**
- Requires API key for LLM provider
- Best used in Git repositories
- May require user confirmation for file edits (use `--yes` if available)

## Available Models

OpenCode supports multiple LLM providers:

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
opencode --headless --model gpt-4o --prompt "Your task"

# Use Anthropic Claude
opencode --headless --model claude-3.7-sonnet --prompt "Your task"

# Configure default model via environment variable
export OPENCODE_MODEL=gpt-4o
opencode --headless --prompt "Your task"
```

**Default Model:**
- If no model is specified, OpenCode uses the default from your configuration or environment
- Set default via `OPENCODE_MODEL` environment variable or config file

## CLI Syntax

**Basic usage:**
```bash
opencode [options] [command]
```

**Common options:**
- `--headless`: Enable headless mode (required for automation)
- `--prompt, -p TEXT`: Provide prompt directly
- `--file, -f FILE`: Include file in context
- `--files, -F FILES`: Include multiple files (space-separated)
- `--directory, -d DIR`: Include directory in context
- `--output, -o FILE`: Save output to file
- `--model, -m MODEL`: Specify LLM model
- `--config FILE`: Use configuration file
- `--yes, -y`: Auto-accept all changes (if available)
- `--version`: Show version
- `--help`: Show help message

**Headless Mode Examples:**
```bash
# Basic headless chat
opencode --headless --prompt "Review this code for bugs"

# With file context
opencode --headless --prompt "Add error handling" --file src/main.py

# Multiple files
opencode --headless --prompt "Refactor code" --files src/main.py src/utils.py

# Directory-based
opencode --headless --prompt "Analyze codebase" --directory src/

# Save output
opencode --headless --prompt "Generate documentation" --file src/api.py --output docs/api.md
```

**Interactive Mode:**
```bash
# Start interactive session
opencode

# In OpenCode prompt:
# > Review src/main.py for bugs
# > Generate tests for src/calculator.py
# > Refactor src/api.py to use async/await
# > exit
```

## Configuration

**Environment Variables:**
```bash
export OPENAI_API_KEY=your_key
export ANTHROPIC_API_KEY=your_key
export OPENCODE_MODEL=gpt-4o
```

**Config file:**
- Location: `~/.opencode/config.json` or `.opencode/config.json` in project
- Format: JSON configuration

**Example config:**
```json
{
  "model": "gpt-4o",
  "auto_accept": false,
  "headless": true,
  "output_format": "text"
}
```

## Examples

**Code Review (Headless):**
```bash
# Review code file
opencode --headless --prompt "Review this code for bugs, security issues, and best practices" --file src/main.py

# Review multiple files
opencode --headless --prompt "Review these changes for potential issues" --files src/main.py src/utils.py

# Review directory
opencode --headless --prompt "Analyze codebase for security vulnerabilities" --directory src/
```

**Code Transformation (Headless):**
```bash
# Modernize legacy code
opencode --headless --prompt "Convert this code to use async/await patterns" --file legacy.py

# Refactor codebase
opencode --headless --prompt "Refactor to apply SOLID principles and improve maintainability" --directory src/

# Add error handling
opencode --headless --prompt "Add comprehensive error handling and input validation" --file src/api.py
```

**Code Generation (Headless):**
```bash
# Generate unit tests
opencode --headless --prompt "Generate comprehensive unit tests with 80%+ coverage" --file src/calculator.py --output tests/test_calculator.py

# Generate documentation
opencode --headless --prompt "Generate API documentation following OpenAPI 3.0 specification" --file src/api.py --output docs/api.md

# Add type hints
opencode --headless --prompt "Add type hints to all functions and classes" --file src/main.py
```

**Codebase Analysis (Headless):**
```bash
# Analyze entire codebase
opencode --headless --prompt "Analyze codebase structure, identify technical debt, and suggest improvements" --directory . --output analysis.md

# Security audit
opencode --headless --prompt "Perform security audit: identify vulnerabilities, insecure patterns, and suggest fixes" --directory src/
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

# Run OpenCode in headless mode
opencode --headless --prompt "Fix linting issues and add type hints" --directory src/

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
        with:
          fetch-depth: 0

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install OpenCode CLI
        run: |
          npm install -g opencode

      - name: Run OpenCode Code Review
        id: opencode_review
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
          # Alternative: use Anthropic
          # ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          # Get list of changed code files
          if [ "${{ github.event_name }}" == "pull_request" ]; then
            CHANGED_FILES=$(git diff --name-only origin/${{ github.base_ref }}...HEAD | grep -E '\.(py|js|ts|java|go|rs)$' || true)
          else
            CHANGED_FILES=$(git diff --name-only HEAD~1 HEAD | grep -E '\.(py|js|ts|java|go|rs)$' || true)
          fi

          if [ -z "$CHANGED_FILES" ]; then
            echo "No code files to review."
            echo "review_output=No code files to review." >> $GITHUB_OUTPUT
            echo "has_review=false" >> $GITHUB_OUTPUT
          else
            # Run review on changed files
            REVIEW_OUTPUT=$(opencode --headless --prompt "Review these code changes for potential bugs, security vulnerabilities, and adherence to best practices. Provide actionable suggestions for improvement. Focus on: code quality, performance, security, and maintainability." --files $CHANGED_FILES 2>&1 || echo "Review completed")
            
            echo "review_output<<EOF" >> $GITHUB_OUTPUT
            echo "$REVIEW_OUTPUT" >> $GITHUB_OUTPUT
            echo "EOF" >> $GITHUB_OUTPUT
            echo "has_review=true" >> $GITHUB_OUTPUT
          fi

      - name: Post Review Comment
        if: github.event_name == 'pull_request' && steps.opencode_review.outputs.has_review == 'true'
        uses: actions/github-script@v7
        with:
          script: |
            const reviewOutput = `${{ steps.opencode_review.outputs.review_output }}`;
            const prNumber = context.issue.number;
            const owner = context.repo.owner;
            const repo = context.repo.repo;

            if (reviewOutput && reviewOutput.trim() !== '' && reviewOutput !== 'Review completed') {
              const body = `## 🤖 Automated Code Review by OpenCode\n\n${reviewOutput}\n\n---\n*Generated by OpenCode CLI in CI/CD*`;
              
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

opencode-review:
  stage: review
  image: node:20
  before_script:
    - npm install -g opencode
  script:
    - opencode --headless --prompt "Review code changes for issues" --directory .
  only:
    - merge_requests
```

**Best Practices for CI/CD:**
- Always use `--headless` flag for non-interactive execution
- Set appropriate API keys as secrets
- Use `--output` flag to save results as artifacts
- Handle exit codes properly (non-zero indicates failure)
- Consider timeouts for long-running operations
- Use specific file paths rather than directories when possible

## Limitations

- **API dependency:** Requires API key for LLM provider
- **Git dependency:** Works best in Git repositories
- **Context limits:** Depends on selected LLM provider
- **File editing focus:** May require approval for changes

## References

- **OpenCode Documentation:** Check official OpenCode documentation for latest features
- **GitHub Repository:** Search for OpenCode repositories on GitHub
- **Community Forums:** Engage with OpenCode community for support and updates

**Note:** OpenCode is actively developed. Check the official documentation and GitHub repositories for the latest features, CLI commands, and integration options. CLI commands and syntax may vary based on the specific implementation.

