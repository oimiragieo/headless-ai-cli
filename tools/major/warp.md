# ⚡ Warp Terminal

**Version tested:** Latest (check with `warp --version` or via terminal)  
**Risk level:** 🟢 Low (Terminal emulator, enhances CLI tool usage)

**When NOT to use Warp:**
- ❌ You need a pure CLI tool (Warp is a terminal emulator)
- ❌ You're working in a server environment without GUI
- ❌ You need terminal-agnostic automation scripts
- ❌ You prefer traditional terminal emulators

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Warp](#-why-use-warp)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [AI Features](#-ai-features)
- [Available Models](#available-models)
- [CLI Tool Integration](#-cli-tool-integration)
- [CLI Syntax](#-cli-syntax)
- [Configuration](#-configuration)
- [Examples](#-examples)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Warp is a modern terminal emulator built in Rust, designed to enhance command-line productivity with AI-powered features and a user-friendly interface. It combines the functionalities of an IDE and CLI, offering an agentic development environment for coding with multiple AI agents.

**Key Characteristics:**
- Built in Rust with GPU acceleration
- AI-powered command suggestions and error explanations
- Block-based output organization
- Team collaboration features (Warp Drive)
- Modern input editor with IDE-like experience

## Installation

**Download and Install:**

**macOS:**
```bash
# Download from warp.dev or use Homebrew
brew install --cask warp
```

**Windows:**
```bash
# Download installer from warp.dev
# Or use winget
winget install Warp.Warp
```

**Windows (WSL - Windows Subsystem for Linux):**
```bash
# Install dependencies and add Warp repository
sudo apt-get install wget gpg

# Download and add Warp GPG key
wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor > warpdotdev.gpg
sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg

# Add Warp repository to sources
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'

# Clean up temporary GPG file
rm warpdotdev.gpg

# Update package list and install Warp
sudo apt update && sudo apt install warp-terminal
```

**Linux (Debian/Ubuntu):**
```bash
# Same as WSL installation above
sudo apt-get install wget gpg
wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor > warpdotdev.gpg
sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'
rm warpdotdev.gpg
sudo apt update && sudo apt install warp-terminal
```

**Linux (Other distributions):**
```bash
# Download from warp.dev
# Or use package manager specific to your distribution
```

**System Requirements:**
- macOS: macOS 10.14 or later
- Windows: Windows 10 or later (native) or WSL 2 (for Linux version)
- Linux: Modern distributions (Ubuntu 18.04+, Debian 10+, etc.)
- GPU acceleration recommended for best performance

## 🚀 Start Here

```bash
# Launch Warp terminal (GUI)
# Use natural language or commands as usual
# Warp AI will provide suggestions and assistance

# Or use Warp CLI for automation
warp-terminal agent run --prompt "Warp anything"
```

## AI Features

### Warp AI
- **Command Generation:** Natural language to command conversion
- **Error Explanations:** AI-powered error diagnosis and solutions
- **Interactive Shell:** AI agents can run commands and work inside CLI apps
- **Context Awareness:** Uses codebase context, images, URLs, and documentation
- **Model Integration:** Supports AI models from OpenAI, Anthropic, and Google
- **Agent Profiles:** Configure agent behavior and permissions via profiles

### Universal Input
- Modern input editor with cursor movement
- Multi-line editing capabilities
- Rich command completions
- Contextual chips (directory paths, Git status, runtime versions)

### Agents
- Autodetects natural language prompts vs commands
- Multiple agents can run simultaneously
- Unified panel for managing agent interactions
- Full terminal use: can run interactive commands, work inside CLI apps
- Supports MCP (Model Context Protocol) and codebase embeddings

## Available Models

Warp lets you choose from a curated set of Large Language Models (LLMs) to power your Agentic Development Environment.

**Supported Models:**

| Provider | Models | Description |
|----------|--------|-------------|
| **OpenAI** | GPT-5, GPT-5.1 | Select between low, medium, and high reasoning modes |
| **Anthropic** | Claude Sonnet 4.5, Claude Opus 4.1, Claude Haiku 4.5, Claude Sonnet 4 | Strong reasoning and coding capabilities |
| **Google** | Gemini 3 Pro, Gemini 2.5 Pro | Large context support |
| **z.ai** | GLM 4.6 | Hosted in the US by Fireworks AI |

**Auto Models:**

Warp also offers two Auto modes that intelligently select the best model for your task based on the context and request type:

- **Auto (Cost-efficient):** Optimizes for lower credit consumption while maintaining strong output quality, helping extend your available usage.

- **Auto (Responsiveness):** Prioritizes the highest-quality results using the fastest available model, though it may consume credits more quickly.

Both Auto models perform well across all agent workflows and are ideal if you prefer Warp to manage model selection dynamically.

**Model Selection:**
- Models can be configured in Warp settings (GUI)
- Auto modes are recommended for most use cases
- Choose specific models for specialized tasks requiring particular model capabilities

## CLI Tool Integration

**Warp works seamlessly with all AI CLI tools:**

### Using with Gemini CLI
```bash
# Warp terminal with Gemini CLI
gemini -p "Review this codebase" --output-format json
# Warp AI can help explain Gemini output
```

### Using with Claude CLI
```bash
# Warp terminal with Claude CLI
claude -p "Explain this architecture" --output-format json
# Warp's block-based output makes results easier to navigate
```

### Using with Codex
```bash
# Warp terminal with Codex
codex exec "Generate unit tests"
# Warp AI can assist with understanding Codex output
```

### Using with Cursor Agent
```bash
# Warp terminal with Cursor
cursor-agent -p --force "Refactor this code"
# Warp's modern input makes command editing easier
```

### Using with Droid
```bash
# Warp terminal with Droid
droid exec --auto low "Run security audit"
# Warp blocks organize Droid output clearly
```

### Using with Copilot CLI
```bash
# Warp terminal with Copilot
copilot -p "Review PR #123"
# Warp AI can help interpret Copilot suggestions
```

## CLI Syntax

**Warp, the Agentic Development Environment.**

The Warp CLI is a tool for programming agents. You can use it to:
* Create autonomous, asynchronous agents that respond to event triggers, run on schedules, or respond to queries in third-party services.
* Run one-off agents on remote machines.
* Check Warp configuration in order to set up new agents.

**Basic usage:**
```bash
warp-terminal [OPTIONS]
warp-terminal <COMMAND>
```

**Core Options:**
- `--api-key <API_KEY>` - API key for server authentication (available to all subcommands)
- `--debug` - Enable debug logging
- `--crash-recovery-mechanism <CRASH_RECOVERY_MECHANISM>` - Crash recovery mechanism to use if parent process terminated
  - Possible values: `force-x11`, `force-dedicated-gpu`, `disable-opengl`, `force-vulkan`
- `-h, --help` - Print help

**Commands:**

**Agent Management:**
```bash
# Interact with Warp's agent
warp-terminal agent

# Run agent with prompt
warp-terminal agent run --prompt "Warp anything"

# Manage agent profiles, settings, etc.
warp-terminal agent --help
```

**Environment Management:**
```bash
# Manage cloud environments
warp-terminal environment
# or alias
warp-terminal e
```

**MCP (Model Context Protocol):**
```bash
# Manage MCP servers
warp-terminal mcp

# List MCP servers
warp-terminal mcp list

# Add, remove, configure MCP servers
warp-terminal mcp --help
```

**Task Management:**
```bash
# Manage tasks
warp-terminal task

# Create, list, manage tasks
warp-terminal task --help
```

**Authentication:**
```bash
# Log in to Warp
warp-terminal login
```

**Integration Management:**
```bash
# Manage integrations
warp-terminal integration
# or alias
warp-terminal i
```

**Shell Completions:**
```bash
# Generate shell completions for your shell to stdout
warp-terminal completions

# Example: Generate completions for bash
warp-terminal completions bash > ~/.local/share/bash-completion/completions/warp-terminal

# Example: Generate completions for zsh
warp-terminal completions zsh > ~/.zfunc/_warp-terminal
```

**Debugging:**
```bash
# Print debugging information and exit
warp-terminal dump-debug-info
# or
warp-terminal --dump-debug-info
```

**Help:**
```bash
# Print help message or help for specific subcommand
warp-terminal help
warp-terminal help <COMMAND>
```

## Automation & Headless Mode

**Warp CLI for Automation:**
```bash
# Run agent in headless mode (without GUI)
warp-terminal agent run --prompt "Your task here"

# With API key authentication
warp-terminal --api-key your-api-key agent run --prompt "Review code"

# With debug logging
warp-terminal --debug agent run --prompt "Analyze security"

# List MCP servers
warp-terminal mcp list

# Manage tasks
warp-terminal task list

# Log in to Warp
warp-terminal login
```

**Note:** Warp CLI allows automation without the GUI, but Warp is primarily a terminal emulator. For pure headless automation, consider using the AI CLI tools directly (Gemini, Claude, Codex, etc.) within Warp or in traditional terminals.

## Workflows

**Create and share workflows:**
```bash
# Create workflow directory
mkdir -p ~/.warp/workflows/

# Create workflow YAML file
cat > ~/.warp/workflows/my-workflow.yaml <<EOF
name: Run Tests
command: npm test
description: Run the test suite
tags: ["test", "npm"]
EOF
```

**Execute workflows:**
- Access workflows from Warp's command palette
- Share workflows via Warp Drive
- Use workflows in automation scripts

## Configuration

**Settings Location:**
- macOS: `~/Library/Application Support/warp`
- Windows: `%APPDATA%\warp`
- Linux: `~/.config/warp`

**Workflows Location:**
- Local workflows: `~/.warp/workflows/`
- Team workflows: Shared via Warp Drive

**Shell Support:**
- Zsh, Bash, Fish, PowerShell, WSL, Git Bash
- Prompt frameworks: PS1, Starship, Spaceship, P10K, Oh-my-Posh, Oh-my-Zsh

**Themes and Customization:**
- Custom themes available
- Keybindings customization
- Prompt style customization
- Input positioning options

**Agent Profiles:**
- Manage agent behavior and permissions
- Create profiles for different use cases
- Use profiles in automation workflows

**Warp Drive (Team Collaboration):**
- Secure, encrypted repository
- Share commands, workflows, and runbooks
- Sync across team members
- Standardize development processes

## CI/CD Integration

**GitHub Actions workflow:**
```yaml
name: Warp Agent Automation

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  warp_task:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - name: Checkout code
        uses: actions/checkout@v5

      - name: Run Warp Agent
        uses: warp.dev/warp-agent-action@v1
        with:
          api_key: ${{ secrets.WARP_API_KEY }}
          prompt: "Review the latest pull request changes for bugs, security issues, and best practices. Provide actionable feedback."
          profile: "code-review-profile"
```

**Direct CLI usage in CI/CD:**
```bash
#!/bin/bash
set -e

# Run agent with API key
warp-terminal --api-key "$WARP_API_KEY" \
  agent run \
  --prompt "Review code changes for security issues"

# With debug logging
warp-terminal --api-key "$WARP_API_KEY" --debug \
  agent run \
  --prompt "Analyze for vulnerabilities"

# Error handling
if [ $? -eq 0 ]; then
  echo "✅ Review completed"
else
  echo "❌ Review failed"
  exit 1
fi
```

**Best practices for CI/CD:**
- Use `warp agent run` for headless automation
- Configure agent profiles for different tasks
- Store API keys as secrets, never hardcode
- Warp agents can integrate with GitHub, databases, and other tools via MCP
- Use workflows for reusable automation patterns

## Examples

### Natural Language to Command
```
User types: "Show me all Python files modified in the last week"
Warp AI suggests: git log --since="1 week ago" --name-only -- "*.py"
```

### Error Explanation
```bash
$ npm install
Error: EACCES: permission denied
# Warp AI explains the error and suggests: sudo npm install (or use nvm)
```

### Multi-Agent Workflow
```
1. Start agent: "Analyze this codebase for security issues"
2. Start another agent: "Generate documentation"
3. Both agents work simultaneously
4. Manage both in unified panel
```

### Headless Agent Execution
```bash
# Run agent without GUI
warp-terminal agent run --prompt "Review PR changes"

# With API key authentication
warp-terminal --api-key your-api-key agent run --prompt "Generate report"

# With output redirection
warp-terminal agent run --prompt "Generate report" > report.txt

# With debug logging
warp-terminal --debug agent run --prompt "Analyze security"
```

### Block-Based Navigation
```
# Warp organizes terminal output into blocks
# Each command and its output is a block
# Easy to scroll, search, and share specific blocks
```

## Best Use Cases

- **Enhanced CLI Tool Experience:** Better terminal for running AI CLI tools
- **Team Collaboration:** Share commands and workflows via Warp Drive
- **Error Debugging:** AI-powered error explanations
- **Command Discovery:** Natural language to command conversion
- **Multi-Agent Development:** Run multiple AI agents simultaneously
- **Code Review:** Use with AI CLI tools for enhanced code review workflows

## Limitations

- **GUI Required for Full Features:** Terminal emulator requires GUI for full functionality
- **CLI Automation Available:** `warp-terminal agent run` allows headless automation but limited compared to pure CLI tools
- **Platform Specific:** Different installation methods per platform
- **Learning Curve:** Modern interface may differ from traditional terminals
- **Resource Usage:** GPU acceleration requires compatible hardware
- **Privacy:** AI features may send data to external services (check privacy policy)
- **Not a Pure CLI Tool:** Warp is a terminal emulator, not a standalone CLI tool like Gemini or Claude
- **API Key Required for CLI:** Need API key authentication for headless CLI automation

## Integration with AI CLI Tools

**Warp enhances the experience of using AI CLI tools:**

1. **Better Output Organization:** Block-based output makes AI CLI results easier to read
2. **AI Assistance:** Warp AI can help interpret AI CLI tool output
3. **Command History:** Better command history and search
4. **Multi-line Editing:** Easier to compose complex AI CLI commands
5. **Team Sharing:** Share AI CLI workflows via Warp Drive

## References

- Official Website: [warp.dev](https://www.warp.dev)
- Documentation: [docs.warp.dev](https://docs.warp.dev)
- Terminal Features: [warp.dev/terminal](https://www.warp.dev/terminal)
- Agents Documentation: [docs.warp.dev/agents](https://docs.warp.dev/agents)
- CLI Documentation: [docs.warp.dev/developers/cli](https://docs.warp.dev/developers/cli)
- GitHub: [github.com/warpdotdev/Warp](https://github.com/warpdotdev/Warp)

**Note:** Warp is a commercial product with free and paid tiers. Check current pricing and features on the official website.

