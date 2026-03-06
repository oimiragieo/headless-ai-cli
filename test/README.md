# AI CLI Test Suite

This directory contains comprehensive tests for AI CLI tools in headless mode, including Claude Code CLI, OpenAI Codex CLI, and GitHub Copilot CLI. Tests cover basic execution, JSON output, streaming, session management, and CI/CD integration.

## Prerequisites

### Required Tools

- **Claude CLI**: Install with `npm install -g @anthropic-ai/claude-code`
- **Codex CLI**: Install with `npm install -g @openai/codex`
- **Copilot CLI**: Install with `npm install -g @github/copilot`
- **Bash**: Version 4.0 or later (most modern systems)
- **jq**: JSON processor (recommended for full test coverage)
  - Linux: `apt-get install jq` or `yum install jq`
  - macOS: `brew install jq`
  - Windows: Use WSL or install via package manager

### API Key Setup

**For Claude tests:**
Set your Anthropic API key as an environment variable:

```bash
export ANTHROPIC_API_KEY=your_api_key_here
```

**For Codex tests:**
Set your OpenAI API key as an environment variable:

```bash
export OPENAI_API_KEY=your_api_key_here
```

**For Copilot tests:**
GitHub Copilot CLI uses GitHub authentication (not an API key). You need:

- GitHub account with Copilot access (Pro, Pro+, Business, or Enterprise plan)
- Copilot CLI authenticated with your GitHub account
- If receiving Copilot from an organization, ensure Copilot CLI policy is enabled

**Note**: Tests will skip API-dependent tests if authentication is not set, but will still validate CLI syntax and structure.

## Test Files

### Claude CLI Tests

#### Basic Tests

- **`claude-headless-basic.test.sh`**: Basic headless mode execution, exit codes, and output formats
- **`claude-headless-json.test.sh`**: JSON output format validation and parsing
- **`claude-headless-stream.test.sh`**: Streaming JSON output and real-time event parsing

#### Advanced Tests

- **`claude-session-management.test.sh`**: Session management (`--continue`, `--resume`, session persistence)
- **`claude-tool-control.test.sh`**: Tool control (`--allowedTools`, `--disallowedTools`, permission modes)
- **`claude-cicd-integration.test.sh`**: CI/CD integration patterns, error handling, and structured output

### Codex CLI Tests

#### Basic Tests

- **`codex-headless-basic.test.sh`**: Basic headless mode execution, exit codes, and output formats
- **`codex-headless-json.test.sh`**: JSONL output format validation and parsing
- **`codex-headless-stream.test.sh`**: JSONL streaming output and real-time event parsing

#### Advanced Tests

- **`codex-session-management.test.sh`**: Session management (`resume --last`, `resume SESSION_ID`)
- **`codex-sandbox-modes.test.sh`**: Sandbox mode testing (`read-only`, `workspace-write`, `danger-full-access`)
- **`codex-cicd-integration.test.sh`**: CI/CD integration patterns, error handling, and structured output

### Copilot CLI Tests

#### Basic Tests

- **`copilot-headless-basic.test.sh`**: Basic programmatic mode execution, exit codes, and output formats
- **`copilot-headless-json.test.sh`**: JSON output format validation (if supported)

#### Advanced Tests

- **`copilot-tool-control.test.sh`**: Tool control (`--allow-all-tools`, `--allow-tool`, `--deny-tool`, environment variables)
- **`copilot-cicd-integration.test.sh`**: CI/CD integration patterns, error handling, and exit code validation

### Aider CLI Tests

#### Basic Tests

- **`aider-headless-basic.test.sh`**: Basic headless mode execution, exit codes, and flags (`--yes`, `--message`, `--model`)

#### Advanced Tests

- **`aider-headless-advanced.test.sh`**: Advanced features (model selection, API keys, Git integration, error handling)
- **`aider-workflows.test.sh`**: Workflow automation patterns (code generation, refactoring, testing, documentation)
- **`aider-cicd-integration.test.sh`**: CI/CD integration patterns, error handling, and exit code validation

