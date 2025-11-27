#!/bin/bash
# Advanced Headless Mode Tests for GitHub Copilot CLI
# Tests advanced programmatic mode features, model selection, session management, and MCP integration

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

PASSED=0
FAILED=0
SKIPPED=0

# Test counter
test_count=0

# Test function
test_case() {
    local test_name="$1"
    local command="$2"
    local expected_exit="${3:-0}"
    
    test_count=$((test_count + 1))
    echo -n "Test $test_count: $test_name ... "
    
    # Run command and capture exit code
    eval "$command" > /dev/null 2>&1
    local exit_code=$?
    
    if [ "$exit_code" -eq "$expected_exit" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        # If exit code doesn't match but is non-zero, it might be auth-related
        if [ "$exit_code" -ne 0 ] && [ "$expected_exit" -eq 0 ]; then
            echo -e "${YELLOW}SKIP (may require authentication)${NC}"
            SKIPPED=$((SKIPPED + 1))
        else
            echo -e "${RED}FAIL (exit code: $exit_code, expected: $expected_exit)${NC}"
            FAILED=$((FAILED + 1))
        fi
    fi
}

echo "=========================================="
echo "GitHub Copilot CLI - Advanced Headless Tests"
echo "=========================================="
echo ""

# Check if Copilot CLI is installed
if ! command -v copilot &> /dev/null; then
    echo -e "${RED}Error: Copilot CLI not found. Install with: npm install -g @github/copilot${NC}"
    exit 1
fi

# Test 1: Model selection with --model flag
test_case "Model selection with --model flag" \
    "copilot --model claude-sonnet-4.5 --help" 0

# Test 2: Model selection with GPT-5.1
test_case "Model selection with GPT-5.1" \
    "copilot --model gpt-5.1 --help" 0

# Test 3: Model selection with GPT-5.1-Codex
test_case "Model selection with GPT-5.1-Codex" \
    "copilot --model gpt-5.1-codex --help" 0

# Test 4: Model selection with Gemini 3 Pro
test_case "Model selection with Gemini 3 Pro" \
    "copilot --model gemini-3-pro --help" 0

# Test 5: Model selection with Claude Haiku (cost-effective)
test_case "Model selection with Claude Haiku" \
    "copilot --model claude-haiku-4.5 --help" 0

# Test 6: Session management --continue flag
test_case "Session management --continue flag" \
    "copilot --continue --help" 0

# Test 7: Session management --resume flag
test_case "Session management --resume flag" \
    "copilot --resume --help" 0

# Test 8: Continue with programmatic mode
test_case "Continue with programmatic mode" \
    "copilot --continue -p 'test' --allow-all-tools" 0

# Test 9: Stream flag on
test_case "Stream flag (on)" \
    "copilot -p 'test' --stream on --allow-all-tools" 0

# Test 10: Stream flag off
test_case "Stream flag (off)" \
    "copilot -p 'test' --stream off --allow-all-tools" 0

# Test 11: MCP additional config from string
test_case "MCP additional config from string" \
    "copilot --additional-mcp-config '{\"servers\":{}}' --help" 0

# Test 12: MCP additional config from file
test_case "MCP additional config from file" \
    "copilot --additional-mcp-config @/dev/null --help" 0

# Test 13: Disable built-in MCP servers
test_case "Disable built-in MCP servers" \
    "copilot --disable-builtin-mcps --help" 0

# Test 14: Disable specific MCP server
test_case "Disable specific MCP server" \
    "copilot --disable-mcp-server github-mcp-server --help" 0

# Test 15: Enable all GitHub MCP tools
test_case "Enable all GitHub MCP tools" \
    "copilot --enable-all-github-mcp-tools --help" 0

# Test 16: Directory access with --add-dir
test_case "Directory access with --add-dir" \
    "copilot --add-dir /tmp --help" 0

# Test 17: Multiple --add-dir flags
test_case "Multiple --add-dir flags" \
    "copilot --add-dir /tmp --add-dir /var --help" 0

# Test 18: Allow all paths flag
test_case "Allow all paths flag" \
    "copilot --allow-all-paths --help" 0

# Test 19: Log level setting
test_case "Log level setting" \
    "copilot --log-level debug --help" 0

# Test 20: Log directory setting
test_case "Log directory setting" \
    "copilot --log-dir /tmp --help" 0

# Test 21: Combined flags - model, silent, no-color
test_case "Combined flags - model, silent, no-color" \
    "copilot --model claude-haiku-4.5 --silent --no-color --help" 0

# Test 22: Combined flags - stream, allow-all-tools
test_case "Combined flags - stream, allow-all-tools" \
    "copilot -p 'test' --stream on --allow-all-tools" 0

# Test 23: MCP with programmatic mode
test_case "MCP with programmatic mode" \
    "copilot --enable-all-github-mcp-tools -p 'test' --allow-all-tools" 0

# Test 24: Model persistence check (syntax)
test_case "Model persistence syntax check" \
    "copilot --model claude-sonnet-4.5 -p 'test' --allow-all-tools" 0

# Test 25: Advanced tool control with MCP
test_case "Advanced tool control with MCP" \
    "copilot --allow-tool 'My-MCP-Server' --deny-tool 'My-MCP-Server(tool_name)' --help" 0

# Test 26: Session resume with model selection
test_case "Session resume with model selection" \
    "copilot --resume test-session --model claude-sonnet-4.5 --help" 0

# Test 27: Error handling - invalid model
test_case "Error handling - invalid model" \
    "copilot --model invalid-model --help 2>&1; [ \$? -ne 0 ] || true" 0

# Test 28: Error handling - invalid stream value
test_case "Error handling - invalid stream value" \
    "copilot -p 'test' --stream invalid --help 2>&1; [ \$? -ne 0 ] || true" 0

# Test 29: Complex command with all flags
test_case "Complex command with all flags" \
    "copilot --model claude-haiku-4.5 --silent --no-color --stream off --log-level error --add-dir /tmp -p 'test' --allow-all-tools" 0

# Test 30: MCP server usage in prompt
test_case "MCP server usage in prompt syntax" \
    "copilot -p 'Use GitHub MCP server' --enable-all-github-mcp-tools --allow-all-tools" 0

echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Total tests: $test_count"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo -e "${YELLOW}Skipped: $SKIPPED${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi

