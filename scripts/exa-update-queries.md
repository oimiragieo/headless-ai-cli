# Exa Search Queries for Documentation Updates

**Purpose:** Run these Exa searches periodically to check for CLI tool updates (models, syntax, features, deprecations). Use findings to update `tools/major/*.md` documentation files.

**Last run:** March 2026
**Recommended frequency:** Monthly or when a major model release is announced

---

## Search Queries by Tool

### 1. Claude Code (tools/major/claude.md)

```text
Query: "Claude Code CLI changes {YEAR} new models features updates"
Alt:   "Anthropic Claude CLI new version {YEAR} release"
Alt:   "claude-opus claude-sonnet new model {YEAR}"
```

**What to check:** Models table, effort parameter, CLI flags, context window changes

### 2. Codex (tools/major/codex.md)

```text
Query: "OpenAI Codex CLI changes {YEAR} new models features updates"
Alt:   "gpt codex new model {YEAR} release OpenAI"
Alt:   "codex exec CLI syntax changes {YEAR}"
```

**What to check:** Models table (gpt-\*-codex variants), CLI syntax, sandbox modes

### 3. Cursor Agent (tools/major/cursor.md)

```text
Query: "Cursor Agent CLI changes {YEAR} new features models syntax"
Alt:   "cursor-agent CLI new version {YEAR}"
Alt:   "cursor.com/blog/cli {YEAR}"
```

**What to check:** CLI command name (cursor-agent vs agent), modes, model list

### 4. Gemini CLI (tools/major/gemini.md)

```text
Query: "Google Gemini CLI changes {YEAR} new models deprecations"
Alt:   "gemini-cli new version {YEAR} release"
Alt:   "gemini model deprecation shutdown {YEAR}"
```

**What to check:** New gemini-\* model variants, deprecation dates, CLI syntax (-p flag status)

### 5. GitHub Copilot CLI (tools/major/copilot.md)

```text
Query: "GitHub Copilot CLI changes {YEAR} new features models"
Alt:   "github.blog copilot CLI {YEAR}"
Alt:   "copilot CLI GA release {YEAR}"
```

**What to check:** GA status, model list, new features (fleet mode, autopilot), install methods

### 6. Aider (tools/major/aider.md)

```text
Query: "Aider AI coding tool changes {YEAR} new models features updates"
Alt:   "aider-ai/aider releases {YEAR}"
Alt:   "aider changelog {YEAR} new version"
```

**What to check:** Supported models/providers, CLI flags, new features (architect mode, voice)

### 7. Cline (tools/major/cline.md)

```text
Query: "Cline AI CLI tool updates {YEAR} new version features"
Alt:   "cline.bot blog {YEAR} CLI"
Alt:   "cline CLI 2.0 {YEAR} release"
```

**What to check:** CLI version (2.0+), parallel agents, headless mode, new models, install command

### 8. Continue Dev (tools/major/continue-dev.md)

```text
Query: "Continue Dev AI coding assistant updates {YEAR} new features"
Alt:   "blog.continue.dev {YEAR}"
Alt:   "continue.dev CLI headless {YEAR}"
```

**What to check:** Continuous AI pivot, headless/TUI modes, Mission Control, auth changes

### 9. Factory AI Droid (tools/major/droid.md)

```text
Query: "Factory AI Droid CLI updates {YEAR} new features models"
Alt:   "docs.factory.ai changelog {YEAR}"
Alt:   "droid CLI new version {YEAR}"
```

**What to check:** Model stack rank, CLI version, new commands (/diagnostics, mission mode)

### 10. Kiro (tools/major/kiro.md)

```text
Query: "Kiro AI IDE CLI updates {YEAR} new features headless mode"
Alt:   "kiro.dev changelog CLI {YEAR}"
Alt:   "kiro-cli new version {YEAR}"
```

**What to check:** CLI version (v1.24+), skills, agent creation, model selection, tool trust

