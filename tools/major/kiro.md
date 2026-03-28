# 🎨 Kiro (AI-Powered IDE)

**Version tested:** Latest (check with `kiro --version` or via IDE)  
**Risk level:** 🟠 Medium (IDE with AI agents, can modify files)

**Kiro CLI** (v1.28.0, March 2026) is a full-featured terminal coding agent that replaced Amazon Q Developer CLI.

- Install: `curl -fsSL https://cli.kiro.dev/install | bash`
- Supports custom agents, skills, MCP servers, steering files, and granular tool trust
- Dynamic model selection with `/model` command and tab completion
- File references with `@path` syntax for inline context
- Code intelligence for 18 languages out of the box
- AST pattern search/rewrite tools for structural code transforms
- Experimental refreshed TUI with `--tui` flag (v1.28)
- `--list-models` for checking available models (v1.28)
- `/chat new` command for starting fresh conversations (v1.28)
- Rich markdown rendering with syntax-highlighted code blocks in TUI
- Live status bar and interactive panels in TUI mode

**When NOT to use Kiro:**

- ❌ You need massive context windows (Gemini CLI handles larger repos better)
- ❌ You need completely automated CI/CD without any user interaction (Droid is safer)
- ❌ You're working in a server environment without GUI access (CLI available but IDE features require GUI)
- ❌ You need deterministic, production-safe runs (Droid has better safety guarantees)

### Quick Nav

