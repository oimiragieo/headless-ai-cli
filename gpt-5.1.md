# 🧠 AI Model Review Instructions (`gpt-5.1.md`)

This document provides comprehensive guidance on installing, configuring, and using a variety of AI model command-line interfaces (CLIs): **Google Gemini**, **Anthropic Claude**, **OpenAI Codex**, **Cursor Agent**, **GitHub Copilot**, **Factory AI Droid**, **Kiro**, and **Warp**. It is intended to support code review, coding, design, planning, and automation tasks.

You'll also find research-based recommendations to help select the appropriate model or agent depending on the specific requirements of your task (e.g., code analysis, UI generation, planning, automation, etc.).

Begin with a concise checklist (3-7 bullets) of your approach when undertaking multi-step workflows; keep items conceptual and high-level to ensure all major steps are covered upfront.

---

## 📄 One-Page Executive Summary

**If you only read one section, make it this one.**

### Quick Tool Selection by Task

| Task                    | Best Tool                        | Why                                                         |
|-------------------------|----------------------------------|-------------------------------------------------------------|
| **Code review**         | Gemini or Droid                  | Gemini for large repos; Droid for CI/CD-safe reviews        |
| **UI generation**       | Codex or Copilot (gpt-5-codex)   | Excels at turning prompts into front-end components         |
| **Multi-file reasoning**| Claude Opus or Gemini            | Opus for depth; Gemini for massive context                  |
| **Large repos (1M+)**   | Gemini                           | Only tool with 1M token context window                      |
| **CI/CD safe tasks**    | Droid                            | Read-only by default, fail-fast, deterministic              |
| **Automated workflows** | Cursor or Droid                  | Cursor for chained tasks; Droid for production              |
| **Daily coding**        | Claude Sonnet                    | Balanced performance and reasoning                          |
| **Deep architecture**   | Claude Opus                      | Strongest reasoning capabilities                            |
| **GitHub PRs/issues**   | Copilot                          | Native GitHub integration                                   |
| **IDE-based development** | Kiro                          | Spec-driven development, agentic workflows                    |
| **Enhanced terminal experience** | Warp                        | AI-powered terminal for CLI tools                           |

### Quick Tool Selection by Role

| Role                | Best Tools               | Primary Use Case                                |
|---------------------|-------------------------|-------------------------------------------------|
| Backend Engineer    | Claude Sonnet, Gemini   | Code review, API design, refactoring            |
| Frontend Engineer   | Codex, Copilot          | UI components, prototyping, design systems      |
| SRE/DevOps          | Droid, Claude, Gemini   | CI/CD automation, incident response, security   |
| AI/ML Engineer      | Claude Opus, Gemini     | Research, architecture, complex reasoning       |
| PM/Designer         | Codex, Copilot          | Rapid prototyping, UI mockups, user flows       |
| Data Engineer       | Gemini, Claude Sonnet   | Large-scale analysis, ETL pipelines            |
| Security Engineer   | Claude, Droid           | Security audits, compliance checks, vulnerability analysis |
| IDE User            | Kiro, Cursor            | Integrated development with AI assistance      |
| Terminal Power User | Warp                   | Enhanced CLI experience with AI features      |

### Cost & Speed Quick Reference

| Tool            | Cost Tier      | Speed         | Best Value For                  |
|-----------------|----------------|--------------|---------------------------------|
| Claude Haiku    | 💰 Low         | ⚡ Fast       | Quick tasks, budget-conscious   |
| Gemini Flash    | 💰 Low-Medium  | ⚡ Fast       | Large context, quick analysis   |
| Claude Sonnet   | 💰💰 Medium     | ⚡⚡ Medium    | Daily coding, balanced          |
| Gemini Pro      | 💰💰 Medium-High| ⚡⚡ Medium    | Massive repos                   |
| Claude Opus     | 💰💰💰 High      | ⚡ Slow       | Deep reasoning, architecture    |
| Codex           | 💰💰 Medium     | ⚡⚡⚡ Fast     | UI generation, prototyping      |
| Kiro            | 💰💰 Medium     | ⚡⚡ Medium    | IDE-based development, spec-driven |
| Warp            | 💰💰 Medium     | ⚡⚡⚡ Fast     | Terminal enhancement, AI assistance |

