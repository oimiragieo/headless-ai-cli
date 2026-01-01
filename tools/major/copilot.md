# 🤖 GitHub Copilot CLI

**Version tested:** Latest (check with `copilot --version`)  
**Risk level:** ⚡ Very High (can run shell/git, requires careful tool management)

**Note:** GitHub Copilot CLI is in public preview with data protection and subject to change.

**When NOT to use Copilot:**
- ❌ You're in an untrusted repository (can execute shell/git commands)
- ❌ You can't risk shell commands being run (high risk level)
- ❌ You need deterministic runs (tool approval can vary)
- ❌ You don't need GitHub integration (other tools are safer)
- ❌ You're working in production CI/CD without careful sandboxing

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Copilot](#-why-use-copilot)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Availability](#-availability)
- [Supported Operating Systems](#-supported-operating-systems)
- [Modes of Use](#-modes-of-use)
- [Programmatic Mode](#-programmatic-mode)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [Tool Approval](#-tool-approval)
- [MCP Integration](#-mcp-integration)
- [Security](#-security)
- [Examples](#-examples)
- [CI/CD Integration](#-cicd-integration)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

GitHub Copilot CLI is the command-line version of GitHub Copilot, designed for programmatic access to GitHub's AI capabilities. It provides native GitHub integration for managing PRs, issues, workflows, and Actions directly from the CLI.

**Key Characteristics:**
- CLI version of GitHub Copilot
- Interactive and programmatic modes
- Native GitHub integration
- Enhanced code search with built-in `ripgrep`, `grep`, and `glob` tools
- Improved image support (paste and drag-and-drop)
- Tool control system
- Trusted directories for security
- MCP (Model Context Protocol) support
- Headless mode with proper exit codes for automation

## Installation

**Using npm:**
```bash
npm install -g @github/copilot
```

**System Requirements:**
- Node.js 18 or later
- GitHub account with Copilot access
- Network connection

## Availability

**Who can use this feature:**
- GitHub Copilot CLI is available with the following plans:
  - GitHub Copilot Pro
  - GitHub Copilot Pro+
  - GitHub Copilot Business
  - GitHub Copilot Enterprise

**Organization requirements:**
- If you receive Copilot from an organization, the Copilot CLI policy must be enabled in the organization's settings.

## Supported Operating Systems

- **Linux**: Full support
- **macOS**: Full support
- **Windows**: 
  - Windows Subsystem for Linux (WSL) - Full support
  - Native Windows PowerShell - Experimental support

## 🚀 Start Here

```bash
copilot -p "Review this code for bugs"
```

## Modes of Use

GitHub Copilot CLI can be used in two modes:

**Interactive mode:**
- Start an interactive session by using the `copilot` command (default mode)
- In this mode, you can prompt Copilot to answer a question or perform a task
- You can react to Copilot's responses in the same session
- Use slash commands like `/model` to change models or `/feedback` to provide feedback

**Programmatic mode:**
- Pass the CLI a single prompt directly on the command line using `-p` or `--prompt`
- To allow Copilot to modify and execute files, use one of the approval options (see [Tool Approval](#-tool-approval))
- Example: `copilot -p "Show me this week's commits and summarize them" --allow-tool 'shell(git)'`
- You can also pipe script output: `echo ./script-outputting-options.sh | copilot`

## Programmatic Mode

**Basic usage:**
```bash
# Direct prompt
copilot -p "Your prompt here"
# or
copilot --prompt "Your prompt here"

# With tool approval (required for file modifications)
copilot -p "Revert the last commit" --allow-all-tools
```

**Silent mode (scripting):**
```bash
# Output only the agent response (no stats)
copilot -p "Your prompt" --silent
# or
copilot -p "Your prompt" -s
```

**No color output (CI/CD friendly):**
```bash
copilot -p "Your prompt" --no-color
```

**Streaming control:**
```bash
# Enable streaming (default)
copilot -p "Your prompt" --stream on

# Disable streaming
copilot -p "Your prompt" --stream off
```

**Session management with programmatic mode:**
```bash
# Resume most recent session in programmatic mode
copilot --continue -p "Continue from previous session"

# Resume specific session in programmatic mode
copilot --resume [sessionId] -p "Continue from session"
```

**Session management:**
```bash
# Resume the most recent session
copilot --continue

# Resume a specific session
copilot --resume [sessionId]

# Resume with auto-approval
copilot --allow-all-tools --resume
```

**Piping input:**
```bash
# Pipe from script
echo ./script-outputting-options.sh | copilot

# Pipe from command
git diff | copilot -p "Review these changes"
```

## Available Models

**Default model:**
- **Claude Sonnet 4.5** (1x premium request multiplier) - default
- GitHub reserves the right to change the default model

**Available models (verified from CLI, November 2025):**

| # | Model | Cost Multiplier | Description |
|---|-------|-----------------|-------------|
| 1 | **Auto** | 0.9x (10% Off) | Automatically selects the best model for the task |
| 2 | **Claude Sonnet 4.5** | 1x | Default, balanced performance |
| 3 | **Claude Sonnet 4** | 1x | Previous Claude version |
| 4 | **GPT-5** | 1x | Latest OpenAI model |
| 5 | **GPT-5-Mini** | 0x | Free tier OpenAI model |
| 6 | **GPT-4.1** | 0x | Free tier OpenAI model |
| 7 | **GPT-4o** | 0x | Previous flagship, now free tier |
| 8 | **Gemini 3 Pro (Preview)** | 1x | Latest Google model |
| 9 | **Gemini 2.5 Pro** | 1x | Previous Google flagship |
| 10 | **Claude Opus 4.5 (Preview)** | - | New Infinite Context model |
| 11 | **Claude Opus 4.1** | 10x | High-cost reasoning model |
| 12 | **Claude Haiku 4.5** | 0.33x | Low-latency efficient model |
| 13 | **GPT-5-Codex (Preview)** | 1x | Specialized full-stack generation |
| 14 | **GPT-5.1 (Preview)** | 1x | Iterative update with improved reasoning |
| 15 | **GPT-5.1-Codex (Preview)** | 1x | Latest coding-specific fine-tune |
| 16 | **GPT-5.1-Codex-Mini (Preview)**| 0.33x | Lightweight coding model |
| 17 | **Grok Code Fast 1** | 0x | xAI high-speed coding model |
| 18 | **Raptor mini (Preview)** | 0x | Ultra-low latency experimental model |

**Premium request multipliers:**
- `0x` = Free (does not consume premium requests)
- `1x` = Full premium request

**Note:** Model availability may vary based on configured organizational policies. Some models may not be available due to policy restrictions.

**Model selection:**
- Use `/model` slash command in interactive mode to select a different model
- Use `--model <model>` flag in programmatic mode
- Selected model persists across sessions
- Each prompt submission uses one premium request from your monthly quota, multiplied by the model's multiplier

**Change model examples:**
```bash
# In programmatic mode (use exact model name as shown in CLI)
copilot --model "Claude Sonnet 4.5" -p "Your prompt"
copilot --model "GPT-5" -p "Your prompt"
copilot --model "Gemini 3 Pro (Preview)" -p "Your prompt"

# Free tier models
copilot --model "GPT-5-Mini" -p "Your prompt"
copilot --model "GPT-4.1" -p "Your prompt"

# In interactive mode
copilot
# Then type: /model
# Select from the list using number keys (1-6)
```

## CLI Syntax

**Basic usage:**
```bash
copilot [options] -p "Your prompt"
```

**Common options:**
- `-p, --prompt TEXT`: Provide prompt directly
- `-s, --silent`: Output only the agent response (no stats), useful for scripting
- `--no-color`: Disable all color output (CI/CD friendly)
- `--stream <mode>`: Enable or disable streaming mode (choices: "on", "off")
- `--model <model>`: Set the AI model to use
- `--continue`: Resume the most recent session
- `--resume [sessionId]`: Resume from a previous session
- `--allow-all-tools`: Allow all tools without approval (required for non-interactive mode)
- `--allow-tool [tools...]`: Allow specific tools
- `--deny-tool [tools...]`: Deny specific tools (takes precedence)
- `--add-dir <directory>`: Add a directory to the allowed list for file access (can be used multiple times)
- `--allow-all-paths`: Disable file path verification and allow access to any path
- `--log-level <level>`: Set the log level (choices: "none", "error", "warning", "info", "debug", "all", "default")
- `--log-dir <directory>`: Set log file directory (default: ~/.copilot/logs/)
- `--agent <agent>`: Specify a custom agent to use, only in prompt mode
- `--no-custom-instructions`: Disable loading of custom instructions from AGENTS.md and related files
- `--screen-reader`: Enable screen reader optimizations
- `-v, --version`: Show version information
- `-h, --help`: Display help for command

**Environment variables:**
- `COPILOT_ALLOW_ALL`: Equivalent to `--allow-all-tools` flag

## Tool Approval

**Important:** When you use automatic approval options such as `--allow-all-tools`, Copilot has the same access as you do to files on your computer, and can run any shell commands that you can run, without getting your prior approval. See [Security](#-security) for more details.

**Allow all tools (use with caution):**
```bash
copilot -p "Revert the last commit" --allow-all-tools

# Using environment variable
COPILOT_ALLOW_ALL=1 copilot -p "Revert the last commit"
```

**Deny specific tools:**
```bash
# Prevent using rm command
copilot --deny-tool 'shell(rm)' -p "Clean up temporary files"

# Prevent git push
copilot --deny-tool 'shell(git push)' -p "Stage and commit changes"

# Prevent specific MCP tool
copilot --deny-tool 'My-MCP-Server(tool_name)' -p "Use MCP tools"
```

**Allow specific tools:**
```bash
# Allow all shell commands
copilot --allow-tool 'shell' -p "Run build script"

# Allow specific shell command
copilot --allow-tool 'shell(git)' -p "Show git status"

# Allow git commands with wildcard (all git commands except push)
copilot --allow-tool 'shell(git:*)' --deny-tool 'shell(git push)' -p "Git operations"

# Allow file write operations
copilot --allow-tool 'write' -p "Update configuration files"

# Allow specific MCP server (all tools from that server)
copilot --allow-tool 'My-MCP-Server' -p "Use MCP tools"
```

**Tool specification syntax:**
- `'shell(COMMAND)'`: For specific shell commands (e.g., `'shell(rm)'`, `'shell(git push)'`)
- `'shell'`: For all shell commands
- `'shell(git:*)'`: For wildcard patterns (all git commands)
- `'write'`: For file write operations (allows tools other than shell commands to modify files)
- `'MCP_SERVER_NAME'`: For all tools from a specific MCP server
- `'MCP_SERVER_NAME(tool_name)'`: For a specific tool from an MCP server

**Combining options:**
```bash
# Allow all tools except rm and git push
copilot --allow-all-tools --deny-tool 'shell(rm)' --deny-tool 'shell(git push)' \
  -p "Refactor codebase"

# Allow MCP server but deny specific tool
copilot --allow-tool 'My-MCP-Server' --deny-tool 'My-MCP-Server(tool_name)' \
  -p "Use MCP tools"

# Allow all git commands except push
copilot --allow-tool 'shell(git:*)' --deny-tool 'shell(git push)' \
  -p "Stage and commit changes"
```

**Note:** `--deny-tool` takes precedence over `--allow-tool` or `--allow-all-tools`.

## MCP Integration

**Additional MCP configuration:**
```bash
# Add MCP config from JSON string
copilot --additional-mcp-config '{"servers": {...}}' -p "Your prompt"

# Add MCP config from file (prefix with @)
copilot --additional-mcp-config @mcp-config.json -p "Your prompt"

# Can be used multiple times
copilot --additional-mcp-config @config1.json --additional-mcp-config @config2.json -p "Your prompt"
```

**Disable built-in MCP servers:**
```bash
# Disable all built-in MCP servers (currently: github-mcp-server)
copilot --disable-builtin-mcps -p "Your prompt"

# Disable specific MCP server
copilot --disable-mcp-server github-mcp-server -p "Your prompt"
```

**Enable all GitHub MCP tools:**
```bash
# Enable all GitHub MCP server tools instead of the default CLI subset
copilot --enable-all-github-mcp-tools -p "Your prompt"
```

**Finding MCP server names:**
- Enter `/mcp` in interactive mode to see a list of configured MCP servers
- Select a server from the list to see its tools

**MCP examples:**
```bash
# Use GitHub MCP server explicitly
copilot -p "Use the GitHub MCP server to find good first issues from octo-org/octo-repo"

# Specify MCP server in prompt (helps Copilot deliver better results)
copilot -p "Use My-MCP-Server to fetch data from the API"
```

## Security

**Warning:** You should only launch Copilot CLI from directories that you trust. You should not use Copilot CLI in directories that may contain executable files you can't be sure you trust. Similarly, if you launch the CLI from a directory that contains sensitive or confidential data, or files that you don't want to be changed, you could inadvertently expose those files to risk. Typically, you should not launch Copilot CLI from your home directory.

**Trusted directories:**
- When starting a session, you'll be asked to confirm trust for the current directory
- Choose to trust for current session only, or for future sessions
- If you choose to trust for future sessions, the trusted directory prompt will not be displayed again
- Edit permanently trusted directories in `~/.copilot/config.json` (or `$XDG_CONFIG_HOME/copilot/config.json` if set)
- Config file location can be changed by setting the `XDG_CONFIG_HOME` environment variable

**Config file structure:**
```json
{
  "trusted_folders": [
    "/path/to/trusted/directory"
  ]
}
```

**Path verification:**
- By default, Copilot verifies file paths before accessing them
- Use `--allow-all-paths` to disable file path verification (use with caution)
- Use `--disallow-temp-dir` to prevent automatic access to the system temporary directory
- Use `--add-dir <directory>` to add specific directories to the allowed list (can be used multiple times)

**Tool approval:**
- First time using a tool (e.g., `touch`, `chmod`, `node`, `sed`), Copilot asks for approval
- Options:
  1. Yes (this time only) - allows this particular command this time only
  2. Yes, and approve TOOL for the rest of the running session - allows Copilot to use this tool again without asking for the duration of the current session
  3. No, and tell Copilot what to do differently (Esc) - cancels the proposed command

**Security implications of automatic tool approval:**
- Using `--allow-all-tools` or other approval options allows Copilot to execute commands without giving you the opportunity to review and approve those commands before they are run
- While this streamlines workflows and allows headless operation, it increases the risk of unintended actions that might result in data loss or corruption, or other security issues

**Risk mitigation:**
- Use in restricted environments (VM, container, dedicated system) without internet access
- Review suggested commands carefully when Copilot CLI requests your approval
- Don't launch from home directory or untrusted locations
- Scoping is heuristic; GitHub doesn't guarantee all files outside trusted directories are protected
- Use `--deny-tool` to prevent specific dangerous commands even when using `--allow-all-tools`

## Examples

### Local Tasks

**Code changes:**
```bash
# Change CSS styling
copilot -p "Change the background-color of H1 headings to dark blue" --allow-tool 'write'

# Show file history
copilot -p "Show me the last 5 changes made to the CHANGELOG.md file. Who changed the file, when, and give a brief summary of the changes they made" --allow-tool 'shell(git)'

# Improve code
copilot -p "Suggest improvements to content.js" --allow-tool 'write'

# Rewrite documentation
copilot -p "Rewrite the readme in this project to make it more accessible to newcomers" --allow-tool 'write'
```

**Git operations:**
```bash
# Commit changes
copilot -p "Commit the changes to this repo" --allow-tool 'shell(git)'

# Revert commit
copilot -p "Revert the last commit, leaving the changes unstaged" --allow-tool 'shell(git)'
```

**Create applications:**
```bash
# Create Next.js app with GitHub API integration
copilot -p "Use the create-next-app kit and tailwind CSS to create a next.js app. The app should be a dashboard built with data from the GitHub API. It should track this project's build success rate, average build duration, number of failed builds, and automated test pass rate. After creating the app, give me easy to follow instructions on how to build, run, and view the app in my browser." --allow-all-tools
```

**Debugging:**
```bash
# Fix issues
copilot -p "You said: 'The application is now running on http://localhost:3002 and is fully functional!' but when I browse to that URL I get 'This site can't be reached'" --allow-all-tools
```

### Tasks Involving GitHub.com

**List work:**
```bash
# List open PRs
copilot -p "List my open PRs"

# List specific issues
copilot -p "List all open issues assigned to me in OWNER/REPO"
```

**Work on issues:**
```bash
# Start working on an issue
copilot -p "I've been assigned this issue: https://github.com/octo-org/octo-repo/issues/1234. Start working on this for me in a suitably named branch." --allow-all-tools
```

**Create pull requests:**
```bash
# Create PR with file changes
copilot -p "In the root of this repo, add a Node script called user-info.js that outputs information about the user who ran the script. Create a pull request to add this file to the repo on GitHub." --allow-all-tools

# Update file and create PR
copilot -p "Create a PR that updates the README at https://github.com/octo-org/octo-repo, changing the subheading 'How to run' to 'Example usage'" --allow-all-tools
```

**Create issues:**
```bash
# Raise improvement issue
copilot -p "Raise an improvement issue in octo-org/octo-repo. In src/someapp/somefile.py the \`file = open('data.txt', 'r')\` block opens a file but never closes it." --allow-all-tools
```

**Review pull requests:**
```bash
# Check PR changes
copilot -p "Check the changes made in PR https://github.com/octo-org/octo-repo/pull/57575. Report any serious errors you find in these changes."
```

**Manage pull requests:**
```bash
# Merge PRs
copilot -p "Merge all of the open PRs that I've created in octo-org/octo-repo" --allow-all-tools

# Close PR
copilot -p "Close PR #11 on octo-org/octo-repo" --allow-all-tools
```

**Find issues:**
```bash
# Find good first issues
copilot -p "Use the GitHub MCP server to find good first issues for a new team member to work on from octo-org/octo-repo"
```

**GitHub Actions:**
```bash
# List workflows
copilot -p "List any Actions workflows in this repo that add comments to PRs"

# Create workflow
copilot -p "Branch off from main and create a GitHub Actions workflow that will run on pull requests, or can be run manually. The workflow should run eslint to check for problems in the changes made in the PR. If warnings or errors are found these should be shown as messages in the diff view of the PR. I want to prevent code with errors from being merged into main so, if any errors are found, the workflow should cause the PR check to fail. Push the new branch and create a pull request." --allow-all-tools
```

### Model Selection Examples

```bash
# Use specific model
copilot --model claude-sonnet-4.5 -p "Your prompt"
copilot --model gpt-5.1-codex -p "Your prompt"
copilot --model claude-haiku-4.5 -p "Your prompt"  # Lower cost option
```

### Directory Access Examples

```bash
# Add directory to allowed list
copilot --add-dir /home/user/projects -p "Analyze this code"

# Add multiple directories
copilot --add-dir ~/workspace --add-dir /tmp -p "Process files"

# Disable path verification (use with caution)
copilot --allow-all-paths -p "Access any file"
```

### Logging Examples

```bash
# Set log level
copilot --log-level debug -p "Your prompt"

# Set custom log directory
copilot --log-dir /path/to/logs --log-level info -p "Your prompt"
```

## CI/CD Integration

**Note:** Copilot CLI supports headless/programmatic mode for CI/CD automation. The `-p` flag exits with nonzero codes on permission or communication errors, making it suitable for automated workflows.

**Best practices for CI/CD:**
- Use `--allow-all-tools` with extreme caution in CI/CD environments
- Use `--no-color` for clean log output
- Use `--silent` for script-friendly output (outputs only agent response, no stats)
- Always handle exit codes properly
- Use environment variables for configuration
- Redirect output to files for artifacts

**CI/CD-friendly execution:**
```bash
# Silent mode with no color (ideal for CI/CD)
copilot -p "Review code changes" --silent --no-color --allow-all-tools

# With error handling
copilot -p "Analyze codebase" --silent --no-color --allow-all-tools || exit 1

# With logging
copilot -p "Analyze codebase" --log-level error --no-color --allow-all-tools

# Output to file for artifacts
copilot -p "Generate report" --silent --no-color --allow-all-tools > report.txt 2>&1
```

**GitHub Actions workflow example:**
```yaml
name: Copilot Code Review

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - run: npm install -g @github/copilot
      
      - name: Run Code Review
        env:
          COPILOT_ALLOW_ALL: 1
        run: |
          git diff origin/${{ github.base_ref }}...HEAD | \
            copilot -p "Review these changes for bugs, security issues, and code quality. Provide specific suggestions." \
            --no-color \
            --silent \
            --allow-all-tools \
            > review.txt || echo "Review failed" > review.txt
      
      - name: Post Review Comment
        uses: actions/github-script@v7
        if: always()
        with:
          script: |
            const fs = require('fs');
            const reviewText = fs.existsSync('review.txt') 
              ? fs.readFileSync('review.txt', 'utf8')
              : 'Review file not found';
            
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## 🤖 AI Code Review (GitHub Copilot)\n\n${reviewText}\n\n---\n*Generated by GitHub Copilot CLI*`
            });
```

**Automation patterns:**
```bash
# Batch processing
for file in src/*.js; do
  copilot -p "Review $file for security issues" \
    --silent --no-color --allow-all-tools \
    > "reports/$(basename $file).review" 2>&1
done

# Error handling with exit codes
if ! copilot -p "Run tests" --allow-all-tools; then
  echo "Tests failed"
  exit 1
fi

# Model selection for cost optimization
copilot --model claude-haiku-4.5 -p "Quick analysis" --silent --no-color --allow-all-tools
```

## Limitations

- Each prompt submission uses one premium request from your monthly quota, multiplied by the model's premium request multiplier
- Always review suggested commands before approval when not using `--allow-all-tools`
- Use `--allow-all-tools` with caution; it bypasses security checks
- Tool approval system can be bypassed with `--allow-all-tools`
- Can execute shell/git commands without clear warnings in some modes
- Scoping of permissions is heuristic and GitHub does not guarantee that all files outside trusted directories will be protected
- GitHub Copilot CLI is in public preview with data protection and subject to change
- Model availability may change; GitHub reserves the right to change available models
- Programmatic mode (`-p`) exits with nonzero codes on permission or communication errors, which is useful for automation but requires proper error handling

## Feedback

If you have any feedback about GitHub Copilot CLI, use the `/feedback` slash command in an interactive session and choose one of the options:
- Complete a private feedback survey
- Submit a bug report
- Suggest a new feature

## References

- [Installing GitHub Copilot CLI](https://docs.github.com/en/copilot/cli)
- [About GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli)
- [Using GitHub Copilot CLI](https://docs.github.com/en/copilot/cli/using-github-copilot-cli)
- [Responsible use of GitHub Copilot CLI](https://docs.github.com/en/copilot/using-github-copilot/responsible-use-of-github-copilot-cli)
- [GitHub Copilot](https://github.com/features/copilot)
- [Requests in GitHub Copilot](https://docs.github.com/en/copilot/using-github-copilot/requests-in-github-copilot)
