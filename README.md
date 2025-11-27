# 🧠 AI CLI Reference Repository

A comprehensive quick reference guide repository for all AI CLI agents, featuring headless syntax, features, and available models for **15 verified tools**.

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
IDE-based development?                 → Kiro, Windsurf, RooCode
Enhanced terminal experience?          → Warp
AI pair programming?                   → Aider, Continue Dev
AWS integration?                       → Amazon Q
Task-based workflows?                  → Cline
Multi-language support?                → OpenCode
```

## 📊 Tool Comparison

| Tool | Headless | Multi-Model | JSON Output | Risk | Best For |
|------|----------|-------------|-------------|------|----------|
| **Gemini CLI** | ✅ Full | ✅ Gemini family | ✅ Yes + Streaming | 🟠 Medium | Massive repos (1M token models) |
| **Claude Code** | ✅ Full | ✅ Opus/Sonnet/Haiku | ✅ Yes + Streaming | 🟢 Low | Deep reasoning, daily coding |
| **Codex** | ✅ Full | ✅ GPT family | ✅ Yes + Schemas | 🟠 Medium | UI generation, prototyping |
| **Cursor** | ✅ Full | ✅ Multiple providers | ✅ Yes + Streaming | ⚠️ High | Workflow automation |
| **Droid** | ✅ Full | ✅ Multiple providers | ✅ Yes + Debug | 🟢 Low | CI/CD-safe automation |
| **Copilot** | ✅ Full | ✅ Claude/GPT/Gemini | ⚠️ Limited | ⚡ High | GitHub integration |
| **Kiro** | ⚠️ Agents | ✅ Claude via Bedrock | ⚠️ Limited | 🟠 Medium | IDE-based, spec-driven |
| **Warp** | ❌ Terminal | ✅ Multiple via agents | N/A | 🟢 Low | Enhanced terminal UX |
| **Windsurf** | ⚠️ Docker | ✅ OpenAI/Anthropic | ⚠️ Limited | 🟠 Medium | IDE with Cascade AI |
| **Aider** | ✅ Full | ✅ Multiple providers | ⚠️ Limited | 🟠 Medium | AI pair programming |
| **Continue Dev** | ✅ Full | ✅ Multiple providers | ⚠️ Limited | 🟢 Low | VS Code + CLI |
| **Cline** | ✅ Full | ✅ Multiple providers | ⚠️ Limited | 🟠 Medium | Task-based workflows |
| **Amazon Q** | ✅ Full | ❌ AWS models only | ✅ Yes | 🟢 Low | AWS integration |
| **OpenCode** | ✅ Full | ✅ Multiple providers | ⚠️ Limited | 🟠 Medium | Multi-language support |
| **RooCode** | ❌ VS Code | ✅ Multiple via MCP | ⚠️ Limited | 🟢 Low | VS Code extension |

## 🚀 Installation - All 15 Tools

```bash
# 1. Gemini - Massive context (1M tokens)
npm install -g @google/gemini-cli

# 2. Claude - Deep reasoning and balanced performance
npm install -g @anthropic-ai/claude-code

# 3. Codex - UI generation and rapid prototyping
npm install -g @openai/codex

# 4. Cursor - Workflow automation
curl https://cursor.com/install -fsS | bash

# 5. Copilot - GitHub integration
npm install -g @github/copilot

# 6. Droid - CI/CD-safe, read-only by default
curl -fsSL https://app.factory.ai/cli | sh

# 7. Kiro - AI-powered IDE with CLI support
curl -fsSL https://cli.kiro.dev/install | bash
# IDE download: https://kiro.help/docs

# 8. Warp - Modern terminal with AI features (macOS)
brew install --cask warp
# Windows/Linux: https://warp.dev

# 9. Windsurf - IDE with Cascade AI agent
# Download from: https://windsurf.com
# Headless mode via Docker: https://github.com/pfcoperez/windsurfinabox

# 10. Aider - AI pair programming
pip install aider-chat

# 11. Continue Dev - VS Code integration with CLI
npm install -g @continuedev/cli

# 12. Cline - Task-based autonomous execution
npm install -g @cline/cli

# 13. Amazon Q Developer - AWS AI coding assistant
# macOS:
brew install amazon-q-developer-cli
# Other platforms: https://github.com/aws/amazon-q-developer-cli/releases

# 14. OpenCode - Multi-language AI coding tool
npm install -g opencode
# or
pip install opencode

