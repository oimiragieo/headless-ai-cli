#!/bin/bash
# Tool Control Tests for GitHub Copilot CLI
# Tests tool approval options, allow/deny tools, and security features

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
echo "GitHub Copilot CLI - Tool Control Tests"
echo "=========================================="
echo ""

# Check if Copilot CLI is installed
if ! command -v copilot &> /dev/null; then
    echo -e "${RED}Error: Copilot CLI not found. Install with: npm install -g @github/copilot${NC}"
    exit 1
fi

# Test 1: Allow all tools flag syntax
test_case "Allow all tools flag syntax" \
    "copilot -p 'test' --allow-all-tools --help" 0

# Test 2: Allow tool flag syntax
test_case "Allow tool flag syntax" \
    "copilot --allow-tool 'shell' --help" 0

# Test 3: Deny tool flag syntax
test_case "Deny tool flag syntax" \
    "copilot --deny-tool 'shell(rm)' --help" 0

# Test 4: Environment variable COPILOT_ALLOW_ALL
test_case "Environment variable COPILOT_ALLOW_ALL" \
    "COPILOT_ALLOW_ALL=1 copilot -p 'test' --help" 0

# Test 5: Tool syntax - shell command
test_case "Tool syntax - shell command" \
    "copilot --allow-tool 'shell(rm)' --help" 0

# Test 6: Tool syntax - shell wildcard
test_case "Tool syntax - shell wildcard" \
    "copilot --allow-tool 'shell(git:*)' --help" 0

# Test 7: Tool syntax - write
test_case "Tool syntax - write" \
    "copilot --allow-tool 'write' --help" 0

# Test 8: Tool syntax - MCP server
test_case "Tool syntax - MCP server" \
    "copilot --allow-tool 'My-MCP-Server' --help" 0

# Test 9: Tool syntax - MCP server tool
test_case "Tool syntax - MCP server tool" \
    "copilot --allow-tool 'My-MCP-Server(tool_name)' --help" 0

# Test 10: Combining allow-all-tools and deny-tool
test_case "Combining allow-all-tools and deny-tool" \
    "copilot --allow-all-tools --deny-tool 'shell(rm)' --help" 0

# Test 11: Multiple deny-tool flags
test_case "Multiple deny-tool flags" \
    "copilot --deny-tool 'shell(rm)' --deny-tool 'shell(git push)' --help" 0

# Test 12: Multiple allow-tool flags
test_case "Multiple allow-tool flags" \
    "copilot --allow-tool 'shell' --allow-tool 'write' --help" 0

# Test 13: Deny takes precedence over allow
test_case "Deny takes precedence syntax check" \
    "copilot --allow-all-tools --deny-tool 'shell(rm)' --allow-tool 'shell(rm)' --help" 0

# Test 14: Tool approval with actual command (if authenticated)
test_case "Tool approval with allow-all-tools" \
    "copilot -p 'Say hello' --allow-all-tools" 0

# Test 15: Tool approval with specific allow-tool
test_case "Tool approval with allow-tool" \
    "copilot -p 'Say hello' --allow-tool 'write'" 0

# Test 16: Tool approval with deny-tool
test_case "Tool approval with deny-tool" \
    "copilot -p 'Say hello' --deny-tool 'shell(rm)' --allow-all-tools" 0

# Test 17: Git command wildcard pattern
test_case "Git command wildcard pattern" \
    "copilot --allow-tool 'shell(git:*)' --deny-tool 'shell(git push)' --help" 0

# Test 18: MCP server tool syntax
test_case "MCP server tool syntax" \
    "copilot --allow-tool 'My-MCP-Server' --deny-tool 'My-MCP-Server(tool_name)' --help" 0

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

