# 🔄 Continue Dev

**Version tested:** Latest (check via VS Code extension or CLI)  
**Risk level:** 🟢 Low (VS Code extension with CLI support)

**When NOT to use Continue Dev:**
- ❌ You need pure CLI-only workflows (Continue is primarily a VS Code extension)
- ❌ You're not using VS Code
- ❌ You need headless-only automation
- ❌ You need massive context windows (Gemini handles larger repos better)

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Continue Dev](#-why-use-continue-dev)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Headless Mode](#-headless-mode)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [Configuration](#-configuration)
- [Examples](#-examples)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Continue Dev is an open-source CLI tool designed to accelerate development workflows through Continuous AI. It offers both a Text User Interface (TUI) mode for interactive development and a Headless mode for running background agents, integrating seamlessly into existing development environments.

**Key Characteristics:**
- Interactive TUI mode for exploration and debugging
- Headless mode for CI/CD pipelines and automation
- Context engineering with `@` file references and `/` commands
- Tool integration (file editing, terminal, Git, web search)
- Model flexibility with Continue Mission Control
- Open-source (Apache-2.0 license)

## Installation

**CLI Installation:**
```bash
# Ensure Node.js 18+ is installed
node --version

# Install Continue CLI globally
npm install -g @continuedev/cli

# Or using yarn
yarn global add @continuedev/cli
```

**VS Code Extension (Optional):**
1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X / Cmd+Shift+X)
3. Search for "Continue"
4. Install the Continue extension

**System Requirements:**
- VS Code 1.70.0 or later
- API keys for LLM providers (OpenAI, Anthropic, etc.)

## 🚀 Start Here

```bash
# Navigate to your project
cd your-awesome-project

# Start Continue CLI
cn

# Or use full command
continue

# On first use, you'll be prompted to set up the tool
```

## Headless Mode

**Non-interactive execution for automation, scripting, and CI/CD pipelines:**

**Basic Headless Usage:**
```bash
# Run prompt in headless mode
cn -p "Your prompt here"
# or
continue -p "Your prompt here"

# With Continue API key
export CONTINUE_API_KEY=your_api_key_here
cn -p "Update documentation based on recent code changes"

# Analyze code changes
cn -p "Analyze recent code changes and update the documentation accordingly"

# Review code
cn -p "Review this code for bugs and security issues" --file src/main.py
```

**Headless Mode with Agents:**
```bash
# Run background agents
continue headless --agent "code-review" --trigger "pull-request"

# Execute workflow
continue headless --workflow "security-audit"

# Background agent on schedule
continue headless --agent "dependency-update" --schedule "daily"

# Run specific agent
continue headless --agent <agent-name> [options]
```

**Headless Mode with Files:**
```bash
# Process specific file
cn -p "Add docstrings" --file src/main.py

# Process multiple files
cn -p "Add type hints" --files src/main.py src/utils.py

# Process directory
cn -p "Analyze codebase" --directory src/
```

**TUI Mode (Interactive):**
```bash
# Start interactive TUI
cn

# Use @ to reference files
@src/main.py explain this function

# Use / for specific tasks
/refactor this code to use async/await
```

**Context Engineering:**
- `@filename` - Reference specific files
- `/command` - Execute specific tasks
- Supports file editing, terminal commands, Git operations

**Key Headless Flags:**
- `-p, --prompt TEXT`: Provide prompt directly (headless mode)
- `--file, -f FILE`: Include file in context
- `--files, -F FILES`: Include multiple files (space-separated)
- `--directory, -d DIR`: Include directory in context
- `--agent NAME`: Run specific agent
- `--workflow NAME`: Execute workflow
- `--schedule SCHEDULE`: Schedule agent (cron format)
- `--output, -o FILE`: Save output to file

## Available Models

Continue Dev supports multiple LLM providers:

| Provider | Models | Description |
|----------|--------|-------------|
| OpenAI | `gpt-4o`, `gpt-4o-mini`, `o1`, `o3-mini`, `gpt-4`, `gpt-3.5-turbo` | Default option, excellent code generation |
| Anthropic | `claude-3.7-sonnet`, `claude-3-opus`, `claude-3.5-sonnet`, `claude-3-haiku` | Strong reasoning capabilities |
| Google | `gemini-pro`, `gemini-1.5-pro` | Alternative option |
| DeepSeek | `deepseek-r1`, `deepseek-chat`, `deepseek-v3` | Alternative with strong reasoning |
| Local | Various via Ollama | Run models locally |
| Open Source | CodeLlama, StarCoder | Local models |

**Model Selection:**
```bash
# Use specific model
cn -p "Your task" --model gpt-4o

# Use Anthropic Claude
cn -p "Your task" --model claude-3.7-sonnet

# Configure default model via config file
```

**Model Configuration:**
- Configure in `config.yaml` or VS Code settings
- Support for multiple models simultaneously
- Model selection per conversation
- Continue Mission Control for API key management

## CLI Syntax

**Basic usage:**
```bash
cn [options]
continue [command] [options]
```

**TUI Mode:**
```bash
# Start interactive TUI
cn

# In TUI:
# @filename - Reference files
# /command - Execute tasks
# Type natural language prompts
```

**Headless Mode:**
```bash
# Basic headless prompt
cn -p "Your prompt here"
continue -p "Your prompt here"

# Run background agent
continue headless --agent <agent-name> [options]

# Execute workflow
continue headless --workflow <workflow-name>

# Schedule agent
continue headless --agent <agent-name> --schedule <schedule>

# With file context
cn -p "Add docstrings" --file src/main.py

# With multiple files
cn -p "Refactor code" --files src/main.py src/utils.py

# With directory
cn -p "Analyze codebase" --directory src/
```

**Common options:**
- `-p, --prompt TEXT`: Provide prompt directly (headless mode)
- `--file, -f FILE`: Include file in context
- `--files, -F FILES`: Include multiple files (space-separated)
- `--directory, -d DIR`: Include directory in context
- `--model MODEL`: Specify LLM model
- `--config PATH`: Use custom config file
- `--headless`: Run in headless mode
- `--agent NAME`: Run specific agent
- `--workflow NAME`: Execute workflow
- `--output, -o FILE`: Save output to file

## Configuration

**Config file:**
- Location: `config.yaml` in project root or `~/.continue/config.yaml`
- Format: YAML configuration

**Example config.yaml:**
```yaml
models:
  - title: GPT-4
    provider: openai
    model: gpt-4
    apiKey: ${OPENAI_API_KEY}
  - title: Claude Sonnet
    provider: anthropic
    model: claude-sonnet-4-20250514
    apiKey: ${ANTHROPIC_API_KEY}

contextProviders:
  - name: "@codebase"
  - name: "@web"
  - name: "@docs"
```

**Environment Variables:**
```bash
export CONTINUE_API_KEY=your_key  # For Continue Mission Control
export OPENAI_API_KEY=your_key
export ANTHROPIC_API_KEY=your_key
```

**Continue Mission Control:**
- API access management
- Secrets management
- Configuration synchronization
- Team collaboration features

## Examples

**TUI Mode:**
```bash
# Start Continue
cn

# Reference files and ask questions
@src/main.py explain this function
@src/utils.py refactor to use async/await

# Use commands
/generate unit tests for src/calculator.py
/analyze codebase for security issues
```

**Headless Mode:**
```bash
# Basic headless prompt
cn -p "Review this code for bugs and security issues" --file src/main.py

# Update documentation
cn -p "Analyze recent code changes and update the documentation accordingly"

# Code review
cn -p "Review these changes for potential issues" --files src/main.py src/utils.py

# Code transformation
cn -p "Refactor to use async/await patterns" --file legacy.py

# Run code review agent on PR
continue headless --agent "code-review" --trigger "pull-request"

# Security audit workflow
continue headless --workflow "security-audit" --directory src/

# Scheduled dependency updates
continue headless --agent "dependency-update" --schedule "0 2 * * *"
```

**CI/CD Integration:**
```yaml
# GitHub Actions example
- name: Run Continue Security Audit
  run: |
    npm install -g @continuedev/cli
    continue headless --workflow "security-audit" --output report.json

# Or with prompt-based headless mode
- name: Update Documentation
  env:
    CONTINUE_API_KEY: ${{ secrets.CONTINUE_API_KEY }}
  run: |
    npm install -g @continuedev/cli
    cn -p "Analyze recent code changes and update the documentation accordingly"
```

## CI/CD Integration

**Headless automation for CI/CD pipelines:**

**Basic CI/CD Pattern:**
```bash
#!/bin/bash
set -e

# Set API key
export CONTINUE_API_KEY=$CONTINUE_API_KEY
# or
export OPENAI_API_KEY=$OPENAI_API_KEY
export ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY

# Run Continue in headless mode
cn -p "Fix linting issues and add type hints" --directory src/

# Check exit code
if [ $? -eq 0 ]; then
  echo "✅ Continue completed successfully"
else
  echo "❌ Continue failed"
  exit 1
fi
```

**GitHub Actions Example:**
```yaml
name: Continue Dev Documentation Update

on:
  push:
    branches:
      - main

jobs:
  update-docs:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v5
        with:
          fetch-depth: 0

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'

      - name: Install Continue CLI
        run: npm install -g @continuedev/cli

      - name: Set API Key
        env:
          CONTINUE_API_KEY: ${{ secrets.CONTINUE_API_KEY }}
        run: echo "CONTINUE_API_KEY=$CONTINUE_API_KEY" >> $GITHUB_ENV

      - name: Run Continue CLI in Headless Mode
        run: |
          cn -p "Analyze recent code changes and update the documentation accordingly."

      - name: Commit and Push Changes
        if: github.event_name == 'push'
        run: |
          git config --global user.name 'github-actions[bot]'
          git config --global user.email 'github-actions[bot]@users.noreply.github.com'
          git add .
          git diff --staged --quiet || (git commit -m "Automated documentation update" && git push)
```

**GitLab CI/CD:**
```yaml
stages:
  - docs

update-docs:
  stage: docs
  image: node:18
  before_script:
    - npm install -g @continuedev/cli
  script:
    - export CONTINUE_API_KEY=$CONTINUE_API_KEY
    - cn -p "Update documentation based on code changes"
  only:
    - main
```

**Best Practices for CI/CD:**
- Always use `-p` flag for headless mode prompts
- Set `CONTINUE_API_KEY` as secret in CI/CD platform
- Use `--file` or `--directory` flags for context
- Handle exit codes properly (non-zero indicates failure)
- Consider timeouts for long-running operations
- Use Continue Mission Control for API key management

## Limitations

- **VS Code dependency:** Primarily designed for VS Code
- **Limited CLI:** CLI capabilities may be minimal or unavailable
- **Interactive focus:** Designed for interactive development
- **Context limits:** Depends on selected LLM provider
- **Extension-based:** Requires VS Code installation

## References

- Official Website: [continue.dev](https://www.continue.dev)
- GitHub Repository: [continuedev/continue](https://github.com/continuedev/continue)
- CLI Documentation: [docs.continue.dev/cli/overview](https://docs.continue.dev/cli/overview)
- VS Code Extension: Search for "Continue" in VS Code Marketplace
- Continue Mission Control: [mission.continue.dev](https://mission.continue.dev)

**Note:** Continue Dev is actively developed. Check the VS Code extension marketplace and GitHub for the latest features and CLI capabilities.

