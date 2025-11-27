# ⚡ AI CLI Quick Reference Cheat Sheet

**Ultra-condensed reference for daily use**

---

## 🎯 Tool Selection (10 seconds)

```
1M+ tokens?        → Gemini
Deep reasoning?    → Claude Opus
UI generation?     → Codex
CI/CD safe?        → Droid
GitHub?            → Copilot
IDE dev?           → Kiro
Terminal?          → Warp
Default:           → Claude Sonnet
```

---

## 📦 Installation (One-liners)

```bash
# Major Tools
npm install -g @google/gemini-cli @anthropic-ai/claude-code @openai/codex @github/copilot
curl https://cursor.com/install -fsS | bash
curl -fsSL https://app.factory.ai/cli | sh

# Pair Programming
pip install aider-chat

# CLI Tools
npm install -g @continuedev/cli

# Kiro CLI (headless)
curl -fsSL https://cli.kiro.dev/install | bash
kiro-cli login

# IDEs (download)
# Kiro IDE: https://kiro.help/docs
# Windsurf: https://windsurf.com
# Warp: https://warp.dev (macOS: brew install --cask warp)
```

---

## 🚀 Quick Commands

### Gemini
```bash
gemini -p "query" --output-format json --model gemini-3-pro-preview
```

### Claude
```bash
claude -p "query" --output-format json --model claude-opus-4-5 --allowedTools "Bash,Read"
```

### Codex
```bash
codex exec "query" --full-auto --json
```

### Cursor
```bash
cursor-agent -p --force --output-format json "query"
```

### Droid
```bash
droid exec --auto low "query" --output-format json
```

### Copilot
```bash
copilot -p "query" --allow-all-tools
```

### Aider
```bash
aider --model gpt-4o --api-key openai=key
```

### Continue Dev
```bash
cn  # Interactive TUI
continue headless --agent "name"  # Headless
```

### Kiro
```bash
# CLI Installation
curl -fsSL https://cli.kiro.dev/install | bash
kiro-cli login
# Select "Use with Builder ID"
# Enter device code in browser

# Interactive chat mode (required - Kiro doesn't support direct command execution)
kiro-cli chat
# Then type commands in chat: > Install project dependencies

# Custom agent
kiro-cli chat --agent frontend-specialist
# OR
kiro-cli --agent frontend-specialist chat
```

---

## 📊 Tool Matrix

| Tool | Context | Speed | Risk | Headless | JSON |
|------|---------|-------|------|----------|------|
| Gemini | 1M | ★★★ | 🟠 | ✔ | ✔ |
| Claude | 200K | ★★★ | 🟢 | ✔ | ✔ |
| Codex | Med | ★★★★ | 🟠 | ✔ | ✔ |
| Cursor | Med | ★★★ | ⚠️ | ✔ | ✔ |
| Droid | Med | ★★ | 🟢 | ✔ | ✔ |
| Copilot | Med | ★★★ | ⚡ | ⚠️ | ⚠️ |
| Kiro | Med | ★★★ | 🟠 | ✔ | ✔ |
| Warp | N/A | ★★★★ | 🟢 | N/A | N/A |
| Aider | Med | ★★★ | 🟠 | ⚠️ | ❌ |
| Continue | Med | ★★★ | 🟢 | ✔ | ✔ |

---

## 🔧 Common Patterns

### Headless
```bash
tool -p "query"                    # Direct
echo "query" | tool                # Stdin
git diff | tool -p "Review"         # Pipe
```

### JSON Output
```bash
tool -p "query" --output-format json | jq '.result'
```

### Session Resume
```bash
tool --continue "Next"             # Last session
tool --resume <id> "Continue"      # By ID
```

### Model Selection
```bash
--model gemini-3-pro-preview       # Gemini
--model claude-opus-4-5            # Claude
--model gpt-5.1-codex-max          # Codex
```

---

## 🛡️ Security Flags

| Tool | Read-only | Enable Writes |
|------|-----------|---------------|
| Droid | Default | `--auto low/medium/high` |
| Codex | Default | `--full-auto` |
| Cursor | Default | `--force` |
| Claude | Approval | `--allowedTools` |
| Copilot | Approval | `--allow-all-tools` |
| Gemini | Can modify | `--yolo` |

---

## 🎯 Use Cases

| Task | Tool | Command |
|------|------|---------|
| **Code review** | Gemini/Droid | `gemini -p "Review"` or `droid exec "Review"` |
| **UI gen** | Codex | `codex exec "Create component"` |
| **Architecture** | Claude Opus | `claude -p "Design" --model claude-opus-4-5` |
| **CI/CD** | Droid | `droid exec --auto low "Audit"` |
| **Workflows** | Cursor | `cursor-agent -p --force "Plan, code, test"` |
| **GitHub PRs** | Copilot | `copilot -p "Review PR #123"` |
| **Pair prog** | Aider | `aider --model gpt-4o` |
| **IDE dev** | Kiro | CLI: `kiro-cli chat` (interactive) or IDE chat |

---

## 📝 Output Formats

| Tool | Text | JSON | Stream | Delta |
|------|------|------|--------|-------|
| Gemini | ✔ | ✔ | ✔ | ❌ |
| Claude | ✔ | ✔ | ✔ | ❌ |
| Codex | ✔ | ✔ | ✔ | ✔ |
| Cursor | ✔ | ✔ | ✔ | ✔ |
| Droid | ✔ | ✔ | ✔ (debug) | ❌ |
| Copilot | ✔ | ⚠️ | ⚠️ | ❌ |

---

## 🔗 Quick Links

- **Full Guide:** `claude.md`
- **Comprehensive:** `COMPREHENSIVE.md`
- **Tool Docs:** `tools/major/`
- **Examples:** `examples/ci-cd/`, `examples/automation/`
- **Contributing:** `CONTRIBUTING.md`

---

**Last Updated:** November 2025  
**Tools:** 12 major tools documented (100%)  
**Status:** 14 non-existent tools verified and removed - see VERIFICATION_STATUS.md for details

