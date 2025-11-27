# 🚀 Google Gemini CLI

**Version tested:** Latest (check with `gemini --version`)  
**Risk level:** 🟠 Medium (can modify files, requires approval for some operations)

**Note:** Gemini 2.5 Flash/Pro typically support ~1M-token context in the CLI, though actual limits may vary slightly by API version or account tier. Some developer preview users may have access to up to ~2M tokens.

**When NOT to use Gemini:**
- ❌ You need extremely low cost (Gemini uses premium pricing for large contexts)
- ❌ You need ultra-low-latency (slower than smaller models for short prompts)
- ❌ You need GPT-style code generation (better for analysis than generation)
- ❌ You're working with small codebases (overkill for simple tasks)

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Gemini](#-why-use-gemini)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Headless Mode](#-headless-mode)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [Output Formats](#-output-formats)
- [Configuration](#-configuration)
- [Examples](#-examples)
- [CI/CD Integration](#-cicd-integration)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Google Gemini CLI is a command-line interface for Google's Gemini AI models, designed for massive context windows (up to ~1M tokens) and large-scale codebase analysis. It excels at repository-wide reviews, multi-file analysis, and handling extremely large codebases.

**Key Characteristics:**
- Massive context windows (1M+ tokens)
- Strong for large-scale codebases
- Headless mode for automation
- Structured output formats
- File operations and shell command support

## Installation

**Using npm:**
```bash
npm install -g @google/gemini-cli
```

**System Requirements:**
- Node.js 18 or later
- API key from Google AI Studio

## 🚀 Start Here

```bash
gemini -p "Summarize this repo"
```

## Headless Mode

**Non-interactive execution for automation, scripting, and CI/CD pipelines:**

```bash
# Direct prompt
gemini --prompt "Your prompt here"
# or shorthand
gemini -p "Your prompt here"

# Stdin input
echo "Explain this code" | gemini

# Combine with file input
cat README.md | gemini -p "Summarize this documentation"

# Combine with pipes
git diff | gemini -p "Review these changes"
```

**Exit codes:**
- `0` = Success
- Non-zero = Error

## Available Models

| Model | Context | Speed | Cost | Best For |
|-------|---------|-------|------|----------|
| **gemini-3.0-pro** | ~1M tokens | Medium | High | Most intelligent model, best for coding, agents, and complex reasoning (latest, Nov 2025) |
| **gemini-2.5-pro** | ~1M tokens | Medium | Medium-High | Massive repos, deep analysis, enhanced reasoning |
| **gemini-2.5-flash** | ~1M tokens | Fast | Low-Medium | Quick analysis, large context, general tasks |
| **gemini-1.5-pro** | ~1M tokens | Medium | Medium | Balanced performance for most use cases |
| **gemini-1.5-flash** | ~1M tokens | Fast | Low | Fast responses for simple tasks |
| **gemini-1.5-flash-lite** | ~1M tokens | Very Fast | Very Low | Simple tasks needing quick responses |

**Model Selection:**
```bash
# Use specific model
gemini -p "query" --model gemini-3.0-pro
gemini -p "query" --model gemini-2.5-pro
gemini -p "query" --model gemini-2.5-flash
gemini -p "query" --model gemini-1.5-pro
gemini -p "query" --model gemini-1.5-flash

# List available models
gemini models list

# Set default model via config
gemini config set model gemini-3.0-pro

# Get current model
gemini config get model
```

**Note:** Use `gemini models list` to see all available models. Configure default model with `gemini config set model <model-name>` for consistency.

## CLI Syntax

**Basic usage:**
```bash
gemini [options] -p "Your prompt"
```

**Common options:**
- `-p, --prompt TEXT`: Provide prompt directly (enables headless mode)
- `--model MODEL`: Specify model (latest: gemini-3.0-pro, previous: gemini-2.5-pro)
- `--output-format FORMAT`: Output format (`text`, `json`, `stream-json`)
- `--yolo`: Auto-approve all actions (use with caution)
- `--include-directories DIRS`: Include additional directories (comma-separated)
- `--debug`: Enable debug mode
- `gemini models list`: List all available models
- `gemini config set model MODEL`: Set default model
- `gemini config get model`: Get current default model
- `gemini config init`: Initialize configuration file

## Output Formats

**Text (default):**
```bash
gemini -p "What is the capital of France?"
```

**JSON (for automation):**
```bash
gemini -p "What is the capital of France?" --output-format json
```

Returns structured data:
```json
{
  "response": "The capital of France is Paris.",
  "stats": {
    "models": {
      "gemini-2.5-pro": {
        "api": { "totalRequests": 2, "totalErrors": 0 },
        "tokens": { "prompt": 24939, "candidates": 20, "total": 25113 }
      }
    },
    "tools": {
      "totalCalls": 1,
      "totalSuccess": 1
    },
    "files": {
      "totalLinesAdded": 0,
      "totalLinesRemoved": 0
    }
  }
}
```

**Streaming JSON (real-time events):**
```bash
gemini --output-format stream-json --prompt "Analyze this code"
```

Emits real-time events (init, message, tool_use, tool_result, error, result) as newline-delimited JSON.

## Configuration

**Environment Variables:**
```bash
export GEMINI_API_KEY=your_api_key
```

**Auto-approve actions:**
```bash
gemini -p "query" --yolo
```

**Include additional directories:**
```bash
gemini -p "query" --include-directories src,docs
```

**Debug mode:**
```bash
gemini -p "query" --debug
```

## Examples

**Code review:**
```bash
cat src/auth.py | gemini -p "Review this authentication code for security issues" > security-review.txt
```

**Generate commit messages:**
```bash
result=$(git diff --cached | gemini -p "Write a concise commit message for these changes" --output-format json)
echo "$result" | jq -r '.response'
```

**Batch code analysis:**
```bash
for file in src/*.py; do
    result=$(cat "$file" | gemini -p "Find potential bugs and suggest improvements" --output-format json)
    echo "$result" | jq -r '.response' > "reports/$(basename "$file").analysis"
done
```

**Log analysis:**
```bash
grep "ERROR" /var/log/app.log | tail -20 | gemini -p "Analyze these errors and suggest root cause and fixes" > error-analysis.txt
```

**Release notes generation:**
```bash
result=$(git log --oneline v1.0.0..HEAD | gemini -p "Generate release notes from these commits" --output-format json)
echo "$result" | jq -r '.response' >> CHANGELOG.md
```

## CI/CD Integration

**GitHub Actions workflow:**
```yaml
name: Gemini Code Review

on:
  pull_request:
    types: [opened, synchronize, reopened]

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

      - name: Install Gemini CLI
        run: npm install -g @google/gemini-cli

      - name: Run Gemini Code Review
        id: gemini_review
        env:
          GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
        run: |
          git diff origin/${{ github.base_ref }}...HEAD | \
            gemini -p "Review these code changes for bugs, security issues, and best practices. Provide actionable feedback." \
            --output-format json \
            --model gemini-3.0-pro \
            > gemini_review.json || exit 1
          
          if command -v jq &> /dev/null; then
            REVIEW=$(cat gemini_review.json | jq -r '.response // "Review completed"')
          else
            REVIEW=$(cat gemini_review.json | grep -o '"response":"[^"]*"' | cut -d'"' -f4 || echo "Review completed")
          fi
          
          echo "review_output<<EOF" >> $GITHUB_OUTPUT
          echo "$REVIEW" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Post Review Comment
        if: steps.gemini_review.outputs.review_output != ''
        uses: actions/github-script@v7
        with:
          script: |
            await github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## 🤖 Gemini Code Review\n\n${{ steps.gemini_review.outputs.review_output }}`
            });
```

**Direct CLI usage in CI/CD:**
```bash
#!/bin/bash
set -e

# Install Gemini CLI
npm install -g @google/gemini-cli

# Run with structured output
git diff origin/main...HEAD | \
  gemini -p "Review these changes" \
  --output-format json \
  --model gemini-2.5-pro \
  > review.json

# Error handling
if [ $? -eq 0 ]; then
  echo "✅ Review completed"
  # Parse results
  if command -v jq &> /dev/null; then
    jq -r '.response' review.json
  else
    grep -o '"response":"[^"]*"' review.json | cut -d'"' -f4
  fi
else
  echo "❌ Review failed"
  exit 1
fi
```

**Best practices for CI/CD:**
- Use `--output-format json` for structured, parseable output
- Handle exit codes properly (non-zero indicates failure)
- Use `--model` flag to specify model if needed
- Store API keys as secrets, never hardcode
- Use `--yolo` flag with caution (auto-approves actions)
- Consider using `gemini review` command for automated PR reviews
- Use `gemini models list` to verify available models
- Configure default model with `gemini config set model` for consistency

## Limitations

- Slower than smaller models for short prompts
- Higher token costs for large contexts
- JSON output includes extensive metadata (may require cleaning with jq)
- Context limits may vary by account tier (typically ~1M tokens, up to ~2M for preview users)
- Use `gemini models list` to see all available models
- Configure default model with `gemini config set model <model-name>` for consistency
- Use `gemini config get model` to check current default model

## References

- [Gemini CLI Docs – Google Developers](https://developers.google.com/gemini-code-assist/docs/gemini-cli)
- [Gemini CLI Headless Mode](https://geminicli.com/docs/cli/headless/)
- [Google AI Studio](https://aistudio.google.com/)

