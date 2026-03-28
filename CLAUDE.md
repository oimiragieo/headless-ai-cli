# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a comprehensive reference repository documenting AI CLI tools that support headless/non-interactive execution. The repository serves as a quick reference guide for developers integrating AI capabilities into automated workflows, CI/CD pipelines, and scripting environments.

**Key Focus:** Headless syntax, features, available models, and automation patterns for 15 verified AI CLI tools.

## Repository Structure

```text
headless-ai-cli/
├── README.md                    # Main index with quick reference and all installation commands
├── CLAUDE.md                    # This file - AI agent guidance for working in this repository
├── CONTRIBUTING.md              # Contribution guidelines and documentation standards
├── QUICK_REFERENCE.md           # Ultra-condensed command cheat sheet for daily use
├── LICENSE                      # MIT License
├── .gitignore                   # Standard exclusions (node_modules, IDEs, logs, etc.)
├── .github/
│   └── ISSUE_TEMPLATE/          # GitHub issue templates (3 files)
│       ├── bug_report.md
│       ├── feature_request.md
│       └── verification_report.md
├── tools/
│   ├── TEMPLATE.md              # Standardized template for adding new tools
│   └── major/                   # Individual tool documentation (15 files)
│       ├── gemini.md            # Google Gemini CLI - 1M token context
│       ├── claude.md            # Anthropic Claude (Claude Code) - Deep reasoning
│       ├── codex.md             # OpenAI Codex - UI generation
│       ├── cursor.md            # Cursor Agent - Workflow automation
│       ├── copilot.md           # GitHub Copilot CLI - GitHub integration
│       ├── droid.md             # Factory AI Droid - CI/CD-safe
│       ├── kiro.md              # Kiro CLI - Spec-driven development (full headless v1.27)
│       ├── antigravity.md       # Google Antigravity - Multi-agent IDE (⚠️ NO headless)
│       ├── warp.md              # Warp Terminal - Enhanced CLI experience (⚠️ terminal only)
│       ├── windsurf.md          # Windsurf IDE - Cascade AI agent (⚠️ Docker required, Cognition)
│       ├── aider.md             # Aider - AI pair programming
│       ├── continue-dev.md      # Continue Dev - VS Code integration
│       ├── cline.md             # Cline - Task-based autonomous execution
│       ├── amazon-q.md          # Amazon Q Developer - AWS integration (⚠️ DEPRECATED)
│       ├── open-code.md         # OpenCode - Multi-language support
├── examples/                    # 50 total example files
│   ├── ci-cd/                   # CI/CD integration examples (31 files)
│   │   ├── github-actions-*.yml # GitHub Actions workflows (14 files)
│   │   ├── gitlab-ci-*.yml      # GitLab CI configurations (3 files)
│   │   ├── circleci-*.yml       # CircleCI configurations (1 file)
│   │   └── *-script-patterns.sh # Tool-specific script patterns (13 files)
│   ├── automation/              # Automation scripts (7 files)
│   │   ├── *-headless-workflows.sh
│   │   ├── *-batch-processing.sh
│   │   └── code-review-automation.sh
│   ├── workflows/               # Multi-tool orchestration (2 files)
│   ├── cline-workflows/         # Cline-specific workflows (3 markdown files)
│   └── windsurf-workflows/      # Windsurf-specific workflows (3 markdown files)
└── test/                        # Test scripts (56 files)
    ├── README.md                # Test documentation
    ├── *-headless-basic.test.sh      # Basic headless mode tests (12 files)
    ├── *-headless-advanced.test.sh   # Advanced headless scenarios (11 files)
    ├── *-cicd-integration.test.sh    # CI/CD integration tests (7 files)
    ├── *-workflows.test.sh           # Workflow automation tests (13 files)
    └── *-specialized.test.sh         # Specialized tests (13 files: JSON, stream, session, etc.)
```

## Documentation Standards

### File Organization Principles

