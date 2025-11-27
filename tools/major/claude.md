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

Anthropic Claude (Claude Code) is a command-line AI coding assistant tuned for agentic coding, architecture, and reasoning. It starts an interactive session by default, with `-p/--print` mode for non-interactive output.

**Key Characteristics:**
- Interactive mode by default, headless mode with `-p/--print`
- Multiple model options (Haiku, Sonnet, Opus) with aliases
- Fine-grained tool control and permission modes
- Session management with resume and fork capabilities
- Structured output with JSON Schema validation
- Plugin system and MCP server support

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

# With tool permissions and bypass permissions for fully automated runs
claude -p "Stage my changes and write a set of commits for them" \
  --allowedTools "Bash,Read" \
  --permission-mode bypassPermissions

# Dangerous: Skip all permissions (for sandboxes only)
claude -p "Your prompt here" --dangerously-skip-permissions

# With structured JSON output
claude -p "Generate a user profile" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"name":{"type":"string"},"age":{"type":"number"}},"required":["name","age"]}'
```

**Key Flags:**
- `-p` or `--print`: Enables headless mode (non-interactive execution). Note: workspace trust dialog is skipped in -p mode.
- `--permission-mode bypassPermissions`: Bypass permission prompts for automation
- `--dangerously-skip-permissions`: Bypass ALL permission checks (sandbox only)
- `--output-format`: Specify output format (`text`, `json`, `stream-json`)
- `--json-schema`: JSON Schema for structured output validation

## Available Models

| Model | Full Model ID | Context | Speed | Cost | Best For |
|-------|---------------|---------|-------|------|----------|
| **claude-haiku-4.5** | `claude-haiku-4-5-20251001` | ~200K | Fast | Low | Quick tasks, budget-conscious |
| **claude-sonnet-4.5** | `claude-sonnet-4-5-20250929` | ~200K | Medium | Medium | Daily coding, balanced (default) |
| **claude-opus-4.5** | `claude-opus-4-5-20251101` | ~200K | Medium | Medium-High | Best for coding, agents, computer use |

**Model Selection:**
```bash
# Use model alias (recommended)
claude -p "query" --model sonnet
claude -p "query" --model opus
claude -p "query" --model haiku

# Use full model ID
claude -p "query" --model claude-opus-4-5-20251101
claude -p "query" --model claude-sonnet-4-5-20250929

# Use shortened version
claude -p "query" --model claude-opus-4.5

# With fallback model for overload scenarios
claude -p "query" --model opus --fallback-model sonnet

# Set default via environment variable
export ANTHROPIC_MODEL="claude-haiku-4-5-20251001"
claude -p "query"
```

## Effort Parameter (Beta)

**New in Claude Opus 4.5:** The effort parameter allows you to control how much "thinking budget" Claude spends on a request, giving you more control over cost versus performance tradeoffs.

**Usage:**
The effort parameter is available via the Anthropic API for Claude Opus 4.5. Check the latest [Claude API documentation](https://docs.anthropic.com/) for command-line flag support in Claude Code CLI.

**Benefits:**
- **Cost Control**: Adjust computational effort based on task complexity
- **Performance Tuning**: More effort for complex tasks, less for simple ones
- **Flexibility**: Fine-tune the cost/quality tradeoff per request

**Note:** This is a beta feature available for Claude Opus 4.5. Refer to official Anthropic documentation for the latest API parameters and CLI flag support.

## CLI Syntax

**Basic usage:**
```bash
# Interactive mode (default)
claude [options] [prompt]

# Non-interactive mode (headless)
claude [options] -p "Your prompt"
```

**Core Options:**

**Basic:**
- `-p, --print`: Print response and exit (headless mode). Note: workspace trust dialog is skipped.
- `-d, --debug [filter]`: Enable debug mode with optional category filtering (e.g., "api,hooks" or "!statsig,!file")
- `--verbose`: Override verbose mode setting from config
- `-v, --version`: Output version number
- `-h, --help`: Display help

**Output Control:**
- `--output-format <format>`: Output format (only with --print): "text" (default), "json", or "stream-json"
- `--json-schema <schema>`: JSON Schema for structured output validation
- `--include-partial-messages`: Include partial message chunks as they arrive (only with --print and stream-json)
- `--input-format <format>`: Input format (only with --print): "text" (default) or "stream-json"
- `--replay-user-messages`: Re-emit user messages from stdin on stdout (only with stream-json input/output)

**Permissions & Security:**
- `--permission-mode <mode>`: Permission mode: acceptEdits, bypassPermissions, default, dontAsk, plan
- `--dangerously-skip-permissions`: Bypass all permission checks (sandboxes only)
- `--allow-dangerously-skip-permissions`: Enable bypassing permissions as an option

**Tools:**
- `--allowedTools, --allowed-tools <tools...>`: Comma/space-separated list of allowed tools (e.g., "Bash(git:*) Edit")
- `--tools <tools...>`: Specify available tools from built-in set (only with --print). Use "" to disable all, "default" for all.
- `--disallowedTools, --disallowed-tools <tools...>`: Comma/space-separated list of denied tools

**Model & Settings:**
- `--model <model>`: Model alias (sonnet/opus/haiku) or full name (claude-sonnet-4-5-20250929)
- `--fallback-model <model>`: Enable automatic fallback when overloaded (only with --print)
- `--settings <file-or-json>`: Path to settings JSON file or JSON string
- `--setting-sources <sources>`: Comma-separated setting sources to load (user, project, local)

**Session Management:**
- `-c, --continue`: Continue most recent conversation
- `-r, --resume [sessionId]`: Resume conversation by session ID or select interactively
- `--fork-session`: Create new session ID when resuming (use with --resume or --continue)
- `--session-id <uuid>`: Use specific session ID (must be valid UUID)

**Customization:**
- `--system-prompt <prompt>`: System prompt for the session
- `--append-system-prompt <prompt>`: Append to default system prompt
- `--agents <json>`: JSON object defining custom agents
- `--mcp-config <configs...>`: Load MCP servers from JSON files or strings (space-separated)
- `--strict-mcp-config`: Only use MCP servers from --mcp-config
- `--plugin-dir <paths...>`: Load plugins from directories (repeatable)
- `--add-dir <directories...>`: Additional directories to allow tool access to
- `--ide`: Auto-connect to IDE on startup if available

**Commands:**
- `mcp`: Configure and manage MCP servers
- `plugin`: Manage Claude Code plugins
- `migrate-installer`: Migrate from global npm to local installation
- `setup-token`: Set up long-lived auth token (requires Claude subscription)
- `doctor`: Check health of auto-updater
- `update`: Check for and install updates
- `install [target]`: Install Claude Code native build (stable, latest, or specific version)

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

# Specify available tools (only with --print)
claude -p "query" --tools "Bash,Edit,Read"

# Disable all tools
claude -p "query" --tools ""
```

