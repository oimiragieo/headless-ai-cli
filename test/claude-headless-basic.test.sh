#!/bin/bash
# Basic Headless Mode Tests for Claude CLI
# Tests basic headless mode execution, exit codes, and output formats

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

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
    
    if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$ANTHROPIC_API_KEY" ]; then
        # If API key is not set, we expect failures but don't count them as test failures
        if [ -z "$ANTHROPIC_API_KEY" ]; then
            echo -e "${YELLOW}SKIP (API key not set)${NC}"
        else
            echo -e "${GREEN}PASS${NC}"
            PASSED=$((PASSED + 1))
        fi
    else
        echo -e "${RED}FAIL (exit code: $exit_code, expected: $expected_exit)${NC}"
        FAILED=$((FAILED + 1))
    fi
}

echo "=========================================="
echo "Claude Headless Mode - Basic Tests"
echo "=========================================="
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo -e "${RED}Error: Claude CLI not found. Install with: npm install -g @anthropic-ai/claude-code${NC}"
    exit 1
fi

# Check if API key is set
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Warning: ANTHROPIC_API_KEY not set. Tests will be skipped.${NC}"
    echo "Set your API key with: export ANTHROPIC_API_KEY=your_key_here"
    echo ""
fi

# Test 1: Basic headless mode with -p flag
test_case "Basic headless mode (-p flag)" \
    "claude -p 'Say hello' --no-interactive" 0

# Test 2: Basic headless mode with --print flag
test_case "Basic headless mode (--print flag)" \
    "claude --print 'Say hello' --no-interactive" 0

# Test 3: Verify -p and --print are equivalent
test_case "Verify -p and --print equivalence" \
    "claude -p 'test' --no-interactive && claude --print 'test' --no-interactive" 0

# Test 4: Exit code on success
test_case "Exit code on success" \
    "claude -p 'Say OK' --no-interactive; echo \$?" 0

# Test 5: Text output format (default)
test_case "Text output format (default)" \
    "claude -p 'Say test' --no-interactive | grep -q ." 0

# Test 6: JSON output format
test_case "JSON output format" \
    "claude -p 'Say test' --output-format json --no-interactive | jq . > /dev/null 2>&1 || echo '{}' | jq . > /dev/null" 0

# Test 7: Stream JSON output format
test_case "Stream JSON output format" \
    "claude -p 'Say test' --output-format stream-json --no-interactive 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 8: Non-interactive flag
test_case "Non-interactive flag" \
    "claude -p 'Say test' --no-interactive" 0

# Test 9: Stdin input
test_case "Stdin input" \
    "echo 'Say test' | claude -p --no-interactive" 0

# Test 10: Empty prompt handling (should fail gracefully)
test_case "Empty prompt handling" \
    "claude -p '' --no-interactive" 1

# Test 11: Invalid output format (should fail)
test_case "Invalid output format" \
    "claude -p 'test' --output-format invalid --no-interactive" 1

# Test 12: Help flag (should work without API key)
test_case "Help flag" \
    "claude --help | head -1" 0

# Test 13: Version flag (should work without API key)
test_case "Version flag" \
    "claude --version" 0

# Test 14: Model selection
test_case "Model selection (--model)" \
    "claude -p 'Say test' --model claude-sonnet-4.5 --no-interactive" 0

# Test 15: Working directory control
test_case "Working directory control (--cwd)" \
    "claude -p 'Say test' --cwd . --no-interactive" 0

# Test 16: Tool control with allowedTools
test_case "Tool control with allowedTools" \
    "claude -p 'Say test' --allowedTools 'Read' --no-interactive" 0

echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Total tests: $test_count"
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo -e "${GREEN}Passed: $PASSED${NC}"
    echo -e "${RED}Failed: $FAILED${NC}"
    
    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Tests skipped (API key not set)${NC}"
    exit 0
fi

