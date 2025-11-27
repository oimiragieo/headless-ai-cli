# 🚀 AI CLI Quick Reference (`simple.md`)

Quick reference guide for AI model CLIs: **Gemini**, **Claude**, **Codex**, **Cursor**, **Copilot**, **Droid**, **Kiro**, and **Warp**.

---

## 🎯 Quick Decision Tree

```text
Huge context (1M+ tokens)?     → Gemini
Deepest reasoning?              → Claude Opus
UI/front-end generation?        → Codex
Workflow automation?            → Cursor
CI/CD-safe runs?               → Droid
GitHub integration?            → Copilot
Daily coding?                   → Claude Sonnet
IDE-based development?          → Kiro
Enhanced terminal experience?   → Warp
```

---

## 📊 Tool Comparison

| Tool | Context | Speed | Reasoning | Risk | Best For |
|------|---------|-------|-----------|------|----------|
| **Gemini** | 1M tokens | ★★★ | ★★ | 🟠 Medium | Massive repos |
| **Claude Opus** | 200K | ★★ | ★★★★★ | 🟢 Low | Deep reasoning |
| **Claude Sonnet** | 200K | ★★★ | ★★★★ | 🟢 Low | Daily coding |
| **Codex** | Medium | ★★★★ | ★★★ | 🟠 Medium | UI generation |
| **Cursor** | Medium | ★★★ | ★★★ | ⚠️ High | Workflows |
| **Droid** | Medium | ★★ | ★★ | 🟢 Low | CI/CD safe |
| **Copilot** | Medium | ★★★ | ★★★ | ⚡ High | GitHub PRs |
| **Kiro** | Medium | ★★★ | ★★★★ | 🟠 Medium | IDE-based, spec-driven |
| **Warp** | N/A | ★★★★ | ★★ | 🟢 Low | Terminal enhancement |

---

## 🚀 Installation

```bash
npm install -g @google/gemini-cli
npm install -g @anthropic-ai/claude-code
npm install -g @openai/codex
npm install -g @github/copilot
curl https://cursor.com/install -fsS | bash
curl -fsSL https://app.factory.ai/cli | sh

# Kiro (IDE - download from kiro.help)
# Visit https://kiro.help/docs for installation

# Warp (Terminal)
# macOS: brew install --cask warp
# Visit https://warp.dev for other platforms
```

---

## 📝 Quick Commands

### Gemini
```bash
gemini -p "Summarize this repo"
gemini -p "query" --output-format json
gemini -p "query" --model gemini-2.5-flash
```

### Claude
```bash
claude -p "Explain this code"
claude -p "query" --output-format json
claude -p "query" --model claude-opus-4-1
claude -p "query" --allowedTools "Bash,Read"
claude --resume <session-id> "Continue"
```

### Codex
```bash
codex exec "generate a unit test"
codex exec --full-auto "Refactor code"
codex exec --json "query" | jq
codex exec resume --last "Continue"
codex exec "query" --output-schema schema.json -o output.json
```

### Cursor
```bash
export CURSOR_API_KEY=your_key
cursor-agent -p "what does this file do?"
🚨 cursor-agent -p --force "Refactor code"
cursor-agent -p --output-format json "query"
```

### Copilot
```bash
copilot -p "Review this code"
copilot -p "query" --allow-all-tools
copilot -p "query" --deny-tool 'shell(rm)'
```

### Droid
```bash
export FACTORY_API_KEY=fk-...
🛟 droid exec "analyze code quality"
droid exec --auto low "add JSDoc comments"
droid exec --auto medium "install deps, run tests"
droid exec --auto high "fix bug, commit, push"
droid exec "query" --output-format json
```

### Kiro
```bash
# Kiro is primarily an IDE, use integrated terminal
# Open Kiro IDE and use chat interface for AI assistance
# Configure agent hooks for automated tasks
```

### Warp
```bash
# Warp is a terminal emulator - enhances all CLI tools
# Use natural language: "Show me all Python files modified last week"
# Warp AI suggests: git log --since="1 week ago" --name-only -- "*.py"
# Works seamlessly with all AI CLI tools above
```

---

## 🔧 Common Patterns

### Headless Mode (All Tools)
```bash
# Direct prompt
tool -p "Your prompt"

# Stdin
echo "prompt" | tool

# File input
cat file.txt | tool -p

# Pipe git diff
git diff | tool -p "Review changes"
```

### JSON Output
```bash
tool -p "query" --output-format json | jq -r '.result'
```

### Session Management
```bash
# Claude/Codex: Resume last
tool --continue "Next step"
tool resume --last "Continue"

# Resume by ID
tool --resume <session-id> "Continue"
```

---