### Amazon Q Developer CLI Tests

#### Basic Tests

- **`amazon-q-headless-basic.test.sh`**: Basic headless mode execution, exit codes, and flags (`--prompt`, `--file`, `--files`)

#### Advanced Tests

- **`amazon-q-headless-advanced.test.sh`**: Advanced features (file processing, directory analysis, error handling)
- **`amazon-q-workflows.test.sh`**: Workflow automation patterns (code review, transformation, testing, documentation)
- **`amazon-q-cicd-integration.test.sh`**: CI/CD integration patterns, error handling, and exit code validation

### OpenCode CLI Tests

#### Basic Tests

- **`open-code-headless-basic.test.sh`**: Basic headless mode execution, exit codes, and flags (`--headless`, `--prompt`, `--file`)

#### Advanced Tests

- **`open-code-headless-advanced.test.sh`**: Advanced features (model selection, file processing, directory analysis, error handling)
- **`open-code-workflows.test.sh`**: Workflow automation patterns (code generation, refactoring, testing, documentation)
- **`open-code-cicd-integration.test.sh`**: CI/CD integration patterns, error handling, and exit code validation

### Continue Dev CLI Tests

#### Basic Tests

- **`continue-dev-headless-basic.test.sh`**: Basic headless mode execution, exit codes, and flags (`-p`, `--prompt`, `--file`)

#### Advanced Tests

- **`continue-dev-headless-advanced.test.sh`**: Advanced features (model selection, file processing, directory analysis, error handling)
- **`continue-dev-workflows.test.sh`**: Workflow automation patterns (code generation, refactoring, testing, documentation)
- **`continue-dev-cicd-integration.test.sh`**: CI/CD integration patterns, error handling, and exit code validation

## Running Tests

### Run All Tests

```bash
# Make scripts executable (Linux/macOS)
chmod +x test/*.test.sh

# Run all tests
for test in test/*.test.sh; do
    echo "Running $test..."
    bash "$test"
    echo ""
done
```

### Run Individual Tests

**Claude Tests:**

```bash
# Run basic tests
bash test/claude-headless-basic.test.sh

# Run JSON format tests
bash test/claude-headless-json.test.sh

# Run streaming tests
bash test/claude-headless-stream.test.sh

# Run session management tests
bash test/claude-session-management.test.sh

# Run tool control tests
bash test/claude-tool-control.test.sh

# Run CI/CD integration tests
bash test/claude-cicd-integration.test.sh
```

**Codex Tests:**

```bash
# Run basic tests
bash test/codex-headless-basic.test.sh

# Run JSON format tests
bash test/codex-headless-json.test.sh

# Run streaming tests
bash test/codex-headless-stream.test.sh

# Run session management tests
bash test/codex-session-management.test.sh

# Run sandbox mode tests
bash test/codex-sandbox-modes.test.sh

# Run CI/CD integration tests
bash test/codex-cicd-integration.test.sh
```

**Copilot Tests:**

```bash
# Run basic tests
bash test/copilot-headless-basic.test.sh

# Run JSON format tests (if supported)
bash test/copilot-headless-json.test.sh

# Run tool control tests
bash test/copilot-tool-control.test.sh

# Run CI/CD integration tests
bash test/copilot-cicd-integration.test.sh
```

### Run Tests in CI/CD

**For Claude tests:**

```bash
# Set API key from secret
export ANTHROPIC_API_KEY=${{ secrets.ANTHROPIC_API_KEY }}

# Install dependencies
npm install -g @anthropic-ai/claude-code
apt-get update && apt-get install -y jq  # or equivalent for your OS

# Run Claude tests
set -e
for test in test/claude-*.test.sh; do
    bash "$test" || exit 1
done
```

**For Codex tests:**

```bash
# Set API key from secret
export OPENAI_API_KEY=${{ secrets.OPENAI_API_KEY }}

# Install dependencies
npm install -g @openai/codex
apt-get update && apt-get install -y jq  # or equivalent for your OS

# Run Codex tests
set -e
for test in test/codex-*.test.sh; do
    bash "$test" || exit 1
done
```