- [Start Here](#-start-here)
- [Why Use Kiro](#-why-use-kiro)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Headless Mode](#-headless-mode)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [MCP Configuration](#mcp-model-context-protocol-configuration)
- [Features](#-features)
- [Configuration](#-configuration)
- [Examples](#-examples)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Kiro is an AI-powered Integrated Development Environment (IDE) developed by a team from Amazon, designed to enhance the software development process through agentic workflows and AI assistance. It integrates AI agents into the development workflow, acting as an AI pair programmer capable of turning ideas into production-ready code and handling routine tasks.

**Key Characteristics:**

- Built on VS Code foundation (Code OSS)
- Spec-driven development approach
- AWS Bedrock integration for AI capabilities
- Agent hooks for event-driven automation
- Multimodal chat interface

## Installation

### Kiro CLI (Headless Mode)

**Install Kiro CLI:**

```bash
# macOS/Linux/WSL (Windows Subsystem for Linux)
curl -fsSL https://cli.kiro.dev/install | bash

# Verify installation
kiro-cli --version

# Update Kiro CLI
kiro-cli update

# Authenticate
kiro-cli login
```

**⚠️ IMPORTANT - Windows Users:**

- **MUST run in WSL (Windows Subsystem for Linux)**, NOT in PowerShell
- Kiro CLI does not work in native Windows PowerShell
- Use WSL terminal: `wsl` or open Ubuntu/Debian terminal
- If you see errors in PowerShell, switch to WSL

**System Requirements:**

- macOS, Linux, or **WSL on Windows** (required for Windows)
- Internet connection for authentication and AI features
- Shell with curl available

### Kiro IDE (GUI Mode)

**Download and Install:**

1. Visit [kiro.help](https://kiro.help/docs) or [kiroai.ai](https://kiroai.ai)
2. Download installer for your platform:
   - Windows: Windows 10 or later
   - macOS: macOS 10.14 or later
   - Linux: Ubuntu 18.04 or later, or equivalent distributions

**System Requirements:**

- RAM: Minimum 4GB, recommended 8GB or more
- Storage: At least 1GB of free disk space
- Network: Internet connection required for AI features and updates

**First Launch:**

- Log in using: Google, GitHub, Microsoft, AWS, or Email
- Import VS Code settings (optional)
- Set up shell integration for agent command execution

## 🚀 Start Here

**Non-interactive mode is available with `--no-interactive` flag:**

```bash
# Non-interactive headless execution
kiro-cli chat --no-interactive --trust-all-tools "Your prompt here"

# With MCP startup requirement (fail fast if MCP servers don't start, important for CI/CD)
kiro-cli chat --no-interactive --trust-all-tools --require-mcp-startup "Your prompt here"

# Disable colors for CI logs
KIRO_LOG_NO_COLOR=1 kiro-cli chat --no-interactive --trust-all-tools "Review code"
```

**Note:** Browser-based OAuth doesn't work in headless CI environments. MCP tools may not load in `--no-interactive` mode (known issue #5958).

**CLI Usage (Interactive Mode Only):**

```bash
# Install Kiro CLI (in WSL for Windows users)
curl -fsSL https://cli.kiro.dev/install | bash

# Update Kiro CLI
kiro-cli update

# Authenticate
kiro-cli login
# Select "Use with Builder ID"
# Enter device code in browser

# List available agents
kiro-cli agent list

# Start interactive chat with an agent (REQUIRED - no headless mode)
kiro-cli chat --agent <agent-name>
# OR
kiro-cli --agent <agent-name> chat

# Then type commands in the interactive chat:
# > Install the project dependencies
# > Review this code for security issues
```

**Note:** Kiro CLI does NOT support headless mode like `gemini -p ""` or `droid exec ""`. It requires interactive chat with agents.

**IDE Mode:**

```bash
# Download and install Kiro IDE from kiro.help/docs
# Open Kiro IDE and use the integrated terminal for CLI operations
```

## Headless Mode

Kiro CLI supports agent-based execution. While it uses an interactive chat mode by default, you can configure custom agents for specific tasks and use the CLI in automation workflows.

**Agent-based execution:**

```bash
# List available agents
kiro-cli agent list

# Start chat with an agent
kiro-cli chat --agent <agent-name>
# OR
kiro-cli --agent <agent-name> chat

# Create a new agent (AI-assisted, v1.27+)
kiro-cli agent create <name>
# OR manual mode
kiro-cli agent create <name> --manual
```

**Skills for progressive context loading (v1.24+):**

- Only metadata loads at startup; full content loads on demand
- Requires YAML frontmatter with descriptive metadata

**File references (v1.26+):**

```bash
# Inject file contents inline (avoids tool calls, saves tokens)
@src/main.rs    # file contents
@src/           # directory tree
```

**Dynamic model selection (v1.26+):**

```bash
/model claude-opus-4.6   # switch models with tab completion
```

**Granular tool trust (v1.27+):**

- Interactive picker for tiered shell command scoping
- Trust exact command, command with any args, or base command with wildcards
- Read/write tools: scope to file, directory, or entire tool

**⚠️ Windows Users:**

- **MUST run in WSL** (Windows Subsystem for Linux)
- Does NOT work in PowerShell
- Use `wsl` command or open Ubuntu/Debian terminal

**Update CLI:**

```bash
kiro-cli update
```

### Installation

**Install Kiro CLI:**

```bash
curl -fsSL https://cli.kiro.dev/install | bash
```

**Upgrade from Amazon Q Developer CLI:**

```bash
q update
```

**Verify Installation:**

```bash
kiro-cli --version
```

**Authenticate:**

```bash
kiro-cli login
```

**You'll see a menu - select your login method:**

```text
? Select login method ›
❯ Use with Builder ID        # ← Select this for kiro.dev accounts
  Use with IDC Account
```

**For kiro.dev accounts (Use with Builder ID):**

1. Use arrow keys to select **"Use with Builder ID"**
2. Press Enter
3. Browser opens automatically
4. Sign in with your **AWS Builder ID** credentials
   - This is the same account system used by kiro.dev
   - Can be created with email or Google sign-in
5. Browser confirms authentication
6. Return to terminal - you're logged in

**For AWS Identity Center/SSO (Use with IDC Account):**

1. Use arrow keys to select **"Use with IDC Account"**
2. Press Enter
3. You'll be prompted: `? Enter Start URL ›`
4. Enter your organization's AWS SSO start URL:
   - Format: `https://<your-org>.awsapps.com/start`
   - Example: `https://d-1234567890.awsapps.com/start`
5. Press Enter
6. Browser opens for AWS Identity Center authentication
7. Sign in with your organization's SSO credentials

**Verify Login:**

```bash
kiro-cli whoami
```

This displays the account information you're currently authenticated with.

### Basic Headless Usage

**⚠️ CRITICAL: Kiro CLI REQUIRES AGENTS**

**You CANNOT use direct command execution:**

```bash
# ❌ THIS DOES NOT WORK - Kiro CLI does not support this
kiro-cli "Install the project dependencies"  # ERROR: unrecognized subcommand
```

**✅ CORRECT: Use agents with interactive chat:**

```bash
# List available agents first
kiro-cli agent list

# Start interactive chat with an agent (REQUIRED)
kiro-cli chat --agent <agent-name>
# OR
kiro-cli --agent <agent-name> chat

# In the interactive chat, type commands:
# > Install the project dependencies
# > Review this code for security issues
# > Generate unit tests for this file
```

**Chat with Custom Agent:**

```bash
# Use a custom agent for specialized tasks
kiro-cli chat --agent frontend-specialist
# OR
kiro-cli --agent frontend-specialist chat

# Then type commands in the chat interface
```

**Managing Agents:**

```bash
# List all available agents
kiro-cli agent list

# Create or configure agents
kiro-cli agent --help
```

**⚠️ Important Notes:**

- Kiro CLI **REQUIRES agents** - you cannot pass commands directly as arguments
- Unlike `gemini -p ""` or `droid exec ""`, Kiro CLI uses interactive chat mode with agents
- You must use `kiro-cli chat --agent <name>` to start, then type commands in the chat
- **Windows users MUST run in WSL**, not PowerShell

### Custom Agents

**Create Custom Agent Configuration:**

Create a JSON file in your `.kiro` directory (e.g., `.kiro/agents/frontend-specialist.json`):

```json
{
  "name": "frontend-specialist",
  "description": "Expert in building React applications with TanStack Query, TanStack Router, TypeScript, and Vite",
  "prompt": "You are a frontend developer specializing in React, TypeScript, and modern frontend tooling...",
  "tools": ["fs_read", "fs_write", "execute_bash"],
  "toolsSettings": {
    "fs_write": {
      "allowedPaths": [
        "src/components/**",
        "src/routes/**",
        "src/hooks/**",
        "src/lib/**",
        "src/types/**",
        "src/App.tsx",
        "vite.config.ts",
        "package.json"
      ]
    }
  },
  "resources": [
    "file://.kiro/steering/frontend-standards.md",
    "file://.kiro/steering/component-patterns.md"
  ]
}
```

**Use Custom Agent:**

```bash
kiro-cli chat --agent frontend-specialist
```

### Authentication

**Login Process:**

1. Run `kiro-cli login`
2. Select login method:
   - **Use with Builder ID** - For personal kiro.dev accounts (recommended)
   - **Use with IDC Account** - For AWS Identity Center/SSO accounts
3. If using IDC Account, enter your Start URL:
   - Format: `https://<your-org>.awsapps.com/start`
   - Or your organization's AWS SSO start URL
4. Browser window opens automatically for authentication
5. Sign in with your credentials
6. Browser will confirm successful authentication
7. Return to terminal - you're now logged in

**Verify Authentication:**

```bash
# Check current logged-in account
kiro-cli whoami
```

**Logout:**

```bash
kiro-cli logout
```

**Important Notes:**

- **For kiro.dev accounts:** Always select **"Use with Builder ID"**
- **AWS Builder ID** is AWS's personal identity system (same as kiro.dev)
- **IDC Account** is only for organizations using AWS Identity Center/SSO
- If you're already logged into Kiro IDE, the CLI may use the same session

### Security and Trust

**Trusted Commands:**
Kiro CLI prompts for approval before executing commands. Configure trusted commands to streamline automation:

```bash
# Example: Automatically trust all npm commands
# Add to Kiro settings: npm *
```

**Command Approval:**

- First-time commands require approval
- Trusted commands execute automatically
- All commands are logged for review

### IDE Integration

**Terminal Integration (within Kiro IDE):**

- Use Kiro's integrated terminal for CLI operations
- Agent hooks can run commands automatically on file events
- MCP (Model Context Protocol) for external tool integration

**Agent Hooks (Event-Driven Automation):**

```bash
# Agent hooks can be configured to run commands on file events
# Example: Auto-generate tests on file save
# Configured through Kiro IDE interface
```

## MCP (Model Context Protocol) Configuration

**MCP servers** extend Kiro CLI with additional tools and capabilities, providing structured access to external systems (e.g., GitHub, Slack, databases, APIs).

### Adding MCP Servers via CLI

**Add an MCP Server:**

```bash
# Add a GitHub MCP server
kiro-cli mcp add github \
  --url "mcp://github.com/api" \
  --auth-token "$GITHUB_TOKEN" \
  --type "http"

# Add other MCP servers
kiro-cli mcp add <server-name> \
  --url "<mcp-url>" \
  --auth-token "<token>" \
  --type "http"
```

**List Configured MCP Servers:**

```bash
# View all configured MCP servers
kiro-cli mcp list
```

**Remove an MCP Server:**

```bash
# Remove a configured MCP server
kiro-cli mcp remove <server-name>
```

### Configuring MCP Servers via JSON

**Configuration File Locations:**

- **Workspace-level:** `<project-root>/.kiro/settings/mcp.json`
- **User-level:** `~/.kiro/settings/mcp.json`

**Example `mcp.json` Configuration:**

```json
{
  "mcpServers": {
    "github": {
      "url": "https://api.github.com/mcp",
      "type": "http",
      "headers": {
        "Authorization": "Bearer $GITHUB_TOKEN"
      },
      "disabled": false
    },
    "local-server": {
      "command": "node",
      "args": ["/path/to/mcp-server.js"],
      "env": {
        "API_KEY": "your-api-key",
        "ENV_VAR": "value"
      },
      "disabled": false
    },
    "remote-server": {
      "url": "https://endpoint.to.connect.to",
      "type": "http",
      "headers": {
        "X-API-Key": "your-api-key",
        "Content-Type": "application/json"
      },
      "disabled": false
    }
  }
}
```

**Configuration Options:**

**For Local/Command-based Servers:**

- `command`: Command to run the MCP server (e.g., `node`, `python`, `npx`)
- `args`: Array of arguments to pass to the command
- `env`: Environment variables to set for the server process
- `disabled`: Set to `true` to temporarily disable the server

**For Remote/HTTP Servers:**

- `url`: Endpoint URL for the MCP server
- `type`: Connection type (typically `"http"`)
- `headers`: HTTP headers to include in requests (e.g., authentication tokens)
- `disabled`: Set to `true` to temporarily disable the server

### Using MCP Servers in Kiro

**In Interactive Chat:**

```bash
# Start chat mode
kiro-cli chat

# MCP servers are automatically available
# You can reference them in your prompts:
# > Use the GitHub MCP server to find open issues
# > Query the database using the PostgreSQL MCP server
```

**MCP Server Capabilities:**

- **GitHub Integration:** Access repositories, issues, pull requests, workflows
- **Database Access:** Query databases, run migrations, manage schemas
- **API Integration:** Connect to external APIs and services
- **File System:** Enhanced file operations and monitoring
- **Custom Tools:** Extend Kiro with domain-specific capabilities

### Common MCP Server Examples

**GitHub MCP Server:**

```json
{
  "mcpServers": {
    "github": {
      "url": "https://api.github.com/mcp",
      "type": "http",
      "headers": {
        "Authorization": "Bearer $GITHUB_TOKEN",
        "Accept": "application/vnd.github.v3+json"
      }
    }
  }
}
```

**PostgreSQL MCP Server:**

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@localhost/dbname"
      }
    }
  }
}
```

**Slack MCP Server:**

```json
{
  "mcpServers": {
    "slack": {
      "url": "https://slack.com/api/mcp",
      "type": "http",
      "headers": {
        "Authorization": "Bearer $SLACK_TOKEN"
      }
    }
  }
}
```

### Troubleshooting MCP Servers

**Verify MCP Server Status:**

```bash
# List all configured servers and their status
kiro-cli mcp list

# Check server connectivity
kiro-cli mcp test <server-name>
```

**Common Issues:**

- **Authentication Errors:** Verify tokens and API keys in configuration
- **Connection Failures:** Check URLs and network connectivity
- **Disabled Servers:** Ensure `"disabled": false` in configuration
- **Missing Dependencies:** For command-based servers, ensure required tools are installed

**For More Information:**

- **Official Documentation:** [https://kiro.dev/docs/cli/mcp](https://kiro.dev/docs/cli/mcp)
- **MCP Protocol Spec:** [Model Context Protocol Documentation](https://modelcontextprotocol.io)

## Available Models

Kiro utilizes **Claude models** via AWS Bedrock to power its AI capabilities:

| Model                 | Credit Cost | Description                                                    | Context         | Provider    |
| --------------------- | ----------- | -------------------------------------------------------------- | --------------- | ----------- |
| **Auto** (default)    | 1.0x        | Kiro's model router — combines multiple frontier models, delivers Sonnet 4-class results | Varies          | AWS Bedrock |
| **claude-opus-4.6**   | 2.2x        | Latest Claude Opus model (Feb 2026) - deep reasoning           | 1M (GA Mar 24, 2026) | AWS Bedrock |
| **claude-sonnet-4.6** | 1.3x        | Latest Claude Sonnet model (Feb 2026), approaches Opus 4.6 intelligence | 1M (GA) | AWS Bedrock |
| **claude-sonnet-4.0** | 1.3x        | Direct access for consistent model selection                   | ~200K tokens    | AWS Bedrock |
| **claude-haiku-4.5**  | 0.4x        | Fast, cost-effective model                                     | ~200K tokens    | AWS Bedrock |
| **DeepSeek** (open weight) | -       | Open weight, experimental support on all plans                 | Varies          | Open Weight |
| **MiniMax** (open weight)  | -       | Open weight, experimental support                              | Varies          | Open Weight |
| **Qwen3 Coder Next** (open weight) | 0.05x | 80B sparse MoE, purpose-built for coding agents, 70%+ SWE-Bench | 256K tokens | Open Weight |

> **Note (March 2026):** Kiro CLI v1.28.0. Dynamic model selection with `/model` command and tab completion (v1.26+). Use `/model clau<Tab>` for fuzzy matching. New `--list-models` flag (v1.28). Claude Opus 4.6 1M context GA as of March 24, 2026. Open weight models (DeepSeek, MiniMax, Qwen) now available on all plans. Experimental refreshed TUI with `--tui` flag featuring live status bar, rich markdown rendering, syntax-highlighted code blocks, and interactive panels. Persist TUI with `kiro-cli settings chat.ui "tui"` (macOS/Linux only).

**Credit System:**

- Credits are consumed based on model usage
- Auto mode selects the best model for each task (1x credit)
- Haiku is the most cost-effective (0.4x credit)
- Opus is the most expensive but offers deepest reasoning (2.2x credit)

**Model Selection:**

- Default: Auto (recommended for optimal usage)
- Manual selection available in Kiro IDE settings
- CLI uses the model configured in your Kiro account

**Note:** Specific model availability depends on your AWS Bedrock configuration and region. Credit costs may vary based on your Kiro plan.

## CLI Syntax

### Kiro CLI Commands

**⚠️ CRITICAL: Kiro CLI REQUIRES AGENTS - Direct command execution does NOT work**

**Basic usage:**

```bash
kiro-cli [OPTIONS] [SUBCOMMAND]
```

**Core Options:**

- `-v, --verbose...`: Increase logging verbosity
- `--help-all`: Print help for all subcommands
- `--agent <AGENT>`: Launch chat with specified agent
- `-h, --help`: Print help
- `-V, --version`: Print version

**Commands:**

**AI & Chat:**

```bash
# AI assistant in your terminal (interactive)
kiro-cli chat

# Chat with specific agent
kiro-cli chat --agent <agent-name>
# OR
kiro-cli --agent <agent-name> chat

# Natural Language to Shell translation
kiro-cli translate "list all files in current directory"

# Inline shell completions
kiro-cli inline
```

**Agent Management:**

```bash
# Agent root commands
kiro-cli agent

# List available agents
kiro-cli agent list

# Create or configure agents
kiro-cli agent --help
```

**MCP (Model Context Protocol):**

```bash
# Manage MCP servers
kiro-cli mcp

# Add MCP server
kiro-cli mcp add <server-name> --url <url>

# List MCP servers
kiro-cli mcp list

# Remove MCP server
kiro-cli mcp remove <server-name>
```

**Authentication:**

```bash
# Login
kiro-cli login

# Logout
kiro-cli logout

# Check current user
kiro-cli whoami

# Show profile
kiro-cli profile

# Manage your account
kiro-cli user
```

**Desktop App Control:**

```bash
# Launch the desktop app
kiro-cli launch

# Quit the desktop app
kiro-cli quit

# Restart the desktop app
kiro-cli restart

# Open the dashboard
kiro-cli dashboard
```

**Configuration & Management:**

```bash
# Customize appearance & behavior
kiro-cli settings

# Setup cli components
kiro-cli setup

# Update the Kiro application
kiro-cli update

# Run diagnostic tests
kiro-cli diagnostic

# Fix and diagnose common issues
kiro-cli doctor

# Generate dotfiles for the given shell
kiro-cli init

# Get or set theme
kiro-cli theme

# Manage system integrations
kiro-cli integrations
```

**Debugging & Support:**

```bash
# Debug the app
kiro-cli debug

# Create a new Github issue
kiro-cli issue
```

**❌ WRONG - This does NOT work:**

```bash
# This will FAIL - Kiro CLI does not support direct command execution
kiro-cli "Install the project dependencies"  # ❌ ERROR: unrecognized subcommand
```

**✅ CORRECT - Use agents:**

```bash
# List available agents first
kiro-cli agent list

# Start chat with an agent (REQUIRED)
kiro-cli chat --agent <agent-name>
# OR
kiro-cli --agent <agent-name> chat

# Then in the interactive chat, type your commands:
# > Install the project dependencies
# > Review src/auth.js for security vulnerabilities
# > Create a React component for user profile
# > Run the test suite and fix any failures
```

### IDE Terminal Integration

**Within Kiro IDE:**

- Use integrated terminal for CLI operations
- Agent hooks for automated command execution
- **MCP (Model Context Protocol)** for external tool integration
  - Configure MCP servers via `mcp.json` or `kiro-cli mcp add`
  - Access external systems (GitHub, databases, APIs) through MCP
  - See [MCP Configuration](#mcp-model-context-protocol-configuration) section for details

## Features

### Spec-Driven Development

- Transforms prompts into structured requirements, designs, and tasks
- Facilitates systematic development approach
- Generates detailed specifications from natural language

### Agent Hooks

- Event-driven automations triggered by file events
- Examples: Auto-generate tests, update documentation, run security scans
- Configurable through Kiro IDE interface

### Vibe Coding

- Natural language coding assistance
- Conversational interaction with AI
- Generate and modify code through chat interface

### VS Code Compatibility

- Built on Code OSS foundation
- Supports VS Code extensions (Open VSX)
- Compatible with VS Code settings, themes, and keybindings

### Multimodal Chat Interface

- Supports text, images, and code inputs
- Upload UI mockups or architecture diagrams
- Guide development using various input methods

### AWS Integration

- Seamlessly integrates with AWS services
- Leverages AWS Bedrock for enterprise-grade AI
- Secure, enterprise-ready AI capabilities

## Configuration

**Settings Location:**

- User settings: Similar to VS Code settings
- Extensions: Open VSX compatible
- Agent configuration: Through Kiro IDE interface

**Environment Variables:**

```bash
# AWS credentials for Bedrock access (if using AWS integration)
export AWS_ACCESS_KEY_ID=your_key
export AWS_SECRET_ACCESS_KEY=your_secret
export AWS_REGION=us-east-1
```

**Shell Integration:**

- Kiro can set up shell integration for agent command execution
- Configured during first launch or through settings

## Examples

### Headless Mode (CLI)

**Interactive Chat Mode:**

```bash
# Start chat session
kiro-cli chat

# In the interactive chat, you can type:
# > Install the project dependencies
# > Review src/auth.js for security vulnerabilities
# > Create a React component for user profile with TypeScript
# > Run the test suite and fix any failures
```

**Chat with Custom Agent:**

```bash
# Start chat with specific agent
kiro-cli chat --agent frontend-specialist
# OR
kiro-cli --agent frontend-specialist chat

# Then type commands in the interactive chat
```

**Managing Agents:**

```bash
# List available agents
kiro-cli agent list

# Create or manage agents
kiro-cli agent --help
```

**⚠️ CRITICAL Notes on Headless Mode:**

- Kiro CLI **REQUIRES agents** - you **CANNOT** use direct command execution
- `kiro-cli "command"` will fail with "unrecognized subcommand" error
- Unlike `gemini -p "command"` or `droid exec "command"`, Kiro CLI uses interactive chat mode with agents
- You must:
  1. List agents: `kiro-cli agent list`
  2. Start chat with agent: `kiro-cli chat --agent <name>`
  3. Type commands in the interactive chat interface
- **Windows users MUST run in WSL**, not PowerShell
- Update CLI: `kiro-cli update`

**For CI/CD Automation:**
Kiro CLI's requirement for agents and interactive mode makes it **NOT suitable** for fully automated CI/CD pipelines. Use other tools like Droid or Gemini that support direct command execution for CI/CD automation.

### IDE Mode

**Spec-Driven Development:**

```text
1. Open Kiro IDE
2. Use chat interface: "Create a user authentication system"
3. Kiro generates:
   - Requirements document
   - Design specifications
   - Task breakdown
   - Implementation plan
```

**Agent Hooks:**

```text
1. Configure agent hook: "On file save, run tests"
2. Save a file
3. Agent automatically runs test suite
4. Results displayed in IDE
```

**Multimodal Development:**

```text
1. Upload UI mockup image
2. Ask: "Implement this design in React"
3. Kiro generates code based on image
4. Review and refine through chat
```

## CI/CD Integration

**Kiro CLI supports headless mode for CI/CD pipelines:**

**GitHub Actions Example:**

```yaml
name: Kiro Code Review
on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install Kiro CLI
        run: curl -fsSL https://cli.kiro.dev/install | bash
      - name: Authenticate
        run: kiro-cli login
        env:
          KIRO_API_KEY: ${{ secrets.KIRO_API_KEY }}
      - name: Review Code
        run: |
          # ⚠️ Kiro CLI requires agents - cannot pipe directly
          # Use other tools for CI/CD: droid exec or gemini -p
          echo "Kiro CLI requires agents - not suitable for CI/CD automation"
```

**Note on CI/CD Integration:**
Kiro CLI uses interactive chat mode and is **not suitable for fully automated CI/CD pipelines**. For automated code reviews in CI/CD, consider using:

- **Droid Exec** - Read-only by default, perfect for CI/CD
- **Gemini CLI** - Direct command execution with `-p` flag
- **Claude CLI** - Direct command execution with `-p` flag

**For local development workflows:**

```bash
# Start interactive chat
kiro-cli chat

# Then type commands in the chat interface:
# > Review the staged changes for issues
# > Install project dependencies
# > Generate unit tests
```

## Limitations

- **CLI vs IDE:** Kiro CLI (v1.28) is a full terminal agent with experimental TUI, but some IDE features still require GUI
- **Authentication Required:** CLI requires login/authentication:
  - Browser-based: `kiro-cli login` opens browser (interactive)
  - External identity providers supported (v1.26+)
- **Command Approval:** Commands may require approval unless trusted (granular tool trust in v1.27)
- **AWS Dependency:** AI features require AWS Bedrock access (for IDE mode)
- **Context Limits:** Depends on AWS Bedrock model limits (typically ~200K tokens, 1M beta for Claude 4.6)
- **License Change:** Changed from Apache 2.0 (Amazon Q) to AWS Intellectual Property License
- **Not as Deterministic as Droid:** Less suitable for production CI/CD than Droid's read-only default

## References

- **Official Website:** [kiro.dev](https://kiro.dev)
- **CLI Documentation:** [kiro.dev/docs/cli](https://kiro.dev/docs/cli/)
- **CLI Changelog:** [kiro.dev/changelog/cli](https://kiro.dev/changelog/cli/)
- **CLI Commands Reference:** [kiro.dev/docs/cli/reference/cli-commands](https://kiro.dev/docs/cli/reference/cli-commands/)
- **CLI Installation:** [cli.kiro.dev](https://cli.kiro.dev)
- **MCP Configuration:** [kiro.dev/docs/cli/mcp](https://kiro.dev/docs/cli/mcp) ⭐
- **Getting Started:** [kiro.help/docs/kiro/introduction/installation](https://kiro.help/docs/kiro/introduction/installation)
- **Autopilot Mode:** [kiro.help/docs/kiro/chat/autopilot](https://kiro.help/docs/kiro/chat/autopilot)
- **Custom Agents:** [kiro.directory/guides](https://www.kiro.directory/guides)

**Note:** Kiro is currently in public preview and free to use with some limits. Features and documentation may change as the product evolves. The CLI provides headless mode capabilities similar to other AI CLI tools.