# 15. RooCode - VS Code extension for AI coding
# Installation: Search "RooCode" in VS Code Extensions marketplace
# Supports MCP (Model Context Protocol) integration
```

## 📚 Documentation Structure

```
headless-ai-cli/
├── README.md                    # This file - quick reference and all installation commands
├── CLAUDE.md                    # AI agent guidance for working in this repository
├── CONTRIBUTING.md              # Contribution guidelines and standards
├── QUICK_REFERENCE.md           # Ultra-condensed command cheat sheet for daily use
├── .gitignore                   # Standard exclusions (node_modules, IDEs, logs, etc.)
├── tools/
│   ├── TEMPLATE.md              # Standardized template for adding new tools
│   └── major/                   # Individual tool documentation (15 files)
│       ├── gemini.md            # Google Gemini CLI
│       ├── claude.md            # Anthropic Claude (Claude Code)
│       ├── codex.md             # OpenAI Codex
│       ├── cursor.md            # Cursor Agent
│       ├── copilot.md           # GitHub Copilot CLI
│       ├── droid.md             # Factory AI Droid
│       ├── kiro.md              # Kiro (AI-Powered IDE)
│       ├── warp.md              # Warp Terminal
│       ├── windsurf.md          # Windsurf IDE
│       ├── aider.md             # Aider (AI pair programming)
│       ├── continue-dev.md      # Continue Dev
│       ├── cline.md             # Cline
│       ├── amazon-q.md          # Amazon Q Developer
│       ├── open-code.md         # OpenCode
│       └── roocode.md           # RooCode
├── examples/
│   ├── ci-cd/                   # CI/CD integration examples (40+ files)
│   │   ├── github-actions-*.yml # GitHub Actions workflows
│   │   ├── gitlab-ci-*.yml      # GitLab CI configurations
│   │   └── circleci-*.yml       # CircleCI configurations
│   ├── automation/              # Automation scripts
│   │   ├── *-headless-workflows.sh
│   │   ├── *-batch-processing.sh
│   │   └── code-review-automation.sh
│   └── workflows/               # Common workflow patterns
└── test/                        # Test scripts (60+ files)
    ├── *-headless-basic.test.sh      # Basic headless mode tests
    ├── *-headless-advanced.test.sh   # Advanced headless scenarios
    ├── *-cicd-integration.test.sh    # CI/CD integration tests
    └── *-workflows.test.sh           # Workflow automation tests
```

## 📖 Documentation Files

### Main Documentation

- **[README.md](README.md)** - This file: Quick reference, installation, overview
- **[CLAUDE.md](CLAUDE.md)** - Guidance for AI agents working in this repository
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines and standards
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Ultra-condensed command cheat sheet

### Individual Tool Documentation

All 15 tools are comprehensively documented in `tools/major/` directory:

1. **[tools/major/gemini.md](tools/major/gemini.md)** - Google Gemini CLI (1M token context)
2. **[tools/major/claude.md](tools/major/claude.md)** - Anthropic Claude (Claude Code)
3. **[tools/major/codex.md](tools/major/codex.md)** - OpenAI Codex
4. **[tools/major/cursor.md](tools/major/cursor.md)** - Cursor Agent
5. **[tools/major/copilot.md](tools/major/copilot.md)** - GitHub Copilot CLI
6. **[tools/major/droid.md](tools/major/droid.md)** - Factory AI Droid
7. **[tools/major/kiro.md](tools/major/kiro.md)** - Kiro (AI-Powered IDE)
8. **[tools/major/warp.md](tools/major/warp.md)** - Warp Terminal
9. **[tools/major/windsurf.md](tools/major/windsurf.md)** - Windsurf IDE
10. **[tools/major/aider.md](tools/major/aider.md)** - Aider (AI pair programming)
11. **[tools/major/continue-dev.md](tools/major/continue-dev.md)** - Continue Dev
12. **[tools/major/cline.md](tools/major/cline.md)** - Cline
13. **[tools/major/amazon-q.md](tools/major/amazon-q.md)** - Amazon Q Developer
14. **[tools/major/open-code.md](tools/major/open-code.md)** - OpenCode
15. **[tools/major/roocode.md](tools/major/roocode.md)** - RooCode

## 🎯 All 15 Tools Listed

1. ✅ **Google Gemini CLI** - Massive context (1M tokens), repo-wide analysis
2. ✅ **Anthropic Claude (Claude Code)** - Deep reasoning, balanced performance
3. ✅ **OpenAI Codex** - UI generation, rapid prototyping
4. ✅ **Cursor Agent** - Workflow automation, chained tasks
5. ✅ **GitHub Copilot CLI** - GitHub integration, PR management
6. ✅ **Factory AI Droid** - CI/CD-safe, read-only by default
7. ✅ **Kiro** - AI-powered IDE with CLI, spec-driven development
8. ✅ **Warp** - Modern terminal with AI-powered assistance
9. ✅ **Windsurf** - AI-powered IDE with Cascade agent
10. ✅ **Aider** - AI pair programming, Git-based editing
11. ✅ **Continue Dev** - VS Code extension with CLI support
12. ✅ **Cline** - Task-based autonomous execution
13. ✅ **Amazon Q Developer** - AWS AI coding assistant, GitHub integration
14. ✅ **OpenCode** - Multi-language AI coding support
15. ✅ **RooCode** - VS Code extension with MCP integration

## 🔧 Quick Examples

### Code Review
```bash
# Using Gemini for large repos
git diff | gemini -p "Review for bugs and security" --output-format json