**For Copilot tests:**

```bash
# Install dependencies
npm install -g @github/copilot
apt-get update && apt-get install -y jq  # or equivalent for your OS

# Set environment variable for non-interactive mode
export COPILOT_ALLOW_ALL=1

# Authenticate with GitHub Copilot (requires GitHub Copilot access)
# Note: Authentication may require interactive setup or GitHub token

# Run Copilot tests
set -e
for test in test/copilot-*.test.sh; do
    bash "$test" || exit 1
done
```

**For Aider tests:**

```bash
# Set API key from secret
export OPENAI_API_KEY=${{ secrets.OPENAI_API_KEY }}
# or
export ANTHROPIC_API_KEY=${{ secrets.ANTHROPIC_API_KEY }}

# Install dependencies
pip install aider-chat
apt-get update && apt-get install -y git  # Git is required for best Aider experience

# Run Aider tests
set -e
for test in test/aider-*.test.sh; do
    bash "$test" || exit 1
done
```

**For Amazon Q Developer tests:**

```bash
# Install dependencies
wget https://github.com/aws/amazon-q-developer-cli/releases/latest/download/amazon-q-developer-cli-linux.zip
unzip amazon-q-developer-cli-linux.zip
cd amazon-q-developer-cli-linux
sudo ./install.sh
cd ..

# Setup authentication (pre-authenticate and copy ~/.amazonq/ directory)
# Or use AWS credentials if using AWS SDK integration
mkdir -p ~/.amazonq
echo "${{ secrets.AMAZONQ_AUTH }}" > ~/.amazonq/auth.json

# Run Amazon Q Developer tests
set -e
for test in test/amazon-q-*.test.sh; do
    bash "$test" || exit 1
done
```

```bash
# Set API key from secret
export OPENAI_API_KEY=${{ secrets.OPENAI_API_KEY }}
# or
export ANTHROPIC_API_KEY=${{ secrets.ANTHROPIC_API_KEY }}

# Install dependencies
# or

# Setup MCP server

set -e
    bash "$test" || exit 1
done
```

**For OpenCode tests:**

```bash
# Set API key from secret
export OPENAI_API_KEY=${{ secrets.OPENAI_API_KEY }}
# or
export ANTHROPIC_API_KEY=${{ secrets.ANTHROPIC_API_KEY }}

# Install dependencies
npm install -g open-code
# or
npm install -g open-code

# Run OpenCode tests
set -e
for test in test/open-code-*.test.sh; do
    bash "$test" || exit 1
done
```

**For Continue Dev tests:**

```bash
# Set API key from secret
export CONTINUE_API_KEY=${{ secrets.CONTINUE_API_KEY }}
# or
export OPENAI_API_KEY=${{ secrets.OPENAI_API_KEY }}
# or
export ANTHROPIC_API_KEY=${{ secrets.ANTHROPIC_API_KEY }}

# Install dependencies
npm install -g @continuedev/cli

# Run Continue Dev tests
set -e
for test in test/continue-dev-*.test.sh; do
    bash "$test" || exit 1
done
```

## Test Output

Tests provide color-coded output:

- 🟢 **GREEN**: Test passed
- 🔴 **RED**: Test failed
- 🟡 **YELLOW**: Test skipped (usually due to missing API key)

Each test file provides a summary at the end:

```text
==========================================
Test Summary
==========================================
Total tests: 10
Passed: 8
Failed: 2
```

## Expected Behavior

### Without API Key / Authentication

Tests will:

- ✅ Validate CLI syntax and flags
- ✅ Check exit codes for invalid commands
- ✅ Verify JSON structure (if jq is available)
- ⚠️ Skip API-dependent tests (marked as SKIP)

### With API Key

Tests will:

- ✅ Execute full test suite
- ✅ Validate API responses
- ✅ Test session management
- ✅ Verify tool control
- ✅ Test CI/CD patterns

## Troubleshooting

### "Claude CLI not found"

Install Claude CLI:

