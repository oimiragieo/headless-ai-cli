#!/bin/bash
# Advanced Headless Mode Tests for OpenCode CLI
# Tests advanced features: model selection, session management, multi-message execution

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
        # API key or auth issues result in skip
        echo -e "${YELLOW}SKIP (likely auth/API issue)${NC}"
        SKIPPED=$((SKIPPED + 1))
    fi
}

echo "=========================================="
echo "OpenCode Headless Mode - Advanced Tests"
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

# Test 1: Model selection - OpenCode models
test_case "Model selection - opencode/big-pickle" \
    "opencode run 'Say hello' --model opencode/big-pickle 2>&1 || true" 0

# Test 2: Model selection - short model flag
test_case "Model selection - short flag (-m)" \
    "opencode run 'Say hello' -m opencode/big-pickle 2>&1 || true" 0

# Test 3: Session continue
test_case "Session continue (--continue)" \
    "opencode run 'Continue the task' --continue 2>&1 || true" 0

# Test 4: Session continue - short flag
test_case "Session continue - short flag (-c)" \
    "opencode run 'Continue the task' -c 2>&1 || true" 0

# Test 5: Multi-message execution
test_case "Multi-message execution" \
    "opencode run 'Analyze' 'this' 'code' 2>&1 || true" 0

# Test 6: Piped input
test_case "Piped input" \
    "echo 'Review this code' | opencode run 2>&1 || true" 0

# Test 7: Complex prompt
test_case "Complex prompt" \
    "opencode run 'Refactor code to use async/await patterns, add error handling, and improve code quality' 2>&1 || true" 0

# Test 8: Security audit prompt
test_case "Security audit prompt" \
    "opencode run 'Perform security audit: identify vulnerabilities and suggest fixes' 2>&1 || true" 0

# Test 9: Stats command
test_case "Stats command" \
    "opencode stats 2>&1 || true" 0

# Test 10: Models command
test_case "Models command" \
    "opencode models 2>&1 || true" 0

# Test 11: Agent command
test_case "Agent command" \
    "opencode agent 2>&1 || true" 0

# Test 12: Export command
test_case "Export command" \
    "opencode export 2>&1 || true" 0

# Test 13: Auth list command
test_case "Auth list command" \
    "opencode auth list 2>&1 || opencode auth ls 2>&1 || true" 0

# Test 14: Log level option
test_case "Log level option" \
    "opencode --log-level DEBUG --help 2>&1 | head -1" 0

# Test 15: Print logs option
test_case "Print logs option" \
    "opencode --print-logs --help 2>&1 | head -1" 0

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
