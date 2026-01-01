# AI CLI Quick Reference

> **Single-source reference for headless AI CLI tools**
> *Last Updated: January 2026 | 14 Tools Documented (9 full headless, 4 limited, 1 deprecated)*

---

## 10-Second Tool Selector

| Need | Tool | Why |
|------|------|-----|
| **Huge context (1M+ tokens)** | Gemini | Best for repo-wide analysis |
| **Deep reasoning** | Claude Opus | Architecture & complex logic |
| **UI/front-end generation** | Codex | Fast HTML/CSS/React prototyping |
| **CI/CD automation** | Droid | Safe, deterministic, read-only default |
| **GitHub integration** | Copilot | Native PR & issue understanding |
| **AWS integration** | Amazon Q ⚠️ | AWS services (DEPRECATED - use Kiro) |
| **Workflow automation** | Cursor | Multi-step agent workflows |
| **Pair programming** | Aider | Git-integrated AI pair coding |
| **VS Code integration** | Continue Dev | IDE-first development |
| **Task automation** | Cline | Autonomous task execution |
| **Multi-language** | OpenCode | Polyglot support |
| **Spec-driven development** | Kiro ⚠️ | IDE only - NO headless mode |
| **Enhanced terminal** | Warp ⚠️ | macOS terminal UX (no headless) |
| **IDE development** | Windsurf ⚠️ | Docker-only headless |

---

## What to Use When

```
Fast local inference         → Aider (with local models)
Best structured JSON output  → Gemini, Claude, Codex, Droid
CI/CD headless execution     → Droid, Claude, Gemini
Shell/terminal integration   → Warp (macOS), Amazon Q
Offline/air-gapped           → Aider (with Ollama)
GitHub PR automation         → Copilot, Claude
AWS infrastructure           → Amazon Q
Large monorepo analysis      → Gemini (1M context)
Security auditing            → Droid (read-only), Claude
Code review automation       → All tools with --output-format json
```

---

## Feature Matrix (All 14 Tools)

| Tool | Headless | JSON | Stream | Writes | Platform |
|------|:--------:|:----:|:------:|:------:|----------|
| Gemini | ✅ | ✅ | ✅ | flag | Win/Mac/Linux |
| Claude | ✅ | ✅ | ✅ | approval | Win/Mac/Linux |
| Codex | ✅ | ✅ | ✅ | flag | Win/Mac/Linux |
| Cursor | ✅ | ✅ | ✅ | default | Win/Mac/Linux |
| Droid | ✅ | ✅ | ✅ | flag | Win/Mac/Linux |
| Copilot | ✅ | ❌ | ❌ | flag | Win/Mac/Linux |
| Aider | ✅ | ❌ | ❌ | flag | Win/Mac/Linux |
| Continue | ✅ | ❌ | ❌ | approval | Win/Mac/Linux |
| Cline | ✅ | ✅ | ❌ | flag | Win/Mac/Linux |
| OpenCode | ✅ | ❌ | ❌ | flag | Win/Mac/Linux |
| Kiro | ❌ | — | — | — | IDE only |
| Warp | ❌ | — | — | — | macOS terminal |
| Windsurf | ⚠️ | ❌ | ❌ | default | Docker required |
| Amazon Q | ✅ | ✅ | ❌ | flag | DEPRECATED |

**Writes:** approval = user must approve | flag = opt-in via flag | default = writes without prompting

---

## Headless Command "Rosetta Stone"

Map standard actions across all tools:

| Action | Gemini | Claude | Codex | Droid |
|--------|--------|--------|-------|-------|
| **Headless prompt** | `gemini -p "cmd"` | `claude -p "cmd"` | `codex exec "cmd"` | `droid exec "cmd"` |
| **JSON output** | `--output-format json` | `--output-format json` | `--json` | `--output-format json` |
| **Skip confirmations** | (default) | `--permission-mode bypassPermissions` | `--full-auto` | `--auto high` |
| **Read-only mode** | N/A | `--allowedTools "Read"` | (default) | `--auto low` |
| **Set model** | `--model gemini-3-pro` | `--model opus` | `--model gpt-5.1` | N/A |
| **Pipe input** | `cat file \| gemini -p` | `cat file \| claude -p` | `cat file \| codex exec` | `cat file \| droid exec` |

