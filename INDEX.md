# 📑 AI CLI Tools Index

**Quick navigation to all tools and documentation**

---

## 🗂️ Main Documentation

- **[README.md](README.md)** - Main index and quick reference
- **[COMPREHENSIVE.md](COMPREHENSIVE.md)** - Single-file reference for all 26+ tools
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Ultra-condensed cheat sheet
- **[claude.md](claude.md)** - Detailed guide for 8 major tools
- **[simple.md](simple.md)** - Quick reference guide
- **[gpt-5.1.md](gpt-5.1.md)** - GPT-5.1 specific guide
- **[PROGRESS.md](PROGRESS.md)** - Implementation progress
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines
- **[SUMMARY.md](SUMMARY.md)** - Implementation summary

---

## 🚀 Major Tools (12)

### Production-Ready AI CLI Agents

1. **[Google Gemini CLI](tools/major/gemini.md)**
   - **Best for:** Massive repos (1M+ tokens), large-scale analysis
   - **Context:** 1M+ tokens
   - **Risk:** 🟠 Medium

2. **[Anthropic Claude (Claude Code)](tools/major/claude.md)**
   - **Best for:** Deep reasoning, architecture, daily coding
   - **Context:** 200K tokens
   - **Risk:** 🟢 Low

3. **[OpenAI Codex](tools/major/codex.md)**
   - **Best for:** UI generation, rapid prototyping
   - **Context:** Medium
   - **Risk:** 🟠 Medium

4. **[Cursor Agent](tools/major/cursor.md)**
   - **Best for:** Workflow automation, chained tasks
   - **Context:** Medium
   - **Risk:** ⚠️ High

5. **[GitHub Copilot CLI](tools/major/copilot.md)**
   - **Best for:** GitHub integration, PR management
   - **Context:** Medium
   - **Risk:** ⚡ Very High

6. **[Factory AI Droid](tools/major/droid.md)**
   - **Best for:** CI/CD-safe automation, production
   - **Context:** Medium
   - **Risk:** 🟢 Very Low

7. **[Kiro (AI-Powered IDE)](tools/major/kiro.md)**
   - **Best for:** Spec-driven development, IDE-based workflows
   - **Context:** Medium
   - **Risk:** 🟠 Medium

8. **[Warp Terminal](tools/major/warp.md)**
   - **Best for:** Terminal enhancement, CLI tool integration
   - **Context:** N/A
   - **Risk:** 🟢 Low

9. **[Aider](tools/major/aider.md)**
   - **Best for:** AI pair programming, Git-based editing
   - **Context:** Medium
   - **Risk:** 🟠 Medium

10. **[Continue Dev](tools/major/continue-dev.md)**
    - **Best for:** VS Code + CLI, continuous AI workflows
    - **Context:** Medium
    - **Risk:** 🟢 Low

11. **[Windsurf](tools/major/windsurf.md)**
    - **Best for:** AI-powered IDE with CLI capabilities
    - **Context:** Medium
    - **Risk:** 🟠 Medium

12. **[Amazon Q Developer](tools/major/amazon-q.md)**
    - **Best for:** AWS integration, GitHub code reviews
    - **Context:** Medium
    - **Risk:** 🟢 Low

---

## 🌱 Emerging Tools

**Status:** No emerging tools currently documented. Tools will be added as they are discovered and verified.

---

## 🔧 Specialized Tools

**Status:** No specialized tools currently documented. Tools will be added as they are discovered and verified.

---

## 📚 Examples & Workflows

### CI/CD Examples
- **[GitHub Actions - Gemini Review](examples/ci-cd/github-actions-gemini-review.yml)**
- **[GitLab CI - Droid Audit](examples/ci-cd/gitlab-ci-droid-audit.yml)**

### Automation Scripts
- **[Code Review Automation](examples/automation/code-review-automation.sh)**

### Workflows
- **[Multi-Tool Orchestration](examples/workflows/multi-tool-orchestration.sh)**

---

## 🎯 Quick Navigation by Use Case

### By Task
- **Massive repos (1M+ tokens)** → [Gemini](tools/major/gemini.md)
- **Deep reasoning** → [Claude Opus](tools/major/claude.md)
- **UI generation** → [Codex](tools/major/codex.md)
- **Workflow automation** → [Cursor](tools/major/cursor.md)
- **CI/CD safe** → [Droid](tools/major/droid.md)
- **GitHub integration** → [Copilot](tools/major/copilot.md)
- **IDE-based dev** → [Kiro](tools/major/kiro.md), [Windsurf](tools/major/windsurf.md), [Continue Dev](tools/major/continue-dev.md)
- **Terminal enhancement** → [Warp](tools/major/warp.md)
- **Pair programming** → [Aider](tools/major/aider.md)
- **AWS integration** → [Amazon Q](tools/major/amazon-q.md)

### By Risk Level
- **🟢 Low Risk:** [Claude](tools/major/claude.md), [Droid](tools/major/droid.md), [Warp](tools/major/warp.md), [Continue Dev](tools/major/continue-dev.md), [Amazon Q](tools/major/amazon-q.md)
- **🟠 Medium Risk:** [Gemini](tools/major/gemini.md), [Codex](tools/major/codex.md), [Kiro](tools/major/kiro.md), [Aider](tools/major/aider.md), [Windsurf](tools/major/windsurf.md)
- **⚠️ High Risk:** [Cursor](tools/major/cursor.md)
- **⚡ Very High Risk:** [Copilot](tools/major/copilot.md)

---

## 📖 Documentation Template

- **[TEMPLATE.md](tools/TEMPLATE.md)** - Standardized format for new tools

---

## 🔍 Search by Feature

### Headless Mode Support
All major tools support headless mode. See individual tool documentation for details.

### JSON Output
- [Gemini](tools/major/gemini.md) - ✔ Full support
- [Claude](tools/major/claude.md) - ✔ Full support
- [Codex](tools/major/codex.md) - ✔ Full support
- [Cursor](tools/major/cursor.md) - ✔ Full support
- [Droid](tools/major/droid.md) - ✔ Full support
- [Copilot](tools/major/copilot.md) - ⚠️ Limited support
- [Continue Dev](tools/major/continue-dev.md) - ✔ Full support

### Streaming Support
- [Gemini](tools/major/gemini.md) - ✔ Stream JSON
- [Claude](tools/major/claude.md) - ✔ Stream JSON
- [Codex](tools/major/codex.md) - ✔ Stream JSON + Delta
- [Cursor](tools/major/cursor.md) - ✔ Stream JSON + Delta
- [Droid](tools/major/droid.md) - ✔ Debug format

### CI/CD Integration
- [Droid](tools/major/droid.md) - ⭐ Best for CI/CD (read-only default)
- [Gemini](tools/major/gemini.md) - ✔ Headless mode
- [Claude](tools/major/claude.md) - ✔ Headless mode
- [Codex](tools/major/codex.md) - ✔ GitHub Actions
- [Continue Dev](tools/major/continue-dev.md) - ✔ Headless mode

---

## 📊 Statistics

- **Total Tools:** 12 (all major tools)
- **Fully Documented:** 12 major tools (100%)
- **Removed:** 14 non-existent tools (verified and removed)
- **Total Files:** 27 markdown files
- **Examples:** 7 files
- **See:** [VERIFICATION_STATUS.md](VERIFICATION_STATUS.md) for verification details

---

**Last Updated:** November 2025

