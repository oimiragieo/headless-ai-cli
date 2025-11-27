# 🧩 Anthropic Claude (Claude Code)

**Version tested:** Latest (check with `claude --version`)  
**Risk level:** 🟢 Low (tool approval required, fine-grained control)

**When NOT to use Claude:**
- ❌ You need massive context windows (Gemini handles larger repos better)
- ❌ You need UI/front-end generation (Codex is better for this)
- ❌ You need completely automated runs without any approval (Droid is safer)
- ❌ You're working with large monorepos (context limits may be restrictive)

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Claude](#-why-use-claude)
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

Anthropic Claude (Claude Code) is a command-line AI coding assistant tuned for agentic coding, architecture, and reasoning. It provides fine-grained tool control, session management, and multiple model options for balanced performance and cost.

**Key Characteristics:**
- Tuned for agentic coding and reasoning
- Multiple model options (Haiku, Sonnet, Opus)
- Fine-grained tool control
- Session management
- Headless mode for automation

## Installation

**Using npm:**
```bash
npm install -g @anthropic-ai/claude-code
```

**System Requirements:**
- Node.js 18 or later
- API key from Anthropic

## 🚀 Start Here

```bash
claude -p "Explain this code"
```

## Headless Mode

**Non-interactive execution for automation, scripting, and CI/CD pipelines:**

```bash
# Direct prompt (non-interactive)
claude --print "Your prompt here"
# or shorthand
claude -p "Your prompt here"

# From stdin
echo "Explain this code" | claude -p

# Fully non-interactive (no prompts, no confirmations - ideal for CI/CD)
claude -p "Your prompt here" --no-interactive

# With tool permissions and non-interactive mode
claude -p "Stage my changes and write a set of commits for them" \
  --allowedTools "Bash,Read" \
  --permission-mode acceptEdits \
  --no-interactive
```

**Key Flags:**
- `-p` or `--print`: Enables headless mode (non-interactive execution)
- `--no-interactive`: Suppresses all prompts and confirmations (required for fully automated CI/CD)
- `--output-format`: Specify output format (`text`, `json`, `stream-json`)

## Available Models

| Model | Full Model ID | Context | Speed | Cost | Best For |
|-------|---------------|---------|-------|------|----------|
| **claude-haiku-4.5** | `claude-haiku-4-5-20251001` | ~200K | Fast | Low | Quick tasks, budget-conscious |
| **claude-sonnet-4.5** | `claude-sonnet-4-5-20250929` | ~200K | Medium | Medium | Daily coding, balanced (default) |
| **claude-opus-4.1** | `claude-opus-4-1-20250805` | ~200K | Slow | High | Deep reasoning, architecture |

**Model Selection:**
```bash
# Use full model ID
claude -p "query" --model claude-opus-4-1-20250805

# Use model alias (if supported)
claude -p "query" --model claude-opus-4.1

# Set default via environment variable
export ANTHROPIC_MODEL="claude-haiku-4-5-20251001"
claude -p "query"
```

## CLI Syntax

**Basic usage:**
```bash
claude [options] -p "Your prompt"
```

**Common options:**
- `-p, --print TEXT`: Provide prompt directly (enables headless mode)
- `--no-interactive`: Suppress all prompts and confirmations (required for CI/CD)
- `--model MODEL`: Specify model (e.g., `claude-sonnet-4-5-20250929` or `claude-sonnet-4.5`)
- `--output-format FORMAT`: Output format (`text`, `json`, `stream-json`)
- `--input-format FORMAT`: Input format for multi-turn conversations (`stream-json`)
- `--allowedTools TOOLS`: Allow specific tools (comma-separated)
- `--disallowedTools TOOLS`: Disallow specific tools (comma-separated)
- `--permission-mode MODE`: Permission mode (`acceptEdits`, etc.)
- `--continue`: Continue most recent conversation
- `--resume ID`: Resume specific conversation by session ID
- `--mcp-config FILE`: Load MCP servers from JSON file
- `--append-system-prompt TEXT`: Customize system prompt
- `--verbose`: Verbose logging

## Output Formats

**Text (default):**
```bash
claude -p "Explain file src/components/Header.tsx"
```

**JSON (for automation):**
```bash
claude -p "How does the data layer work?" --output-format json
```

Returns structured data:
```json
{
  "type": "result",
  "subtype": "success",
  "total_cost_usd": 0.003,
  "is_error": false,
  "duration_ms": 1234,
  "duration_api_ms": 800,
  "num_turns": 6,
  "result": "The response text here...",
  "session_id": "abc123"
}
```

**Streaming JSON (real-time events):**
```bash
claude -p "Build an application" --output-format stream-json
```

Streams each message as it is received, beginning with an `init` system message, followed by user and assistant messages, and ending with a `result` system message with stats.

## Configuration

**Tool control:**
```bash
# Allow specific tools
claude -p "query" --allowedTools "Bash,Read,WebSearch,mcp__filesystem"

# Disallow specific tools
claude -p "query" --disallowedTools "Bash(git commit),mcp__github"

# Permission mode
claude -p "query" --permission-mode acceptEdits
```

**Session management:**
```bash
# Continue most recent conversation
claude --continue "Now refactor this for better performance"

# Resume specific conversation by session ID
claude --resume abc123 "Update the tests"

# Resume in non-interactive mode (no prompts)
claude --resume abc123 "Fix all linting issues" --no-interactive

# Headless mode with session resume
claude -p --resume abc123 "Continue from previous session" --no-interactive
```

**MCP configuration:**
```bash
# Load MCP servers from JSON file
claude -p "query" --mcp-config servers.json
```

**System prompt customization:**
```bash
claude -p "query" --append-system-prompt "You are an SRE expert. Diagnose issues and provide action items."
```

## Examples

**SRE Incident Response:**
```bash
#!/bin/bash
investigate_incident() {
    local incident_description="$1"
    local severity="${2:-medium}"

    claude -p "Incident: $incident_description (Severity: $severity)" \
      --append-system-prompt "You are an SRE expert. Diagnose the issue, assess impact, and provide immediate action items." \
      --output-format json \
      --allowedTools "Bash,Read,WebSearch,mcp__datadog" \
      --mcp-config monitoring-tools.json
}

investigate_incident "Payment API returning 500 errors" "high"
```

**Automated Security Review:**
```bash
audit_pr() {
    local pr_number="$1"
    gh pr diff "$pr_number" | claude -p \
      --append-system-prompt "You are a security engineer. Review this PR for vulnerabilities, insecure patterns, and compliance issues." \
      --output-format json \
      --allowedTools "Read,Grep,WebSearch"
}

audit_pr 123 > security-report.json
```

**Multi-turn Legal Assistant:**
```bash
session_id=$(claude -p "Start legal review session" --output-format json | jq -r '.session_id')

claude -p --resume "$session_id" "Review contract.pdf for liability clauses"
claude -p --resume "$session_id" "Check compliance with GDPR requirements"
claude -p --resume "$session_id" "Generate executive summary of risks"
```

## CI/CD Integration

**GitHub Actions workflow:**
```yaml
name: Claude Code Review

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

      - name: Install Claude CLI
        run: npm install -g @anthropic-ai/claude-code

      - name: Run Claude Code Review
        id: claude_review
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          git diff origin/${{ github.base_ref }}...HEAD | \
            claude -p "Review these code changes for bugs, security issues, and best practices. Provide actionable feedback." \
            --output-format json \
            --no-interactive \
            --allowedTools "Read,Grep" \
            > claude_review.json || exit 1
          
          REVIEW=$(cat claude_review.json | jq -r '.result // "Review completed"')
          echo "review_output<<EOF" >> $GITHUB_OUTPUT
          echo "$REVIEW" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Post Review Comment
        if: steps.claude_review.outputs.review_output != ''
        uses: actions/github-script@v7
        with:
          script: |
            await github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## 🤖 Claude Code Review\n\n${{ steps.claude_review.outputs.review_output }}`
            });
