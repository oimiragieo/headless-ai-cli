#!/bin/bash
# GitHub Copilot CLI Headless Mode Workflows
# Demonstrates various programmatic mode patterns for automation

# Windows/WSL detection: If on Windows and not in WSL, re-run via WSL
# Check if we're on Windows (not in WSL)
if [[ (-n "$WINDIR" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32") && -z "$WSL_DISTRO_NAME" && -z "$WSL_INTEROP" ]]; then
    if command -v wsl &> /dev/null; then
        # Convert Windows path to WSL path format
        SCRIPT_PATH="$0"
        if [[ "$SCRIPT_PATH" =~ ^[A-Za-z]: ]]; then
            # Windows absolute path - convert to WSL path
            SCRIPT_PATH=$(wslpath -a "$SCRIPT_PATH" 2>/dev/null || echo "$SCRIPT_PATH")
        fi
        # Re-execute via WSL
        exec wsl bash "$SCRIPT_PATH" "$@"
    else
        echo "Error: This script requires WSL (Windows Subsystem for Linux) on Windows."
        echo "Please install WSL or run this script from within WSL."
        exit 1
    fi
fi

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Copilot CLI is installed
if ! command -v copilot &> /dev/null; then
    echo -e "${RED}Error: Copilot CLI not found. Install with: npm install -g @github/copilot${NC}"
    exit 1
fi

# Check if user is authenticated
if ! copilot --version &> /dev/null; then
    echo -e "${YELLOW}Warning: Copilot CLI may not be authenticated. Some operations may fail.${NC}"
    echo "Authenticate with GitHub Copilot to run full examples."
fi

echo -e "${GREEN}=== GitHub Copilot CLI Headless Mode Workflows ===${NC}\n"

# Example 1: Basic programmatic execution
echo -e "${YELLOW}Example 1: Basic Programmatic Execution${NC}"
echo "Command: copilot -p 'Explain what programmatic mode means' --allow-all-tools"
copilot -p "Explain what programmatic mode means in one sentence" --allow-all-tools || echo "Command failed (authentication may be required)"
echo ""

# Example 2: Silent mode for scripting
echo -e "${YELLOW}Example 2: Silent Mode for Scripting${NC}"
echo "Command: copilot -p 'Say hello' --silent --allow-all-tools"
RESULT=$(copilot -p "Say hello" --silent --allow-all-tools 2>/dev/null || echo "Command failed")
echo "Result: $RESULT"
echo ""

# Example 3: CI/CD friendly output
echo -e "${YELLOW}Example 3: CI/CD Friendly Output${NC}"
echo "Command: copilot -p 'Say test' --no-color --silent --allow-all-tools"
copilot -p "Say test" --no-color --silent --allow-all-tools || echo "Command failed"
echo ""

# Example 4: Session management
echo -e "${YELLOW}Example 4: Session Management${NC}"
echo "Resuming most recent session..."
copilot --continue --allow-all-tools -p "Continue from previous session" || echo "No previous session found or authentication required"
echo ""

# Example 5: Model selection
echo -e "${YELLOW}Example 5: Model Selection${NC}"
echo "Command with specific model:"
copilot --model claude-sonnet-4.5 -p "Say hello" --allow-all-tools || echo "Command failed"
echo ""

# Example 6: Tool control - allow specific tools
echo -e "${YELLOW}Example 6: Tool Control - Allow Specific Tools${NC}"
echo "Command with allow-tool:"
copilot -p "List files in current directory" \
    --allow-tool 'shell(ls)' \
    --allow-all-tools || echo "Command failed"
echo ""

# Example 7: Tool control - deny specific tools
echo -e "${YELLOW}Example 7: Tool Control - Deny Specific Tools${NC}"
echo "Command with deny-tool:"
copilot -p "Clean up temporary files" \
    --allow-all-tools \
    --deny-tool 'shell(rm)' || echo "Command failed"
echo ""

# Example 8: Code review automation
echo -e "${YELLOW}Example 8: Code Review Automation${NC}"
echo "Command: copilot -p 'Review the recent code changes' --allow-all-tools"
copilot -p "Review the recent code changes and provide feedback" --allow-all-tools || echo "Command failed"
echo ""

# Example 9: PR management
echo -e "${YELLOW}Example 9: PR Management${NC}"
echo "Command: copilot -p 'List my open PRs'"
copilot -p "List my open PRs" --allow-all-tools || echo "Command failed"
echo ""

# Example 10: GitHub Actions workflow creation
echo -e "${YELLOW}Example 10: GitHub Actions Workflow${NC}"
echo "Command: copilot -p 'List Actions workflows in this repo'"
copilot -p "List any Actions workflows in this repo" --allow-all-tools || echo "Command failed"
echo ""

# Example 11: MCP server usage
echo -e "${YELLOW}Example 11: MCP Server Usage${NC}"
echo "Command: copilot -p 'Use GitHub MCP server to find issues'"
copilot -p "Use the GitHub MCP server to find good first issues" --allow-all-tools || echo "Command failed"
echo ""

# Example 12: Directory access
echo -e "${YELLOW}Example 12: Directory Access${NC}"
echo "Command: copilot --add-dir /tmp -p 'Analyze files'"
copilot --add-dir /tmp -p "Analyze files in /tmp" --allow-all-tools || echo "Command failed"
echo ""

# Example 13: Environment variable usage
echo -e "${YELLOW}Example 13: Environment Variable Usage${NC}"
echo "Command: COPILOT_ALLOW_ALL=1 copilot -p 'Say test'"
COPILOT_ALLOW_ALL=1 copilot -p "Say test" || echo "Command failed"
echo ""

# Example 14: Error handling in automation
echo -e "${YELLOW}Example 14: Error Handling${NC}"
echo "Testing error handling with invalid input:"
if copilot -p "" --allow-all-tools 2>/dev/null; then
    echo "Command succeeded"
else
    echo "Command failed as expected (empty prompt)"
fi
echo ""

# Example 15: Batch processing pattern
echo -e "${YELLOW}Example 15: Batch Processing Pattern${NC}"
echo "Processing multiple prompts:"
for prompt in "Say hello" "Say world" "Say test"; do
    echo "Processing: $prompt"
    copilot -p "$prompt" --silent --allow-all-tools || echo "Failed: $prompt"
done
echo ""

# Example 16: Output redirection for artifacts
echo -e "${YELLOW}Example 16: Output Redirection${NC}"
echo "Command: copilot -p 'Generate report' --allow-all-tools > report.txt"
copilot -p "Generate a brief report" --allow-all-tools > /tmp/copilot-report.txt 2>&1 || echo "Command failed"
if [ -f /tmp/copilot-report.txt ]; then
    echo "Report saved to /tmp/copilot-report.txt"
    head -3 /tmp/copilot-report.txt
    rm -f /tmp/copilot-report.txt
fi
echo ""

# Example 17: Logging configuration
echo -e "${YELLOW}Example 17: Logging Configuration${NC}"
echo "Command: copilot --log-level error -p 'Test logging'"
copilot --log-level error -p "Test logging" --allow-all-tools || echo "Command failed"
echo ""

# Example 18: Multi-flag combination
echo -e "${YELLOW}Example 18: Multi-Flag Combination${NC}"
echo "Command: copilot --model claude-haiku-4.5 --no-color --silent -p 'Test'"
copilot --model claude-haiku-4.5 --no-color --silent -p "Test multi-flag combination" --allow-all-tools || echo "Command failed"
echo ""

echo -e "${GREEN}=== Workflows Complete ===${NC}"
echo ""
echo "Note: Some examples may fail if GitHub Copilot CLI is not authenticated."
echo "Authenticate with GitHub Copilot to run full examples."

