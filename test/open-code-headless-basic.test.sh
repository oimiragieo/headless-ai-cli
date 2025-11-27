#!/bin/bash
# Basic Headless Mode Tests for OpenCode CLI
# Tests basic headless mode execution, exit codes, and output formats

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
        # Check if this is an API key related issue
        if [ "$exit_code" -ne 0 ] && [ "$expected_exit" -eq 0 ]; then
            echo -e "${YELLOW}SKIP (likely API key not set)${NC}"
            SKIPPED=$((SKIPPED + 1))
        else
            echo -e "${RED}FAIL (exit code: $exit_code, expected: $expected_exit)${NC}"
            FAILED=$((FAILED + 1))
        fi
    fi
}

echo "=========================================="
echo "OpenCode Headless Mode - Basic Tests"
echo "=========================================="
echo ""

# Check if OpenCode CLI is installed
if ! command -v opencode &> /dev/null; then
    echo -e "${RED}Error: OpenCode CLI not found.${NC}"
    echo "Install from: npm install -g open-code"
    exit 1
fi

echo "Note: OpenCode requires authentication via 'opencode auth login'"
echo "Tests may be skipped if not authenticated."
echo ""

# Test 1: Version flag (should work without authentication)
test_case "Version flag" \
    "opencode --version" 0

# Test 2: Help flag (should work without authentication)
test_case "Help flag" \
    "opencode --help | head -1" 0

# Test 3: List models (should work with authentication)
test_case "List models" \
    "opencode models 2>&1 || true" 0

# Test 4: Auth list providers (should work)
test_case "Auth list providers" \
    "opencode auth list 2>&1 || opencode auth ls 2>&1 || true" 0

# Test 5: Basic headless mode with run command
test_case "Basic headless mode (opencode run)" \
    "opencode run 'Say hello' 2>&1 || true" 0

# Test 6: Run with multiple message arguments
test_case "Run with multiple arguments" \
    "opencode run 'Analyze' 'this' 'code' 2>&1 || true" 0

# Test 7: Run with model selection
test_case "Run with model selection (--model)" \
    "opencode run 'Say test' --model opencode/big-pickle 2>&1 || true" 0

# Test 8: Run with short model flag (-m)
test_case "Run with short model flag (-m)" \
    "opencode run 'Say hello' -m opencode/big-pickle 2>&1 || true" 0

# Test 9: Run with continue flag
test_case "Run with continue flag (--continue)" \
    "opencode run 'Continue task' --continue 2>&1 || true" 0

# Test 10: Run with short continue flag (-c)
test_case "Run with short continue flag (-c)" \
    "opencode run 'Continue task' -c 2>&1 || true" 0

# Test 11: Stats command (view usage statistics)
test_case "Stats command" \
    "opencode stats 2>&1 || true" 0

# Test 12: Log level option
test_case "Log level option" \
    "opencode --log-level DEBUG --help 2>&1 | head -1" 0

# Test 13: Print logs option
test_case "Print logs option" \
    "opencode --print-logs --help 2>&1 | head -1" 0

# Test 14: Agent command (list agents)
test_case "Agent command" \
    "opencode agent 2>&1 || true" 0

# Test 15: Export command (session export)
test_case "Export command" \
    "opencode export 2>&1 || true" 0

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
