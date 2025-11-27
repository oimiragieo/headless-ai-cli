# 🧠 AI CLI Reference Repository

[![Last Updated](https://img.shields.io/badge/Last%20Updated-November%202025-blue)](https://github.com/oimiragieo/headless-ai-cli)
[![Tools Documented](https://img.shields.io/badge/Tools%20Documented-14-green)](https://github.com/oimiragieo/headless-ai-cli/tree/main/tools/major)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

A comprehensive **documentation and reference repository** for AI CLI agents, focusing on **headless/non-interactive execution** for automation, CI/CD pipelines, and scripting environments.

## 📋 What This Repository Is

**This is a documentation aggregator and reference guide** — not a tool installer or wrapper. It provides:

- 📚 **Curated documentation** for 14 verified AI CLI tools
- 🔧 **Headless/automation syntax** that's often buried in official docs
- 📦 **CI/CD integration examples** ready to copy into your pipelines
- 🧪 **Test scripts** to verify tools work in your environment
- 📊 **Comparison tables** to help you choose the right tool

**Who this is for:**
- DevOps engineers integrating AI into CI/CD pipelines
- Developers automating code review, testing, or documentation
- Teams evaluating which AI CLI tool fits their workflow
- Anyone wanting a "cheat sheet" for headless AI tool usage

## 🎯 Quick Decision Tree

```text
Huge context (1M+ tokens)?           → Gemini
Deepest reasoning?                    → Claude Opus
UI/front-end generation?              → Codex
Workflow automation?                  → Cursor
CI/CD-safe deterministic runs?        → Droid
GitHub integration?                   → Copilot
Daily coding?                         → Claude Sonnet
AI pair programming?                  → Aider, Continue Dev, Cline
AWS integration?                      → Amazon Q
Multi-language support?               → OpenCode
```

## 📊 Tool Comparison Matrix

| Tool | Install | Headless | JSON Output | Risk Level | Last Verified |
|------|---------|----------|-------------|------------|---------------|
| **[Gemini CLI](tools/major/gemini.md)** | `npm i -g @google/gemini-cli` | ✅ Full | ✅ Text/JSON/Stream | 🟠 Medium | Nov 2025 |
| **[Claude Code](tools/major/claude.md)** | `npm i -g @anthropic-ai/claude-code` | ✅ Full | ✅ Text/JSON/Stream | 🟢 Low | Nov 2025 |
| **[Codex](tools/major/codex.md)** | `npm i -g @openai/codex` | ✅ Full | ✅ Text/JSON/Schema | 🟠 Medium | Nov 2025 |
| **[Cursor](tools/major/cursor.md)** | `curl script` | ✅ Full | ✅ Text/JSON/Stream | ⚠️ High | Nov 2025 |
| **[Droid](tools/major/droid.md)** | `curl script` | ✅ Full | ✅ Text/JSON | 🟢 Low | Nov 2025 |
| **[Copilot](tools/major/copilot.md)** | `npm i -g @github/copilot` | ✅ Full | ⚠️ Limited | ⚡ Very High | Nov 2025 |
| **[Kiro](tools/major/kiro.md)** | `curl script` | ⚠️ Agents only | ⚠️ Limited | 🟠 Medium | Nov 2025 |
| **[Warp](tools/major/warp.md)** | `brew install --cask warp` | ❌ No | N/A | 🟢 Low | Nov 2025 |
| **[Windsurf](tools/major/windsurf.md)** | Download IDE | ⚠️ Docker only | ⚠️ Limited | 🟠 Medium | Nov 2025 |
| **[Aider](tools/major/aider.md)** | `pip install aider-chat` | ✅ Full | ⚠️ Limited | 🟠 Medium | Nov 2025 |
| **[Continue Dev](tools/major/continue-dev.md)** | `npm i -g @continuedev/cli` | ✅ Full | ⚠️ Limited | 🟢 Low | Nov 2025 |
| **[Cline](tools/major/cline.md)** | `npm i -g cline` | ✅ Full | ⚠️ Limited | 🟠 Medium | Nov 2025 |
| **[Amazon Q](tools/major/amazon-q.md)** | `brew install amazon-q-developer-cli` | ✅ Full | ✅ Text/JSON | 🟠 Medium | Nov 2025 |
| **[OpenCode](tools/major/open-code.md)** | `npm i -g open-code` | ✅ Full | ⚠️ Limited | 🟠 Medium | Nov 2025 |

**Risk Levels:** 🟢 Low (read-only default) | 🟠 Medium (writes with flags) | ⚠️ High (writes by default) | ⚡ Very High (minimal safeguards)

## ⚡ Quick Start Example: GitHub Actions PR Review

Here's a real CI/CD example showing how to use these tools in automation:

```yaml
# .github/workflows/ai-code-review.yml
name: AI Code Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
        with:
          fetch-depth: 0

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Claude CLI
        run: npm install -g @anthropic-ai/claude-code

      - name: Run AI Code Review
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          git diff origin/${{ github.base_ref }}...HEAD | \
            claude -p "Review these changes for bugs and security issues" \
            --output-format json \
            --permission-mode bypassPermissions \
            --allowedTools "Read,Grep" \
            > review.json

      - name: Post Review Comment
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const review = JSON.parse(fs.readFileSync('review.json', 'utf8'));
            await github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## 🤖 AI Code Review\n\n${review.result}`
            });
```

**More examples:** See [`examples/ci-cd/`](examples/ci-cd/) for 40+ ready-to-use workflows.

## 🚀 Installation Commands

```bash
# Core Tools (npm)
npm install -g @google/gemini-cli        # Gemini - 1M token context
npm install -g @anthropic-ai/claude-code # Claude - Deep reasoning
npm install -g @openai/codex             # Codex - UI generation
npm install -g @github/copilot           # Copilot - GitHub integration
npm install -g @continuedev/cli          # Continue Dev - VS Code CLI
npm install -g cline                     # Cline - Task automation
npm install -g open-code                 # OpenCode - Multi-language

# Shell Script Installs
curl https://cursor.com/install -fsS | bash          # Cursor
curl -fsSL https://app.factory.ai/cli | sh           # Droid
curl -fsSL https://cli.kiro.dev/install | bash       # Kiro

# Python
pip install aider-chat                   # Aider - AI pair programming

# Platform-specific
brew install --cask warp                 # Warp (macOS)
brew install amazon-q-developer-cli      # Amazon Q (macOS)
```

## 📚 Documentation Structure

```
headless-ai-cli/
├── README.md                    # This file - overview and quick reference
├── CONTRIBUTING.md              # How to contribute and maintain docs
├── QUICK_REFERENCE.md           # Ultra-condensed command cheat sheet
├── tools/major/                 # Individual tool documentation (14 files)
│   ├── gemini.md, claude.md, codex.md, cursor.md, copilot.md
│   ├── droid.md, kiro.md, warp.md, windsurf.md
│   ├── aider.md, continue-dev.md, cline.md, amazon-q.md, open-code.md
├── examples/
│   ├── ci-cd/                   # 40+ GitHub Actions, GitLab CI, CircleCI examples
│   ├── automation/              # Shell script patterns for batch processing
│   └── workflows/               # Multi-tool orchestration examples
└── test/                        # 60+ test scripts for verification
```

## 🔧 Common Headless Patterns

### Code Review
```bash
# Gemini (large repos)
git diff | gemini -p "Review for bugs" --output-format json

# Claude (deep analysis)
claude -p "Review PR" --output-format json --permission-mode bypassPermissions

# Droid (CI/CD safe)
droid exec "Security audit" --auto low --output-format json
```

### Code Generation
```bash
# Codex (UI generation)
codex exec "Create React button component" --full-auto

# Cline (task automation)
cline "Generate unit tests" --yolo --output-format json
```

### Batch Processing
```bash
# Process multiple files with Claude
for file in src/*.py; do
  claude -p "Add type hints to $file" --permission-mode bypassPermissions
done
```

## 👥 Tools by Role

| Role | Recommended Tools | Why |
|------|-------------------|-----|
| **SRE/DevOps** | Droid, Claude, Amazon Q | Read-only defaults, CI/CD integration |
| **Backend Engineer** | Claude Sonnet, Gemini | Deep reasoning, large context |
| **Frontend Engineer** | Codex, Cursor, Copilot | UI generation, workflow automation |
| **Security Engineer** | Droid, Claude | Audit capabilities, structured output |
| **Pair Programmer** | Aider, Continue Dev, Cline | Interactive coding, Git integration |

## 🔗 Official Documentation

| Tool | Primary Docs | CLI Reference | GitHub |
|------|--------------|---------------|--------|
| **Gemini CLI** | [geminicli.com/docs](https://geminicli.com/docs/) | [Google Developers](https://developers.google.com/gemini-code-assist/docs/gemini-cli) | [google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli) |
| **Claude Code** | [docs.anthropic.com](https://docs.anthropic.com/en/docs/claude-code/overview) | [CLI Reference](https://docs.claude.com/en/docs/claude-code/cli-reference) | [anthropics/claude-code](https://github.com/anthropics/claude-code) |
| **Codex** | [developers.openai.com](https://developers.openai.com/codex/) | [CLI Reference](https://developers.openai.com/codex/cli/reference/) | [openai/codex](https://github.com/openai/codex) |
| **Cursor** | [docs.cursor.com](https://docs.cursor.com/en/cli/overview) | [Agent Mode](https://docs.cursor.com/chat/agent) | — |
| **Copilot CLI** | [GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli) | [Usage Guide](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli) | [github/copilot-cli](https://github.com/github/copilot-cli) |
| **Droid** | [docs.factory.ai](https://docs.factory.ai/cli/getting-started/quickstart) | [Product Page](https://factory.ai/product/cli) | [Factory-AI/factory](https://github.com/Factory-AI/factory) |
| **Kiro** | [kiro.dev/docs](https://kiro.dev/docs/) | [CLI Docs](https://kiro.dev/docs/cli/) | [kirodotdev/Kiro](https://github.com/kirodotdev/Kiro) |
| **Warp** | [docs.warp.dev](https://docs.warp.dev) | [AI Features](https://docs.warp.dev/features/warp-ai) | [warpdotdev/Warp](https://github.com/warpdotdev/Warp) |
| **Windsurf** | [docs.windsurf.com](https://docs.windsurf.com/) | [Editor](https://windsurf.com/editor) | — |
| **Aider** | [aider.chat/docs](https://aider.chat/docs/) | [Main Site](https://aider.chat/) | [Aider-AI/aider](https://github.com/Aider-AI/aider) |
| **Continue Dev** | [docs.continue.dev](https://docs.continue.dev/quickstart) | [CLI Guide](https://docs.continue.dev/guides/cli) | [continuedev/continue](https://github.com/continuedev/continue) |
| **Cline** | [docs.cline.bot](https://docs.cline.bot/cline-cli/overview) | [Main Site](https://cline.bot/) | [cline/cline](https://github.com/cline/cline) |
| **Amazon Q** | [AWS Docs](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html) | [CLI Reference](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-reference.html) | [aws/amazon-q-developer-cli](https://github.com/aws/amazon-q-developer-cli) |
| **OpenCode** | [opencode.ai/docs](https://opencode.ai/docs/) | [CLI Docs](https://opencode.ai/docs/cli/) | [sst/opencode](https://github.com/sst/opencode) |

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Quick ways to help:**
- 🐛 Report outdated commands or broken examples
- 📝 Add missing tools or improve documentation
- 🧪 Submit test results from your environment
- 💡 Suggest new CI/CD integration patterns

## ⚠️ Maintenance Notice

These tools are actively developed and change frequently. We aim to verify documentation monthly, but CLI flags and features may drift between updates.

**Last full verification:** November 2025

If you find outdated information, please [open an issue](https://github.com/oimiragieo/headless-ai-cli/issues).

## 📊 Repository Statistics

- **Tools Documented:** 14 (all verified)
- **CI/CD Examples:** 40+ workflows
- **Test Scripts:** 60+ verification scripts
- **Documentation:** 18 markdown files, 30,000+ lines

## 📝 License

MIT License - see [LICENSE](LICENSE) for details.

Individual tools have their own licenses - refer to each tool's official documentation.

---

**Quick Start:** Pick a tool from the comparison table, install it, then check its [individual documentation](tools/major/) for comprehensive headless usage guides and examples.