1. **Main Documentation Files:**
   - `README.md` - Entry point, quick decision tree, tool comparison tables, all installation commands
   - `CLAUDE.md` - This file: AI agent guidance for working in this repository
   - `CONTRIBUTING.md` - Contribution guidelines and documentation standards
   - `QUICK_REFERENCE.md` - Ultra-condensed command cheat sheet for daily use
   - Individual tool files in `tools/major/` (14 files) - Deep-dive documentation for each tool

2. **Documentation Hierarchy:**
   - README.md → Quick navigation and decision tree
   - Individual tool docs (`tools/major/*.md`) → Detailed reference
   - Examples (`examples/`) → Real-world usage patterns
   - Tests (`test/`) → Verification and validation

### Documentation Format (from TEMPLATE.md)

Every tool documentation file follows this structure:

```markdown
# Tool Name

**Version tested:** Latest (check with `tool --version`)
**Risk level:** [🟢 Low / 🟠 Medium / ⚠️ High / ⚡ Very High]

**When NOT to use [Tool]:**

- ❌ Specific limitation 1
- ❌ Specific limitation 2

### Quick Nav

- Links to sections within the document

## Overview

## Installation

## 🚀 Start Here (Quick start example)

## Headless Mode

## Available Models

## CLI Syntax

## Configuration

## Examples

## Limitations

## References
```

### Key Documentation Principles

1. **Accuracy:** All commands must be verified. No made-up tools, commands, or features.
2. **Consistency:** Follow the template format exactly. Use consistent terminology across all docs.
3. **Completeness:** Include installation, headless mode, examples, and limitations for every tool.
4. **Conciseness:** Be clear and direct. Avoid redundancy.

## Development Workflows

### Adding a New Tool

1. **Verify the tool exists:**

   ```bash
   # Check official documentation
   # Verify CLI availability
   # Test installation commands
   ```

2. **Use the template:**

   ```bash
   cp tools/TEMPLATE.md tools/major/new-tool.md
   ```

3. **Fill in all sections** following the format in TEMPLATE.md

4. **Update main documentation:**
   - Add to README.md tool list, comparison tables, and installation section
   - Update CONTRIBUTING.md if adding new categories
   - Add to QUICK_REFERENCE.md if appropriate

5. **Create examples:**
   - CI/CD integration example in `examples/ci-cd/`
   - Automation script in `examples/automation/`
   - Test scripts in `test/`

### Updating Existing Documentation

1. **Verify current information:**
   - Check official documentation for changes
   - Test installation and basic commands
   - Verify model availability

2. **Update the individual tool file** in `tools/major/`

3. **Update related files:**
   - README.md comparison tables and installation section
   - QUICK_REFERENCE.md quick commands
   - CONTRIBUTING.md if workflow changes

4. **Add examples** if new features warrant them

### Testing Documentation

All test scripts are in `test/` directory:

- `{tool}-headless-basic.test.sh` - Basic headless mode tests
- `{tool}-headless-advanced.test.sh` - Advanced headless scenarios
- `{tool}-cicd-integration.test.sh` - CI/CD integration tests
- `{tool}-workflows.test.sh` - Workflow automation tests

Run tests to verify documentation accuracy:

```bash
bash test/claude-headless-basic.test.sh
bash test/gemini-workflows.test.sh
```

## Important Files to Reference

### When Adding/Updating Tools

1. **TEMPLATE.md** - Use this as the exact structure for new tool docs
2. **CONTRIBUTING.md** - Follow contribution guidelines strictly
3. **README.md** - Update tool lists, comparison tables, and installation commands
4. **QUICK_REFERENCE.md** - Add quick command reference if appropriate

### When Reviewing/Understanding the Repository