```bash
npm install -g @anthropic-ai/claude-code
```

Verify installation:

```bash
claude --version
```

### "Codex CLI not found"

Install Codex CLI:

```bash
npm install -g @openai/codex
```

Verify installation:

```bash
codex --version
```

### "Copilot CLI not found"

Install Copilot CLI:

```bash
npm install -g @github/copilot
```

Verify installation:

```bash
copilot --version
```

### "jq not found"

Install jq (see Prerequisites above). Tests will still run but some JSON parsing tests will be skipped.

### "API key not set"

**For Claude tests:**
Set your API key:

```bash
export ANTHROPIC_API_KEY=your_key_here
```

Get your API key from: <https://console.anthropic.com/>

**For Codex tests:**
Set your API key:

```bash
export OPENAI_API_KEY=your_key_here
```

Get your API key from: <https://platform.openai.com/api-keys>

**For Copilot tests:**
GitHub Copilot CLI uses GitHub authentication, not an API key. Ensure:

1. You have GitHub Copilot access (Pro, Pro+, Business, or Enterprise plan)
2. Copilot CLI is authenticated: `copilot --version` should work
3. If using organization Copilot, ensure CLI policy is enabled
4. Set `COPILOT_ALLOW_ALL=1` for non-interactive mode

Get Copilot access from: <https://github.com/features/copilot>

**For Aider tests:**
Set your API key:

```bash
export OPENAI_API_KEY=your_key_here
# or
export ANTHROPIC_API_KEY=your_key_here
```

Get your API keys from:

- OpenAI: <https://platform.openai.com/api-keys>
- Anthropic: <https://console.anthropic.com/>

**For Amazon Q Developer tests:**
Amazon Q Developer CLI uses authentication via `q login`. For headless mode:

1. Pre-authenticate locally: `q login`
2. Copy `~/.amazonq/` directory to CI environment
3. Or use AWS credentials if using AWS SDK integration

Install CLI from: <https://github.com/aws/amazon-q-developer-cli>

1. Set API key: `export OPENAI_API_KEY=your_key` or `export ANTHROPIC_API_KEY=your_key`

**For OpenCode tests:**
OpenCode CLI uses API keys for LLM providers. For headless mode:

1. Set API key: `export OPENAI_API_KEY=your_key` or `export ANTHROPIC_API_KEY=your_key`
2. Install OpenCode: `npm install -g open-code`
3. Authenticate: `opencode auth login`
4. Use `opencode run "message"` for headless execution

Install CLI from: npm install -g open-code

**For Continue Dev tests:**
Continue Dev CLI uses API keys for LLM providers. For headless mode:

1. Set API key: `export CONTINUE_API_KEY=your_key` or `export OPENAI_API_KEY=your_key` or `export ANTHROPIC_API_KEY=your_key`
2. Install Continue Dev: `npm install -g @continuedev/cli`
3. Use `-p` or `--prompt` flag for headless mode: `cn -p "Your prompt"`

Install CLI from: npm install -g @continuedev/cli

### Tests failing with API key set

**For Claude tests:**

1. Verify API key is valid: `echo $ANTHROPIC_API_KEY`
2. Check rate limits: You may be hitting API rate limits
3. Verify network connectivity
4. Check Claude CLI version: `claude --version` (update if needed)

**For Codex tests:**

1. Verify API key is valid: `echo $OPENAI_API_KEY`
2. Check rate limits: You may be hitting API rate limits
3. Verify network connectivity
4. Check Codex CLI version: `codex --version` (update if needed)
5. Ensure you have access to Codex models in your OpenAI account

**For Copilot tests:**

1. Verify authentication: `copilot --version` should work
2. Check GitHub Copilot access: Ensure you have an active Copilot subscription
3. Verify network connectivity
4. Check Copilot CLI version: `copilot --version` (update if needed)
5. Ensure `COPILOT_ALLOW_ALL=1` is set for non-interactive mode
6. If using organization Copilot, verify CLI policy is enabled in organization settings

### Permission denied errors

Make scripts executable:

```bash
chmod +x test/*.test.sh
```

## Test Coverage

### Claude CLI Coverage

#### Basic Functionality

- ✅ Headless mode flags (`-p`, `--print`)
- ✅ Output formats (`text`, `json`, `stream-json`)
- ✅ Permission bypass mode (`--permission-mode bypassPermissions`)
- ✅ Exit code handling
- ✅ Stdin input

#### JSON Output

- ✅ Valid JSON structure
- ✅ Required fields (`type`, `result`, `session_id`, `total_cost_usd`)
- ✅ JSON parsing with jq
- ✅ Error handling

#### Streaming

- ✅ Stream JSON format
- ✅ Event types (`init`, `message`, `result`)
- ✅ Real-time parsing
- ✅ Incremental processing

#### Session Management

- ✅ Session ID extraction
- ✅ Resume session (`--resume`)
- ✅ Continue conversation (`--continue`)
- ✅ Session persistence
- ✅ Multiple session operations

#### Tool Control

- ✅ Allow tools (`--allowedTools`)
- ✅ Disallow tools (`--disallowedTools`)
- ✅ Permission modes
- ✅ Tool approval behavior

#### CI/CD Integration

- ✅ Environment variable handling
- ✅ Structured output for automation
- ✅ Error handling in CI context
- ✅ Exit code validation
- ✅ Timeout handling
- ✅ Artifact generation

### Codex CLI Coverage

#### Basic Functionality

- ✅ Headless mode execution (`codex exec`)
- ✅ Output formats (text, JSONL with `--json`)
- ✅ Exit code handling
- ✅ Color output control (`--color`)
- ✅ Working directory (`--cd`, `-C`)
- ✅ Model selection (`--model`, `-m`)

#### JSONL Output

- ✅ Valid JSONL structure (newline-delimited JSON)
- ✅ Event types (`thread.started`, `turn.started`, `turn.completed`, `item.*`)
- ✅ JSONL parsing with jq
- ✅ Error handling
- ✅ Thread ID extraction

#### Streaming

- ✅ JSONL stream format
- ✅ Event types (`thread.started`, `turn.*`, `item.*`, `error`)
- ✅ Real-time parsing
- ✅ Incremental processing

#### Session Management

- ✅ Thread ID extraction from JSONL
- ✅ Resume last session (`resume --last`)
- ✅ Resume specific session (`resume SESSION_ID`)
- ✅ Session persistence
- ✅ Multi-step workflows

#### Sandbox Modes

- ✅ Read-only sandbox (default)
- ✅ Workspace-write sandbox (`--sandbox workspace-write`, `--full-auto`)
- ✅ Danger-full-access sandbox (`--sandbox danger-full-access`)
- ✅ Sandbox mode validation

#### CI/CD Integration

- ✅ Environment variable handling (`OPENAI_API_KEY`)
- ✅ Structured output for automation (JSONL)
- ✅ Error handling in CI context
- ✅ Exit code validation
- ✅ Color output control for CI (`--color never`)
- ✅ Artifact generation
- ✅ JSON Schema support (`--output-schema`)

### Copilot CLI Coverage

#### Basic Functionality

- ✅ Programmatic mode flags (`-p`, `--prompt`)
- ✅ Output formats (text default, JSON if supported)
- ✅ Silent mode (`--silent`, `-s`)
- ✅ No color output (`--no-color`)
- ✅ Stream control (`--stream on/off`)
- ✅ Exit code handling
- ✅ Stdin input

#### Tool Control

- ✅ Allow all tools (`--allow-all-tools`)
- ✅ Allow specific tools (`--allow-tool`)
- ✅ Deny specific tools (`--deny-tool`)
- ✅ Environment variable (`COPILOT_ALLOW_ALL`)
- ✅ Tool syntax validation (`shell(COMMAND)`, `write`, `MCP_SERVER_NAME`)
- ✅ Tool precedence (deny takes precedence)

#### CI/CD Integration