## 🛡️ Security & Permissions

| Tool | Default | Enable Writes | Risk Level |
|------|---------|---------------|------------|
| **Droid** | Read-only | `--auto low/medium/high` | 🟢 Low |
| **Codex** | Read-only | `--full-auto` or `--sandbox danger-full-access` | 🟠 Medium |
| **Cursor** | Propose only | `--force` | ⚠️ High |
| **Claude** | Approval required | `--allowedTools` | 🟢 Low |
| **Copilot** | Approval required | `--allow-all-tools` | ⚡ High |
| **Gemini** | Can modify | `--yolo` (auto-approve) | 🟠 Medium |
| **Kiro** | IDE-based | Agent hooks, terminal integration | 🟠 Medium |
| **Warp** | Terminal | N/A (enhances other tools) | 🟢 Low |

---

## 📤 Output Formats

| Tool | Text | JSON | Stream JSON | Delta Stream |
|------|------|------|-------------|--------------|
| **Gemini** | ✔ | ✔ | ✔ | ❌ |
| **Claude** | ✔ | ✔ | ✔ | ❌ |
| **Codex** | ✔ | ✔ | ✔ | ✔ |
| **Cursor** | ✔ | ✔ | ✔ | ✔ |
| **Droid** | ✔ | ✔ | ✔ (debug) | ❌ |
| **Copilot** | ✔ | ⚠️ | ⚠️ | ❌ |
| **Kiro** | ✔ | ⚠️ | ⚠️ | ❌ |
| **Warp** | N/A | N/A | N/A | N/A |

---

## 🎯 Use Cases by Task

| Task | Tool | Command |
|------|------|---------|
| **Code review** | Gemini/Droid | `gemini -p "Review changes"` or `droid exec "Review PR"` |
| **UI generation** | Codex | `codex exec "Create React button component"` |
| **Architecture** | Claude Opus | `claude -p "Design API" --model claude-opus-4-1` |
| **CI/CD automation** | Droid | `droid exec --auto low "Run security audit"` |
| **Workflow chains** | Cursor | `cursor-agent -p --force "Plan, code, test"` |
| **GitHub PRs** | Copilot | `copilot -p "Review PR #123"` |
| **Large repos** | Gemini | `gemini -p "Analyze entire codebase"` |
| **IDE development** | Kiro | Open Kiro IDE, use chat interface |
| **Terminal enhancement** | Warp | Use with any CLI tool for better experience |

---

## 👥 By Role

| Role | Best Tools | Example |
|------|------------|---------|
| **Backend** | Claude Sonnet, Gemini | `claude -p "Review API endpoint"` |
| **Frontend** | Codex, Copilot | `codex exec "Create React component"` |
| **SRE/DevOps** | Droid, Claude | `droid exec "Diagnose incident"` |
| **AI/ML** | Claude Opus, Gemini | `claude -p "Design architecture" --model claude-opus-4-1` |
| **PM/Designer** | Codex, Copilot | `codex exec "Create user flow"` |
| **Data Engineer** | Gemini, Claude Sonnet | `gemini -p "Review ETL pipeline"` |
| **Security** | Claude, Droid | `droid exec "Audit for SQL injection"` |
| **IDE User** | Kiro, Cursor | IDE-based development with AI |
| **Terminal Power User** | Warp | Enhanced CLI experience |

---

## 💰 Cost & Speed

| Model | Cost | Speed | Best For |
|-------|------|-------|----------|
| **Claude Haiku** | 💰 Low | ⚡ Fast | Quick tasks |
| **Gemini Flash** | 💰 Low-Med | ⚡ Fast | Large context, quick |
| **Claude Sonnet** | 💰💰 Med | ⚡⚡ Med | Daily coding |
| **Gemini Pro** | 💰💰 Med-High | ⚡⚡ Med | Massive repos |
| **Claude Opus** | 💰💰💰 High | ⚡ Slow | Deep reasoning |
| **Codex** | 💰💰 Med | ⚡⚡⚡ Fast | UI generation |
| **Kiro** | 💰💰 Med | ⚡⚡ Med | IDE-based development |
| **Warp** | 💰💰 Med | ⚡⚡⚡ Fast | Terminal enhancement |

---

## 🔍 Model Selection

### By Context Size
- **1M+ tokens**: Gemini only
- **200K tokens**: Claude Opus/Sonnet
- **Medium**: Codex, Cursor, Copilot, Droid

### By Reasoning Depth
- **Deepest**: Claude Opus
- **Balanced**: Claude Sonnet, Gemini
- **Fast**: Codex, Claude Haiku

