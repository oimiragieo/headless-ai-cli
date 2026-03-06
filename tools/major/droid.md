# 🤖 Factory AI Droid

**Version tested:** Latest (check with `droid --version`)  
**Risk level:** 🟢 Very Low (read-only by default, safest for CI/CD)

**When NOT to use Droid:**

- ❌ You need delta streaming (Droid doesn't support incremental text updates)
- ❌ You need massive context windows (Gemini handles larger repos better)
- ❌ You need UI/front-end generation (Codex is better for this)
- ❌ You need complex multi-turn reasoning (Claude Opus is better)

### Quick Nav

- [Start Here](#-start-here)
- [Why Use Droid](#-why-use-droid)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Headless Mode](#-headless-mode)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [Autonomy Levels](#-autonomy-levels)
- [Output Formats](#-output-formats)
- [Examples](#-examples)
- [CI/CD Integration](#-cicd-integration)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Factory AI Droid is Factory's AI coding agent that works in both interactive and non-interactive modes. It's designed primarily for CI/CD pipelines and automation scripts with secure defaults (read-only mode) and explicit opt-in for mutations via autonomy levels.

**Key Characteristics:**

- Interactive and non-interactive modes
- Secure by default (read-only)
- Structured output formats
- Fail-fast behavior
- Composable for shell scripting

**Two Modes:**

1. **Interactive Mode** (default): `droid` or `droid "initial prompt"`
2. **Non-Interactive Mode** (for automation): `droid exec`

## Installation

**macOS/Linux:**

```bash
curl -fsSL https://app.factory.ai/cli | sh
```

**Windows (PowerShell):**

```powershell
irm https://app.factory.ai/cli/windows | iex
```

**Get API Key:**
Generate your API key from the [Factory Settings Page](https://app.factory.ai/settings/api-keys)

**Set Environment Variable:**

```bash
export FACTORY_API_KEY=fk-...
```

## 🚀 Start Here

**Interactive mode (default):**

```bash
droid "analyze this folder"
```

**Non-interactive mode (for automation):**

```bash
droid exec "analyze this folder"
```

## Interactive Mode

**Start interactive session:**

```bash
# Start interactive mode (default)
droid

# Start with initial prompt
droid "review app.tsx"

# Resume a session (defaults to last modified)
droid -r
droid -r [sessionId]
droid --resume [sessionId]
```

Interactive mode provides a conversational interface where you can ask follow-up questions and refine tasks. Use this for exploratory work and iterative development.

## Non-Interactive Mode (Headless)

**Non-interactive execution for CI/CD pipelines and automation scripts:**

```bash
# Direct prompt (read-only by default)
droid exec "analyze code quality"

# With autonomy level for file operations
droid exec "fix the bug in src/main.js" --auto low

# From file
droid exec -f prompt.md

# Pipe input (two methods)
echo "summarize repo structure" | droid exec
droid exec - < prompt.txt

# Session continuation
droid exec --session-id <session-id> "continue with next steps"
```

## Available Models

**Factory Provided Models** (multipliers represent cost in Standard Tokens):

| Rank | Model                    | Cost Multiplier | Description                                                     | Best For                            |
| ---- | ------------------------ | --------------- | --------------------------------------------------------------- | ----------------------------------- |
| 1    | **Claude Opus 4.6**      | -               | Latest Anthropic flagship with Max reasoning (Feb 2026)         | Complex work, best depth and safety |
| 2    | **Claude Opus 4.6 Fast** | -               | Opus 4.6 tuned for faster response; 12x multiplier              | Speed-critical complex tasks        |
| 3    | **Claude Opus 4.5**      | 1.2x            | Proven quality-and-safety balance                               | Strong default for TUI and exec     |
| 4    | **GPT-5.1-Codex-Max**    | -               | Fast coding loops with Extra High reasoning                     | Heavy implementation, debugging     |
| 5    | **Claude Sonnet 4.5**    | 1.2x            | Balanced cost/quality daily driver                              | General-purpose coding              |
| 6    | **GPT-5.3-Codex**        | -               | Newest OpenAI coding model with Extra High reasoning (Feb 2026) | Implementation-heavy tasks          |
| 7    | **GPT-5.2-Codex**        | -               | Proven OpenAI coding model with Extra High reasoning (Jan 2026) | Solid implementation                |
| 8    | **GPT-5.1-Codex**        | 0.5x            | Quick iteration with solid code quality                         | Lower-cost coding                   |
| 9    | **Haiku 4.5**            | 0.4x            | Claude Haiku 4.5                                                | Fast and cost-effective             |
| 10   | **Droid Core (GLM-4.6)** | 0.25x           | GLM-4.6 open-source model                                       | Most cost-effective option          |

> **Note (March 2026):** Stack rank updated Feb 25, 2026 per Factory docs. Droid CLI now at v0.65.0. New features include `/diagnostics` command, session archiving, inline rename, custom model reasoning effort, and concurrent mission warnings.

**Additional Options:**

- **Custom Model** - User-configured via BYOK (Bring Your Own Key)
- **Spec Mode Model** - Can be configured separately from main model

**Model Selection:**

```bash
# Use model name
droid exec -m "Sonnet 4.5" "analyze code"

# Cost-effective option
droid exec -m "Haiku 4.5" "quick task"

# Most cost-effective (open-source)
droid exec -m "Droid Core" "analyze logs"

# Best for code generation
droid exec -m "GPT-5.1-Codex" "generate component"

# With autonomy level
droid exec -m "Sonnet 4.5" -r medium "install deps and run tests"

# Large context analysis
droid exec -m "Gemini 3 Pro (High)" -r low -f plan.md
```

**Cost Considerations:**

- Most cost-effective: Droid Core (0.25x)
- Budget-friendly: Haiku 4.5 (0.4x), GPT-5.1 series (0.5x)
- Balanced: Gemini 3 Pro (0.8x), Sonnet/Opus 4.5 (1.2x)
- Legacy (expensive): Opus 4.1 (6x) - avoid unless necessary

## CLI Syntax

**Basic usage:**

```bash
droid exec [options] "Your prompt"
```

**Common options:**

- `-f, --file FILE`: Read prompt from file
- `-m, --model MODEL`: Specify model (short name or full ID)
- `-r, --auto LEVEL`: Autonomy level (`low`, `medium`, `high`)
- `--output-format FORMAT`: Output format (`text`, `json`, `debug`)
- `--cwd PATH`: Working directory
- `--session-id ID`: Continue session

## Autonomy Levels

**Default (read-only):**

- ✅ Reading files, logs, git status, directory listings
- ❌ No modifications to files or system
- **Use case:** Safe analysis and planning

```bash
droid exec "Analyze the authentication system and create a detailed migration plan"
```

**`--auto low`** - Low-risk Operations:

- ✅ File creation/editing in project directories
- ❌ No system modifications or package installations
- **Use case:** Documentation updates, code formatting

```bash
droid exec --auto low "add JSDoc comments to all functions"
```

**`--auto medium`** - Development Operations:

- ✅ Installing packages (npm, pip), git operations (no push), building code
- ❌ No git push, sudo commands, or production changes
- **Use case:** Local development, testing, dependency management

```bash
droid exec --auto medium "install deps, run tests, fix issues"
```

**`--auto high`** - Production Operations:

- ✅ Git push, running untrusted code, production deployments
- ❌ Still blocks: sudo rm -rf /, system-wide changes
- ⚠️ **Factory-side restrictions:** Even at high autonomy, Droid cannot execute certain destructive commands (factory-enforced safety limits)
- **Use case:** CI/CD pipelines, automated deployments

```bash
droid exec --auto high "fix bug, test, commit, and push to main"
```

## Output Formats

**Text (default):**

```bash
droid exec --auto low "create a python file that prints 'hello world'"
```

**JSON (for automation):**

```bash
droid exec "summarize this repository" --output-format json
```

**Debug (streaming):**

```bash
droid exec "run ls command" --output-format debug
```

## Examples

**Security audit:**

```bash
droid exec --auto low \
  "Run a comprehensive security audit of this codebase. Check for:
  - SQL injection vulnerabilities
  - XSS vulnerabilities
  - Insecure authentication patterns
  - Hardcoded secrets
  - Insecure dependencies

  Write findings to security-audit.json in JSON format." \
  --output-format json > audit-result.json
```

**License enforcement:**

```bash
git ls-files "*.ts" | xargs -I {} \
  droid exec --auto low "Ensure {} begins with the Apache-2.0 header; add it if missing"
```

**Code review:**

```bash
droid exec --auto low "Review PR changes for bugs and security issues" --output-format json
```

## CI/CD Integration

**GitHub Actions workflow:**

```yaml
name: Factory Droid Automation

on:
  push:
    branches: [main]
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  droid_task:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - name: Checkout code
        uses: actions/checkout@v5

      - name: Install Factory CLI
        run: |
          curl -fsSL https://app.factory.ai/cli | sh
          echo "$HOME/.local/bin" >> $GITHUB_PATH

      - name: Run Droid Code Review
        id: droid_review
        env:
          FACTORY_API_KEY: ${{ secrets.FACTORY_API_KEY }}
        run: |
          # Get diff for the current PR
          if [ "${{ github.event_name }}" == "pull_request" ]; then
            DIFF_CONTENT=$(git diff origin/${{ github.base_ref }}...HEAD)
          else
            DIFF_CONTENT=$(git diff HEAD~1 HEAD)
          fi

          if [ -z "$DIFF_CONTENT" ]; then
            echo "No changes to review."
            echo "review_output=No changes to review." >> $GITHUB_OUTPUT
          else
            echo "$DIFF_CONTENT" | \
              droid exec --output-format json \
              "Review these code changes for potential bugs, security vulnerabilities, and adherence to best practices. Provide actionable suggestions for improvement. Format your response as a markdown list." \
              > droid_review_output.json || echo '{"result":"Review failed"}' > droid_review_output.json
            
            if command -v jq &> /dev/null; then
              REVIEW_OUTPUT=$(cat droid_review_output.json | jq -r '.result // "Review completed"')
            else
              REVIEW_OUTPUT=$(cat droid_review_output.json | grep -o '"result":"[^"]*"' | cut -d'"' -f4 || echo "Review completed")
            fi
            
            echo "review_output<<EOF" >> $GITHUB_OUTPUT
            echo "$REVIEW_OUTPUT" >> $GITHUB_OUTPUT
            echo "EOF" >> $GITHUB_OUTPUT
          fi

      - name: Post Review Comment on PR
        if: github.event_name == 'pull_request' && steps.droid_review.outputs.review_output != 'No changes to review.'
        uses: actions/github-script@v7
        with:
          script: |
            const reviewOutput = `${{ steps.droid_review.outputs.review_output }}`;
            const prNumber = context.issue.number;
            const owner = context.repo.owner;
            const repo = context.repo.repo;

            if (reviewOutput && reviewOutput.trim() !== '' && reviewOutput !== 'Review failed') {
              await github.rest.issues.createComment({
                issue_number: prNumber,
                owner: owner,
                repo: repo,
                body: `## 🤖 Automated Code Review by Factory AI Droid\n\n${reviewOutput}\n\n---\n*Generated by Factory AI Droid CLI in CI/CD*`
              });
            } else {
              console.log('No review output to post.');
            }
```

**GitLab CI example:**

```yaml
droid-audit:
  script:
    - |
      droid exec --auto low \
        "Run security audit" \
        --output-format json > audit-result.json
  artifacts:
    paths:
      - audit-result.json
```

**Direct CLI usage in CI/CD:**

```bash
#!/bin/bash
set -e

# Install Factory CLI
curl -fsSL https://app.factory.ai/cli | sh
export PATH="$HOME/.local/bin:$PATH"

# Run with structured output
droid exec --output-format json \
  "Review code changes" > review.json

# Error handling
if [ $? -eq 0 ]; then
  echo "✅ Review completed"
  # Parse results
  if command -v jq &> /dev/null; then
    jq -r '.result' review.json
  else
    grep -o '"result":"[^"]*"' review.json | cut -d'"' -f4
  fi
else
  echo "❌ Review failed"
  exit 1
fi
```

**Best practices for CI/CD:**

- Default mode is read-only (safest for CI/CD)
- Use `--auto` flags only when file modifications are needed
- Use `--output-format json` for structured, parseable output
- Handle exit codes properly (0 = success, non-zero = failure)
- Use appropriate autonomy levels based on trust level
- Store API keys as secrets, never hardcode
- Model selection via `-m` flag or configure in `settings.json`

## Limitations

- Default mode is read-only for safety (safest for CI/CD)
- Use `--auto` flags to enable mutations based on risk level
- Exit code 0 = success, non-zero = failure (use in CI checks)
- Avoid `--skip-permissions-unsafe` unless in isolated environments
- No delta streaming support (only debug format for real-time visibility)
- Model names can use short aliases (e.g., `sonnet`, `opus`, `haiku`) or full IDs
- Configure default model in `settings.json` file for consistency
- `droid exec` is designed for one-shot task execution; use `droid` for interactive workflows

## References

- [Factory AI Droid Exec](https://docs.factory.ai/cli/droid-exec/overview.md)
- [Factory AI Settings](https://app.factory.ai/settings/api-keys)
- [Factory AI Documentation](https://docs.factory.ai/)
