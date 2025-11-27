# 🧠 OpenAI Codex

**Version tested:** Latest (check with `codex --version`)  
**Risk level:** 🟠 Medium (sandbox modes differ, read-only default)

**Note:** This is the 2025 OpenAI Codex CLI tool, not the original 2021 Codex model. The CLI provides programmatic access to OpenAI's latest code generation models (GPT-5 Codex, etc.).

**When NOT to use Codex:**
- ❌ You need deep reasoning for complex architecture (Claude Opus is better)
- ❌ You need massive context windows (Gemini handles larger repos)
- ❌ You're not in a Git repository (requires Git repo by default, unless you override)
- ❌ You need deterministic, production-safe CI/CD runs (Droid is safer)

**Git repository requirement:** The Codex CLI assumes the workspace is a Git repository because many of its built-in capabilities rely on diff analysis and file tracking. Use `--skip-git-repo-check` to override this requirement.

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Codex](#-why-use-codex)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Headless Mode](#-headless-mode)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [Permission Modes](#-permission-modes)
- [Output Control](#-output-control)
- [Examples](#-examples)
- [CI/CD Integration](#-cicd-integration)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

OpenAI Codex is a command-line coding agent designed for UI generation, rapid prototyping, and planning tasks. It converts natural language into working code and provides both interactive and non-interactive modes for different workflows.

**Key Characteristics:**
- Interactive and non-interactive modes
- Strong for UI generation and prototyping
- Structured output with JSON Schema support
- Sandbox modes for safety (read-only, workspace-write, danger-full-access)
- TypeScript SDK available for programmatic control
- GitHub Actions integration with `openai/codex-action@v1`
- Autofix CI: Automatically fix CI failures and open PRs
- MCP (Model Context Protocol) integration support
- Experimental plan tracking for complex multi-step tasks

**Two Modes:**
1. **Interactive Mode** (default): `codex [OPTIONS] [PROMPT]`
2. **Non-Interactive Mode** (for automation): `codex exec [OPTIONS] [PROMPT]`

## Installation

**Using npm:**
```bash
npm install -g @openai/codex
```

**System Requirements:**
- Node.js 18 or later
- Git repository (by default, can be overridden with `--skip-git-repo-check`)
- API key from OpenAI

**Authentication:**
Set your OpenAI API key as an environment variable:
```bash
export OPENAI_API_KEY=your_api_key_here
codex exec "query"
```

Or use it inline for a single command:
```bash
OPENAI_API_KEY=your_api_key_here codex exec "query"
```

**For `codex exec` only:** You can also use `CODEX_API_KEY` to override credentials for a single run:
```bash
CODEX_API_KEY=your-api-key codex exec --json "triage open bug reports"
```

**Note:** `CODEX_API_KEY` is only supported in `codex exec`, not in other Codex commands. The standard `OPENAI_API_KEY` works for all Codex operations.

## 🚀 Start Here

**Interactive mode (default):**
```bash
codex
```

**Interactive mode with initial prompt:**
```bash
codex "generate a unit test"
```

**Non-interactive mode (for automation):**
```bash
codex exec "generate a unit test"
```

## Interactive Mode

**Start interactive session:**
```bash
# Start interactive mode (default)
codex

# Start with initial prompt
codex "Build a React component for user profile"

# Resume previous session (picker by default)
codex resume

# Resume most recent session
codex resume --last

# Use specific model
codex --model gpt-5.1-codex-high "Create a dashboard"

# With image attachments
codex -i screenshot.png "Recreate this UI"

# Full-auto mode (low-friction sandboxed automatic execution)
codex --full-auto "Refactor this module"

# With web search enabled
codex --search "Find best practices for React hooks"
```

**Interactive mode options:**
- `[PROMPT]` - Optional initial prompt to start the session
- `-m, --model <MODEL>` - Model to use (e.g., `gpt-5.1-codex-high`)
- `-i, --image <FILE>...` - Attach image(s) to initial prompt
- `--full-auto` - Low-friction sandboxed automatic execution
- `--search` - Enable web search
- `-C, --cd <DIR>` - Set working directory
- `-s, --sandbox <MODE>` - Sandbox policy (read-only, workspace-write, danger-full-access)
- `-a, --ask-for-approval <POLICY>` - Approval policy (untrusted, on-failure, on-request, never)

## Non-Interactive Mode (Headless)

**Non-interactive execution for CI/CD pipelines and automation:**

Headless mode is the default behavior of `codex exec`. It processes a single user prompt, executes all required actions automatically (subject to sandbox policies), and exits upon completion.

```bash
# Basic execution (read-only by default)
codex exec "Your prompt here"

# Allow file edits
codex exec --full-auto "Your prompt here"

# Allow edits and networked commands
codex exec --sandbox danger-full-access "Your prompt here"

# Set working directory
codex exec --cd /path/to/project "analyze this codebase"

# Pipe output to file
codex exec "generate release notes" | tee release-notes.md

# Non-interactive with JSON output (ideal for CI/CD)
codex exec --json --color never "review code changes" > review.jsonl
```

## Available Models

| Model | Description | Speed | Cost | Best For |
|-------|-------------|-------|------|----------|
| **gpt-5.1-codex-max** | Latest Codex-optimized flagship for deep and fast reasoning (current) | Fast | High | Complex code generation, deep reasoning |
| **gpt-5.1-codex** | Standard Codex model | Medium | Medium | UI generation, prototyping, general coding |
| **gpt-5.1-codex-mini** | Cheaper, faster, less capable | Very Fast | Low | Simple tasks, quick prototypes |
| **gpt-5.1** | Broad world knowledge with strong general reasoning | Medium | Medium-High | Non-coding tasks, general reasoning |

**Model Selection:**
```bash
# Use latest flagship (recommended)
codex exec "query" --model gpt-5.1-codex-max

# Use standard Codex
codex exec "query" --model gpt-5.1-codex

# Use mini for faster/cheaper
codex exec "query" --model gpt-5.1-codex-mini

# Short form
codex exec -m gpt-5.1-codex-max "query"

# Model with other flags
codex exec --model gpt-5.1-codex-max --json --color never "query"
```

**Note:** `gpt-5.1-codex-max` is the current default and recommended for most coding tasks. Use `-m <model_name>` to access legacy models or specific model versions.

## Reasoning Level (Effort Parameter)

Codex supports configurable reasoning depth for models like `gpt-5.1-codex-max`. This controls how much computational effort the model spends on reasoning.

| Level | Description | Speed | Best For |
|-------|-------------|-------|----------|
| **Low** | Fast responses with lighter reasoning | Very Fast | Simple tasks, quick iterations |
| **Medium** | Balances speed and reasoning depth (default) | Fast | Everyday coding tasks |
| **High** | Maximizes reasoning depth | Slower | Complex problems, deep analysis |
| **Extra high** | Extra high reasoning depth | Slowest | Most complex architectural decisions |

**Setting Reasoning Level:**

The reasoning level is typically set interactively during model selection in the Codex CLI. For programmatic use, reasoning levels may be configured via:
- Interactive CLI prompts when selecting models
- Configuration files (`config.toml`)
- Command-line flags (if supported - check `codex --help` for latest options)

**Example usage:**
```bash
# Interactive: CLI will prompt for reasoning level after model selection
codex exec "Your prompt here"

# The CLI presents options:
# 1. Low - Fast responses with lighter reasoning
# 2. Medium (default) - Balances speed and reasoning depth
# 3. High - Maximizes reasoning depth for complex problems
# 4. Extra high - Extra high reasoning depth
```

**When to adjust reasoning level:**
- **Low**: Rapid prototyping, simple code generation
- **Medium**: Standard development tasks, most use cases
- **High**: Complex refactoring, architectural decisions, debugging hard problems
- **Extra high**: Critical systems, deep optimization, complex algorithms

## CLI Syntax

**Basic usage:**
```bash
# Interactive mode
codex [OPTIONS] [PROMPT]

# Non-interactive mode
codex exec [OPTIONS] [PROMPT]
```

**Commands:**
- `exec` (alias: `e`) - Run Codex non-interactively
- `login` - Manage login
- `logout` - Remove stored authentication credentials
- `mcp` - [experimental] Run Codex as MCP server and manage MCP servers
- `mcp-server` - [experimental] Run Codex MCP server (stdio transport)
- `app-server` - [experimental] Run app server or related tooling
- `completion` - Generate shell completion scripts
- `sandbox` (alias: `debug`) - Run commands within Codex-provided sandbox
- `apply` (alias: `a`) - Apply latest diff as `git apply` to local working tree
- `resume` - Resume previous interactive session (picker by default; use `--last` for most recent)
- `cloud` - [EXPERIMENTAL] Browse tasks from Codex Cloud and apply changes locally
- `features` - Inspect feature flags

**Common options:**
- `[PROMPT]` - Optional user prompt to start the session
- `-m, --model <MODEL>` - Model the agent should use
- `-i, --image <FILE>...` - Optional image(s) to attach to initial prompt
- `-s, --sandbox <MODE>` - Sandbox policy (read-only, workspace-write, danger-full-access)
- `-a, --ask-for-approval <POLICY>` - When model requires human approval (untrusted, on-failure, on-request, never)
- `-C, --cd <DIR>` - Tell agent to use specified directory as working root
- `-c, --config <key=value>` - Override configuration value from `~/.codex/config.toml`
- `-p, --profile <CONFIG_PROFILE>` - Configuration profile from config.toml
- `--enable <FEATURE>` - Enable a feature (repeatable)
- `--disable <FEATURE>` - Disable a feature (repeatable)
- `--full-auto` - Low-friction sandboxed automatic execution (-a on-request, --sandbox workspace-write)
- `--dangerously-bypass-approvals-and-sandbox` - Skip all confirmations (EXTREMELY DANGEROUS)
- `--search` - Enable web search (off by default)
- `--add-dir <DIR>` - Additional directories that should be writable
- `--oss` - Use local open source model provider (verifies LM Studio or Ollama server)
- `--local-provider <OSS_PROVIDER>` - Specify local provider (lmstudio or ollama)

**Approval policies (`-a, --ask-for-approval`):**
- `untrusted` - Only run "trusted" commands without approval (ls, cat, sed, etc.)
- `on-failure` - Run all commands without approval; only ask if command fails
- `on-request` - Model decides when to ask for approval
- `never` - Never ask for approval; execution failures returned to model

**Sandbox modes (`-s, --sandbox`):**
- `read-only` - Read-only sandbox (default), no file modifications
- `workspace-write` - Allow file creation/editing within workspace
- `danger-full-access` - Full file system access (DANGEROUS)

## Permission Modes (Sandbox Policies)

**Default (read-only):**
```bash
codex exec "find any remaining TODOs and create plans"
```
- Read-only sandbox (default)
- No file modifications
- No networked commands
- Safe for analysis and planning tasks

**Workspace-write (allow file edits):**
```bash
# Using --full-auto flag (shorthand for workspace-write)
codex exec --full-auto "Refactor authentication module"

# Or explicitly specify sandbox mode
codex exec --sandbox workspace-write "Update configuration files"
```
- Allows file creation and editing within workspace
- No system modifications
- No network access
- Suitable for code refactoring and file updates

**Danger-full-access (full permissions):**
```bash
codex exec --sandbox danger-full-access "Install dependencies and update config"
```
- Full file system access
- Network access enabled
- Can install packages and run commands
- ⚠️ **Use with caution** - only in trusted environments

## Output Control

**Default (final message to stdout):**
```bash
codex exec "generate release notes" | tee release-notes.md
```
- Streams activity to stderr
- Final agent message to stdout
- Easy to pipe into other tools

**Save to file:**
```bash
codex exec -o output.md "analyze codebase"
# or
codex exec --output-last-message output.md "analyze codebase"
```

**JSON streaming (all events):**
```bash
codex exec --json "summarize the repo structure" | jq
```

**Color output control:**
```bash
# Always use colors
codex exec --color always "analyze code"

# Never use colors (useful for CI/CD)
codex exec --color never "generate report"

# Auto-detect based on terminal
codex exec --color auto "review changes"
```

**JSON Event Types:**
When using `--json`, events are emitted as JSONL (newline-delimited JSON). Event types include:
- `thread.started`: Thread initialization
- `turn.started`: Turn begins
- `turn.completed`: Turn successfully completed
- `turn.failed`: Turn failed with error
- `item.started`: Item processing begins
- `item.completed`: Item processing completed
- `item.*` types:
  - `agent_message`: Agent text responses
  - `reasoning`: Agent reasoning steps
  - `command_execution`: Shell command execution
  - `file_change`: File modifications
  - `mcp_tool_call`: MCP (Model Context Protocol) tool calls
  - `web_search`: Web search results
  - `plan_update`: Plan tracking updates (with `--include-plan-tool`)
- `error`: Error events

## Structured Output

Use JSON Schema to receive structured JSON output. This ensures the final agent message conforms to your specified schema, making it perfect for automation and CI/CD pipelines.

**schema.json:**
```json
{
  "type": "object",
  "properties": {
    "project_name": { "type": "string" },
    "programming_languages": {
      "type": "array",
      "items": { "type": "string" }
    },
    "dependencies": {
      "type": "array",
      "items": { "type": "string" }
    }
  },
  "required": ["project_name", "programming_languages"],
  "additionalProperties": false
}
```

**Usage:**
```bash
codex exec "Extract project metadata" \
  --output-schema ./schema.json \
  -o ./project-metadata.json
```

The output file will contain JSON that strictly conforms to your schema, making it easy to parse programmatically.

## Session Management

Codex maintains session state, allowing you to continue conversations across multiple commands.

**Resume last session:**
```bash
codex exec "Review the change for race conditions"
codex exec resume --last "Fix the race conditions you found"
```

**Resume specific session:**
```bash
codex exec resume <SESSION_ID> "Continue from where we left off"
```

**Session ID extraction:**
When using `--json` output, session IDs are included in the thread events:
```bash
codex exec --json "analyze code" | jq -r 'select(.type=="thread.started") | .thread_id'
```

## TypeScript SDK

**Install SDK:**
```bash
npm install @openai/codex-sdk
```

**Usage:**
```typescript
import { Codex } from "@openai/codex-sdk";

const codex = new Codex();
const thread = codex.startThread();
const result = await thread.run("Make a plan to diagnose and fix the CI failures");

// Continue on same thread
const result2 = await thread.run("Execute the plan");
```

## Examples

**Automated code review:**
```bash
codex exec --json "Review PR changes for bugs and security issues" | \
  jq -r 'select(.type=="item.completed" and .item.type=="agent_message") | .item.text'
```

**Structured metadata extraction:**
```bash
codex exec "Extract project metadata" \
  --output-schema ./schema.json \
  -o ./project-metadata.json
```

**Multi-step task with session:**
```bash
codex exec "Analyze codebase structure"
codex exec resume --last "Generate migration plan"
codex exec resume --last "Create execution checklist"
```

**Batch processing with working directory:**
```bash
codex exec --cd /path/to/project --full-auto "Refactor all TypeScript files to use ES6+ syntax"
```

**CI/CD-friendly execution:**
```bash
codex exec --json --color never --full-auto "Run tests and fix any failures" > ci-output.jsonl
```

**Using experimental plan tracking:**
```bash
codex exec --include-plan-tool --json "Plan and execute a major refactoring" | \
  jq 'select(.type=="item.completed" and .item.type=="plan_update")'
```

## CI/CD Integration

**GitHub Action (using official action):**
```yaml
name: Codex pull request review
on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  codex:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    outputs:
      final_message: ${{ steps.run_codex.outputs.final-message }}
    steps:
      - uses: actions/checkout@v5
        with:
          ref: refs/pull/${{ github.event.pull_request.number }}/merge
      
      - name: Pre-fetch base and head refs
        run: |
          git fetch --no-tags origin \
            ${{ github.event.pull_request.base.ref }} \
            +refs/pull/${{ github.event.pull_request.number }}/head
      
      - name: Run Codex
        id: run_codex
        uses: openai/codex-action@v1
        with:
          openai-api-key: ${{ secrets.OPENAI_API_KEY }}
          prompt-file: .github/codex/prompts/review.md
          output-file: codex-output.md
          safety-strategy: drop-sudo
          sandbox: workspace-write
          codex-args: '["--json", "--color", "never"]'
      
      - name: Post Codex feedback
        if: steps.run_codex.outputs.final_message != ''
        uses: actions/github-script@v7
        with:
          script: |
            await github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: context.payload.pull_request.number,
              body: process.env.CODEX_FINAL_MESSAGE,
            });
          env:
            CODEX_FINAL_MESSAGE: ${{ steps.run_codex.outputs.final_message }}
```

**Autofix CI pattern:**
Codex can automatically fix CI failures and open pull requests with patches:
```yaml
name: Autofix CI
on:
  workflow_run:
    workflows: ["CI"]
    types:
      - completed

jobs:
  autofix:
    if: ${{ github.event.workflow_run.conclusion == 'failure' }}
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v5
        with:
          ref: ${{ github.event.workflow_run.head_branch }}
      
      - name: Run Codex Autofix
        uses: openai/codex-action@v1
        with:
          openai-api-key: ${{ secrets.OPENAI_API_KEY }}
          prompt: "Diagnose and fix the CI failures. Create a minimal patch."
          sandbox: workspace-write
          safety-strategy: drop-sudo
          codex-args: '["--full-auto", "--json", "--color", "never"]'
```

**Direct CLI usage in CI/CD:**
```yaml
- name: Install Codex CLI
  run: npm install -g @openai/codex

- name: Run Codex Review
  env:
    OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
  run: |
    codex exec --json --color never --full-auto \
      "Review code changes for bugs and security issues" \
      > codex-review.jsonl || exit 1
    
    # Parse results
    jq -r 'select(.type=="item.completed" and .item.type=="agent_message") | .item.text' \
      codex-review.jsonl > review-summary.txt
```

**Key CI/CD considerations:**
- Use `--color never` for clean log output
- Use `--json` for structured, parseable output
- Set appropriate sandbox modes based on trust level
- Handle exit codes properly (Codex returns non-zero on errors)
- Consider using `--output-schema` for consistent output format
- Use `safety-strategy: drop-sudo` in GitHub Actions for security
- Capture `final-message` output from the action for posting comments
- Use `codex-args` to pass additional CLI flags to the action

## Limitations

- Not as strong for deep reasoning or multi-step architecture
- Smaller context window than Gemini
- Requires Git repository by default (override with `--skip-git-repo-check`)
- Sandbox modes have different behaviors
- `CODEX_API_KEY` is only supported in `codex exec`, not other commands
- Autofix CI requires proper permissions and workflow configuration

## References

- [OpenAI Codex](https://openai.com/research/codex)
- [Codex SDK - Using Codex CLI Programmatically](https://developers.openai.com/codex/sdk#using-codex-cli-programmatically)
- [OpenAI Platform](https://platform.openai.com/)

