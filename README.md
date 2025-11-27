# 🧠 AI CLI Reference Repository

A comprehensive quick reference guide repository for all AI CLI agents, featuring headless syntax, features, and available models for 12 verified tools.

## 📋 Overview

This repository serves as the definitive source of truth for developers integrating AI capabilities into automated workflows, CI/CD pipelines, and scripting environments. It documents every major AI CLI agent available, with comprehensive headless usage instructions.

## 🎯 Quick Decision Tree

**10-second guide to choosing the right tool:**

```text
Huge context (1M+ tokens)?           → Gemini
Deepest reasoning?                    → Claude Opus
UI/front-end generation?              → Codex
Workflow automation?                  → Cursor
CI/CD-safe deterministic runs?        → Droid
GitHub integration?                   → Copilot
Daily coding?                          → Claude Sonnet
IDE-based development?                 → Kiro
Enhanced terminal experience?          → Warp
```

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

## 🚀 Installation Quick Start

### Major Tools

```bash
# Gemini
npm install -g @google/gemini-cli

# Claude
npm install -g @anthropic-ai/claude-code

# Codex
npm install -g @openai/codex

# Cursor
curl https://cursor.com/install -fsS | bash

# Copilot
npm install -g @github/copilot

# Droid
curl -fsSL https://app.factory.ai/cli | sh

# Kiro (IDE - download from kiro.help)
# Visit https://kiro.help/docs for installation

# Warp (Terminal)
# macOS: brew install --cask warp
# Visit https://warp.dev for other platforms
```

## 📚 Documentation Structure

```
headless-ai-cli/
├── README.md                    # This file - main index
├── COMPREHENSIVE.md             # Single comprehensive guide (all tools)
├── QUICK_REFERENCE.md           # Condensed quick reference
├── claude.md                    # Original comprehensive guide
├── simple.md                    # Quick reference guide
├── gpt-5.1.md                   # Alternative comprehensive guide
├── tools/
│   ├── TEMPLATE.md              # Documentation template
│   ├── major/                    # Production-ready tools
│   │   ├── gemini.md
│   │   ├── claude.md
│   │   ├── codex.md
│   │   ├── cursor.md
│   │   ├── copilot.md
│   │   ├── droid.md
│   │   ├── kiro.md
│   │   └── warp.md
│   ├── emerging/                # Newer/emerging tools
│   └── specialized/             # Specialized/niche tools
└── examples/
    ├── ci-cd/                   # CI/CD integration examples
    ├── automation/              # Automation scripts
    └── workflows/               # Common workflows
```

## 📖 Documentation Files

### Main Guides

- **[COMPREHENSIVE.md](COMPREHENSIVE.md)** - Single comprehensive guide with all tools
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Ultra-condensed cheat sheet
- **[INDEX.md](INDEX.md)** - Complete navigation index for all tools
- **[claude.md](claude.md)** - Detailed guide for 8 major tools
- **[simple.md](simple.md)** - Quick reference guide
- **[gpt-5.1.md](gpt-5.1.md)** - Alternative comprehensive guide
- **[VERIFICATION_CHECKLIST.md](VERIFICATION_CHECKLIST.md)** - Checklist for verifying placeholder tools
- **[VERIFICATION_STATUS.md](VERIFICATION_STATUS.md)** - Verification results and status report
- **[COMPLETION_REPORT.md](COMPLETION_REPORT.md)** - Complete task completion report
- **[FINAL_SUMMARY.md](FINAL_SUMMARY.md)** - Final summary and status
- **[REPOSITORY_STATUS.md](REPOSITORY_STATUS.md)** - Current repository status and statistics
- **[PROGRESS.md](PROGRESS.md)** - Implementation progress tracking
- **[SUMMARY.md](SUMMARY.md)** - Implementation summary
- **[CHANGELOG.md](CHANGELOG.md)** - Changelog
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines

### Individual Tool Documentation

Individual tool documentation is available in `tools/major/` directory.