### Risk Levels at a Glance

- 🟢 **Low:** Droid (read-only default)
- 🟢 **Low:** Claude (tool approval required)
- 🟠 **Medium:** Gemini, Codex (sandbox modes), Kiro (IDE with agents)
- ⚠️ **High:** Cursor (requires `--force` for writes)
- ⚡ **High:** Copilot (can run shell/git)
- 🟢 **Low:** Warp (terminal emulator, enhances CLI tools)

### Installation Quick Start

```bash
# Install Gemini
npm install -g @google/gemini-cli

# Install Claude
npm install -g @anthropic-ai/claude-code

# Install Codex
npm install -g @openai/codex

# Install Cursor
curl https://cursor.com/install -fsS | bash

# Install Copilot
npm install -g @github/copilot

# Install Droid
curl -fsSL https://app.factory.ai/cli | sh

# Install Kiro (IDE - download from kiro.help)
# Visit https://kiro.help/docs for installation

# Install Warp (Terminal)
# macOS: brew install --cask warp
# Visit https://warp.dev for other platforms
```

After each significant configuration, tool call, or code edit, validate the result in 1-2 lines and proceed or self-correct if validation does not meet the intended outcome.

**Next:** See [Common CLI Concepts](#-common-cli-concepts) for standard usage patterns, or jump to individual tool documentation below.

📄 **Tip:** For a condensed printable reference, focus on:
- Executive Summary
- Decision Tree
- Model Selection Cheat Sheet
- Role-Based Quick Guide
- Troubleshooting Guide

**Icon Legend:**
- 🚨: Dangerous (requires caution)
- 🛟: Safe-by-default (read-only)
- ⚙️: Required configuration
- ⭐: Proven approach

---

## 🎯 Quick Decision Tree: Selecting Your Tool

**10-second guide:**

```text
Need huge context (1M+ tokens)?          → Gemini
Need deepest reasoning?                  → Claude Opus
Need UI or front-end generation?         → Codex
Need workflow automation?                → Cursor
Need CI/CD-safe deterministic runs?      → Droid
Need GitHub integration?                 → Copilot
Need balanced daily coding?              → Claude Sonnet
```

(**Full decision logic and further details continue below…**)

---

## 📑 Navigation

**Quick Links:**
- [📄 Executive Summary](#-one-page-executive-summary)
- [👥 Role-Based Quick Guide](#-role-based-quick-guide)
- [🔧 Common CLI Concepts](#-common-cli-concepts) ⭐ **Read this first**
- [🧠 OpenAI Codex (GPT-5.1)](#-openai-codex-gpt-51)
- [🎯 Model Selection Cheat Sheet](#-model-selection-cheat-sheet)
- [🧮 Model Recommendations](#-model--agent-recommendations-by-task)
- [🧪 Example Workflows](#-example-workflows)
- [📌 Version Pinning Guide](#-version-pinning-guide)
- [🔍 Troubleshooting Guide](#-troubleshooting-guide)
- [📐 Architecture Overview](#-architecture-overview)
- [⚠️ Limitations & Gotchas](#-limitations--gotchas)

---

## 👥 Role-Based Quick Guide

**Choose tools based on your role and primary tasks:**

### Backend Engineer
**Best Tools:** Claude Sonnet, Gemini  
**Primary Tasks:**
- Code review and refactoring → `claude -p "Review this API endpoint"`
- Multi-file architecture → `gemini -p "Analyze the authentication system"`
- API design → `claude -p "Design a REST API for user management"`

### Frontend Engineer
**Best Tools:** Codex, Copilot  
**Primary Tasks:**
- UI components → `codex exec "Create a React button component"`
- Design systems → `copilot -p "Generate a Tailwind component library"`
- Prototyping → `codex exec "Build a login form with validation"`

### SRE/DevOps
**Best Tools:** Droid, Claude, Gemini  
**Primary Tasks:**
- CI/CD automation → `droid exec "Run security audit and generate report"`
- Incident response → `claude -p "Diagnose production API errors"`
- Infrastructure as code → `gemini -p "Review Terraform configs for proven approaches"`

### AI/ML Engineer
**Best Tools:** Claude Opus, Gemini  
**Primary Tasks:**
- Research and architecture → `claude -p "Design a transformer architecture"`
- Large-scale analysis → `gemini -p "Analyze this ML pipeline across 500 files"`
- Model evaluation → `claude -p "Review model performance metrics"`

### PM/Designer
**Best Tools:** Codex, Copilot  
**Primary Tasks:**
- Rapid prototyping → `codex exec "Create a user onboarding flow"`
- UI mockups → `copilot -p "Generate a dashboard design"`
- User flows → `codex exec "Map the checkout process"`

### Data Engineer
**Best Tools:** Gemini, Claude Sonnet  
**Primary Tasks:**
- ETL pipelines → `gemini -p "Review this data transformation pipeline"`
- Large-scale analysis → `gemini -p "Analyze data quality across datasets"`
- Schema design → `claude -p "Design a data warehouse schema"`

### Security Engineer
**Best Tools:** Claude, Droid  
**Primary Tasks:**
- Security audits → `droid exec "Audit codebase for SQL injection risks"`
- Compliance checks → `claude -p "Review code for GDPR compliance"`
- Vulnerability analysis → `droid exec "Scan for known CVEs in dependencies"`

---

## 🔧 Common CLI Concepts

**This section consolidates patterns shared across all tools. Individual tool sections reference this instead of repeating details.**

### Headless Mode (Non-Interactive Execution)

All tools support headless mode for automation, scripting, and CI/CD pipelines. Commands run without user interaction and output to stdout/stderr.

**Common patterns:**
```bash
# Direct prompt
tool -p "Your prompt here"

# Stdin input
echo "Your prompt" | tool

# File input
cat prompt.txt | tool -p

# Combine with pipes
git diff | tool -p "Review these changes"
```

**Exit codes:**
- `0` = Success
- Non-zero = Error (check tool-specific documentation)

### JSON Output Format

All tools support JSON output for programmatic processing. Use `--output-format json` or `--json` flag.

**Common structure:**
```json
{
  "result": "Response text",
  "metadata": {
    "cost": 0.003,
    "duration_ms": 1234,
    "tokens": 500
  }
}
```

**Parsing with jq:**
```bash
tool -p "query" --output-format json | jq -r '.result'
```

### Streaming JSON Output

Most tools support real-time JSON streaming (JSONL format) for monitoring progress.

**Common usage:**
```bash
tool -p "query" --output-format stream-json | while IFS= read -r line; do
  event=$(echo "$line" | jq -r '.type')
  echo "Event: $event"
done
```

**Event types (tool-specific):**
- `system.init`: Session initialization
- `assistant`: Assistant messages
- `tool_call.*`: Tool execution events
- `result`: Final outcome with stats

### File Modifications & Risk Levels

**Default behaviors:**
- **Read-only:** Droid (default), Codex (default sandbox), Cursor (without `--force`)
- **Requires approval:** Claude, Copilot (tool approval system)
- **Can modify:** Gemini, Codex (with sandbox modes), Cursor (with `--force`), Droid (with `--auto`)

**Risk mitigation:**
- Use in restricted environments (VM, container)
- Review suggested commands before approval
- Don't launch from home directory
- Use narrowest permissions that allow task completion

### Tool Approval & Permissions

**Claude & Copilot:**
- First-time tool use requires approval
- Options: Yes (this time), Yes (rest of session), No
- Pre-approve with `--allowedTools` or `--allow-tool`

**Droid:**
- Autonomy levels: `--auto low`, `--auto medium`, `--auto high`
- Fail-fast if action exceeds autonomy level
- Factory-side restrictions prevent destructive commands even at high autonomy

**Codex:**
- Sandbox modes: `--full-auto` (workspace-write), `--sandbox danger-full-access`
- Default is read-only

### Session Management

**Resume conversations:**
```bash
# Continue most recent (Claude, Codex)
tool --continue "Next step"

# Resume by session ID
tool --resume <session-id> "Continue"
```

**Session storage:**
- Session IDs typically stored in tool config directories
- Use `--session-id` or `--resume` flags

### Model Selection

**Change models:**
```bash
⚙️ # Gemini
gemini -p "query" --model gemini-2.5-pro

⚙️ # Claude
claude -p "query" --model claude-opus-4-1

⚙️ # Codex
codex exec "query" --model gpt-5-codex

⚙️ # Droid
droid exec "query" -m claude-sonnet-4-20250514
```

**Default models:**
- Gemini: `gemini-2.5-pro` (or latest)
- Claude: `claude-sonnet-4.5` (or latest)
- Codex: `gpt-5-codex` (automatically aliases to `gpt-5-codex-latest`, the most recent stable Codex model)
- Copilot: GitHub typically uses Claude Sonnet 4 (or newer Sonnet 4.x series), but may switch to GPT-4.1 or other models depending on task, region, or org settings
- Droid: `gpt-5-codex` (configurable)

### CI/CD Integration

**Proven approaches:**
- ⭐ Use structured output (JSON) for parsing
- ⭐ Check exit codes for error handling
- ⭐ Set appropriate autonomy/permission levels
- ⭐ Use read-only modes when possible
- ⭐ Use retry logic with exponential backoff

**Example pattern:**
```bash
#!/bin/bash
set -e

result=$(tool -p "query" --output-format json)
if [ $? -ne 0 ]; then
  echo "Error: Tool execution failed"
  exit 1
fi

# Parse and use result
response=$(echo "$result" | jq -r '.result')
echo "$response"
```

---

## 🧠 OpenAI Codex (GPT-5.1)

**Version tested:** Latest (check with `codex --version`)  
**Risk level:** 🟠 Medium (sandbox modes differ, read-only default)

**Note:** This is the 2025 OpenAI Codex CLI tool, not the original 2021 Codex model. The CLI provides programmatic access to OpenAI's latest code generation models (GPT-5 Codex, GPT-5.1, etc.).

**When NOT to use Codex:**
- ❌ You need deep reasoning for complex architecture (Claude Opus is better)
- ❌ You need massive context windows (Gemini handles larger repos)
- ❌ You're not in a Git repository (requires Git repo by default, unless you override)
- ❌ You need deterministic, production-safe CI/CD runs (Droid is safer)

**Git repository requirement:** The Codex CLI assumes the workspace is a Git repository because many of its built-in capabilities rely on diff analysis and file tracking. Use `--skip-git-repo-check` to override this requirement.

### Quick Nav
- [Start Here](#-start-here-3)
- [Why Use Codex](#-why-use-codex)
- [Best Use Cases](#-best-use-cases-2)
- [Permission Modes](#-permission-modes)
- [Output Control](#-output-control)
- [Example Workflows](#-example-workflows-3)

**Install CLI:**
```bash
npm install -g @openai/codex
```

**🚀 Start here:**
```bash
codex exec "generate a unit test"
```

**Run a prompt (Non-interactive execution):**
```bash
# Basic execution (read-only by default)
codex exec "Your prompt here"

# Allow file edits
codex exec --full-auto "Your prompt here"

# Allow edits and networked commands
codex exec --sandbox danger-full-access "Your prompt here"

# Pipe output to file
codex exec "generate release notes" | tee release-notes.md
```

### ✅ Why use Codex
- Strong for **UI generation**, **prototyping**, and **planning** tasks.
- **Non-interactive execution** designed for CI/CD pipelines and automation.
- Converts natural language into working code.
- Turns product ideas into quick front-end scaffolds.
- **Programmatic control** via TypeScript SDK, CLI, or GitHub Actions.
- **Structured output** with JSON Schema support for automation.

### 💡 Best Use Cases
- Generating UI components and design systems.
- Planning workflows or writing quick automation scripts.
- Integrating LLMs into apps or CLIs.
- **CI/CD automation**: automated code reviews, patches, and quality checks
- **GitHub Actions**: PR reviews, release prep, and migrations
- **Structured data extraction**: JSON Schema-based output for pipelines

### ⚙️ Permission Modes

**Default (read-only):**
```bash
codex exec "find any remaining TODOs and create plans"
```
- Read-only sandbox
- No file modifications
- No networked commands

**Allow file edits:**
```bash
codex exec --full-auto "Refactor authentication module"
```

**Allow edits and network:**
```bash
codex exec --sandbox danger-full-access "Install dependencies and update config"
```

### ⚙️ Output Control

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

Event types include:
- `thread.started`
- `turn.started`, `turn.completed`, `turn.failed`
- `item.*` (agent messages, reasoning, commands, file changes, MCP tool calls, web searches, plan updates)
- `error`

Example JSON stream:
```json
{"type":"thread.started","thread_id":"0199a213-81c0-7800-8aa1-bbab2a035a53"}
{"type":"turn.started"}
{"type":"item.started","item":{"id":"item_1","type":"command_execution","command":"bash -lc ls","status":"in_progress"}}
{"type":"item.completed","item":{"id":"item_3","type":"agent_message","text":"Repo contains docs, sdk, and examples directories."}}
{"type":"turn.completed","usage":{"input_tokens":24763,"cached_input_tokens":24448,"output_tokens":122}}
```

### ⚙️ Structured Output

Use JSON Schema to receive structured JSON output:

**schema.json:**
```json
{
  "type": "object",
  "properties": {
    "project_name": { "type": "string" },
    "programming_languages": {
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

Output conforms to your schema, perfect for feeding into scripts or CI pipelines.

### ⚙️ Session Management

**Resume last session:**
```bash
codex exec "Review the change for race conditions"
codex exec resume --last "Fix the race conditions you found"
```

**Resume specific session:**
```bash
codex exec resume <SESSION_ID> "Continue from where we left off"
```

### ⚙️ TypeScript SDK

**Install SDK:**
```bash
npm install @openai/codex-sdk
```

**Usage:**
```typescript
import { Codex } from "@openai/codex-sdk";

const codex = new Codex();
const thread = codex.startThread();
const result = await thread.run(
  "Make a plan to diagnose and fix the CI failures"
);

// Continue on same thread
const result2 = await thread.run("Execute the plan");

// Resume past thread
const thread2 = codex.resumeThread(threadId);
const result3 = await thread2.run("Pick up where you left off");
```

### ⚙️ GitHub Action

Use `openai/codex-action@v1` for CI/CD integration:

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
    steps:
      - uses: actions/checkout@v5
      - name: Run Codex
        uses: openai/codex-action@v1
        with:
          openai-api-key: ${{ secrets.OPENAI_API_KEY }}
          prompt-file: .github/codex/prompts/review.md
          output-file: codex-output.md
          safety-strategy: drop-sudo
          sandbox: workspace-write
```

**Key features:**
- Automated PR reviews and feedback
- CI pipeline quality checks
- Repeatable tasks (code review, release prep, migrations)
- Safety strategies (drop-sudo, unprivileged-user, read-only)

### ⚙️ Authentication

**Default (uses CLI authentication):**
```bash
codex exec "query"
```

**Override for single run:**
```bash
CODEX_API_KEY=your-api-key codex exec --json "triage open bug reports"
```

### ⚙️ Example Workflows

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

### ⚠️ Notes
- Not as strong for deep reasoning or multi-step architecture.
- Smaller context window than Gemini.
- Requires Git repository by default (override with `--skip-git-repo-check`).
- Use `--full-auto` or `--sandbox` flags to enable file modifications.
- JSON streaming provides detailed event-level visibility.
- Structured output with JSON Schema ensures consistent data format.

---

## 🎯 Model Selection Cheat Sheet

### By Model Family

| Model | Speed | Reasoning | Context | Cost | Best For |
|-------|-------|-----------|---------|------|----------|
| **Gemini 2.5 Pro** | Medium | High | ★★★★★ (1M tokens) | Medium-High | Massive repos, repo-wide analysis |
| **Gemini 2.5 Flash** | Fast | Medium | ★★★★★ (1M tokens) | Low-Medium | Quick analysis, large context needs |
| **Claude Opus 4.1** | Slow | ★★★★★ | Medium (200K) | High | Deep reasoning, architecture |
| **Claude Sonnet 4.5** | Medium | ★★★★ | Medium (200K) | Medium | Daily coding, balanced |
| **Claude Haiku 4.5** | Fast | ★★★ | Medium (200K) | Low | Quick tasks, budget-conscious |
| **GPT-5 Codex** | Fast | ★★★ | Medium | Medium | UI generation, prototyping |
| **GPT-5** | Medium | ★★★★ | Medium | Medium-High | General purpose |
| **GPT-4.1** | Medium | ★★★ | Medium | Medium | Balanced performance |

### By Use Case

**Massive Context (1M+ tokens):**
- Primary: `Gemini 2.5 Pro` or `Gemini 2.5 Flash`
- Alternative: None (Gemini is unique here)

**Deep Reasoning:**
- Primary: `Claude Opus 4.1`
- Alternative: `Claude Sonnet 4.5` (faster, cheaper)

**UI/Front-end Generation:**
- Primary: `GPT-5 Codex` or `Codex CLI`
- Alternative: `Copilot (gpt-5-codex)`

**Daily Coding:**
- Primary: `Claude Sonnet 4.5`
- Alternative: `Claude Haiku 4.5` (faster, lower cost)

**Budget-Conscious:**
- Primary: `Claude Haiku 4.5` or `Gemini 2.5 Flash`
- Alternative: `GPT-4.1`

**Speed-Critical:**
- Primary: `Claude Haiku 4.5` or `Gemini 2.5 Flash`
- Alternative: `GPT-5 Codex`

---

## 🧮 Model & Agent Recommendations by Task

| Task Type | Recommended Model / Agent | Why |
|------------|---------------------------|-----|
| **Daily coding & feature dev** | `Claude Sonnet` (Claude Code CLI) | Balanced performance and reasoning for code. |
| **Complex architecture or multi-file reasoning** | `Claude Opus` | Deep reasoning and architectural design. |
| **Large repository or long context** | `Gemini 2.5 Pro` (Gemini CLI) | Massive context and strong code understanding. |
| **UI generation / prototyping** | `Codex` or `Copilot (gpt-5-codex)` | Strong at turning prompts into front-end components. |
| **Automation / workflows** | `Cursor Agent`, `Droid Exec`, or `Gemini CLI` (headless) | Ideal for chaining build, test, deploy steps. |
| **CI/CD pipelines** | `Droid Exec` or `Gemini CLI` (headless) | Non-interactive, secure-by-default, structured output. |
| **Code reviews / PR analysis** | `Gemini CLI` (with Code Review extension or headless mode) or `Droid Exec` | Built-in PR analysis and commenting tools. |
| **Low-latency / budget tasks** | `Claude Haiku` or fast Copilot model | Lightweight and fast for everyday prompts. |

---

## 🧪 Example Workflows

### 🎨 UI Prototyping
```bash
codex exec "Create a React + Tailwind component library for buttons and forms"

# With structured output
codex exec "Create a React + Tailwind component library for buttons and forms" \
  --output-schema ./ui-schema.json \
  -o ./ui-components.json
```

### 🤖 CI/CD Automation
```bash
# Automated code review with Codex
codex exec --json "Review PR changes for bugs and security issues" | \
  jq -r 'select(.type=="item.completed" and .item.type=="agent_message") | .item.text'

# Structured metadata extraction
codex exec "Extract project metadata" \
  --output-schema ./schema.json \
  -o ./project-metadata.json
```

---

## ⚡ Proven Approaches

- **Match model to task**: don't always pick the largest one
- **Claude Sonnet**: everyday workhorse for most dev tasks
- **Claude Opus**: deep refactors and architecture reasoning
- **Gemini**: huge-context or multi-file code reviews
- **Codex/Copilot**: strong for UI and rapid generation
- **Cursor**: strong for automating repetitive or chained workflows
- **Droid**: strong for CI/CD pipelines, batch processing, and secure automation with structured output

Keep CLIs updated to the latest versions for optimal compatibility and performance.

---

## 📌 Version Pinning Guide

CLI versions change frequently. For production CI/CD, pin specific versions:

```bash
# Codex
npm install -g @openai/codex@2.2.0

# Claude
npm install -g @anthropic-ai/claude-code@1.9.3

# Gemini
npm install -g @google/gemini-cli@3.1.0

# Copilot
npm install -g @github/copilot@0.0.329
```

**Note:** Version numbers shown are examples. Check each tool's repository for current stable versions. Update pinning quarterly or when new features are required.

---

## 🔍 Troubleshooting Guide

**Common errors and solutions:**

### "Tool not approved" / "Agent refused action"

**Symptoms:**
- Tool execution fails with permission error
- Agent refuses to perform requested action

**Solutions:**
- **Codex:** Use `--full-auto` or `--sandbox danger-full-access` (use with caution)
- **Claude/Copilot:** Pre-approve tools with `--allowedTools` or `--allow-tool`
- **Droid:** Increase autonomy level (`--auto low` → `--auto medium` → `--auto high`)
- **Cursor:** Add `--force` flag for file modifications
- Check tool allow/deny lists
- Verify trusted directory settings (Copilot)

### "Context limit exceeded"

**Symptoms:**
- Error about context window being too large
- Tool refuses to process large files/repos

**Solutions:**
- **Use Gemini** for massive repos (1M token context)
- Split large tasks into smaller chunks
- Use streaming to process incrementally
- Filter files before processing (e.g., `git ls-files "*.ts"`)

### "Git repository required"

**Symptoms:**
- Codex fails with Git repository error

**Solutions:**
- Initialize Git repository: `git init`
- Use `--skip-git-repo-check` to override (may limit functionality)
- Codex requires Git for diff analysis and file tracking

### "JSON parsing fails"

**Symptoms:**
- `jq` or JSON parser errors
- Unexpected JSON structure

**Solutions:**
- Use `jq` to extract specific fields: `jq -r '.result'`
- Check for metadata wrappers (some tools wrap JSON)
- Validate JSON Schema (Codex)
- Use `--output-format json` explicitly
- Check tool documentation for exact JSON structure

### "Session ID not found"

**Symptoms:**
- Cannot resume conversation
- Session ID invalid

**Solutions:**
- Check session ID format (varies by tool)
- Verify session exists in tool's config directory
- Use `--continue` or `resume --last` to resume most recent session
- Start new session if ID is lost

---

## 📐 Architecture Overview

### Tool Approval Layers

```text
┌─────────────────────────────────────────────────────────┐
│                    User Prompt                          │
└────────────────────┬────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
    ┌────▼────┐            ┌────▼────┐
    │  CLI    │            │  Agent  │
    │  Layer  │            │  Layer  │
    └────┬────┘            └────┬────┘
         │                       │
    ┌────▼───────────────────────▼────┐
    │     Tool Approval Layer         │
    │  • Trusted directories           │
    │  • Tool allow/deny lists         │
    │  • Autonomy levels (Droid)       │
    │  • Permission modes (Claude)     │
    │  • Sandbox modes (Codex)         │
    └────┬────────────────────────────┘
         │
    ┌────▼────────────────────────────┐
    │     Sandbox/Execution Layer      │
    │  • Read-only (default)           │
    │  • File modifications            │
    │  • Shell command execution       │
    │  • Network access                │
    └────┬────────────────────────────┘
         │
    ┌────▼────────────────────────────┐
    │     Output Layer                │
    │  • Text (default)                │
    │  • JSON (structured)             │
    │  • Stream JSON (real-time)       │
    │  • Delta streaming (incremental) │
    └────┬────────────────────────────┘
         │
    ┌────▼────────────────────────────┐
    │     CI/CD Pipeline Integration   │
    │  • Exit codes                    │
    │  • Structured artifacts          │
    │  • Error handling                │
    └──────────────────────────────────┘
```

### Security Model Comparison

**Layered Security Approach:**

1. **Directory Trust** (Copilot, Droid)
   - User confirms trust for working directory
   - Prevents accidental execution in untrusted locations

2. **Tool Approval** (Claude, Copilot)
   - Per-tool permission requests
   - Session-based or permanent approvals
   - Fine-grained control (allow/deny specific commands)

3. **Autonomy Levels** (Droid)
   - Read-only (default)
   - Low/Medium/High risk tiers
   - Fail-fast on permission violations

4. **Sandbox Modes** (Codex)
   - Read-only (default)
   - Workspace-write (`--full-auto`)
   - Danger-full-access (use with caution)

5. **Force Flags** (Cursor)
   - Default: propose changes only
   - `--force`: enable actual file modifications

---

## ⚠️ Limitations & Gotchas

### General Limitations

**Codex:**
- ⚠️ Requires Git repository by default (override with `--skip-git-repo-check` if needed). Codex assumes a Git repo because its capabilities rely on diff analysis and file tracking.
- ⚠️ Sandbox modes have different behaviors; `danger-full-access` is truly dangerous
- ⚠️ Structured output schemas must be valid JSON Schema (validation can fail silently)
- ⚠️ Not as strong for deep reasoning or multi-step architecture
- ⚠️ Smaller context window than Gemini

### Common Gotchas

1. **Exit Codes:** Not all tools return consistent exit codes; always test in your CI/CD environment
2. **JSON Parsing:** Some tools wrap JSON in additional metadata; use `jq` filters to extract clean data
3. **Session Management:** Resuming sessions requires storing session IDs; easy to lose context
4. **Rate Limits:** All tools have rate limits; use retry logic with exponential backoff
5. **Cost Tracking:** Premium requests consume quotas; monitor usage in production
6. **Version Compatibility:** CLI versions change frequently; pin versions in production
7. **Error Messages:** Some tools have cryptic error messages; check logs and verbose modes

### Troubleshooting Tips

**"Tool not approved" errors:**
- Check tool allow/deny lists
- Verify autonomy levels (Droid) or sandbox modes (Codex)
- Review trusted directory settings (Copilot)

**"Context too large" errors:**
- Use Gemini for massive repos
- Split large tasks into smaller chunks
- Use streaming to process incrementally

**"Unexpected file modifications":**
- Verify `--force` flags (Cursor)
- Check autonomy levels (Droid)
- Review sandbox modes (Codex)

**"JSON parsing fails":**
- Use `jq` to extract specific fields
- Check for metadata wrappers
- Validate JSON Schema (Codex)

---

## 🔗 References

- [OpenAI Codex](https://openai.com/research/codex)
- [Codex SDK - Using Codex CLI Programmatically](https://developers.openai.com/codex/sdk#using-codex-cli-programmatically)
- [Gemini CLI Docs – Google Developers](https://developers.google.com/gemini-code-assist/docs/gemini-cli)
- [Anthropic Claude Models](https://docs.claude.ai)
- [Claude Code Headless Mode](https://code.claude.com/docs/en/headless.md)
- [Cursor Agent](https://cursor.com/)
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/cli)
- [Factory AI Droid Exec](https://docs.factory.ai/cli/droid-exec/overview.md)
- [AI Model Benchmarks (GetBind)](https://blog.getbind.co/2025/05/23/claude-4-vs-claude-3-7-sonnet-vs-gemini-2-5-pro-which-is-best-for-coding/)
- [AI Model Selection Guide (Eesel)](https://www.eesel.ai/blog/claude-code-model-selection)

---

**Created by:** James Hollingsworth  
**Last Updated:** November 2025  
**Version:** 2.3 (Focused on GPT-5.1/Codex with comprehensive CLI reference)  
**Purpose:** Internal AI review and comparison reference for engineering teams, with emphasis on OpenAI Codex (GPT-5.1) usage.