```

**Direct CLI usage in CI/CD:**
```bash
# Parse JSON response
result=$(claude -p "Generate code" --output-format json --no-interactive)
code=$(echo "$result" | jq -r '.result')
cost=$(echo "$result" | jq -r '.total_cost_usd')
session_id=$(echo "$result" | jq -r '.session_id')

# Error handling
if [ $? -ne 0 ]; then
  echo "Claude command failed"
  exit 1
fi
```

**Best practices for CI/CD:**
- Always use `--no-interactive` to prevent prompts
- Use `--output-format json` for structured output
- Pre-approve tools with `--allowedTools` to avoid approval prompts
- Handle exit codes properly (non-zero indicates failure)
- Use `--cwd` to set working directory if needed
- Set appropriate timeout values for long-running operations
- Store API keys as secrets, never hardcode

## Working Directory Control

**Set working directory:**
```bash
claude -p "List files in directory" \
  --cwd /path/to/project \
  --allowedTools "Bash" \
  --no-interactive
```

This is essential when running Claude from different locations or in CI/CD pipelines where the working directory context matters for file operations and tool execution.

## Limitations

- Context limit smaller than Gemini (200K vs 1M tokens)
- Opus model may be slower/costlier; use Sonnet 4.5 for balanced performance
- Tool approval prompts can interrupt automation workflows (use `--allowedTools` to pre-approve)
- Requires `--no-interactive` flag for fully automated CI/CD runs
- Model aliases may not always be supported; prefer full model IDs for reliability

## References

- [Anthropic Claude Models](https://docs.claude.ai)
- [Claude Code Headless Mode](https://code.claude.com/docs/en/headless.md)
- [Anthropic Console](https://console.anthropic.com/)