**Major Tools (12 files):**
- `tools/major/gemini.md` - Google Gemini CLI
- `tools/major/claude.md` - Anthropic Claude (Claude Code)
- `tools/major/codex.md` - OpenAI Codex
- `tools/major/cursor.md` - Cursor Agent
- `tools/major/copilot.md` - GitHub Copilot CLI
- `tools/major/droid.md` - Factory AI Droid
- `tools/major/kiro.md` - Kiro (AI-Powered IDE)
- `tools/major/warp.md` - Warp Terminal
- `tools/major/aider.md` - Aider (AI pair programming)
- `tools/major/continue-dev.md` - Continue Dev
- `tools/major/windsurf.md` - Windsurf IDE
- `tools/major/amazon-q.md` - Amazon Q Developer

## 🎯 Tools Documented

### Major/Production Tools (12)

1. ✅ **Google Gemini CLI** - Massive context (1M tokens), repo-wide analysis
2. ✅ **Anthropic Claude (Claude Code)** - Deep reasoning, balanced performance
3. ✅ **OpenAI Codex** - UI generation, rapid prototyping
4. ✅ **Cursor Agent** - Workflow automation, chained tasks
5. ✅ **GitHub Copilot CLI** - GitHub integration, PR management
6. ✅ **Factory AI Droid** - CI/CD-safe, read-only by default
7. ✅ **Kiro** - AI-powered IDE, spec-driven development
8. ✅ **Warp** - Modern terminal, AI-powered assistance
9. ✅ **Aider** - AI pair programming, Git-based editing
10. ✅ **Continue Dev** - VS Code extension with CLI support
11. ✅ **Windsurf** - AI-powered IDE with CLI capabilities
12. ✅ **Amazon Q Developer** - AWS AI coding assistant, GitHub integration

### Emerging Tools

**Status:** No emerging tools currently documented. Tools will be added as they are discovered and verified.

### Specialized Tools

**Status:** No specialized tools currently documented. Tools will be added as they are discovered and verified.

## 🔧 Quick Examples

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

### IDE Development
```bash
# Open Kiro IDE and use chat interface for spec-driven development
```

### Enhanced Terminal
```bash
# Use Warp terminal with any CLI tool for better experience
gemini -p "Review codebase" # Warp AI helps explain output
```

## 🛡️ Security & Risk Levels

- 🟢 **Low:** Droid (read-only), Claude (approval), Warp (terminal)
- 🟠 **Medium:** Gemini, Codex (sandbox), Kiro (IDE with agents)
- ⚠️ **High:** Cursor (`--force` required)
- ⚡ **High:** Copilot (can run shell/git)

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

## 🔗 Quick Links

### Official Documentation

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

## 📌 Version Pinning (CI/CD)

For production CI/CD, pin specific versions:

```bash
npm install -g @anthropic-ai/claude-code@1.9.3
npm install -g @openai/codex@2.2.0
npm install -g @google/gemini-cli@3.1.0
npm install -g @github/copilot@0.0.329
```

**Note:** Version numbers shown are examples. Check each tool's repository for current stable versions.

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Adding new tools
- Updating existing documentation
- Reporting issues
- Submitting improvements

## 📝 License

[Add license information here]

## 🎯 Status

- ✅ **12 Major Tools** documented with individual files (Gemini, Claude, Codex, Cursor, Copilot, Droid, Kiro, Warp, Aider, Continue Dev, Windsurf, Amazon Q)
- ✅ **14 Non-Existent Tools Removed** - All placeholder tools verified as non-existent and removed from repository
- ✅ **Repository Cleaned** - Only verified, existing tools remain
- ✅ **Repository Structure** - Complete
- ✅ **Documentation Template** - Available
- ✅ **CONTRIBUTING.md** - Available
- ✅ **CI/CD Examples** - Created (GitHub Actions, GitLab CI, CircleCI)
- ✅ **Automation Scripts** - Created (code review, batch analysis, security audit, multi-tool orchestration)
- ✅ **27 Markdown Files** - Complete documentation structure (14 placeholder files removed)
- ✅ **33 Total Files** - Including examples and workflows
- ✅ **Verification Complete** - All 14 placeholder tools verified as NON-EXISTENT and removed (see VERIFICATION_STATUS.md)

## 📅 Last Updated

November 2025

---

**Icon Legend:**
- 🚨 = Dangerous (requires caution)
- 🛟 = Safe-by-default (read-only)
- ⚙️ = Required configuration
- ⭐ = Proven approach

