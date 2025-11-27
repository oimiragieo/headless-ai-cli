# 🌊 Windsurf

**Version tested:** Latest (check via IDE or Docker image)  
**Risk level:** 🟠 Medium (AI-powered IDE with headless Docker support)

**Note:** Windsurf is primarily an IDE-based tool. Headless mode is available via Docker using the `windsurfinabox` project, which enables CI/CD integration.

**When NOT to use Windsurf:**
- ❌ You need pure CLI-only workflows (Windsurf is an IDE)
- ❌ You need headless automation without Docker (requires Docker for headless mode)
- ❌ You're working in a server environment without Docker support
- ❌ You need massive context windows (Gemini CLI handles larger repos better)

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Windsurf](#-why-use-windsurf)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Headless Mode](#-headless-mode)
- [Available Models](#-available-models)
- [CLI Syntax](#-cli-syntax)
- [Features](#-features)
- [Configuration](#-configuration)
- [Examples](#-examples)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Windsurf is an AI-powered IDE with CLI capabilities, designed to enhance software development through AI assistance. It combines IDE features with AI-powered code generation, suggestions, and workflow automation.

**Key Characteristics:**
- AI-powered IDE
- CLI integration for automation
- Multiple LLM provider support
- Code generation and refactoring
- Workflow automation

## Installation

**Download and Install:**
1. Visit Windsurf website (check for official site)
2. Download installer for your platform:
   - Windows
   - macOS
   - Linux

**System Requirements:**
- Modern operating system
- Sufficient RAM (8GB+ recommended)
- API keys for LLM providers

## 🚀 Start Here

```bash
# Launch Windsurf IDE
# Use integrated terminal for CLI operations
# Access AI features through IDE interface
```

## Headless Mode

**Docker-based headless operation using `windsurfinabox`:**

Windsurf can operate in headless mode using Docker, allowing integration into automated processes such as CI/CD pipelines. The `windsurfinabox` project encapsulates Windsurf's Cascade agent within a Docker image for this purpose.

**Setup Steps:**

1. **Build the Docker Image:**
```bash
git clone https://github.com/pfcoperez/windsurfinabox.git
cd windsurfinabox
docker build . -t windsurf
```

2. **Prepare the Workspace:**
```bash
# Ensure workspace directory has read and write permissions
# User must have UID:GID=1000:1000
mkdir -p /path/to/workspace
chown -R 1000:1000 /path/to/workspace
```

3. **Create an Instructions File:**
```bash
# Create file with your task prompt
echo "Your task prompt here" > /path/to/workspace/windsurf-instructions.txt
```

4. **Obtain Windsurf Auth Token:**
- Open Windsurf IDE
- Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS)
- Run the command `Provide auth token`
- Copy the token

5. **Run the Docker Container:**
```bash
export WINDSURF_TOKEN=your_auth_token
docker run --rm -it --name windsurf \
  -e WINDSURF_TOKEN=$WINDSURF_TOKEN \
  -v /path/to/.config/Windsurf:/home/ubuntu/.config/Windsurf \
  -v /path/to/workspace:/home/ubuntu/workspace \
  windsurf
```

**How it works:**
- Uses Xvfb to create a virtual X11 screen
- Launches Windsurf editor in the virtual display
- Uses `xdotool` to automate interactions
- Executes instructions from `windsurf-instructions.txt`
- Enables headless operation without physical display

**IDE Integration:**
- Use Windsurf IDE for development
- Integrated terminal for CLI operations
- AI-powered code suggestions via Cascade agent
- Workflow automation through IDE

## Available Models

Windsurf supports multiple LLM providers:

| Provider | Models | Description |
|----------|--------|-------------|
| **OpenAI** | GPT-4, GPT-4 Turbo, GPT-3.5-turbo | Code generation, general tasks |
| **Anthropic** | Claude 3 Opus, Claude 3 Sonnet, Claude 3 Haiku | Strong reasoning, code analysis |
| **Google** | Gemini Pro, Gemini Flash | Alternative option, large context |

**Model Configuration:**
- Configure in Windsurf IDE settings
- Select models per project or globally
- Support for multiple models simultaneously
- API keys managed in IDE settings

**Cascade Agent:**
- AI-driven assistant that autonomously executes complex, multi-step tasks
- Manages package installations, implements libraries, performs refactoring
- Flow awareness: learns project structure and recent edits
- Adaptive meta-learning: learns team preferences and coding standards

## Cascade Agent

**Cascade Agent Features:**
- **Autonomous Task Execution**: Manages package installations, implements libraries, performs refactoring
- **Flow Awareness**: Continuously learns project structure and recent edits for precise, context-aware suggestions
- **Autonomous Editing**: Applies edits across multiple files automatically, preserving repository rules
- **Integrated Commands**: Executes terminal actions directly from Cascade
- **Adaptive Meta-Learning**: Learns team preferences, coding standards, and project-specific guidelines over time

**Using Cascade:**
- Access through Windsurf IDE interface
- Provide natural language prompts
- Cascade executes multi-step tasks autonomously
- Review and approve changes before committing

## Workflows

**Create workflows for automation:**

Workflows are markdown files stored in `.windsurf/workflows/` directory. They define reusable sequences of steps for repetitive tasks.

**Creating a Workflow:**
1. Navigate to the `Customizations` icon in the Cascade panel
2. Select the `Workflows` panel
3. Click on `+ Workflow` to create a new workflow
4. Workflows are saved as markdown files in `.windsurf/workflows/`

**Example Workflow:**
```markdown
# Deploy Workflow
1. Run tests: npm test
2. Build project: npm run build
3. Deploy to staging: npm run deploy:staging
4. Run smoke tests: npm run smoke-tests
```

**Invoke Workflows:**
- Use `/[workflow-name]` command in Cascade
- Workflows can be parameterized
- Can be shared across team members
- Support for complex multi-step automation

## Features

**AI-Powered Development:**
- Code generation from natural language
- Real-time code suggestions
- Automated refactoring
- Code explanation and documentation

**IDE Features:**
- Full-featured code editor
- Integrated terminal
- Git integration
- Extension support

**Workflow Automation:**
- Automated code generation
- Test generation
- Documentation updates
- Code quality improvements

## Configuration

**IDE Settings:**
- Configure in Windsurf settings
- API key management
- Model selection
- Feature toggles

**Environment Variables:**
```bash
export OPENAI_API_KEY=your_key
export ANTHROPIC_API_KEY=your_key
```

**Config file:**
- Location: Windsurf config directory
- Format: JSON or YAML

## Examples

**In Windsurf IDE:**
```
1. Open project in Windsurf
2. Use AI chat: "Create a REST API endpoint"
3. Generate code with AI assistance
4. Refactor code using AI suggestions
```

**CLI (if available):**
```bash
# Analyze project
windsurf analyze src/

# Generate code
windsurf generate --file src/api.py --prompt "Add authentication"
```

## CI/CD Integration

**GitHub Actions workflow example:**
```yaml
name: Windsurf Headless Automation

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  windsurf_task:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - name: Checkout code
        uses: actions/checkout@v5

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build Windsurf Docker image
        run: |
          git clone https://github.com/pfcoperez/windsurfinabox.git
          cd windsurfinabox
          docker build . -t windsurf

      - name: Prepare workspace
        run: |
          mkdir -p workspace
          echo "Review PR changes for bugs and security issues" > workspace/windsurf-instructions.txt
          chown -R 1000:1000 workspace

      - name: Run Windsurf in headless mode
        env:
          WINDSURF_TOKEN: ${{ secrets.WINDSURF_TOKEN }}
        run: |
          docker run --rm \
            -e WINDSURF_TOKEN=$WINDSURF_TOKEN \
            -v ${{ github.workspace }}/workspace:/home/ubuntu/workspace \
            windsurf
```

**Direct Docker usage in CI/CD:**
```bash
#!/bin/bash
set -e

# Build Docker image
docker build . -t windsurf

# Prepare workspace
mkdir -p workspace
echo "Your task prompt" > workspace/windsurf-instructions.txt
chown -R 1000:1000 workspace

# Run Windsurf
docker run --rm \
  -e WINDSURF_TOKEN=$WINDSURF_TOKEN \
  -v $(pwd)/workspace:/home/ubuntu/workspace \
  windsurf
```

**Best practices for CI/CD:**
- Use `windsurfinabox` Docker image for headless automation
- Store Windsurf auth token as secret
- Ensure workspace has correct permissions (UID:GID=1000:1000)
- Create `windsurf-instructions.txt` with clear task prompts
- Use workflows for reusable automation patterns
- Review Cascade agent changes before committing

## Limitations

- **IDE dependency:** Primarily designed as IDE, not a pure CLI tool
- **Docker required for headless:** Headless mode requires Docker and `windsurfinabox` project
- **GUI required for IDE:** Full IDE features require GUI environment
- **Context limits:** Depends on selected LLM provider (not as large as Gemini's 1M tokens)
- **Resource usage:** IDE requires significant resources (8GB+ RAM recommended)
- **Autonomous changes:** Cascade agent makes changes autonomously (review before committing)
- **Workflow complexity:** Workflows are markdown-based, may require IDE for complex editing

## References

- Official Website: [windsurf.com](https://windsurf.com)
- Windsurf in a Box: [github.com/pfcoperez/windsurfinabox](https://github.com/pfcoperez/windsurfinabox)
- Cascade Documentation: Check Windsurf IDE documentation
- Workflows Guide: See Windsurf IDE workflows panel

**Note:** Windsurf is actively developed. Check the official website and GitHub for the latest features, Cascade agent capabilities, and workflow documentation.

