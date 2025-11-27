# 💻 Cursor Agent

**Version tested:** Latest (check with `cursor-agent --version`)  
**Risk level:** ⚠️ High (writes files with `--force`, strong for chained workflows)

**When NOT to use Cursor:**
- ❌ You need production-safe CI/CD runs (Droid is safer with read-only default)
- ❌ You need massive context windows (Gemini handles larger repos)
- ❌ You need deterministic, predictable output (delta messages can be verbose)
- ❌ You're working in untrusted environments (requires `--force` for file writes)

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Cursor](#-why-use-cursor)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Headless Mode](#-headless-mode)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [File Modification](#-file-modification)
- [Output Formats](#-output-formats)
- [Examples](#-examples)
- [CI/CD Integration](#-cicd-integration)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Cursor Agent is a command-line tool designed for workflow automation and multi-agent orchestration. It can chain tasks such as plan → code → test → deploy, and integrates well with VS Code and terminal pipelines.

**Key Characteristics:**
- Strong for workflow automation
- Headless mode for automation
- Can chain multiple tasks
- File modification control via `--force`
- Multiple output formats

## Installation

**Using curl:**
```bash
curl https://cursor.com/install -fsS | bash
```

**Set API key:**
```bash
export CURSOR_API_KEY=your_api_key_here
```

**System Requirements:**
- API key from Cursor
- Network connection

## 🚀 Start Here

```bash
cursor-agent -p "what does this file do?"
```

## Headless Mode

**Non-interactive execution for automation, scripting, and CI/CD pipelines:**

```bash
# Basic non-interactive mode (proposes changes, doesn't modify files)
cursor-agent -p "Your prompt here"

# Enable file modifications in scripts
🚨 cursor-agent -p --force "Refactor this code to use ES6+ syntax"

# Example (via WSL):
wsl bash -lc "cursor-agent -p 'Your prompt here'"
```

## Available Models

**View available models:**
- Use interactive mode and type `/model` to see all available models
- No CLI flag exists for listing models; use the interactive mode

```bash
# Interactive mode to see models
cursor-agent
# Then type: /model
```

**Available models (verified from CLI, November 2025):**

| Model Command | Full Name | Category | Description |
|---------------|-----------|----------|-------------|
| `composer-1` | Composer 1 | Cursor Native | Cursor's proprietary model |
| `auto` | Auto | Smart Selection | Free tier - automatically selects best model |
| `sonnet-4.5` | Claude 4.5 Sonnet | Claude | Balanced reasoning and speed |
| `sonnet-4.5-thinking` | Claude 4.5 Sonnet (Thinking) | Claude | Extended reasoning mode |
| `opus-4.5` | Claude 4.5 Opus | Claude | Best for complex tasks |
| `opus-4.5-thinking` | Claude 4.5 Opus (Thinking) | Claude | Extended reasoning mode |
| `opus-4.1` | Claude 4.1 Opus | Claude | Legacy Claude model |
| `gemini-3-pro` | Gemini 3 Pro | Google | Large context, latest Gemini |
| `gpt-5` | GPT-5 | OpenAI | Standard GPT-5 |
| `gpt-5.1` | GPT-5.1 | OpenAI | Latest GPT model |
| `gpt-5-high` | GPT-5 High | OpenAI | Extended reasoning |
| `gpt-5.1-high` | GPT-5.1 High | OpenAI | Latest with extended reasoning |
| `gpt-5-codex` | GPT-5 Codex | OpenAI Codex | Code generation focused |
| `gpt-5-codex-high` | GPT-5 Codex High | OpenAI Codex | Code generation + extended reasoning |
| `gpt-5.1-codex` | GPT-5.1 Codex | OpenAI Codex | Latest code generation |
| `gpt-5.1-codex-high` | GPT-5.1 Codex High | OpenAI Codex | Latest code + extended reasoning |
| `grok` | Grok | xAI | Grok AI model |

**Model selection examples:**
```bash
# Use specific model
cursor-agent -p --model gpt-5.1-high "Your prompt here"

# Use auto model (free tier - automatically selects best model)
cursor-agent -p --model auto "Your prompt here"

# Use Claude with extended reasoning
cursor-agent -p --model opus-4.5-thinking "Complex architectural decision"

# Use latest Codex for code generation
cursor-agent -p --model gpt-5.1-codex-high "Generate React component"

# Use Gemini for large context
cursor-agent -p --model gemini-3-pro "Analyze entire codebase"

# With file modifications
cursor-agent -p --force --model gpt-5.1 "Refactor this code"

# Interactive model selection
cursor-agent
# Then type: /model
# Select from list
```

**Notes:**
- **Auto model** is available in the free tier and automatically selects the best model for your task
- **Thinking/High models** provide extended reasoning at potentially higher cost
- Model availability may vary based on your Cursor subscription tier
- Use `/model` slash command in interactive mode to switch models dynamically

## CLI Syntax

**Basic usage:**
```bash
cursor-agent [options] -p "Your prompt"
```

**Common options:**
- `-p, --print TEXT`: Provide prompt directly (enables headless mode)
- `--force`: Enable file modifications (required for writes in scripts)
- `--output-format FORMAT`: Output format (`text`, `json`, `stream-json`)
- `--stream-partial-output`: Enable incremental character-by-character updates
- `--model MODEL`: Specify model (e.g., `gpt-5`, `auto`)
- `--list-models`: List all available models

## File Modification

**Default (proposes changes only):**
```bash
cursor-agent -p "Add JSDoc comments to this file"
# Won't modify files, only proposes changes
```

**Enable file modifications:**
```bash
🚨 cursor-agent -p --force "Refactor this code to use ES6+ syntax"
# Actually modifies files without confirmation
```

⚠️ **Warning:** `--force` enables direct file writes with no confirmation.

## Output Formats

**Text (default):**
```bash
cursor-agent -p "What does this codebase do?"
```
- Clean, final-answer-only responses

**JSON (structured analysis):**
```bash
cursor-agent -p --force --output-format json \
  "Review the recent code changes and provide feedback"
```
- Structured data for programmatic processing

**Streaming JSON (real-time progress):**
```bash
cursor-agent -p --force --output-format stream-json \
  "Analyze this project structure and create a summary report"
```
- Message-level progress tracking

**Streaming with partial output (incremental deltas):**
```bash
cursor-agent -p --force --output-format stream-json --stream-partial-output \
  "Analyze this project structure and create a summary report"
```
- Model-native incremental streaming
- Smooth progress updates character-by-character

## Examples

**Simple codebase question:**
```bash
#!/bin/bash
cursor-agent -p "What does this codebase do?"
```

**Automated code review:**
```bash
#!/bin/bash
cursor-agent -p --force --output-format text \
  "Review the recent code changes and provide feedback on:
  - Code quality and readability
  - Potential bugs or issues
  - Security considerations
  
  Provide specific suggestions for improvement and write to review.txt"
```

**Real-time progress tracking:**
```bash
cursor-agent -p --force --output-format stream-json --stream-partial-output \
  "Analyze this project structure and create a summary report" | \
  while IFS= read -r line; do
    type=$(echo "$line" | jq -r '.type // empty')
    # Process events...
  done
```

## CI/CD Integration

**GitHub Actions workflow:**
```yaml
name: Cursor Code Review

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

      - name: Install Cursor CLI
        run: |
          curl https://cursor.com/install -fsS | bash
          echo "$HOME/.local/bin" >> $GITHUB_PATH

      - name: Run Cursor Code Review
        id: cursor_review
        env:
          CURSOR_API_KEY: ${{ secrets.CURSOR_API_KEY }}
        run: |
          git diff origin/${{ github.base_ref }}...HEAD | \
            cursor-agent -p --force --output-format json \
            "Review these code changes for bugs, security issues, and best practices. Provide actionable feedback." \
            > cursor_review.json || exit 1
          
          REVIEW=$(cat cursor_review.json | jq -r '.result // "Review completed"')
          echo "review_output<<EOF" >> $GITHUB_OUTPUT
          echo "$REVIEW" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Post Review Comment
        if: steps.cursor_review.outputs.review_output != ''
        uses: actions/github-script@v7
        with:
          script: |
            await github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## 🤖 Cursor Agent Code Review\n\n${{ steps.cursor_review.outputs.review_output }}`
            });
```

**Direct CLI usage in CI/CD:**
```bash
#!/bin/bash
set -e

# Install Cursor CLI
curl https://cursor.com/install -fsS | bash
export PATH="$HOME/.local/bin:$PATH"

# Run with structured output
cursor-agent -p --force --output-format json \
  "Review code changes" > review.json

# Error handling
if [ $? -eq 0 ]; then
  echo "✅ Review completed"
  # Parse results
  jq -r '.result' review.json
else
  echo "❌ Review failed"
  exit 1
fi
```

**Best practices for CI/CD:**
- Always use `--force` when file modifications are needed
- Use `--output-format json` for structured, parseable output
- Handle exit codes properly (non-zero indicates failure)
- Implement timeouts for long-running operations (known issue: process may not release terminal)
- Use `--model` flag to specify model if needed
- Store API keys as secrets, never hardcode

## Limitations

- Best used in combination with Claude or Gemini for reasoning
- Use `--force` flag to enable file modifications in headless mode
- Without `--force`, changes are only proposed, not applied
- Streaming JSON parsing requires careful handling
- **Known issue:** Process may not release terminal upon completion; implement timeouts or process termination in scripts
- Model availability depends on subscription tier (use `--list-models` to check)
- The `auto` model is available in free tier, but specific models may require paid subscription

## References

- [Cursor Agent](https://cursor.com/)
- [Cursor CLI Headless Mode](https://cursor.com/docs/cli/headless)
- [Cursor Documentation](https://cursor.com/docs)

