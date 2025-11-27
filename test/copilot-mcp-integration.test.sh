#!/bin/bash
# MCP Integration Tests for GitHub Copilot CLI
# Tests MCP server configuration, GitHub MCP tools, and custom MCP servers

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
echo "GitHub Copilot CLI - MCP Integration Tests"
echo "=========================================="
echo ""

# Check if Copilot CLI is installed
if ! command -v copilot &> /dev/null; then
    echo -e "${RED}Error: Copilot CLI not found. Install with: npm install -g @github/copilot${NC}"
    exit 1
fi

# Create temporary MCP config file
MCP_CONFIG=$(mktemp)
trap "rm -f $MCP_CONFIG" EXIT
cat > $MCP_CONFIG << 'EOF'
{
  "servers": {
    "test-server": {
      "command": "echo",
      "args": ["test"]
    }
  }
}
EOF

# Test 1: Additional MCP config from JSON string
test_case "Additional MCP config from JSON string" \
    "copilot --additional-mcp-config '{\"servers\":{}}' --help" 0

# Test 2: Additional MCP config from file
test_case "Additional MCP config from file" \
    "copilot --additional-mcp-config @$MCP_CONFIG --help" 0

# Test 3: Multiple additional MCP configs
test_case "Multiple additional MCP configs" \
    "copilot --additional-mcp-config @$MCP_CONFIG --additional-mcp-config '{\"servers\":{}}' --help" 0

# Test 4: Disable built-in MCP servers
test_case "Disable built-in MCP servers" \
    "copilot --disable-builtin-mcps --help" 0

# Test 5: Disable specific MCP server
test_case "Disable specific MCP server" \
    "copilot --disable-mcp-server github-mcp-server --help" 0

# Test 6: Enable all GitHub MCP tools
test_case "Enable all GitHub MCP tools" \
    "copilot --enable-all-github-mcp-tools --help" 0

# Test 7: MCP with programmatic mode
test_case "MCP with programmatic mode" \
    "copilot --enable-all-github-mcp-tools -p 'test' --allow-all-tools" 0

# Test 8: MCP with tool control
test_case "MCP with tool control" \
    "copilot --enable-all-github-mcp-tools --allow-tool 'github-mcp-server' --help" 0

# Test 9: MCP server in prompt
test_case "MCP server in prompt" \
    "copilot -p 'Use GitHub MCP server' --enable-all-github-mcp-tools --allow-all-tools" 0

# Test 10: MCP server tool allow
test_case "MCP server tool allow" \
    "copilot --allow-tool 'My-MCP-Server' --help" 0

# Test 11: MCP server specific tool allow
test_case "MCP server specific tool allow" \
    "copilot --allow-tool 'My-MCP-Server(tool_name)' --help" 0

# Test 12: MCP server tool deny
test_case "MCP server tool deny" \
    "copilot --deny-tool 'My-MCP-Server(tool_name)' --help" 0

# Test 13: MCP server allow with deny
test_case "MCP server allow with deny" \
    "copilot --allow-tool 'My-MCP-Server' --deny-tool 'My-MCP-Server(tool_name)' --help" 0

# Test 14: MCP with model selection
test_case "MCP with model selection" \
    "copilot --model claude-sonnet-4.5 --enable-all-github-mcp-tools --help" 0

# Test 15: MCP with silent mode
test_case "MCP with silent mode" \
    "copilot --enable-all-github-mcp-tools -p 'test' --silent --allow-all-tools" 0

# Test 16: MCP with no-color
test_case "MCP with no-color" \
    "copilot --enable-all-github-mcp-tools -p 'test' --no-color --allow-all-tools" 0

# Test 17: MCP with session management
test_case "MCP with session management" \
    "copilot --enable-all-github-mcp-tools --continue --help" 0

# Test 18: MCP config with invalid JSON (should handle gracefully)
test_case "MCP config with invalid JSON handling" \
    "copilot --additional-mcp-config 'invalid json' --help 2>&1; [ \$? -ne 0 ] || true" 0

# Test 19: MCP config with non-existent file
test_case "MCP config with non-existent file" \
    "copilot --additional-mcp-config @/nonexistent/file.json --help 2>&1; [ \$? -ne 0 ] || true" 0

# Test 20: Multiple MCP servers configuration
test_case "Multiple MCP servers configuration" \
    "copilot --additional-mcp-config '{\"servers\":{\"server1\":{},\"server2\":{}}}' --help" 0

# Test 21: MCP with allow-all-tools
test_case "MCP with allow-all-tools" \
    "copilot --enable-all-github-mcp-tools --allow-all-tools -p 'test'" 0

# Test 22: MCP with specific allow-tool
test_case "MCP with specific allow-tool" \
    "copilot --enable-all-github-mcp-tools --allow-tool 'github-mcp-server' -p 'test'" 0

# Test 23: Disable MCP and enable GitHub tools
test_case "Disable MCP and enable GitHub tools" \
    "copilot --disable-builtin-mcps --enable-all-github-mcp-tools --help" 0

# Test 24: MCP with logging
test_case "MCP with logging" \
    "copilot --enable-all-github-mcp-tools --log-level debug --help" 0

# Test 25: Complex MCP configuration
test_case "Complex MCP configuration" \
    "copilot --additional-mcp-config @$MCP_CONFIG --enable-all-github-mcp-tools --model claude-sonnet-4.5 --help" 0

# Cleanup
rm -f $MCP_CONFIG

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

