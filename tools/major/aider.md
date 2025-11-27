# 🤖 Aider

**Version tested:** Latest (check with `aider --version`)  
**Risk level:** 🟠 Medium (can modify files, Git-based editing)

**When NOT to use Aider:**
- ❌ You need pure headless automation without interactive features
- ❌ You need massive context windows (Gemini handles larger repos better)
- ❌ You need UI/front-end generation (Codex is better for this)
- ❌ You're working in a non-Git repository (Aider uses Git for context)

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Aider](#-why-use-aider)
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

Aider is an AI pair-programming tool that integrates directly into your terminal, facilitating collaborative coding sessions. It supports local Git-based editing with LLM collaboration, making it ideal for interactive code editing and pair programming workflows.

**Key Characteristics:**
- Terminal-based AI pair programming
- Git integration for context and version control
- Supports multiple LLM providers (Claude, GPT-4, DeepSeek, local models)
- Interactive editing workflow
- File-level code editing
- Codebase mapping for enhanced context
- Voice-to-code capabilities
- Automatic linting and testing
- Supports 100+ programming languages

## Installation

**Using pip:**
```bash
pip install aider-chat
```

**Using aider-install (recommended):**
```bash
python -m pip install aider-install
aider-install
```

**Using pipx:**
```bash
pipx install aider-chat
```

**Using Homebrew (macOS):**
```bash
brew install aider
```

**System Requirements:**
- Python 3.8 or later
- Git repository (for best experience)
- API key for LLM provider (OpenAI, Anthropic, etc.)

## 🚀 Start Here

```bash
# Set API key
export OPENAI_API_KEY=your_key
# or
export ANTHROPIC_API_KEY=your_key

# Start aider in a Git repository
aider
```

## Headless Mode

**Non-interactive execution for automation, scripting, and CI/CD pipelines:**

```bash
# Basic headless mode with file specification
aider file1.py file2.py

# With specific prompt (non-interactive)
aider --message "Add error handling to these files" file1.py file2.py

# Auto-accept all changes (required for true headless automation)
aider --yes --message "Fix linting issues" src/

# Using stdin input
echo "Add logging" | aider file1.py

# Combined: stdin + auto-accept
echo "Refactor to use async/await" | aider --yes src/api.py

# Headless with model specification
aider --yes --model gpt-4o --message "Generate unit tests" src/calculator.py

# Headless with no Git integration (faster, less context)
aider --yes --no-git --message "Add type hints" file1.py file2.py
```

**Key Headless Flags:**
- `--yes` / `-y`: Auto-accept all changes (essential for automation)
- `--message MESSAGE` / `-m MESSAGE`: Provide initial prompt
- `--no-git`: Disable Git integration (faster, less context)
- `--model MODEL`: Specify LLM model
- `--api-key PROVIDER=KEY`: Override API key for specific provider

**Limitations:**
- Primarily interactive tool, but `--yes` enables headless automation
- Best used in Git repositories (provides better context)
- Without `--yes`, may require user confirmation for file edits
- Some interactive features may not work in pure headless mode

## Available Models

Aider supports multiple LLM providers with the latest models:

| Provider | Models | Description |
|----------|--------|-------------|
| OpenAI | `gpt-4o`, `gpt-4o-mini`, `o1`, `o1-mini`, `o3`, `o3-mini`, `gpt-3.5-turbo` | Default provider, excellent code generation |
| Anthropic | `claude-3.7-sonnet`, `claude-3-opus`, `claude-3.5-sonnet`, `claude-3-sonnet`, `claude-3-haiku` | Strong reasoning, excellent for refactoring |
| DeepSeek | `deepseek-r1`, `deepseek-chat`, `deepseek-v3` | Alternative with strong reasoning, cost-effective |
| Google | `gemini-pro`, `gemini-1.5-pro` | Alternative option |
| Local | Various via Ollama | Run models locally (requires Ollama setup) |

**Model Selection:**
```bash
# Use specific OpenAI model
aider --model gpt-4o
aider --model o1
aider --model o3-mini

# Use Anthropic Claude (latest)
aider --model claude-3.7-sonnet
aider --model claude-3-opus

# Use DeepSeek
aider --model deepseek-r1
aider --model deepseek-chat

# With API key override
aider --model gpt-4o --api-key openai=your_key
aider --model claude-3.7-sonnet --api-key anthropic=your_key

# Headless with model selection
aider --yes --model gpt-4o --message "Refactor code" src/
```

**Default Model:**
- If no model is specified, aider uses the default from your configuration or environment
- Set default via `AIDER_MODEL` environment variable or config file

## CLI Syntax

**Basic usage:**
```bash
aider [options] [files...]
```

**Common options:**
- `--model MODEL` / `-m MODEL`: Specify LLM model
- `--message MESSAGE` / `-m MESSAGE`: Provide initial prompt (note: `-m` conflicts with `--model`, use `--message` for prompts)
- `--yes` / `-y`: Auto-accept all changes (required for headless automation)
- `--no-git`: Disable Git integration (faster, less context)
- `--api-key PROVIDER=KEY`: Override API key for specific provider
- `--version`: Show version
- `--help`: Show help message

**Headless Mode Options:**
```bash
# Essential for automation
aider --yes --message "Your prompt" file1.py file2.py

# With stdin
echo "Your prompt" | aider --yes file1.py

# Multiple files
aider --yes --message "Refactor all files" src/*.py

# Directory-based (requires Git repo)
aider --yes --message "Add error handling" src/
```

**Interactive mode:**
```bash
# Start interactive session
aider

# In aider prompt:
# > Add error handling to main.py
# > Refactor authentication module
# > exit
```

## Configuration

**Environment Variables:**
```bash
export OPENAI_API_KEY=your_key
export ANTHROPIC_API_KEY=your_key
export AIDER_MODEL=gpt-4
```

**Config file:**
- Location: `~/.aider.conf` or `.aider.conf` in project
- Format: INI-style configuration

**Example config:**
```ini
[default]
model = gpt-4
auto_commits = true
```

## Examples

**Add features to existing files (interactive):**
```bash
aider src/main.py src/utils.py
# Then interactively: "Add logging and error handling"
```

**Add features (headless):**
```bash
aider --yes --message "Add logging and error handling" src/main.py src/utils.py
```

**Refactor code (headless):**
```bash
aider --yes --model claude-3.7-sonnet --message "Refactor to use async/await" src/api.py
```

**Generate tests (headless):**
```bash
aider --yes --model gpt-4o --message "Generate comprehensive unit tests with 80%+ coverage" src/calculator.py
```

**Batch editing (headless):**
```bash
aider --yes --message "Add type hints to all functions" file1.py file2.py file3.py
```

**Fix linting issues (headless):**
```bash
aider --yes --message "Fix all linting issues reported by flake8" src/
```

**Add documentation (headless):**
```bash
aider --yes --message "Add comprehensive docstrings following Google style guide" src/
```

**Security improvements (headless):**
```bash
aider --yes --model claude-3.7-sonnet --message "Review and fix security vulnerabilities, add input validation" src/
```

**Code review automation:**
```bash
# Review changed files
git diff --name-only | xargs aider --yes --message "Review for bugs and suggest improvements"
```

## CI/CD Integration

**Headless automation for CI/CD pipelines:**

**Basic CI/CD Pattern:**
```bash
#!/bin/bash
set -e

# Set API key
export OPENAI_API_KEY=$OPENAI_API_KEY
# or
export ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY

# Run aider in headless mode
aider --yes --message "Fix linting issues and add type hints" src/

# Check exit code
if [ $? -eq 0 ]; then
  echo "✅ Aider completed successfully"
else
  echo "❌ Aider failed"
  exit 1
fi
```

**GitHub Actions Example:**
```yaml
- name: Run Aider Code Fixes
  env:
    OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
  run: |
    aider --yes --message "Fix linting issues" src/
```

**Pre-commit Hooks:**
```bash
#!/bin/sh
# .git/hooks/pre-commit

# Run aider for code quality
aider --yes --message "Ensure code follows style guide" $(git diff --cached --name-only --diff-filter=ACM | grep '\.py$')
```

**Automated Code Generation:**
```bash
# Generate tests
aider --yes --model gpt-4o --message "Generate comprehensive unit tests" src/calculator.py

# Refactor code
aider --yes --model claude-3.7-sonnet --message "Refactor to use async/await patterns" src/api.py

# Add documentation
aider --yes --message "Add docstrings to all functions" src/
```

**Best Practices for CI/CD:**
- Always use `--yes` flag for non-interactive execution
- Set appropriate API keys as secrets
- Use `--no-git` if Git context is not needed (faster)
- Specify models explicitly for consistency
- Handle exit codes properly (non-zero indicates failure)
- Consider timeouts for long-running operations
- Use specific file paths rather than directories when possible

## Limitations

- **Interactive by design:** Not fully headless
- **Git dependency:** Works best in Git repositories
- **Context limits:** Depends on selected LLM provider
- **File editing focus:** Not ideal for large-scale refactoring
- **User confirmation:** May require approval for changes

## References

- Official Website: [aider.chat](https://aider.chat)
- GitHub Repository: [Aider-AI/aider](https://github.com/Aider-AI/aider)
- Official Documentation: [aider.chat Documentation](https://aider.chat/)
- PyPI: [aider-chat](https://pypi.org/project/aider-chat/)

**Note:** Aider is actively developed. Check the GitHub repository for the latest features and documentation.