**Permission modes:**
```bash
# Accept edits without prompting
claude -p "query" --permission-mode acceptEdits

# Bypass all permissions (for automation)
claude -p "query" --permission-mode bypassPermissions

# Don't ask for permissions (let model proceed)
claude -p "query" --permission-mode dontAsk

# Plan mode (planning without execution)
claude -p "query" --permission-mode plan

# Dangerous: Skip all permissions (sandbox only)
claude -p "query" --dangerously-skip-permissions
```

**Session management:**
```bash
# Continue most recent conversation
claude --continue "Now refactor this for better performance"

# Resume specific conversation by session ID
claude --resume abc123 "Update the tests"

# Resume in headless mode with bypass permissions
claude -p --resume abc123 "Fix all linting issues" --permission-mode bypassPermissions

# Fork session when resuming (create new session ID)
claude -p --resume abc123 "Try alternative approach" --fork-session

# Use specific session ID
claude -p "Your prompt" --session-id "550e8400-e29b-41d4-a716-446655440000"
```

**MCP configuration:**
```bash
# Load MCP servers from JSON file
claude -p "query" --mcp-config servers.json

# Load multiple MCP configs
claude -p "query" --mcp-config config1.json config2.json

# Strict mode: only use MCP from --mcp-config
claude -p "query" --mcp-config servers.json --strict-mcp-config
```

**System prompt customization:**
```bash
# Append to default system prompt
claude -p "query" --append-system-prompt "You are an SRE expert. Diagnose issues and provide action items."

# Replace system prompt entirely
claude -p "query" --system-prompt "You are a security auditor. Focus on vulnerabilities."
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
            --permission-mode bypassPermissions \
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
# Parse JSON response with bypass permissions
result=$(claude -p "Generate code" --output-format json --permission-mode bypassPermissions)
code=$(echo "$result" | jq -r '.result')
cost=$(echo "$result" | jq -r '.total_cost_usd')
session_id=$(echo "$result" | jq -r '.session_id')

# Error handling
if [ $? -ne 0 ]; then
  echo "Claude command failed"
  exit 1
fi

# Structured output with JSON Schema
result=$(claude -p "Generate user profile" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"name":{"type":"string"},"age":{"type":"number"}},"required":["name"]}' \
  --permission-mode bypassPermissions)
```

**Best practices for CI/CD:**
- Use `--permission-mode bypassPermissions` to prevent prompts in automation
- Use `--output-format json` for structured output
- Pre-approve tools with `--allowedTools` to avoid approval prompts
- Use `--tools` to specify exactly which tools are available (only with --print)
- Use `--json-schema` for validated structured output
- Handle exit codes properly (non-zero indicates failure)
- Use `--add-dir` to specify additional directories for tool access
- Set appropriate timeout values for long-running operations
- Store API keys as secrets, never hardcode
- Consider `--fallback-model` for handling model overload scenarios

## Limitations

- Context limit smaller than Gemini (200K vs 1M tokens)
- Opus model may be slower/costlier; use Sonnet 4.5 for balanced performance
- Tool approval prompts can interrupt automation workflows (use `--permission-mode bypassPermissions` or pre-approve with `--allowedTools`)
- `-p/--print` mode automatically skips workspace trust dialog
- Model aliases (sonnet, opus, haiku) are supported; full model IDs can also be used for precision

## References

- [Anthropic Claude Models](https://docs.claude.ai)
- [Claude Code Headless Mode](https://code.claude.com/docs/en/headless.md)
- [Anthropic Console](https://console.anthropic.com/)

