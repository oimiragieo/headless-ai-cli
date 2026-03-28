# 🧩 Anthropic Claude (Claude Code)

**Version tested:** v2.1.86+ (check with `claude --version`)
**Risk level:** 🟢 Low (tool approval required, fine-grained control)

**When NOT to use Claude:**

- ❌ You need UI/front-end generation (Codex is better for this)
- ❌ You need completely automated runs without any approval (Droid is safer)
- ❌ You need the cheapest option for simple tasks (Haiku or other tools may be more cost-effective)

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
- [Hooks](#-hooks-automation-lifecycle)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Anthropic Claude (Claude Code) is a command-line AI coding assistant tuned for agentic coding, architecture, and reasoning. It starts an interactive session by default, with `-p/--print` mode for non-interactive output. The CLI is part of the **Agent SDK**, which also provides [Python](https://platform.claude.com/docs/en/agent-sdk/python) and [TypeScript](https://platform.claude.com/docs/en/agent-sdk/typescript) packages for full programmatic control with structured outputs, tool approval callbacks, and native message objects.

> **Note:** The `-p` CLI mode was previously called "headless mode." All CLI options work the same way — Anthropic now refers to this as the Agent SDK CLI.

**Key Characteristics:**

- Interactive mode by default, headless mode with `-p/--print` (Agent SDK CLI)
- Multiple model options (Haiku, Sonnet, Opus) with aliases
- Fine-grained tool control and permission modes
- Session management with resume and fork capabilities
- Structured output with JSON Schema validation
- Plugin system and MCP server support
- Voice mode with push-to-talk (`/voice`)
- Scheduled recurring tasks with `/loop`
- Batch file operations with `/batch` (conflict detection for overlapping edits)
- Computer Use for macOS (mouse, keyboard, browser automation)
- Agent Teams (experimental) for multi-agent collaboration with shared tasks
- Plugin system for extending Claude Code with custom commands, agents, hooks
- Auto Memory across sessions
- Git worktrees for isolated agent/session work (`-w/--worktree`)
- Channel relay (`--channels`) for remote tool approval via Telegram, Discord, iMessage

## Installation

**Native installer (recommended):**

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

**Using Homebrew:**

```bash
brew install claude-code
```

**Using npm (deprecated as of Feb 2026):**

```bash
npm install -g @anthropic-ai/claude-code
```

> **Note:** npm installation is deprecated. The native installer auto-updates in the background. Homebrew installs do NOT auto-update.

**System Requirements:**

- Node.js 18 or later (for npm install only)
- API key from Anthropic or Claude subscription

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
- `--bare`: Recommended for scripted/CI calls. Skips auto-discovery of hooks, skills, plugins, MCP servers, auto memory, and CLAUDE.md.
- `--permission-mode bypassPermissions`: Bypass permission prompts for automation
- `--dangerously-skip-permissions`: Bypass ALL permission checks (sandbox only)
- `--output-format`: Specify output format (`text`, `json`, `stream-json`)
- `--json-schema`: JSON Schema for structured output validation

> **Note:** User-invoked [skills](https://code.claude.com/docs/en/skills) (like `/commit`) and [built-in commands](https://code.claude.com/docs/en/commands) are only available in interactive mode. In `-p` mode, describe the task you want accomplished instead.

## Available Models

| Model                 | Full Model ID                | Context         | Speed  | Cost        | Best For                              |
| --------------------- | ---------------------------- | --------------- | ------ | ----------- | ------------------------------------- |
| **claude-haiku-4.5**  | `claude-haiku-4-5-20251001`  | ~200K           | Fast   | $1/$5 per M tokens  | Quick tasks, budget-conscious         |
| **claude-sonnet-4.6** | `claude-sonnet-4-6-20250514` | 1M (GA)         | Medium | $3/$15 per M tokens | Daily coding, balanced                |
| **claude-opus-4.6**   | `claude-opus-4-6-20250205`   | 1M (GA)         | Medium | $5/$25 per M tokens | Best for coding, agents, computer use (default) |

> **Note (March 2026):** Claude Opus 4.6 released Feb 5, 2026. Claude Sonnet 4.6 released Feb 17, 2026. Both support 1M context (GA as of March 13, 2026 — no surcharge). Opus 4.6 is now the default model in Claude Code with 64K max output tokens. The `/effort` command (v2.1.76) sets model effort across three levels. The "ultrathink" keyword enables maximum extended thinking. Claude Opus 4/4.1/4.5 and Sonnet 4.5 are still available but aliases (`sonnet`, `opus`) now map to 4.6 versions. Up to 90% savings with prompt caching, 50% with batch processing. Latest CLI version: v2.1.86 (March 27, 2026).

**Model Selection:**

```bash
# Use model alias (recommended)
claude -p "query" --model sonnet
claude -p "query" --model opus
claude -p "query" --model haiku

# Use full model ID
claude -p "query" --model claude-opus-4-6-20250205
claude -p "query" --model claude-sonnet-4-6-20250514

# Use shortened version
claude -p "query" --model claude-opus-4.6

# With fallback model for overload scenarios
claude -p "query" --model opus --fallback-model sonnet

# Set default via environment variable
export ANTHROPIC_MODEL="claude-haiku-4-5-20251001"
claude -p "query"
```

## Effort Parameter

**Available for Claude Opus 4.6:** The effort parameter controls how much "thinking budget" Claude spends on a request, giving you control over cost versus performance tradeoffs. Opus 4.6 defaults to medium effort.

**Usage:**

```bash
# In interactive mode, use the /effort command (v2.1.76+)
/effort           # View current effort level
/effort high      # Set to high effort
/effort low       # Set to low effort

# In prompts, use "ultrathink" keyword for maximum effort
claude -p "ultrathink: Analyze this complex architecture"
```

**Effort Levels (simplified in v2.1.76):**

| Level      | Description                        | Best For                          |
| ---------- | ---------------------------------- | --------------------------------- |
| **Low**    | Fast responses, lighter reasoning  | Simple tasks, quick iterations    |
| **Medium** | Balanced (default for Opus 4.6)    | Everyday coding tasks             |
| **High**   | Maximum reasoning depth            | Complex architecture, deep analysis |

**Benefits:**

- **Cost Control**: Adjust computational effort based on task complexity
- **Performance Tuning**: More effort for complex tasks, less for simple ones
- **Flexibility**: Fine-tune the cost/quality tradeoff per request

**Note:** Refer to official Anthropic documentation for the latest API parameters and CLI flag support.

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

- `--allowedTools, --allowed-tools <tools...>`: Comma/space-separated list of allowed tools using [permission rule syntax](https://code.claude.com/docs/en/settings#permission-rule-syntax). Supports prefix matching with trailing ` *` (e.g., `Bash(git diff *)` allows any command starting with `git diff`). **Important:** the space before `*` matters — `Bash(git diff*)` would also match `git diff-index`.
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

- `--system-prompt <prompt>`: System prompt for the session (fully replaces default)
- `--append-system-prompt <prompt>`: Append to default system prompt
- `--append-system-prompt-file <file>`: Append contents of a file to the default system prompt
- `--agents <json>`: JSON object defining custom agents
- `--mcp-config <configs...>`: Load MCP servers from JSON files or strings (space-separated)
- `--strict-mcp-config`: Only use MCP servers from --mcp-config
- `--plugin-dir <paths...>`: Load plugins from directories (repeatable)
- `--add-dir <directories...>`: Additional directories to allow tool access to
- `--ide`: Auto-connect to IDE on startup if available
- `--max-turns <n>`: Cap agentic turns (prevents runaway in CI/CD)
- `--bare`: Skip hooks, LSP, plugins, skill walks for lightweight scripted calls
- `-w, --worktree`: Start in an isolated git worktree
- `--agent <name>`: Run as a named subagent
- `--agents <json>`: Define ephemeral agent teams
- `-n, --name <name>`: Name the session at startup

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

When using `--json-schema`, the validated structured output is in the `structured_output` field (not `result`):

```bash
# Extract structured output with jq
claude -p "Extract function names from auth.py" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}' \
  | jq '.structured_output'
```

**Streaming JSON (real-time events):**

```bash
claude -p "Explain recursion" --output-format stream-json --verbose --include-partial-messages
```

Streams each message as it is received, beginning with an `init` system message, followed by user and assistant messages, and ending with a `result` system message with stats. Use `--verbose` and `--include-partial-messages` to receive tokens as they're generated.

Filter for streaming text deltas with jq:

```bash
claude -p "Write a poem" --output-format stream-json --verbose --include-partial-messages | \
  jq -rj 'select(.type == "stream_event" and .event.delta.type? == "text_delta") | .event.delta.text'
```

**API Retry Events:**

When an API request fails with a retryable error during streaming, Claude Code emits a `system/api_retry` event before retrying:

| Field            | Type            | Description                                          |
| ---------------- | --------------- | ---------------------------------------------------- |
| `type`           | `"system"`      | Message type                                         |
| `subtype`        | `"api_retry"`   | Identifies this as a retry event                     |
| `attempt`        | integer         | Current attempt number (starting at 1)               |
| `max_retries`    | integer         | Total retries permitted                              |
| `retry_delay_ms` | integer         | Milliseconds until next attempt                      |
| `error_status`   | integer or null | HTTP status code, or `null` for connection errors    |
| `error`          | string          | Error category (e.g., `rate_limit`, `server_error`, `authentication_failed`, `billing_error`, `invalid_request`, `max_output_tokens`, `unknown`) |

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

**Automated Commit from Staged Changes:**

```bash
claude -p "Look at my staged changes and create an appropriate commit" \
  --allowedTools "Bash(git diff *),Bash(git log *),Bash(git status *),Bash(git commit *)"
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

      - name: Install Claude CLI
        run: curl -fsSL https://claude.ai/install.sh | bash

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

## New Features (March 2026)

**Voice Mode (`/voice`):**

Push-to-talk voice interaction. Hold spacebar to speak, release to send. Supports 20+ languages. Activate with `/voice` in interactive mode. Rolling out progressively (~5% of Pro, Max, Team, Enterprise users).

**Scheduled Tasks (`/loop`):**

Run prompts or slash commands on a recurring interval, turning Claude Code into a background worker for PR reviews, deployment monitoring, and more.

```bash
# In interactive mode
/loop 5m /review     # Run /review every 5 minutes
/loop 10m            # Default 10-minute interval
```

**Batch File Operations (`/batch`):**

Operate on multiple files simultaneously with conflict detection if two tasks modify the same file.

**Computer Use:**

Claude Code can operate your Mac — moving the mouse, clicking buttons, browsing the web, and opening applications. No manual configuration required. Available for macOS (Pro/Max users, added March 23, 2026).

**Agent Teams (Experimental):**

Multi-agent collaboration with shared tasks, inter-agent messaging, and centralized management. Disabled by default; enable via `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` environment variable. Agents work in isolated git worktrees.

**Plugin System:**

Extend Claude Code with custom commands, agents, hooks, and MCP servers. Manage with `claude plugin` command.

**Channel Relay (`--channels`):**

Push events into a running Claude Code session from external sources. Channels are MCP server plugins (Telegram, Discord, iMessage) that can forward tool approval prompts to your phone for remote approval, or act as **webhook receivers** so CI failures, monitoring alerts, and deploy events reach Claude where it already has your files open. Requires claude.ai login (not API keys). Research preview as of v2.1.80.

```bash
claude --channels plugin:telegram@claude-plugins-official
```

**`--bare` Flag:**

For scripted `-p` calls. Skips hooks, LSP, plugin sync, skill directory walks, auto memory, CLAUDE.md, and MCP servers. Only flags you pass explicitly take effect — a hook in a teammate's `~/.claude` or an MCP server in the project's `.mcp.json` won't run. Requires `ANTHROPIC_API_KEY` or `apiKeyHelper` via `--settings`. OAuth/keychain auth disabled.

> **Note:** `--bare` is the recommended mode for scripted and SDK calls, and will become the default for `-p` in a future release.

```bash
claude -p "Quick analysis" --bare --permission-mode bypassPermissions
```

In bare mode, Claude has access to Bash, file read, and file edit tools. Pass any additional context you need with flags:

| To load                 | Use                                                     |
| ----------------------- | ------------------------------------------------------- |
| System prompt additions | `--append-system-prompt`, `--append-system-prompt-file` |
| Settings                | `--settings <file-or-json>`                             |
| MCP servers             | `--mcp-config <file-or-json>`                           |
| Custom agents           | `--agents <json>`                                       |
| A plugin directory      | `--plugin-dir <path>`                                   |

**Session Colors (`/color`):**

Set a color for the prompt bar of the current session, useful for visually distinguishing multiple parallel sessions.

```bash
/color blue    # Set session prompt bar to blue
```

**Auto Memory:**

Claude automatically records and recalls memories across sessions, building up context about your preferences and project.

## Hooks (Automation Lifecycle)

Hooks are user-defined shell commands (or HTTP endpoints, LLM prompts, or agent subprocesses) that execute at specific points in Claude Code's lifecycle. They provide **deterministic control** — ensuring certain actions always happen rather than relying on the LLM. Hooks are critical for CI/CD pipelines and automation workflows.

> **Important:** `PermissionRequest` hooks do **not** fire in non-interactive mode (`-p`). Use `PreToolUse` hooks for automated permission decisions in headless mode. Also note that `--bare` mode skips all hooks entirely.

**Hook Types:**

| Type        | Description                                              |
| ----------- | -------------------------------------------------------- |
| `command`   | Run a shell command (most common)                        |
| `http`      | POST event data to an HTTP endpoint                      |
| `prompt`    | Single-turn LLM evaluation (Haiku by default)            |
| `agent`     | Multi-turn verification subagent with tool access         |

**Key Hook Events for Automation:**

| Event               | When it fires                          | CI/CD Use Case                              |
| ------------------- | -------------------------------------- | ------------------------------------------- |
| `PreToolUse`        | Before a tool call executes (can block)| Block dangerous commands, enforce policies   |
| `PostToolUse`       | After a tool call succeeds             | Auto-format code, log commands               |
| `Stop`              | When Claude finishes responding        | Verify task completion, run tests            |
| `SessionStart`      | Session begins, resumes, or compacts   | Re-inject context after compaction           |
| `UserPromptSubmit`  | When a prompt is submitted             | Validate/transform input                     |
| `Notification`      | When Claude needs attention            | Desktop/webhook notifications                |

**Configuration (add to settings JSON):**

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "if": "Bash(git push *)",
            "command": "echo 'Blocked: no pushes in CI' >&2 && exit 2"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write"
          }
        ]
      }
    ]
  }
}
```

**Hook I/O:**

- **Input**: Event-specific JSON on stdin (includes `session_id`, `cwd`, `tool_name`, `tool_input`, etc.)
- **Exit 0**: Action proceeds. Stdout added to context for `SessionStart`/`UserPromptSubmit`.
- **Exit 2**: Action blocked. Stderr message fed back to Claude as feedback.
- **Structured JSON output**: Exit 0 with JSON for fine-grained control (e.g., `"permissionDecision": "deny"` with a reason).

**Matchers** filter hooks by tool name (regex): `"Bash"`, `"Edit|Write"`, `"mcp__github__.*"`. The `if` field (v2.1.85+) adds argument-level filtering using [permission rule syntax](https://code.claude.com/docs/en/permissions) (e.g., `"Bash(git *)"`).

**Settings locations:**

| Location                       | Scope          | Shareable |
| ------------------------------ | -------------- | --------- |
| `~/.claude/settings.json`      | All projects   | No        |
| `.claude/settings.json`        | Single project | Yes       |
| `.claude/settings.local.json`  | Single project | No        |
| Managed policy settings        | Organization   | Yes       |

See [Hooks Guide](https://code.claude.com/docs/en/hooks-guide) and [Hooks Reference](https://code.claude.com/docs/en/hooks) for full event schemas, async hooks, and MCP tool hooks.

## Limitations

- Context limit now matches Gemini at 1M (GA since March 13, 2026)
- Opus 4.6 max output: 64K tokens
- Opus model may be slower/costlier; use Sonnet 4.6 for balanced performance
- Tool approval prompts can interrupt automation workflows (use `--permission-mode bypassPermissions` or pre-approve with `--allowedTools`)
- `-p/--print` mode automatically skips workspace trust dialog
- Model aliases (sonnet, opus, haiku) are supported; full model IDs can also be used for precision
- npm installation deprecated (Feb 2026); use native installer or Homebrew instead

## References

- [Anthropic Claude Models](https://docs.claude.ai)
- [Claude Code Agent SDK CLI (Headless Mode)](https://code.claude.com/docs/en/headless.md)
- [Agent SDK Overview (Python/TypeScript)](https://platform.claude.com/docs/en/agent-sdk/overview)
- [CLI Reference (all flags)](https://code.claude.com/docs/en/cli-reference)
- [GitHub Actions Integration](https://code.claude.com/docs/en/github-actions)
- [GitLab CI/CD Integration](https://code.claude.com/docs/en/gitlab-ci-cd)
- [Hooks Guide](https://code.claude.com/docs/en/hooks-guide)
- [Hooks Reference](https://code.claude.com/docs/en/hooks)
- [Channels (Event Push)](https://code.claude.com/docs/en/channels)
- [Scheduled Tasks](https://code.claude.com/docs/en/scheduled-tasks)
- [Anthropic Console](https://console.anthropic.com/)
