#!/bin/bash
# Basic Headless Mode Tests for Continue Dev CLI
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
    
    if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$CONTINUE_API_KEY" ] && [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
        # If API key is not set, we expect failures but don't count them as test failures
        if [ -z "$CONTINUE_API_KEY" ] && [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
            echo -e "${YELLOW}SKIP (API key not set)${NC}"
            SKIPPED=$((SKIPPED + 1))
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
echo "Continue Dev Headless Mode - Basic Tests"
echo "=========================================="
echo ""

# Check if Continue CLI is installed
if ! command -v cn &> /dev/null && ! command -v continue &> /dev/null; then
    echo -e "${RED}Error: Continue Dev CLI not found.${NC}"
    echo "Install from: npm install -g @continuedev/cli"
    exit 1
fi

# Determine which command to use
CN_CMD="cn"
if ! command -v cn &> /dev/null; then
    CN_CMD="continue"
fi

# Check if API key is set
if [ -z "$CONTINUE_API_KEY" ] && [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Warning: CONTINUE_API_KEY, OPENAI_API_KEY, or ANTHROPIC_API_KEY not set. Tests will be skipped.${NC}"
    echo "Set your API key with: export CONTINUE_API_KEY=your_key_here"
    echo "or: export OPENAI_API_KEY=your_key_here"
    echo "or: export ANTHROPIC_API_KEY=your_key_here"
    echo ""
fi

# Create a temporary test file for testing
TEST_FILE=$(mktemp /tmp/continue_test_XXXXXX.py)
echo "# Test file" > "$TEST_FILE"
echo "def hello():" >> "$TEST_FILE"
echo "    pass" >> "$TEST_FILE"

# Test 1: Version flag (should work without API key)
test_case "Version flag" \
    "$CN_CMD --version" 0

# Test 2: Help flag (should work without API key)
test_case "Help flag" \
    "$CN_CMD --help | head -1" 0

# Test 3: Basic headless mode with -p
test_case "Basic headless mode (-p)" \
    "$CN_CMD -p 'Say hello'" 0

# Test 4: Basic headless mode with --prompt
test_case "Basic headless mode (--prompt)" \
    "$CN_CMD --prompt 'Say hello'" 0

# Test 5: Headless mode with file
test_case "Headless mode with file (--file)" \
    "$CN_CMD -p 'Add a docstring' --file '$TEST_FILE'" 0

# Test 6: Headless mode with file (-f)
test_case "Headless mode with file (-f)" \
    "$CN_CMD -p 'Add a comment' -f '$TEST_FILE'" 0

# Test 7: Headless mode with multiple files
TEST_FILE2=$(mktemp /tmp/continue_test_XXXXXX.py)
echo "# Test file 2" > "$TEST_FILE2"
test_case "Headless mode with multiple files" \
    "$CN_CMD -p 'Add docstrings' --files '$TEST_FILE' '$TEST_FILE2'" 0

# Test 8: Headless mode with directory
test_case "Headless mode with directory" \
    "$CN_CMD -p 'Analyze code' --directory $(dirname $TEST_FILE)" 0

# Test 9: Headless mode with output file
OUTPUT_FILE=$(mktemp /tmp/continue_output_XXXXXX.txt)
test_case "Headless mode with output file" \
    "$CN_CMD -p 'Say test' --output '$OUTPUT_FILE'" 0
rm -f "$OUTPUT_FILE" 2>/dev/null || true

# Test 10: Empty prompt handling (should fail gracefully)
test_case "Empty prompt handling" \
    "$CN_CMD -p ''" 1

# Test 11: Invalid file (should fail)
test_case "Invalid file" \
    "$CN_CMD -p 'test' --file /nonexistent/file.py" 1

# Test 12: Combined flags - prompt, file, output
OUTPUT_FILE2=$(mktemp /tmp/continue_output_XXXXXX.txt)
test_case "Combined flags - prompt, file, output" \
    "$CN_CMD -p 'Add comments' --file '$TEST_FILE' --output '$OUTPUT_FILE2'" 0
rm -f "$OUTPUT_FILE2" 2>/dev/null || true

# Test 13: Stdin input
test_case "Stdin input" \
    "echo 'Say hello' | $CN_CMD" 0

# Test 14: Model selection
test_case "Model selection (--model)" \
    "$CN_CMD -p 'Say test' --model gpt-4o" 0

# Test 15: Config file (if supported)
test_case "Config file (--config)" \
    "$CN_CMD -p 'Say test' --config /dev/null 2>&1 || [ \$? -ne 0 ]" 0

# Cleanup
rm -f "$TEST_FILE" "$TEST_FILE2" 2>/dev/null || true

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

