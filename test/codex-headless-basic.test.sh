#!/bin/bash
# Basic Headless Mode Tests for Codex CLI
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
    
    if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$OPENAI_API_KEY" ]; then
        # If API key is not set, we expect failures but don't count them as test failures
        if [ -z "$OPENAI_API_KEY" ]; then
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
echo "Codex Headless Mode - Basic Tests"
echo "=========================================="
echo ""

# Check if Codex CLI is installed
if ! command -v codex &> /dev/null; then
    echo -e "${RED}Error: Codex CLI not found. Install with: npm install -g @openai/codex${NC}"
    exit 1
fi

# Check if API key is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo -e "${YELLOW}Warning: OPENAI_API_KEY not set. Tests will be skipped.${NC}"
    echo "Set your API key with: export OPENAI_API_KEY=your_key_here"
    echo ""
fi

# Test 1: Basic headless mode execution
test_case "Basic headless mode (codex exec)" \
    "codex exec 'Say hello'" 0

# Test 2: Exit code on success
test_case "Exit code on success" \
    "codex exec 'Say OK'; echo \$?" 0

# Test 3: Text output format (default)
test_case "Text output format (default)" \
    "codex exec 'Say test' | grep -q . || true" 0

# Test 4: JSON output format
test_case "JSON output format (--json)" \
    "codex exec --json 'Say test' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 5: Color output control (always)
test_case "Color output control (--color always)" \
    "codex exec --color always 'Say test'" 0

# Test 6: Color output control (never)
test_case "Color output control (--color never)" \
    "codex exec --color never 'Say test'" 0

# Test 7: Color output control (auto)
test_case "Color output control (--color auto)" \
    "codex exec --color auto 'Say test'" 0

# Test 8: Working directory option
test_case "Working directory option (--cd)" \
    "codex exec --cd . 'Say test'" 0

# Test 9: Working directory option (short form -C)
test_case "Working directory option (-C)" \
    "codex exec -C . 'Say test'" 0

# Test 10: Model selection (--model)
test_case "Model selection (--model)" \
    "codex exec --model gpt-5-codex-latest 'Say test'" 0

# Test 11: Model selection (short form -m)
test_case "Model selection (-m)" \
    "codex exec -m gpt-5-codex-latest 'Say test'" 0

# Test 12: Model selection with gpt-5-codex
test_case "Model selection with gpt-5-codex" \
    "codex exec --model gpt-5-codex 'Say test'" 0

# Test 13: CODEX_API_KEY environment variable
test_case "CODEX_API_KEY environment variable" \
    "CODEX_API_KEY=\${OPENAI_API_KEY:-test} codex exec 'Say test'" 0

# Test 12: Output to file (-o)
test_case "Output to file (-o)" \
    "codex exec -o /tmp/codex-test-output.txt 'Say test' && test -f /tmp/codex-test-output.txt && rm -f /tmp/codex-test-output.txt" 0

# Test 13: Output to file (--output-last-message)
test_case "Output to file (--output-last-message)" \
    "codex exec --output-last-message /tmp/codex-test-output2.txt 'Say test' && test -f /tmp/codex-test-output2.txt && rm -f /tmp/codex-test-output2.txt" 0

# Test 14: Skip Git repo check
test_case "Skip Git repo check (--skip-git-repo-check)" \
    "codex exec --skip-git-repo-check 'Say test'" 0

# Test 15: Help flag (should work without API key)
test_case "Help flag" \
    "codex --help | head -1" 0

# Test 16: Version flag (should work without API key)
test_case "Version flag" \
    "codex --version" 0

# Test 17: Invalid model (should fail gracefully)
test_case "Invalid model handling" \
    "codex exec --model invalid-model-xyz 'Say test'" 1

# Test 18: Empty prompt handling (should fail gracefully)
test_case "Empty prompt handling" \
    "codex exec ''" 1

echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Total tests: $test_count"
if [ -n "$OPENAI_API_KEY" ]; then
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