### 11. Amazon Q Developer (tools/major/amazon-q.md)

```text
Query: "Amazon Q Developer CLI {YEAR} deprecated Kiro migration"
Alt:   "amazon q developer cli end of life {YEAR}"
```

**What to check:** Deprecation status, migration path, backward compatibility

### 12. Warp (tools/major/warp.md)

```text
Query: "Warp terminal AI updates {YEAR} new features changes"
Alt:   "warp.dev blog agents {YEAR}"
Alt:   "warp terminal changelog {YEAR}"
```

**What to check:** Agent versions, model list, new integrations, still terminal-only?

### 13. Windsurf (tools/major/windsurf.md)

```text
Query: "Windsurf IDE CLI updates {YEAR} headless mode changes"
Alt:   "windsurf.com changelog {YEAR}"
Alt:   "windsurf cascade new features {YEAR}"
```

**What to check:** Model list, Arena Mode, ownership changes, headless Docker status

### 15. Google Antigravity (tools/major/antigravity.md)

```text
Query: "Google Antigravity IDE updates {YEAR} new features models changes"
Alt:   "antigravity.google changelog {YEAR}"
Alt:   "antigravity IDE headless CLI {YEAR}"
```

**What to check:** Model list, pricing changes, headless/CLI support (currently none), rate limit changes, MCP support

### 14. OpenCode (tools/major/open-code.md)

```text
Query: "OpenCode AI CLI tool updates {YEAR} new version features"
Alt:   "opencode.ai changelog {YEAR}"
Alt:   "opencode CLI run headless {YEAR}"
```

**What to check:** CLI version, new commands (agent, attach, upgrade), model providers, skills

---

## Cross-Cutting Searches

Run these to catch changes that affect multiple tools:

```text
Query: "AI coding CLI tools comparison {YEAR}"
Query: "Claude Opus Sonnet new model release {YEAR}"
Query: "GPT Codex new model release {YEAR}"
Query: "Gemini model deprecation {YEAR}"
Query: "AI CLI tool headless mode CI/CD {YEAR}"
```

---

## Update Process

1. Replace `{YEAR}` with the current year (e.g., 2026)
2. Run each query via `mcp__Exa__web_search_exa` with `numResults: 5`
3. Compare findings against current `tools/major/*.md` content
4. For each finding, note:
   - **What changed** (new model, syntax, deprecation, feature)
   - **Source URL** for verification
   - **Specific lines** in the doc file to update
5. Present findings to reviewer for approval before editing
6. After edits, update CLAUDE.md version info and this file's "Last run" date

## Source URLs for Direct Verification

These are the most reliable primary sources for each tool:

| Tool        | Primary Source                                                            |
| ----------- | ------------------------------------------------------------------------- |
| Claude      | <https://docs.anthropic.com>, <https://claude.ai>                         |
| Codex       | <https://platform.openai.com/docs>                                        |
| Cursor      | <https://cursor.com/blog>                                                 |
| Gemini      | <https://ai.google.dev>, <https://blog.google/technology/google-deepmind> |
| Copilot     | <https://github.blog/changelog>, <https://docs.github.com/copilot>        |
| Aider       | <https://aider.chat>, <https://github.com/aider-ai/aider>                 |
| Cline       | <https://cline.bot/blog>                                                  |
| Continue    | <https://blog.continue.dev>                                               |
| Droid       | <https://docs.factory.ai>                                                 |
| Kiro        | <https://kiro.dev/changelog/cli>, <https://kiro.dev/docs/cli>             |
| Amazon Q    | <https://github.com/aws/amazon-q-developer-cli>                           |
| Warp        | <https://www.warp.dev/blog>, <https://docs.warp.dev>                      |
| Antigravity | <https://antigravity.google>, <https://antigravity.google/blog>           |
| Windsurf    | <https://windsurf.com/changelog>                                          |
| OpenCode    | <https://opencode.ai/changelog>, <https://opencode.ai/docs/cli>           |
