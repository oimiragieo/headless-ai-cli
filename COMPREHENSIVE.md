# 🧠 Comprehensive AI CLI Reference Guide

**Complete documentation for all AI CLI agents, tools, and assistants**

This is the definitive single-file reference for 12 verified AI CLI tools, with comprehensive headless usage instructions, model information, and integration examples.

---

## 📋 Table of Contents

- [Executive Summary](#-executive-summary)
- [Quick Decision Tree](#-quick-decision-tree)
- [Tool Comparison Tables](#-tool-comparison-tables)
- [Major Tools (12)](#-major-tools-12)
- [Common Patterns](#-common-patterns)
- [CI/CD Integration](#-cicd-integration)
- [Model Selection Guide](#-model-selection-guide)
- [References](#-references)

---

## 📄 Executive Summary

**Quick reference for choosing the right tool:**

### By Task Type

| Task | Best Tool | Alternative |
|------|-----------|-------------|
| **Massive repos (1M+ tokens)** | Gemini | - |
| **Deep reasoning** | Claude Opus | Claude Sonnet |
| **UI generation** | Codex | Copilot |
| **Workflow automation** | Cursor | Droid |
| **CI/CD safe** | Droid | Gemini (headless) |
| **GitHub integration** | Copilot | - |
| **IDE-based dev** | Kiro | Windsurf, Continue Dev |
| **Terminal enhancement** | Warp | - |
| **Pair programming** | Aider | Continue Dev |
| **AWS integration** | Amazon Q | - |

### By Risk Level

- 🟢 **Low Risk:** Droid, Claude, Warp
- 🟠 **Medium Risk:** Gemini, Codex, Kiro, Aider, Continue Dev, Windsurf
- ⚠️ **High Risk:** Cursor, Copilot

### Installation Quick Start

```bash
# Major Tools
npm install -g @google/gemini-cli
npm install -g @anthropic-ai/claude-code
npm install -g @openai/codex
npm install -g @github/copilot
curl https://cursor.com/install -fsS | bash
curl -fsSL https://app.factory.ai/cli | sh

# Pair Programming
pip install aider-chat

# CLI Tools
npm install -g @continuedev/cli

# IDEs (download from official sites)
# Kiro: https://kiro.help/docs
# Windsurf: https://windsurf.com
# Warp: https://warp.dev
```

---

## 🎯 Quick Decision Tree

```
Need massive context (1M+ tokens)?
  → Gemini

Need deepest reasoning?
  → Claude Opus

Need UI/front-end generation?
  → Codex or Copilot

Need workflow automation?
  → Cursor or Droid

Need CI/CD-safe runs?
  → Droid

Need GitHub integration?
  → Copilot

Need IDE-based development?
  → Kiro, Windsurf, or Continue Dev

Need terminal enhancement?
  → Warp

Need pair programming?
  → Aider or Continue Dev

Need AWS integration?
  → Amazon Q Developer

Default: Claude Sonnet (balanced)
```

---

## 📊 Tool Comparison Tables

### Performance Comparison

| Tool | Speed | Reasoning | Context | Safety | Best For |
|------|-------|-----------|---------|--------|----------|
| **Gemini** | ★★★ | ★★ | ★★★★★ | ★★★ | Massive repos |
| **Claude Opus** | ★★ | ★★★★★ | ★★ | ★★★★ | Deep reasoning |
| **Claude Sonnet** | ★★★ | ★★★★ | ★★ | ★★★★ | Daily coding |
| **Codex** | ★★★★ | ★★★ | ★★ | ★★ | UI generation |
| **Cursor** | ★★★ | ★★★ | ★★ | ★★ | Workflows |
| **Droid** | ★★ | ★★ | ★★ | ★★★★★ | CI/CD safe |
| **Copilot** | ★★★ | ★★★ | ★★ | ★ | GitHub integration |
| **Kiro** | ★★★ | ★★★★ | ★★ | ★★★ | IDE-based dev |
| **Warp** | ★★★★ | ★★ | N/A | ★★★★★ | Terminal |
| **Aider** | ★★★ | ★★★ | ★★ | ★★★ | Pair programming |
| **Continue Dev** | ★★★ | ★★★ | ★★ | ★★★ | VS Code + CLI |
| **Windsurf** | ★★★ | ★★★ | ★★ | ★★★ | AI-powered IDE |
| **Amazon Q** | ★★★ | ★★★ | ★★ | ★★★ | AWS integration |

### Feature Matrix

| Tool | Headless | JSON | Streaming | File Edits | CI/CD Safe | Models |
|------|----------|------|-----------|------------|------------|--------|
| **Gemini** | ✔ | ✔ | ✔ | ✔ | ✔ | Gemini 2.5 |
| **Claude** | ✔ | ✔ | ✔ | ✔ | ⚠️ | Claude 3/4 |
| **Codex** | ✔ | ✔ | ✔ | ✔ | ⚠️ | GPT-5 Codex |
| **Cursor** | ✔ | ✔ | ✔ | ✔ (--force) | ⚠️ | Multiple |
| **Droid** | ✔ | ✔ | ✔ (debug) | via auto | ✔ | Multiple |
| **Copilot** | ⚠️ | ⚠️ | ❌ | ✔ | ⚠️ | Claude/GPT |
| **Kiro** | ⚠️ | ❌ | ❌ | ✔ | ⚠️ | Claude (Bedrock) |
| **Warp** | N/A | ❌ | ❌ | ❌ | ✔ | N/A |
| **Aider** | ⚠️ | ❌ | ❌ | ✔ | ⚠️ | Multiple |
| **Continue Dev** | ✔ | ✔ | ❌ | ✔ | ⚠️ | Multiple |
| **Windsurf** | ⚠️ | ❌ | ❌ | ✔ | ⚠️ | Multiple |
| **Amazon Q** | ✔ | ⚠️ | ❌ | ✔ | ⚠️ | Claude (Bedrock) |

---

## 🚀 Major Tools (12)

### Production-Ready AI CLI Agents

#### 1. Google Gemini CLI
**Best for:** Massive repos, large-scale analysis  
**Context:** 1M+ tokens  
**Risk:** 🟠 Medium

**Quick Start:**
```bash
npm install -g @google/gemini-cli
gemini -p "Summarize this repo"
```

**See:** `tools/major/gemini.md` for detailed documentation

#### 2. Anthropic Claude (Claude Code)
**Best for:** Deep reasoning, architecture, daily coding  
**Context:** 200K tokens  
**Risk:** 🟢 Low

**Quick Start:**
```bash
npm install -g @anthropic-ai/claude-code
claude -p "Explain this code"
```

**See:** `tools/major/claude.md` for detailed documentation

#### 3. OpenAI Codex
**Best for:** UI generation, rapid prototyping  
**Context:** Medium  
**Risk:** 🟠 Medium

**Quick Start:**
```bash
npm install -g @openai/codex
codex exec "generate a unit test"
```

**See:** `tools/major/codex.md` for detailed documentation

#### 4. Cursor Agent
**Best for:** Workflow automation, chained tasks  
**Context:** Medium  
**Risk:** ⚠️ High

**Quick Start:**
```bash
curl https://cursor.com/install -fsS | bash
cursor-agent -p "what does this file do?"
```

**See:** `tools/major/cursor.md` for detailed documentation

#### 5. GitHub Copilot CLI
**Best for:** GitHub integration, PR management  
**Context:** Medium  
**Risk:** ⚡ Very High

**Quick Start:**
```bash
npm install -g @github/copilot
copilot -p "Review this code for bugs"
```

**See:** `tools/major/copilot.md` for detailed documentation

#### 6. Factory AI Droid
**Best for:** CI/CD-safe automation, production  
**Context:** Medium  
**Risk:** 🟢 Very Low

**Quick Start:**
```bash
curl -fsSL https://app.factory.ai/cli | sh
droid exec "analyze this folder"
```

**See:** `tools/major/droid.md` for detailed documentation

#### 7. Kiro (AI-Powered IDE)
**Best for:** Spec-driven development, IDE-based workflows, CLI automation  
**Context:** Medium  
**Risk:** 🟠 Medium

**Quick Start (CLI - Interactive Chat Mode):**
```bash
# Install Kiro CLI
curl -fsSL https://cli.kiro.dev/install | bash

# Authenticate
kiro-cli login
# Select "Use with Builder ID"
# Enter device code in browser

# Start interactive chat
kiro-cli chat
# Then type commands in the chat interface
```

**Quick Start (IDE):**
```bash
# Download from https://kiro.help/docs
# Open Kiro IDE and use integrated terminal
```

**See:** `tools/major/kiro.md` for detailed documentation

#### 8. Warp Terminal
**Best for:** Terminal enhancement, CLI tool integration  
**Context:** N/A  
**Risk:** 🟢 Low

**Quick Start:**
```bash
# macOS: brew install --cask warp
# Visit https://warp.dev for other platforms
```

**See:** `tools/major/warp.md` for detailed documentation

#### 9. Aider
**Best for:** AI pair programming, Git-based editing  
**Context:** Medium  
**Risk:** 🟠 Medium

**Quick Start:**
```bash
pip install aider-chat
aider --model gpt-4o
```

**See:** `tools/major/aider.md` for detailed documentation

#### 10. Continue Dev
**Best for:** VS Code + CLI, continuous AI workflows  
**Context:** Medium  
**Risk:** 🟢 Low

**Quick Start:**
```bash
npm install -g @continuedev/cli
cn
```

**See:** `tools/major/continue-dev.md` for detailed documentation

#### 11. Windsurf
**Best for:** AI-powered IDE with CLI capabilities  
**Context:** Medium  
**Risk:** 🟠 Medium

**Quick Start:**
```bash
# Download from https://windsurf.com
# Use integrated terminal for CLI operations
```

**See:** `tools/major/windsurf.md` for detailed documentation

#### 12. Amazon Q Developer
**Best for:** AWS integration, GitHub code reviews  
**Context:** Medium  
**Risk:** 🟢 Low

**Quick Start:**
```bash
aws configure
aws q --help
```

**See:** `tools/major/amazon-q.md` for detailed documentation

---


---

## 🔧 Common Patterns

### Headless Mode

All tools support headless mode for automation:

```bash
# Direct prompt
tool -p "Your prompt"

# Stdin input
echo "prompt" | tool

# File input
cat file.txt | tool -p

# With pipes
git diff | tool -p "Review changes"
```

### JSON Output

Most tools support JSON for automation:

```bash
tool -p "query" --output-format json | jq '.result'
```

### Session Management

Resume conversations:

```bash
tool --continue "Next step"
tool --resume <session-id> "Continue"
```

### Model Selection

```bash
# Gemini
gemini -p "query" --model gemini-2.5-pro

# Claude
claude -p "query" --model claude-opus-4-1

# Codex
codex exec "query" --model gpt-5-codex
```

---

## 🚀 CI/CD Integration

### GitHub Actions Example

```yaml
name: AI Code Review
on: [pull_request]
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Gemini Review
        run: |
          npm install -g @google/gemini-cli
          git diff origin/main...HEAD | \
            gemini -p "Review changes" --output-format json
```

**See:** `examples/ci-cd/` for more examples

---

## 🎯 Model Selection Guide

### By Context Size
- **1M+ tokens:** Gemini
- **200K tokens:** Claude Opus/Sonnet
- **Medium:** Codex, Cursor, Copilot, Droid, others

### By Reasoning Depth
- **Deepest:** Claude Opus
- **Balanced:** Claude Sonnet, Gemini
- **Fast:** Codex, Claude Haiku

### By Task Type
- **Code review:** Gemini, Droid
- **UI generation:** Codex, Copilot
- **Architecture:** Claude Opus
- **Daily coding:** Claude Sonnet
- **CI/CD:** Droid

---

## 📚 References

### Official Documentation
- [Gemini CLI Docs](https://developers.google.com/gemini-code-assist/docs/gemini-cli)
- [Claude Code Docs](https://code.claude.com/docs)
- [Codex Documentation](https://openai.com/research/codex)
- [Cursor Documentation](https://cursor.com/docs)
- [Copilot CLI Docs](https://docs.github.com/en/copilot/cli)
- [Droid Exec Docs](https://docs.factory.ai/cli/droid-exec)
- [Aider Documentation](https://aider.chat)
- [Continue Dev Docs](https://docs.continue.dev)
- [Kiro Documentation](https://kiro.help/docs)
- [Warp Documentation](https://docs.warp.dev)

### Repository Files
- **Main Guide:** `claude.md` (detailed guide for 8 tools)
- **Quick Reference:** `simple.md`
- **Tool Files:** `tools/major/`
- **Examples:** `examples/ci-cd/`, `examples/automation/`, `examples/workflows/`
- **Contributing:** `CONTRIBUTING.md`

---

## 📝 Notes

- **Placeholder Tools:** All 14 placeholder tools researched - verification failed (see VERIFICATION_STATUS.md)
- **Version Tracking:** Check individual tool files for latest versions
- **Contributions:** See `CONTRIBUTING.md` for adding/updating tools
- **Progress:** See `PROGRESS.md` for implementation status
- **Verification:** See `VERIFICATION_STATUS.md` for detailed verification results
- **Completion:** See `COMPLETION_REPORT.md` for full task completion report

---

**Last Updated:** November 2025  
**Total Tools Documented:** 12 (all major tools)  
**Status:** 
- ✅ Major tools: 12 fully documented (100%)
- ✅ Non-existent tools: 14 placeholder tools removed after verification
- 📝 See VERIFICATION_STATUS.md for verification details