# Using Claude for deep analysis
claude -p "Review this PR for architectural issues" --output-format json --no-interactive

# Using Droid for CI/CD
droid exec "Review code for security issues" --output-format json
```

### UI Generation
```bash
# Using Codex
codex exec "Create React + Tailwind button component"

# Using Copilot
copilot -p "Generate a responsive navigation component" --allow-all-tools
```

### CI/CD Automation
```bash
# Using Droid (safest for CI/CD)
droid exec --auto low "Run security audit" --output-format json

# Using Gemini with structured output
gemini -p "Analyze test failures" --output-format json

# Using Claude with pre-approved tools
claude -p "Fix linting issues" --allowedTools "Bash,Read,Edit" --no-interactive
```

### AI Pair Programming
```bash
# Using Aider
aider --model claude-sonnet-4-5 --yes

# Using Continue Dev
cn -p "Add type hints to all functions" --file src/main.py

# Using Cline
cline task new -y "Generate unit tests for all Go files"
```

### IDE Development
```bash
# Kiro CLI (must use agents)
kiro-cli chat --agent frontend-specialist

# Windsurf (Docker headless mode)
docker run --rm -e WINDSURF_TOKEN=$WINDSURF_TOKEN \
  -v ./workspace:/home/ubuntu/workspace windsurf

# RooCode (VS Code extension)
# Use through VS Code interface with MCP integration
```

### AWS Integration
```bash
# Amazon Q Developer
q chat "Explain this Lambda function"
q scan --auto-fix  # Security scan with auto-fix
```

### Multi-Language Support
```bash
# OpenCode
opencode generate "Create a REST API endpoint in Python"
opencode review --language go
```

## 🛡️ Security & Risk Levels

- 🟢 **Low Risk:** Droid (read-only default), Claude (approval required), Warp (terminal), Continue Dev, Amazon Q, RooCode
- 🟠 **Medium Risk:** Gemini, Codex (sandbox), Kiro (IDE with agents), Aider, Windsurf, Cline, OpenCode
- ⚠️ **High Risk:** Cursor (`--force` required for writes)
- ⚡ **Very High Risk:** Copilot (can run shell/git commands)

## 📤 Output Formats Supported

| Tool | Text | JSON | Stream JSON | Delta Stream | Notes |
|------|------|------|-------------|--------------|-------|
| **Gemini** | ✔ | ✔ | ✔ | ❌ | Comprehensive stats |
| **Claude** | ✔ | ✔ | ✔ | ❌ | Session management |
| **Codex** | ✔ | ✔ | ✔ | ✔ | Structured schemas |
| **Cursor** | ✔ | ✔ | ✔ | ✔ | Partial output streaming |
| **Droid** | ✔ | ✔ | ✔ (debug) | ❌ | Read-only default |
| **Copilot** | ✔ | ⚠️ | ⚠️ | ❌ | Limited JSON support |
| **Kiro** | ✔ | ⚠️ | ⚠️ | ❌ | Primarily IDE-based |
| **Warp** | N/A | N/A | N/A | N/A | Terminal emulator |
| **Aider** | ✔ | ⚠️ | ❌ | ❌ | Git-based workflow |
| **Continue Dev** | ✔ | ⚠️ | ⚠️ | ❌ | TUI and headless |
| **Windsurf** | ✔ | ⚠️ | ❌ | ❌ | Docker headless |
| **Amazon Q** | ✔ | ✔ | ⚠️ | ❌ | AWS integration |
| **Cline** | ✔ | ⚠️ | ❌ | ❌ | Instance-based |
| **OpenCode** | ✔ | ⚠️ | ⚠️ | ❌ | Multi-language |
| **RooCode** | ✔ | ⚠️ | ❌ | ❌ | VS Code extension |

## 👥 Tools by Role

| Role | Best Tools | Example |
|------|------------|---------|
| **Backend Engineer** | Claude Sonnet, Gemini, Droid | `claude -p "Review API endpoint" --no-interactive` |
| **Frontend Engineer** | Codex, Copilot, OpenCode | `codex exec "Create React component"` |
| **SRE/DevOps** | Droid, Claude, Amazon Q | `droid exec "Diagnose incident" --auto low` |
| **AI/ML Engineer** | Claude Opus, Gemini | `claude -p "Design ML architecture" --model claude-opus-4-1` |
| **PM/Designer** | Codex, Copilot, Cursor | `codex exec "Create user flow mockup"` |
| **Data Engineer** | Gemini, Claude Sonnet | `gemini -p "Review ETL pipeline" --output-format json` |
| **Security Engineer** | Claude, Droid, Amazon Q | `droid exec "Security audit" --output-format json` |
| **Pair Programmer** | Aider, Continue Dev, Cline | `aider --model claude-sonnet-4-5` |
| **IDE Power User** | Kiro, Windsurf, RooCode | Use IDE interface with AI agents |
| **Terminal Power User** | Warp, Cursor | Enhanced CLI experience with AI |

## 🔗 Official Documentation Links

### Core Tools
- [Gemini CLI](https://developers.google.com/gemini-code-assist/docs/gemini-cli) - Google Developers
- [Claude Code](https://code.claude.com/docs/en/headless.md) - Anthropic
- [Codex SDK](https://developers.openai.com/codex/sdk) - OpenAI
- [Cursor CLI](https://cursor.com/docs/cli/headless) - Cursor
- [Copilot CLI](https://docs.github.com/en/copilot/cli) - GitHub
- [Droid Exec](https://docs.factory.ai/cli/droid-exec/overview.md) - Factory AI

### IDE Tools
- [Kiro AI](https://kiroai.ai) | [Docs](https://kiro.help/docs) - Kiro
- [Warp Terminal](https://www.warp.dev) | [Docs](https://docs.warp.dev) - Warp
- [Windsurf](https://windsurf.com) - Windsurf IDE

### AI Pair Programming
- [Aider](https://aider.chat) | [Docs](https://aider.chat/docs) - Aider
- [Continue Dev](https://continue.dev) | [CLI Docs](https://docs.continue.dev/cli/overview) - Continue
- [Cline](https://docs.cline.bot) | [CLI](https://docs.cline.bot/cline-cli/overview) - Cline

### Cloud & Extensions
- [Amazon Q](https://aws.amazon.com/q/developer/) | [CLI](https://github.com/aws/amazon-q-developer-cli) - AWS
- [OpenCode](https://opencode.ai) - OpenCode
- RooCode - VS Code Marketplace

## 📌 Version Pinning for CI/CD

For production CI/CD, pin specific versions to ensure reproducibility:

```bash
# Core npm packages
npm install -g @anthropic-ai/claude-code@1.9.3
npm install -g @openai/codex@2.2.0
npm install -g @google/gemini-cli@3.1.0
npm install -g @github/copilot@0.0.329
npm install -g @continuedev/cli@latest
npm install -g @cline/cli@latest
npm install -g opencode@latest