### By Task Type
- **UI/Prototyping**: Codex, Copilot
- **Code Review**: Gemini, Droid
- **Architecture**: Claude Opus
- **CI/CD**: Droid, Gemini (headless)
- **Workflows**: Cursor, Droid
- **IDE Development**: Kiro
- **Terminal Enhancement**: Warp

---

## ⚙️ Configuration

### Model Selection
```bash
gemini -p "query" --model gemini-2.5-pro
claude -p "query" --model claude-opus-4-1
codex exec "query" --model gpt-5-codex
droid exec "query" -m claude-sonnet-4-20250514
```

### Default Models
- Gemini: `gemini-2.5-pro`
- Claude: `claude-sonnet-4.5`
- Codex: `gpt-5-codex` (aliases to `gpt-5-codex-latest`)
- Droid: `gpt-5-codex` (configurable)
- Copilot: Claude Sonnet 4 (may switch to GPT-4.1)

---

## 🚨 Risk Levels

- 🟢 **Low**: Droid (read-only), Claude (approval), Warp (terminal)
- 🟠 **Medium**: Gemini, Codex (sandbox), Kiro (IDE with agents)
- ⚠️ **High**: Cursor (`--force` required)
- ⚡ **High**: Copilot (can run shell/git)

---

## 📋 Common Workflows

### Code Review
```bash
git diff | gemini -p "Review for bugs and security" --output-format json
```

### UI Generation
```bash
codex exec "Create React + Tailwind button component"
```

### CI/CD Automation
```bash
droid exec --auto low "Run security audit" --output-format json
```

### Multi-step Task
```bash
codex exec "Analyze structure"
codex exec resume --last "Generate plan"
codex exec resume --last "Create checklist"
```

### Batch Processing
```bash
find src -name "*.ts" | xargs -I {} \
  droid exec --auto low "Refactor {} to use TypeScript patterns"
```

---

## 🔧 Troubleshooting

| Error | Solution |
|-------|----------|
| **Tool not approved** | Use `--allowedTools` (Claude), `--auto` (Droid), `--force` (Cursor), `--full-auto` (Codex) |
| **Context limit exceeded** | Use Gemini for massive repos, or split tasks |
| **Git repo required** | `git init` or use `--skip-git-repo-check` (Codex) |
| **JSON parsing fails** | Use `jq -r '.result'` to extract fields |
| **Session ID not found** | Use `--continue` or `resume --last` |

---

## 📌 Version Pinning (CI/CD)

```bash
npm install -g @anthropic-ai/claude-code@1.9.3
npm install -g @openai/codex@2.2.0
npm install -g @google/gemini-cli@3.1.0
npm install -g @github/copilot@0.0.329
```

---

## 🎯 Quick Examples

### Gemini
```bash
gemini -p "Summarize repo"
gemini -p "Review code" --output-format json | jq '.response'
```

### Claude
```bash
claude -p "Explain code"
claude -p "query" --model claude-opus-4-1
claude --resume <id> "Continue"
```

### Codex
```bash
codex exec "generate unit test"
codex exec --full-auto "Refactor auth"
codex exec --json "query" | jq
```

### Cursor
```bash
🚨 cursor-agent -p --force "Refactor to ES6+"
cursor-agent -p --output-format json "Review"
```

### Copilot
```bash
copilot -p "Review PR #123"
copilot -p "query" --allow-all-tools
```

### Droid
```bash
🛟 droid exec "analyze code"
droid exec --auto low "add comments"
droid exec "query" --output-format json
```

---

## ⚡ Proven Approaches

- Match model to task (don't always pick largest)
- Use structured output (JSON) for automation
- Check exit codes in CI/CD
- Use read-only modes when possible
- Pin versions in production
- Use retry logic with exponential backoff

---

## 🔗 Quick Links

- [Gemini CLI](https://developers.google.com/gemini-code-assist/docs/gemini-cli)
- [Claude Code](https://code.claude.com/docs/en/headless.md)
- [Codex SDK](https://developers.openai.com/codex/sdk)
- [Cursor CLI](https://cursor.com/docs/cli/headless)
- [Copilot CLI](https://docs.github.com/en/copilot/cli)
- [Droid Exec](https://docs.factory.ai/cli/droid-exec/overview.md)
- [Kiro AI IDE](https://kiroai.ai)
- [Kiro Documentation](https://kiro.help/docs)
- [Warp Terminal](https://www.warp.dev)
- [Warp Documentation](https://docs.warp.dev)

---

**Icon Legend:**
- 🚨 = Dangerous (requires caution)
- 🛟 = Safe-by-default (read-only)
- ⚙️ = Required configuration
- ⭐ = Proven approach

**Version:** 1.0 (Quick Reference)  
**Last Updated:** November 2025