- ✅ Environment variable handling (`COPILOT_ALLOW_ALL`)
- ✅ Error handling in CI context
- ✅ Exit code validation
- ✅ No color output for CI (`--no-color`)
- ✅ Silent mode for scripting (`--silent`)
- ✅ Log level and directory configuration
- ✅ Artifact generation

### Aider CLI Coverage

#### Basic Functionality

- ✅ Headless mode flags (`--yes`, `-y`)
- ✅ Message input (`--message`, stdin)
- ✅ Model selection (`--model`)
- ✅ Exit code handling
- ✅ File specification
- ✅ Multiple file processing

#### Advanced Features

- ✅ Model selection (OpenAI, Anthropic, DeepSeek)
- ✅ API key override (`--api-key`)
- ✅ Git integration (default) and `--no-git` flag
- ✅ Error handling (invalid files, invalid models)
- ✅ Complex prompts processing
- ✅ Directory-based processing

#### Workflow Automation

- ✅ Code generation workflows
- ✅ Refactoring workflows
- ✅ Documentation generation
- ✅ Test generation
- ✅ Code quality improvements
- ✅ Security enhancements
- ✅ Multi-file processing
- ✅ Batch processing

#### CI/CD Integration

- ✅ Environment variable handling (`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`)
- ✅ Error handling in CI context
- ✅ Exit code validation
- ✅ No Git mode for faster CI (`--no-git`)
- ✅ Model specification for consistency
- ✅ Timeout handling
- ✅ Batch processing in CI

### Amazon Q Developer CLI Coverage

#### Basic Functionality

- ✅ Headless mode flags (`--prompt`, `-p`)
- ✅ File input (`--file`, `-f`)
- ✅ Multiple file processing (`--files`, `-F`)
- ✅ Directory processing (`--directory`, `-d`)
- ✅ Output file (`--output`, `-o`)
- ✅ Exit code handling
- ✅ Stdin input

#### Advanced Features

- ✅ File processing with context
- ✅ Directory-based analysis
- ✅ Multi-file batch processing
- ✅ Error handling (invalid files, invalid directories)
- ✅ Complex prompt processing
- ✅ Output file generation

#### Workflow Automation

- ✅ Code review workflows
- ✅ Code transformation workflows
- ✅ Documentation generation
- ✅ Test generation
- ✅ Code quality improvements
- ✅ Security enhancements
- ✅ Multi-file refactoring
- ✅ Batch processing

#### CI/CD Integration

- ✅ Authentication handling (pre-authenticated credentials)
- ✅ Error handling in CI context
- ✅ Exit code validation
- ✅ Output file for artifacts (`--output`)
- ✅ Timeout handling
- ✅ Batch processing in CI
- ✅ Git integration for changed files

### Kiro CLI Coverage

#### Basic Functionality

- ✅ Headless mode flags (`--prompt`, `-p`, `--headless`)
- ✅ File input (`--file`, `-f`)
- ✅ Multiple file processing (`--files`, `-F`)
- ✅ Directory processing (`--directory`, `-d`)
- ✅ Output file (`--output`, `-o`)
- ✅ Exit code handling
- ✅ Stdin input
- ✅ Model selection (`--model`, `-m`)

#### Advanced Features

- ✅ MCP server integration (`mcp setup`, `mcp start`, `mcp status`)
- ✅ Memory Bank integration (`--memory-bank`)
- ✅ File processing with context
- ✅ Directory-based analysis
- ✅ Multi-file batch processing
- ✅ Error handling (invalid files, invalid directories)
- ✅ Complex prompt processing
- ✅ Output file generation

#### Workflow Automation

- ✅ Code generation workflows
- ✅ Refactoring workflows
- ✅ Documentation generation
- ✅ Test generation
- ✅ Code quality improvements
- ✅ Security enhancements
- ✅ Multi-file refactoring
- ✅ Batch processing

#### CI/CD Integration

- ✅ Environment variable handling (`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`)
- ✅ Error handling in CI context
- ✅ Exit code validation
- ✅ MCP server setup for CI (`mcp setup`, `mcp start --daemon`)
- ✅ Output file for artifacts (`--output`)
- ✅ Timeout handling
- ✅ Batch processing in CI
- ✅ Git integration for changed files
- ✅ Memory Bank integration for context persistence