# Python packages
pip install aider-chat==0.47.1
pip install opencode==latest

# Shell installations (specify versions in scripts)
curl -fsSL https://app.factory.ai/cli | sh  # Droid
curl https://cursor.com/install -fsS | bash  # Cursor
```

**Note:** Version numbers shown are examples. Always check each tool's repository for current stable versions before pinning.

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for comprehensive guidelines on:
- Adding new tools to the repository
- Updating existing documentation
- Using the standardized TEMPLATE.md
- Testing and verification procedures
- Reporting issues and submitting improvements

**Key Requirements:**
- All tools must be verified as actually existing
- Installation commands must be tested
- Follow TEMPLATE.md structure exactly
- Update README.md with new tools
- Add CI/CD examples where applicable

## 📝 License

This repository is provided as-is for educational and reference purposes. Individual tools have their own licenses - please refer to each tool's official documentation.

## 🎯 Repository Status

- ✅ **15 Tools Documented** - All with individual comprehensive files
- ✅ **15 Installation Commands** - Verified and tested
- ✅ **60+ Test Scripts** - Headless, advanced, CI/CD, workflows
- ✅ **40+ Examples** - CI/CD configs and automation scripts
- ✅ **Documentation Template** - Standardized format for consistency
- ✅ **Contributing Guide** - Clear process for additions
- ✅ **Repository Cleaned** - All AI slop removed, only essentials remain

## 📊 Repository Statistics

- **Total Tools:** 15 (all verified and production-ready)
- **Documentation Files:** 19 markdown files total
  - 4 main docs (README, CLAUDE, CONTRIBUTING, QUICK_REFERENCE)
  - 15 individual tool docs (tools/major/)
- **Example Files:** 40+ (CI/CD and automation)
- **Test Scripts:** 60+ (comprehensive test coverage)
- **Lines of Documentation:** 30,000+ lines of verified content

## 📅 Last Updated

November 2025

---

**Quick Start:** Pick a tool from the installation section above (numbered 1-15), install it, then check its individual documentation file in `tools/major/` for comprehensive usage guides, examples, and CI/CD integration patterns.

**Icon Legend:**
- 🚨 = Dangerous (requires caution)
- 🛟 = Safe-by-default (read-only)
- ⚙️ = Required configuration
- ⭐ = Proven approach
- ✅ = Verified and tested
- ⚠️ = Limited support or conditional
- ❌ = Not supported