| Action | Cursor | Copilot | Cline | Amazon Q |
|--------|--------|---------|-------|----------|
| **Headless prompt** | `cursor-agent -p "cmd"` | `copilot -p "cmd"` | `cline "cmd"` | `q chat "cmd"` |
| **JSON output** | `--output-format json` | (limited) | `--output-format json` | `--output json` |
| **Skip confirmations** | `--force` | `--allow-all-tools` | `--yolo` | `--trust-workspace` |
| **Read-only mode** | N/A | N/A | N/A | N/A |
| **Set model** | N/A | N/A | N/A | N/A |

---

## Installation by Package Manager

### npm (Node.js)
```bash
# Core tools
npm install -g @google/gemini-cli        # Gemini CLI
npm install -g @anthropic-ai/claude-code # Claude Code
npm install -g @openai/codex             # OpenAI Codex
npm install -g @github/copilot           # GitHub Copilot
npm install -g @continuedev/cli          # Continue Dev
npm install -g cline                     # Cline
npm install -g open-code                 # OpenCode

# All npm tools at once
npm install -g @google/gemini-cli @anthropic-ai/claude-code @openai/codex @github/copilot @continuedev/cli cline open-code

# Update all npm tools
npm upgrade -g @google/gemini-cli @anthropic-ai/claude-code @openai/codex @github/copilot @continuedev/cli cline open-code
```

### pip (Python)
```bash
pip install aider-chat                   # Aider
```

### curl (Shell Scripts)
```bash
curl https://cursor.com/install -fsS | bash           # Cursor
curl -fsSL https://app.factory.ai/cli | sh            # Droid
curl -fsSL https://cli.kiro.dev/install | bash        # Kiro
```

### brew (macOS)
```bash
brew install --cask warp                 # Warp Terminal
brew install amazon-q-developer-cli      # Amazon Q
```

### Manual Download
```
Windsurf IDE: https://windsurf.com/editor
Kiro IDE:     https://kiro.dev/
```

---

## Tool Reference (All 14 Tools)

### Gemini CLI
> Google's AI CLI with 1M+ token context — best for large codebase analysis

```bash
# Basic headless
gemini -p "Explain this codebase"

# JSON output with model selection
gemini -p "List all API endpoints" --output-format json --model gemini-3-pro-preview

# Pipe input
git diff | gemini -p "Review these changes" --output-format json

# Streaming output
gemini -p "Generate documentation" --output-format streaming
```