1. **README.md** - Repository statistics, tool counts, and status
2. **tools/major/** - Individual tool documentation files (14 tools)
3. **examples/** - Real-world CI/CD and automation examples
4. **test/** - Test scripts for verification

## Common Tasks

### Adding a New CI/CD Example

1. Create file in `examples/ci-cd/`:
   - GitHub Actions: `github-actions-{tool}-{purpose}.yml`
   - GitLab CI: `gitlab-ci-{tool}-{purpose}.yml`
   - CircleCI: `circleci-{tool}-{purpose}.yml`

2. Include:
   - Complete working example
   - Comments explaining each step
   - Error handling
   - Environment variables for secrets

3. Add reference to the tool's documentation file

### Creating an Automation Script

1. Create file in `examples/automation/{tool}-{purpose}.sh`

2. Include:
   - Shebang and set flags: `#!/bin/bash` and `set -e`
   - Clear comments
   - Error handling
   - Example usage in comments

3. Make executable: `chmod +x examples/automation/{tool}-{purpose}.sh`

### Updating Model Information

Models change frequently. When updating:

1. Check official documentation for current model list
2. Update the "Available Models" section in the tool's file
3. Update comparison tables in README.md if needed
4. Note any deprecated models in the "Limitations" section

### Installation Method Updates (January 2026)

Several tools have updated their recommended installation methods:

| Tool            | Current Recommended                                              | Notes                          |
| --------------- | ---------------------------------------------------------------- | ------------------------------ |
| **Claude Code** | Native: `curl -fsSL https://claude.ai/install.sh \| bash`        | npm deprecated Feb 2026, use native or `brew install claude-code` |
| **Codex**       | npm or Homebrew: `brew install --cask codex`                     | Windows via WSL                |
| **Aider**       | Install script: `curl -LsSf https://aider.chat/install.sh \| sh` | Python 3.10+ required          |
| **OpenCode**    | Quick install: `curl -fsSL https://opencode.ai/install \| bash`  | v0.1.x incompatible with older |

**Deprecated/Changed:**

- Amazon Q Developer CLI → Migrated to Kiro CLI (Nov 2025)
- GitHub Copilot CLI → Reached GA on Feb 25, 2026 (Node.js 22+ required). Default model: Claude Sonnet 4.5

## Writing Style Guidelines

1. **Be precise:** Use exact command syntax
2. **Be clear:** Explain what each command does
3. **Be consistent:** Follow existing patterns in the repository
4. **Be complete:** Include all necessary flags and options
5. **Be honest:** Document limitations and gotchas clearly

### Common Patterns

**Risk Levels:**

- 🟢 Low: Read-only default, approval required
- 🟠 Medium: Can modify files with explicit flags
- ⚠️ High: Can modify files by default with safeguards
- ⚡ Very High: Can execute commands with minimal safeguards

**Icon Usage:**

- 🚨 = Dangerous (requires caution)
- 🛟 = Safe-by-default (read-only)
- ⚙️ = Required configuration
- ⭐ = Proven approach
- ✅ = Fully supported
- ⚠️ = Limited support
- ❌ = Not supported

## Critical Guidelines

### What NOT to Do

1. **Never add placeholder tools** - Only document tools that actually exist and are verified
2. **Never make up commands** - All CLI syntax must be verified from official documentation
3. **Never duplicate content** - Reference existing docs instead of repeating information
4. **Never add generic advice** - Keep documentation focused on tool-specific information
5. **Never skip the template** - Always use TEMPLATE.md when adding new tools

### What TO Do

1. **Always verify tools exist** - Check official websites and repositories
2. **Always test commands** - Verify installation and basic usage
3. **Always use the template** - Maintain consistency across all tool docs
4. **Always update related files** - Keep README.md, CLAUDE.md, CONTRIBUTING.md, and QUICK_REFERENCE.md in sync
5. **Always document limitations** - Be honest about what tools can't do

## Quick Reference: Tool Categories

**Production CLI Tools with Full Headless Support (10 tools):**

- Gemini, Claude, Codex, Cursor, Copilot, Droid, Aider, Continue Dev, Cline, Kiro

**IDE/Terminal-Based Tools with Limited/No Headless Support (4 tools):**

- Antigravity (⚠️ Google desktop IDE - NO headless/CLI, use Gemini CLI instead)
- Warp (⚠️ Agentic development environment - `warp-terminal agent run` for headless, but primarily a terminal emulator)
- Windsurf (⚠️ Cognition/Devin AI ownership - requires Docker for headless)
- Amazon Q (⚠️ DEPRECATED Nov 2025 - migrated to Kiro CLI)

**Multi-Language Tools (1 tool):**

- OpenCode

**Total: 15 documented tools (10 with full headless, 4 with limited/no headless, 1 deprecated)**

## ⚠️ Known Issues and Tech Debt

### Critical Documentation Gaps

1. **Kiro**: ~~Documented but lacks actual headless mode~~ **RESOLVED (March 2026)** — Kiro CLI v1.28 is now a full terminal agent with custom agents, skills, granular tool trust, dynamic model selection, and experimental TUI (`--tui` flag). Reclassified to full headless support.
   - Zero examples in `examples/` directory
   - Zero test scripts in `test/` directory
   - **Action needed**: Add CI/CD examples and test scripts

2. **Amazon Q Developer CLI**: **DEPRECATED** as of November 17, 2025
   - Migrated to Kiro CLI via `q update` (auto-upgraded Nov 24, 2025)
   - License changed from Apache 2.0 to AWS Intellectual Property License
   - `q` and `q chat` commands still work for backward compatibility
   - Documentation retained for legacy reference

3. **Warp**: Evolved from terminal emulator to agentic development environment
   - `warp-terminal agent run --prompt "..."` supports headless automation
   - Oz cloud agent platform, scheduled agents, Slack/Linear/GitHub Actions integrations
   - Still primarily a terminal emulator at its core

6. **Cline**: Supply chain attack on CLI v2.3.0 (Feb 17, 2026)
   - Malicious package via stolen npm publish token (~4,000 downloads in 8-hour window)
   - v2.3.0 deprecated, v2.4.0 published as clean replacement
   - Publishing now uses OIDC via GitHub Actions
   - See [GHSA-9ppg-jx86-fqw7](https://github.com/cline/cline/security/advisories/GHSA-9ppg-jx86-fqw7)

4. **Windsurf**: IDE-based (Cognition/Devin AI ownership), requires Docker for headless
   - Missing CLI Syntax section in documentation
   - Headless mode via community Docker project only

5. **Antigravity**: Google desktop IDE (Nov 2025), NO headless/CLI
   - Google recommends Gemini CLI for headless automation
   - **MCP support added** (Firebase MCP server, improved auth in v1.21.6), aggressive rate limits
   - Zero examples in `examples/` directory
   - Zero test scripts in `test/` directory

### Test Coverage Gaps

| Tool     | Missing Tests                          |
| -------- | -------------------------------------- |
| Kiro     | ALL (basic, advanced, cicd, workflows) |
| Cline    | cicd-integration                       |
| Cursor   | cicd-integration                       |
| Droid    | cicd-integration                       |
| Gemini   | cicd-integration                       |
| Warp     | advanced, cicd-integration             |
| Windsurf | advanced, cicd-integration             |

### Documentation Section Gaps

- **Security sections**: Missing from 9 of 14 tool docs
- **Output Formats sections**: Missing from 10 of 14 tool docs
- **CLI Syntax section**: Missing from windsurf.md

## Version Information

- **Repository Created:** November 2025
- **Last Major Update:** March 28, 2026
- **Last Audit:** March 28, 2026
- **Total Tools Documented:** 15 (10 with full headless support, 4 limited/no headless, 1 deprecated)
- **Documentation Files:** 30 markdown files total
  - 4 main docs (README, CLAUDE, CONTRIBUTING, QUICK_REFERENCE)
  - 15 individual tool docs (tools/major/)
  - 1 template (tools/TEMPLATE.md)
  - 1 test README (test/README.md)
  - 6 workflow docs (examples/_-workflows/_.md)
  - 3 issue templates (.github/ISSUE_TEMPLATE/)
- **Example Files:** 50 (CI/CD, automation, and workflow scripts)
- **Test Scripts:** 56 (comprehensive test coverage for 13 of 15 tools)
- **Total Lines of Documentation:** ~8,764 (main docs and tool files)

## Getting Help

- Review CONTRIBUTING.md for detailed contribution guidelines
- Check existing tool documentation in tools/major/ for examples
- Reference TEMPLATE.md for standardized documentation structure
- See README.md for repository statistics and tool listings
