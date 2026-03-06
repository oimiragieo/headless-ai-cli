# 🚀 Google Antigravity

**Version tested:** Latest (desktop app, auto-updates)
**Risk level:** ⚠️ High (multi-agent IDE with autonomous execution, writes by default)

**Note:** Antigravity is a desktop IDE, not a CLI tool. It has NO headless mode or CLI. Google recommends Gemini CLI for headless/CI/CD workflows. Included here for completeness as a major AI coding tool.

**When NOT to use Antigravity:**

- ❌ You need headless/CLI automation (use Gemini CLI instead)
- ❌ You need CI/CD pipeline integration (no headless mode)
- ❌ You need offline/air-gapped workflows (requires constant internet)
- ❌ You need MCP (Model Context Protocol) support (not supported as of Mar 2026)
- ❌ You need predictable rate limits (aggressive throttling reported)

### Quick Nav

- [Start Here](#-start-here)
- [Why Use Antigravity](#-why-use-antigravity)
- [Best Use Cases](#-best-use-cases)
- [Installation](#-installation)
- [Headless Mode](#-headless-mode)
- [Available Models](#-available-models)
- [Features](#-features)
- [Configuration](#-configuration)
- [Examples](#-examples)
- [Limitations](#-limitations)
- [References](#-references)

## Overview

Google Antigravity is an AI-powered desktop IDE launched November 2025 alongside Gemini 3. Built on VS Code, it features multi-agent orchestration ("Swarm Development") with up to 5 parallel agents, a built-in Chrome browser for E2E testing, and native Google Cloud Platform integration.

**Key Characteristics:**

- Multi-agent orchestration (up to 5 parallel agents)
- Built-in Chrome browser for browser-in-the-loop workflows
- VS Code fork — compatible with VS Code extension marketplace
- Native GCP integration (Cloud Run, Firebase, BigQuery)
- Plan Mode and Fast Mode for different workflows
- Artifact transparency (plans, diffs, screenshots, test results)
- 1M token working context (Gemini 3.1 Pro supports 2M)

**Ownership:** Google (launched Nov 18, 2025)

## 🚀 Why Use Antigravity

- **Multi-agent swarms**: Up to 5 agents working simultaneously on different tasks
- **Built-in browser**: Native Chrome for E2E testing, screenshots, network inspection
- **GCP integration**: Zero-config deployment to Cloud Run, Firebase
- **Free tier available**: Generous weekly rate limits with free Google account
- **VS Code compatible**: Use existing VS Code extensions

## 🎯 Best Use Cases

- Full-stack development with browser testing needs
- Google Cloud Platform projects
- Multi-task projects benefiting from parallel agents
- Teams already invested in Google ecosystem

## Installation

**Download:**

- Desktop app from [antigravity.google](https://antigravity.google/)
- Available for Windows, macOS, and Linux

**System Requirements:**

- Google account (required for sign-in)
- Constant internet connection
- VS Code-compatible system requirements

**No CLI installation** — Antigravity is a desktop IDE only. For CLI/headless workflows, use [Gemini CLI](gemini.md).

## 🚀 Start Here

1. Download from [antigravity.google](https://antigravity.google/)
2. Sign in with Google account
3. Open a project folder
4. Use the agent panel to start AI-assisted tasks

## Headless Mode

**⚠️ Antigravity has NO headless mode or CLI.**

Google explicitly recommends using **Gemini CLI** for headless/CI/CD workflows:

- Gemini CLI supports piping output, automation scripts, and CI/CD integration
- Antigravity is the GUI IDE counterpart

```bash
# Use Gemini CLI instead for headless workflows
gemini -p "Review code for bugs" --output-format json
```

See [Gemini CLI documentation](gemini.md) for headless automation.

## Available Models

Models available in Antigravity (Individual/Free tier):

| Model                 | Provider  | Notes                            |
| --------------------- | --------- | -------------------------------- |
| **Gemini 3.1 Pro**    | Google    | Primary agent model, 2M context  |
| **Gemini 3 Flash**    | Google    | Faster/lighter model             |
| **Claude Opus 4.6**   | Anthropic | Premium reasoning (rate-limited) |
| **Claude Sonnet 4.5** | Anthropic | Long-form tasks (rate-limited)   |
| **gpt-oss-120b**      | OpenAI    | Lightweight edits                |

> **Note (March 2026):** Third-party model access (Claude, GPT) is heavily rate-limited — users report as few as 5-7 Claude prompts per week on the Pro plan. Gemini models have more generous limits.

**Model assignment:** Models can be assigned per-agent in the Manager View, allowing different models for different agents within a single session.

## Pricing

| Tier                | Price                  | Details                                 |
| ------------------- | ---------------------- | --------------------------------------- |
| **Individual**      | Free                   | Generous weekly rate limits, all models |
| **Developer**       | $20/mo (Google AI Pro) | Higher rate limits, 2TB storage         |
| **Developer Ultra** | ~$250/mo (AI Ultra)    | Significantly higher rate limits        |
| **Team**            | Google Workspace       | Preview — team rate limits              |
| **Organization**    | Google Cloud           | Coming Soon                             |

## Features

**Multi-Agent Orchestration (Swarm Development):**

- Up to 5 parallel agents working simultaneously
- Manager View for human-in-the-loop oversight
- Per-agent model assignment
- Cross-surface agents (editor, terminal, browser)

**Built-in Browser:**

- Native Chrome integration
- E2E testing with screenshots
- Network inspection
- Browser-in-the-loop agent workflows

**Modes:**

- **Plan Mode**: Detailed task planning before execution
- **Fast Mode**: Instant implementation

**GCP Integration:**

- Zero-config deployment to Cloud Run
- Firebase integration
- BigQuery via Vertex AI

## Configuration

**Authentication:**

- Sign in with Google account
- Optional: Google One AI Pro/Ultra subscription for enhanced rate limits

**Settings:**

- Available through IDE settings panel
- VS Code-compatible settings structure

## Examples

**Note:** All examples are within the IDE — no CLI examples available.

**Multi-Agent Workflow:**

1. Open Manager View
2. Assign agents to tasks (e.g., "Agent 1: refactor auth module", "Agent 2: write tests")
3. Assign models per agent (Gemini 3.1 Pro for complex, Flash for simple)
4. Monitor progress and review artifacts

**Browser-in-the-Loop:**

1. Write frontend code with agent assistance
2. Agent automatically tests in built-in browser
3. Screenshots and network logs captured as artifacts
4. Agent iterates based on visual feedback

## Limitations

- **No headless mode or CLI** — desktop IDE only (use Gemini CLI for automation)
- **No MCP support** — unlike Cursor, Kiro, and Claude Code
- **Aggressive rate limits** — free tier and Pro tier both have tight limits
- **Third-party model throttling** — Claude/GPT access heavily rate-limited (5-7 prompts/week reported)
- **Requires constant internet** — no offline capability
- **No official API** — underlying models available via Vertex AI, but not Antigravity itself
- **No official GitHub repo** — closed-source product
- **Security concerns** — Feb 2026 audit identified 70+ vulnerabilities in v1.107.0
- **Vendor lock-in** — deep Google ecosystem integration
- **Rate limit reliability** — advertised 5-hour refresh cycle not consistently honored

**Benchmarks:**

- SWE-bench Verified: 76.2%
- Terminal-Bench 2.0: ~68%

## References

- **Official Website:** [antigravity.google](https://antigravity.google/)
- **Pricing:** [antigravity.google/pricing](https://antigravity.google/pricing)
- **Blog:** [antigravity.google/blog](https://antigravity.google/blog/introducing-google-antigravity)
- **Google Developers Blog:** [developers.googleblog.com](https://developers.googleblog.com/build-with-google-antigravity-our-new-agentic-development-platform/)
- **Antigravity vs Gemini CLI:** [cloud.google.com](https://cloud.google.com/blog/topics/developers-practitioners/choosing-antigravity-or-gemini-cli)

**Community projects:**

- [antigravity-claude-proxy](https://github.com/badrisnarayanan/antigravity-claude-proxy) — Proxy for using Antigravity's models in external CLI tools (2.9K stars)