**Tags:** `#cloud` `#chat` `#code` `#json` `#headless` `#streaming` `#large-context`
**Compatibility:** ✅ Win/Mac/Linux | ✅ Streaming | ✅ JSON | ✅ Headless | ✅ File input
**Docs:** [geminicli.com/docs](https://geminicli.com/docs/) | [GitHub](https://github.com/google-gemini/gemini-cli)
**Verified:** Nov 2025

---

### Claude Code
> Anthropic's CLI for deep reasoning — best for architecture and complex logic

```bash
# Basic headless
claude -p "Review this PR for security issues"

# JSON with tool restrictions (safe for CI/CD)
claude -p "Analyze code quality" \
  --output-format json \
  --permission-mode bypassPermissions \
  --allowedTools "Read,Grep"

# With model selection
claude -p "Design a caching strategy" --model opus --output-format json

# Session resume
claude -p --resume abc123 "Continue the refactoring"
```

**Tags:** `#cloud` `#reasoning` `#code` `#json` `#headless` `#streaming` `#tools`
**Compatibility:** ✅ Win/Mac/Linux | ✅ Streaming | ✅ JSON | ✅ Headless | ✅ Tool control
**Docs:** [docs.anthropic.com](https://docs.anthropic.com/en/docs/claude-code/overview) | [GitHub](https://github.com/anthropics/claude-code)
**Verified:** Nov 2025

---

### Codex (OpenAI)
> OpenAI's CLI for UI generation — best for front-end and prototyping

```bash
# Basic headless
codex exec "Create a React login form"

# Full auto mode with JSON
codex exec "Refactor auth module" --full-auto --json

# With schema validation
codex exec "Generate user profile" --json --schema profile.json

# Reasoning level control
codex exec "Complex refactor" --reasoning high --full-auto
```

**Tags:** `#cloud` `#ui` `#code` `#json` `#headless` `#full-auto` `#schema`
**Compatibility:** ✅ Win/Mac/Linux | ✅ Streaming | ✅ JSON | ✅ Headless | ✅ Schema validation
**Docs:** [developers.openai.com/codex](https://developers.openai.com/codex/) | [GitHub](https://github.com/openai/codex)
**Verified:** Nov 2025

---

### Cursor
> IDE agent for workflow automation — best for multi-step tasks

```bash
# Basic headless
cursor-agent -p "Update all tests for new API"

# Force mode with JSON
cursor-agent -p "Refactor entire module" --force --output-format json

# With specific model
cursor-agent -p "Complex migration" --model claude-3.5-sonnet --force
```

**Tags:** `#ide` `#workflow` `#agent` `#json` `#headless` `#multi-step`
**Compatibility:** ✅ Win/Mac/Linux | ✅ Streaming | ✅ JSON | ✅ Headless | ⚠️ High risk (writes by default)
**Docs:** [docs.cursor.com](https://docs.cursor.com/en/cli/overview) | No public GitHub
**Verified:** Nov 2025

---

### Droid (Factory AI)
> CI/CD-safe agent — best for deterministic, auditable automation

```bash
# Safe read-only audit
droid exec "Security audit" --auto low --output-format json

# Medium autonomy (some writes)
droid exec "Add logging" --auto medium --output-format json

# High autonomy (full writes)
droid exec "Refactor module" --auto high --output-format json

# Deterministic seed for reproducibility
droid exec "Generate tests" --auto low --seed 12345 --output-format json
```

**Tags:** `#cloud` `#cicd` `#safe` `#json` `#headless` `#deterministic` `#audit`
**Compatibility:** ✅ Win/Mac/Linux | ✅ JSON | ✅ Headless | 🟢 Read-only default
**Docs:** [docs.factory.ai](https://docs.factory.ai/cli/getting-started/quickstart) | [GitHub](https://github.com/Factory-AI/factory)
**Verified:** Nov 2025

---

### Copilot (GitHub)
> GitHub-native AI — best for PR reviews and issue understanding

```bash
# Basic prompt
copilot -p "Explain this repository structure"

# With all tools enabled
copilot -p "Review PR #123 for security issues" --allow-all-tools

# Suggest command
copilot suggest "find large files in git history"

# Explain command
copilot explain "git rebase -i HEAD~5"
```

**Tags:** `#cloud` `#github` `#pr` `#issues` `#headless` `#suggest` `#explain`
**Compatibility:** ✅ Win/Mac/Linux | ⚠️ Limited JSON | ✅ Headless | ⚡ Very high risk
**Docs:** [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli) | [GitHub](https://github.com/github/copilot-cli)
**Verified:** Nov 2025

---

### Kiro
> Spec-driven development — agents-only headless mode

```bash
# Install and authenticate
curl -fsSL https://cli.kiro.dev/install | bash
kiro-cli login  # Browser auth required

# Interactive chat (required - no direct execution)
kiro-cli chat
# > Install project dependencies

# With custom agent
kiro-cli chat --agent frontend-specialist
```

**Tags:** `#ide` `#spec-driven` `#agents` `#interactive`
**Compatibility:** ✅ Win/Mac/Linux | ⚠️ Agents only headless | ⚠️ Limited JSON
**Docs:** [kiro.dev/docs](https://kiro.dev/docs/) | [GitHub](https://github.com/kirodotdev/Kiro)
**Verified:** Nov 2025

---

### Warp
> Enhanced terminal — no headless mode (GUI only)

```bash
# macOS installation
brew install --cask warp

# Launch (GUI only - no headless)
open -a Warp
```

**Tags:** `#terminal` `#macos` `#gui` `#ux`
**Compatibility:** ❌ macOS only | ❌ No headless | ❌ GUI required
**Docs:** [docs.warp.dev](https://docs.warp.dev) | [GitHub](https://github.com/warpdotdev/Warp)
**Verified:** Nov 2025

---

### Windsurf
> Cascade AI agent — Docker-only headless mode

```bash
# Docker-based headless execution
docker run -v $(pwd):/workspace windsurf/cascade \
  --headless "Review code for security issues"

# With volume mounts
docker run -v $(pwd):/workspace -v ~/.ssh:/root/.ssh windsurf/cascade \
  --headless "Clone and analyze repository"
```

**Tags:** `#ide` `#docker` `#agent` `#cascade`
**Compatibility:** ✅ Win/Mac/Linux (via Docker) | ⚠️ Docker only | ⚠️ Limited JSON
**Docs:** [docs.windsurf.com](https://docs.windsurf.com/) | No public GitHub
**Verified:** Nov 2025

---

### Aider
> AI pair programming — best for Git-integrated development

```bash
# Basic usage with model
aider --model gpt-4o

# With local Ollama
aider --model ollama/llama3.1

# Headless mode with message
aider --model gpt-4o --message "Add error handling to auth.py" --yes

# Auto-commit changes
aider --model gpt-4o --auto-commits --message "Refactor"
```

**Tags:** `#local` `#pair-programming` `#git` `#ollama` `#headless`
**Compatibility:** ✅ Win/Mac/Linux | ✅ Offline (with Ollama) | ⚠️ Limited JSON | ✅ Git integration
**Docs:** [aider.chat/docs](https://aider.chat/docs/) | [GitHub](https://github.com/Aider-AI/aider)
**Verified:** Nov 2025

---

### Continue Dev
> VS Code CLI — best for IDE-integrated development

```bash
# Interactive TUI
cn

# Headless with agent
continue headless --agent "code-reviewer"

# With specific model
continue headless --agent "refactor-specialist" --model gpt-4o
```

**Tags:** `#ide` `#vscode` `#headless` `#agents` `#tui`
**Compatibility:** ✅ Win/Mac/Linux | ✅ Headless | ⚠️ Limited JSON | ✅ VS Code integration
**Docs:** [docs.continue.dev](https://docs.continue.dev/quickstart) | [GitHub](https://github.com/continuedev/continue)
**Verified:** Nov 2025

---

### Cline
> Task-based automation — autonomous task execution

```bash
# Basic headless (uses "code" mode by default)
cline "Add input validation to all forms"

# YOLO mode (no confirmations)
cline "Refactor authentication module" --yolo

# With JSON output
cline "Generate API documentation" --output-format json

# With specific mode
cline "Design new feature" --mode architect
```

**Tags:** `#automation` `#tasks` `#yolo` `#headless` `#json`
**Compatibility:** ✅ Win/Mac/Linux | ✅ Headless | ⚠️ Limited JSON | 🟠 Medium risk
**Docs:** [docs.cline.bot](https://docs.cline.bot/cline-cli/overview) | [GitHub](https://github.com/cline/cline)
**Verified:** Nov 2025

---

### Amazon Q
> AWS-integrated AI — best for cloud infrastructure

```bash
# Basic chat
q chat "How do I set up an S3 bucket with versioning?"

# With JSON output
q chat "List IAM best practices" --output json

# Trust workspace (skip confirmations)
q chat "Generate CloudFormation template" --trust-workspace

# Transform code
q transform --source legacy.py --target modern.py
```

**Tags:** `#cloud` `#aws` `#iam` `#cloudformation` `#headless` `#json`
**Compatibility:** ✅ Win/Mac/Linux | ✅ Headless | ✅ JSON | 🟠 Medium risk
**Docs:** [AWS Docs](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html) | [GitHub](https://github.com/aws/amazon-q-developer-cli)
**Verified:** Nov 2025

---

### OpenCode
> Multi-language CLI — polyglot development support

```bash
# Interactive mode (default)
opencode

# Non-interactive execution
echo "Add error handling" | opencode

# With provider selection
OPENCODE_PROVIDER=anthropic opencode
```

**Tags:** `#multi-language` `#polyglot` `#headless` `#providers`
**Compatibility:** ✅ Win/Mac/Linux | ✅ Headless (stdin) | ⚠️ Limited JSON
**Docs:** [opencode.ai/docs](https://opencode.ai/docs/) | [GitHub](https://github.com/sst/opencode)
**Verified:** Nov 2025

---

## Security & Permission Flags

### Risk Levels

| Level | Description | Tools |
|-------|-------------|-------|
| 🟢 **Low** | Read-only default, approval required | Claude, Droid, Continue, Warp |
| 🟠 **Medium** | Writes with explicit flags | Gemini, Codex, Kiro, Aider, Cline, Amazon Q, OpenCode, Windsurf |
| ⚠️ **High** | Writes by default with safeguards | Cursor |
| ⚡ **Very High** | Minimal safeguards | Copilot |

### Safe Flags (Read-Only)

```bash
# Claude: Restrict to read tools
claude -p "query" --allowedTools "Read,Grep,Glob"

# Droid: Low autonomy (read-only)
droid exec "query" --auto low

# Codex: Default is safe
codex exec "query"  # No --full-auto = safe
```

### Dangerous Flags (Full Write Access)

```bash
# Claude: Bypass all permissions
claude -p "query" --dangerously-skip-permissions          # 🔴 Critical

# Codex: Full auto mode
codex exec "query" --full-auto                            # 🔴 Critical

# Cursor: Force mode
cursor-agent -p "query" --force                           # 🔴 Critical

# Gemini: YOLO mode
gemini -p "query" --yolo                                  # 🔴 Critical

# Cline: YOLO mode
cline "query" --yolo                                      # 🔴 Critical

# Droid: High autonomy
droid exec "query" --auto high                            # 🟠 Medium-High
```

---

## JSON Output Patterns

### Tools with Full JSON Support

```bash
# Gemini
gemini -p "query" --output-format json | jq '.result'

# Claude
claude -p "query" --output-format json | jq '.result'

# Codex
codex exec "query" --json | jq '.output'

# Droid
droid exec "query" --output-format json | jq '.result'

# Amazon Q
q chat "query" --output json | jq '.response'
```

### JSON Response Structure (Claude Example)

```json
{
  "type": "result",
  "subtype": "success",
  "total_cost_usd": 0.003,
  "is_error": false,
  "duration_ms": 1234,
  "result": "The response text...",
  "session_id": "abc123"
}
```

---

## Common Patterns

### Code Review Pipeline

```bash
# Safe review with multiple tools
git diff origin/main...HEAD | gemini -p "Review for bugs" --output-format json > review.json
git diff origin/main...HEAD | claude -p "Security audit" --output-format json --allowedTools "Read" >> review.json
git diff origin/main...HEAD | droid exec "Check best practices" --auto low --output-format json >> review.json
```

### CI/CD Gatekeeper

```bash
# Strict read-only for CI/CD
claude -p "Audit this PR" \
  --output-format json \
  --permission-mode bypassPermissions \
  --allowedTools "Read,Grep,Glob"

droid exec "Security scan" --auto low --output-format json
```

### Session Management

```bash
# Continue last session
claude --continue "Continue where we left off"
gemini --continue "Next steps"

# Resume specific session
claude --resume abc123 "Continue refactoring"
```

### Batch Processing

```bash
# Process multiple files
for file in src/*.py; do
  claude -p "Add type hints to $file" \
    --permission-mode bypassPermissions \
    --output-format json
done
```

---

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| **Hanging/no output** | Missing skip-confirmation flag | Add `--force`, `--yolo`, or `--permission-mode bypassPermissions` |
| **Auth error** | Missing API key | Set `ANTHROPIC_API_KEY`, `GOOGLE_API_KEY`, `OPENAI_API_KEY` |
| **Context limit** | File too large | Use Gemini (1M tokens) or split input |
| **Permission denied** | Tool restrictions | Check `--allowedTools` or `--auto` level |
| **Rate limited** | API quota exceeded | Wait or use `--fallback-model` |

---

## Environment Variables

```bash
# API Keys
export ANTHROPIC_API_KEY="sk-ant-..."     # Claude
export GOOGLE_API_KEY="..."               # Gemini
export OPENAI_API_KEY="sk-..."            # Codex
export GITHUB_TOKEN="ghp_..."             # Copilot

# Model defaults
export ANTHROPIC_MODEL="claude-sonnet-4-5-20250929"
export GEMINI_MODEL="gemini-3-pro-preview"
```

---

## Quick Links

| Tool | Primary Docs | CLI Reference | GitHub |
|------|--------------|---------------|--------|
| **Gemini** | [geminicli.com/docs](https://geminicli.com/docs/) | [Google Developers](https://developers.google.com/gemini-code-assist/docs/gemini-cli) | [google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli) |
| **Claude** | [docs.anthropic.com](https://docs.anthropic.com/en/docs/claude-code/overview) | [CLI Reference](https://docs.claude.com/en/docs/claude-code/cli-reference) | [anthropics/claude-code](https://github.com/anthropics/claude-code) |
| **Codex** | [developers.openai.com](https://developers.openai.com/codex/) | [CLI Reference](https://developers.openai.com/codex/cli/reference/) | [openai/codex](https://github.com/openai/codex) |
| **Cursor** | [docs.cursor.com](https://docs.cursor.com/en/cli/overview) | [Agent Mode](https://docs.cursor.com/chat/agent) | - |
| **Droid** | [docs.factory.ai](https://docs.factory.ai/cli/getting-started/quickstart) | [Product Page](https://factory.ai/product/cli) | [Factory-AI/factory](https://github.com/Factory-AI/factory) |
| **Copilot** | [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli) | [Usage Guide](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli) | [github/copilot-cli](https://github.com/github/copilot-cli) |
| **Kiro** | [kiro.dev/docs](https://kiro.dev/docs/) | [CLI Docs](https://kiro.dev/docs/cli/) | [kirodotdev/Kiro](https://github.com/kirodotdev/Kiro) |
| **Warp** | [docs.warp.dev](https://docs.warp.dev) | [AI Features](https://docs.warp.dev/features/warp-ai) | [warpdotdev/Warp](https://github.com/warpdotdev/Warp) |
| **Windsurf** | [docs.windsurf.com](https://docs.windsurf.com/) | [Editor](https://windsurf.com/editor) | - |
| **Aider** | [aider.chat/docs](https://aider.chat/docs/) | [Main Site](https://aider.chat/) | [Aider-AI/aider](https://github.com/Aider-AI/aider) |
| **Continue** | [docs.continue.dev](https://docs.continue.dev/quickstart) | [CLI Guide](https://docs.continue.dev/guides/cli) | [continuedev/continue](https://github.com/continuedev/continue) |
| **Cline** | [docs.cline.bot](https://docs.cline.bot/cline-cli/overview) | [Main Site](https://cline.bot/) | [cline/cline](https://github.com/cline/cline) |
| **Amazon Q** | [AWS Docs](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html) | [CLI Reference](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-reference.html) | [aws/amazon-q-developer-cli](https://github.com/aws/amazon-q-developer-cli) |
| **OpenCode** | [opencode.ai/docs](https://opencode.ai/docs/) | [CLI Docs](https://opencode.ai/docs/cli/) | [sst/opencode](https://github.com/sst/opencode) |

---

## See Also

- **Full Tool Guides:** [`tools/major/`](tools/major/)
- **CI/CD Examples:** [`examples/ci-cd/`](examples/ci-cd/)
- **Automation Scripts:** [`examples/automation/`](examples/automation/)
- **Test Scripts:** [`test/`](test/)
- **Contributing:** [`CONTRIBUTING.md`](CONTRIBUTING.md)

---

**Last Updated:** November 2025
**Tools Documented:** 14 (all verified)
**Maintainer:** [headless-ai-cli](https://github.com/oimiragieo/headless-ai-cli)
