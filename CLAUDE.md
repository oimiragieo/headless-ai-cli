# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a comprehensive reference repository documenting AI CLI tools that support headless/non-interactive execution. The repository serves as a quick reference guide for developers integrating AI capabilities into automated workflows, CI/CD pipelines, and scripting environments.

**Key Focus:** Headless syntax, features, available models, and automation patterns for 12 verified AI CLI tools.

## Repository Structure

```
headless-ai-cli/
├── README.md                    # Main index with quick reference
├── COMPREHENSIVE.md             # Single comprehensive guide (all tools)
├── QUICK_REFERENCE.md           # Ultra-condensed cheat sheet
├── claude.md                    # Detailed guide for 8 major tools (NOT this file)
├── simple.md                    # Quick reference guide
├── gpt-5.1.md                   # Alternative comprehensive guide
├── INDEX.md                     # Complete navigation index
├── CONTRIBUTING.md              # Contribution guidelines
├── tools/
│   ├── TEMPLATE.md              # Standardized template for new tools
│   └── major/                   # Individual tool documentation (12 files)
│       ├── gemini.md            # Google Gemini CLI
│       ├── claude.md            # Anthropic Claude (Claude Code)
│       ├── codex.md             # OpenAI Codex
│       ├── cursor.md            # Cursor Agent
│       ├── copilot.md           # GitHub Copilot CLI
│       ├── droid.md             # Factory AI Droid
│       ├── kiro.md              # Kiro AI IDE
│       ├── warp.md              # Warp Terminal
│       ├── windsurf.md          # Windsurf IDE
│       ├── cline.md             # Cline
│       ├── aider.md             # Aider
│       ├── continue-dev.md      # Continue Dev
│       ├── amazon-q.md          # Amazon Q Developer
│       └── (others)
├── examples/
│   ├── ci-cd/                   # CI/CD integration examples
│   ├── automation/              # Automation scripts
│   ├── workflows/               # Common workflow patterns
│   └── (tool-specific workflows)
└── test/
    └── *.test.sh                # Test scripts for each tool
```

## Documentation Standards

### File Organization Principles

1. **Main Documentation Files:**
   - `README.md` - Entry point, quick decision tree, tool comparison tables
   - `COMPREHENSIVE.md` - Single-file reference for all tools
   - `QUICK_REFERENCE.md` - Ultra-condensed cheat sheet for daily use
   - `claude.md` - Detailed guide covering 8+ major tools (the comprehensive guide used as user instructions)
   - Individual tool files in `tools/major/` - Deep-dive documentation for each tool

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
   - Add to README.md tool list and comparison tables
   - Add to INDEX.md with navigation links
   - Consider adding to claude.md if it's a major tool
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
   - README.md comparison tables
   - claude.md if the tool is covered there
   - QUICK_REFERENCE.md quick commands

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
3. **README.md** - Update tool lists and comparison tables
4. **INDEX.md** - Add navigation links
5. **claude.md** - Consider if the tool should be added to the comprehensive guide

### When Reviewing/Understanding the Repository

1. **VERIFICATION_STATUS.md** - Shows which tools have been verified as existing vs removed as non-existent
2. **COMPLETION_REPORT.md** - Current status of documentation effort
3. **REPOSITORY_STATUS.md** - Repository statistics and health

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
4. **Always update related files** - Keep README.md, INDEX.md, and claude.md in sync
5. **Always document limitations** - Be honest about what tools can't do

## Quick Reference: Tool Categories

**Major Tools (12 verified, production-ready):**
- Gemini, Claude, Codex, Cursor, Copilot, Droid, Kiro, Warp, Windsurf, Cline, Aider, Continue Dev, Amazon Q

**Emerging Tools:**
- Currently none documented (to be added as discovered)

**Specialized Tools:**
- Currently none documented (to be added as discovered)

## Version Information

- **Repository Created:** November 2025
- **Last Major Update:** November 2025
- **Total Tools Documented:** 12 (all major tools)
- **Placeholder Tools Removed:** 14 (verified non-existent)
- **Total Documentation Files:** 27+ markdown files

## Getting Help

- Review CONTRIBUTING.md for detailed guidelines
- Check existing tool documentation for examples
- Reference TEMPLATE.md for structure
- See VERIFICATION_STATUS.md for tool verification history
