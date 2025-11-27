# Contributing to AI CLI Reference Repository

Thank you for your interest in contributing to the AI CLI Reference Repository! This document provides guidelines for adding new tools, updating existing documentation, and maintaining consistency across the repository.

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Adding New Tools](#adding-new-tools)
- [Updating Existing Documentation](#updating-existing-documentation)
- [Documentation Standards](#documentation-standards)
- [Tool Categorization](#tool-categorization)
- [Testing and Verification](#testing-and-verification)
- [Pull Request Process](#pull-request-process)

## Getting Started

1. **Fork the repository**
2. **Clone your fork:**
   ```bash
   git clone https://github.com/your-username/headless-ai-cli.git
   cd headless-ai-cli
   ```
3. **Create a branch:**
   ```bash
   git checkout -b add-new-tool-name
   ```

## Adding New Tools

### Step 1: Research the Tool

Before adding a new tool, verify:
- ✅ Tool exists and is actively maintained
- ✅ Tool has CLI/headless capabilities
- ✅ Official documentation is available
- ✅ Installation instructions are clear
- ✅ Tool supports headless mode or automation

### Step 2: Choose the Right Category

**Major Tools** (`tools/major/`):
- Production-ready tools
- Widely adopted
- Comprehensive documentation
- Active development

**Emerging Tools** (`tools/emerging/`):
- Newer tools
- Growing adoption
- Promising features
- Active development

**Specialized Tools** (`tools/specialized/`):
- Niche use cases
- Specialized functionality
- Limited but focused scope

### Step 3: Create Documentation File

Use the template from `tools/TEMPLATE.md`:

1. Copy the template:
   ```bash
   cp tools/TEMPLATE.md tools/[category]/tool-name.md
   ```

2. Fill in all sections:
   - Overview
   - Installation
   - Headless Mode
   - Available Models
   - CLI Syntax
   - Configuration
   - Examples
   - Limitations
   - References

3. Follow the documentation standards below

### Step 4: Update Main Documentation

Update these files to include the new tool:

- **README.md**: Add to tool list and comparison tables
- **claude.md**: Add to executive summary and full section
- **simple.md**: Add to quick reference tables
- **gpt-5.1.md**: Add to executive summary (if applicable)

## Updating Existing Documentation

When updating existing tool documentation:

1. **Verify information is current:**
   - Check official documentation
   - Verify installation commands
   - Confirm model availability
   - Test CLI syntax (if possible)

2. **Update version information:**
   - Update "Version tested" field
   - Note any breaking changes
   - Update installation commands if changed

3. **Add new features:**
   - Document new CLI options
   - Add new model support
   - Include new use cases

4. **Fix errors:**
   - Correct typos
   - Fix broken links
   - Update outdated information

## Documentation Standards

### File Structure

Each tool documentation file should include:

```markdown
# Tool Name

**Version tested:** Latest (check with `tool --version`)
**Risk level:** [🟢 Low / 🟠 Medium / ⚠️ High / ⚡ Very High]

**When NOT to use [Tool]:**
- ❌ Reason 1
- ❌ Reason 2

### Quick Nav
- [Start Here](#-start-here)
- [Why Use Tool](#-why-use-tool)
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
[Description]

## Installation
[Instructions]

## 🚀 Start Here
[Quick start example]

## Headless Mode
[Headless usage details]

## Available Models
[Model table]

## CLI Syntax
[Command structure]

## Configuration
[Config options]

## Examples
[Usage examples]

## Limitations
[Known limitations]

## References
[Official links]
```

### Writing Guidelines

1. **Be Clear and Concise:**
   - Use simple language
   - Avoid jargon when possible
   - Provide concrete examples

2. **Be Accurate:**
   - Verify all commands
   - Test examples when possible
   - Cite official sources

3. **Be Consistent:**
   - Follow existing format
   - Use consistent terminology
   - Match style of other tools

4. **Be Complete:**
   - Include all required sections
   - Provide installation for all platforms
   - Include multiple examples

### Code Examples

- Use proper syntax highlighting
- Include comments for clarity
- Show both simple and advanced examples
- Include error handling when relevant

```bash
# Good example
gemini -p "Review this code" --output-format json | jq '.response'

# Bad example (too simple, no context)
gemini -p "query"
```

## Tool Categorization

### Major Tools Criteria

- ✅ Production-ready and stable
- ✅ Active maintenance and updates
- ✅ Comprehensive documentation
- ✅ Wide adoption
- ✅ Multiple use cases

### Emerging Tools Criteria

- ✅ New or growing tool
- ✅ Promising features
- ✅ Active development
- ✅ Some documentation available
- ✅ Potential for wider adoption

### Specialized Tools Criteria

- ✅ Focused on specific use case
- ✅ May have limited scope
- ✅ Useful for niche scenarios
- ✅ Well-maintained despite specialization

## Testing and Verification

Before submitting:

1. **Verify Installation:**
   - Test installation commands
   - Verify on multiple platforms if possible
   - Check for dependencies

2. **Test Examples:**
   - Run example commands
   - Verify output format
   - Check for errors

3. **Check Links:**
   - Verify all URLs work
   - Check GitHub repositories exist
   - Confirm documentation links

4. **Review Content:**
   - Check for typos
   - Verify formatting
   - Ensure consistency

## Pull Request Process

1. **Create a descriptive PR:**
   - Clear title
   - Detailed description
   - List of changes
   - Screenshots (if applicable)

2. **Follow the checklist:**
   - [ ] Documentation follows template
   - [ ] All sections completed
   - [ ] Examples tested
   - [ ] Links verified
   - [ ] Main docs updated
   - [ ] No typos or errors

3. **Respond to feedback:**
   - Address review comments
   - Make requested changes
   - Update PR as needed

## Version Tracking

When tools are updated:

1. **Update version information:**
   - Change "Version tested" field
   - Note version in examples if relevant
   - Update installation commands

2. **Document breaking changes:**
   - Note in "Limitations" section
   - Update examples if syntax changed
   - Add migration notes if needed

3. **Update comparison tables:**
   - Update feature comparisons
   - Adjust risk levels if changed
   - Update model availability

## Questions?

If you have questions about contributing:

1. Check existing documentation
2. Review similar tools for examples
3. Open an issue for discussion
4. Ask in PR comments

## Thank You!

Your contributions help make this repository a valuable resource for developers working with AI CLI tools. We appreciate your time and effort!