### OpenCode CLI Coverage

#### Basic Functionality

- ✅ Headless mode flags (`--headless`, `--prompt`, `-p`)
- ✅ File input (`--file`, `-f`)
- ✅ Multiple file processing (`--files`, `-F`)
- ✅ Directory processing (`--directory`, `-d`)
- ✅ Output file (`--output`, `-o`)
- ✅ Exit code handling
- ✅ Stdin input
- ✅ Model selection (`--model`, `-m`)

#### Advanced Features

- ✅ Model selection (OpenAI, Anthropic, DeepSeek)
- ✅ File processing with context
- ✅ Directory-based analysis
- ✅ Multi-file batch processing
- ✅ Error handling (invalid files, invalid directories)
- ✅ Complex prompt processing
- ✅ Output file generation
- ✅ Config file support (`--config`)

#### Workflow Automation

- ✅ Code generation workflows
- ✅ Refactoring workflows
- ✅ Documentation generation
- ✅ Test generation
- ✅ Code quality improvements
- ✅ Security enhancements
- ✅ Multi-file refactoring
- ✅ Batch processing

#### CI/CD Integration

- ✅ Environment variable handling (`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`)
- ✅ Error handling in CI context
- ✅ Exit code validation
- ✅ Output file for artifacts (`--output`)
- ✅ Timeout handling
- ✅ Batch processing in CI
- ✅ Git integration for changed files

### Continue Dev CLI Coverage

#### Basic Functionality

- ✅ Headless mode flags (`-p`, `--prompt`)
- ✅ File input (`--file`, `-f`)
- ✅ Multiple file processing (`--files`, `-F`)
- ✅ Directory processing (`--directory`, `-d`)
- ✅ Output file (`--output`, `-o`)
- ✅ Exit code handling
- ✅ Stdin input
- ✅ Model selection (`--model`, `-m`)

#### Advanced Features

- ✅ Model selection (OpenAI, Anthropic, DeepSeek)
- ✅ File processing with context
- ✅ Directory-based analysis
- ✅ Multi-file batch processing
- ✅ Error handling (invalid files, invalid directories)
- ✅ Complex prompt processing
- ✅ Output file generation
- ✅ Config file support (`--config`)

#### Workflow Automation

- ✅ Code generation workflows
- ✅ Refactoring workflows
- ✅ Documentation generation
- ✅ Test generation
- ✅ Code quality improvements
- ✅ Security enhancements
- ✅ Multi-file refactoring
- ✅ Batch processing

#### CI/CD Integration

- ✅ Environment variable handling (`CONTINUE_API_KEY`, `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`)
- ✅ Error handling in CI context
- ✅ Exit code validation
- ✅ Output file for artifacts (`--output`)
- ✅ Timeout handling
- ✅ Batch processing in CI
- ✅ Git integration for changed files
- ✅ Documentation update automation

## Contributing

When adding new tests:

1. Follow the existing test structure
2. Use the `test_case` function for consistent output
3. Handle missing API keys gracefully (skip, don't fail)
4. Provide clear test names
5. Include error handling
6. Update this README if adding new test categories

## References

### Claude CLI

- [Claude Code Documentation](https://code.claude.com/docs/en/headless.md)
- [Anthropic API Documentation](https://docs.anthropic.com)
- [Claude CLI GitHub](https://github.com/anthropics/claude-code-cli)

### Codex CLI

- [OpenAI Codex Documentation](https://openai.com/research/codex)
- [Codex SDK Documentation](https://developers.openai.com/codex/sdk)
- [OpenAI Platform](https://platform.openai.com/)

### Copilot CLI

- [Installing GitHub Copilot CLI](https://docs.github.com/en/copilot/cli)
- [About GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli)
- [Using GitHub Copilot CLI](https://docs.github.com/en/copilot/cli/using-github-copilot-cli)
- [GitHub Copilot](https://github.com/features/copilot)
