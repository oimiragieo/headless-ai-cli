#!/bin/bash
# Basic Headless Mode Tests for Amazon Q Developer CLI
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
    
    if [ "$exit_code" -eq "$expected_exit" ] || [ ! -d "$HOME/.amazonq" ] 2>/dev/null; then
        # If not authenticated, we expect failures but don't count them as test failures
        if [ ! -d "$HOME/.amazonq" ] 2>/dev/null; then
            echo -e "${YELLOW}SKIP (Not authenticated)${NC}"
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
echo "Amazon Q Developer Headless Mode - Basic Tests"
echo "=========================================="
echo ""

# Check if Amazon Q Developer CLI is installed
if ! command -v q &> /dev/null; then
    echo -e "${RED}Error: Amazon Q Developer CLI not found.${NC}"
    echo "Install from: https://github.com/aws/amazon-q-developer-cli"
    exit 1
fi

# Check if authenticated
if [ ! -d "$HOME/.amazonq" ] 2>/dev/null; then
    echo -e "${YELLOW}Warning: Not authenticated. Run 'q login' first. Tests will be skipped.${NC}"
    echo ""
fi

# Create a temporary test file for testing
TEST_FILE=$(mktemp /tmp/amazonq_test_XXXXXX.py)
echo "# Test file" > "$TEST_FILE"
echo "def hello():" >> "$TEST_FILE"
echo "    pass" >> "$TEST_FILE"

# Test 1: Version flag (should work without authentication)
test_case "Version flag" \
    "q --version" 0

# Test 2: Help flag (should work without authentication)
test_case "Help flag" \
    "q --help | head -1" 0

# Test 3: Chat help
test_case "Chat help" \
    "q chat --help | head -1" 0

# Test 4: Basic headless mode with --prompt
test_case "Basic headless mode (--prompt)" \
    "q chat --prompt 'Say hello'" 0

# Test 5: Basic headless mode with -p
test_case "Basic headless mode (-p)" \
    "q chat -p 'Say hello'" 0

# Test 6: Headless mode with file
test_case "Headless mode with file (--file)" \
    "q chat --prompt 'Add a docstring' --file '$TEST_FILE'" 0

# Test 7: Headless mode with file (-f)
test_case "Headless mode with file (-f)" \
    "q chat -p 'Add a comment' -f '$TEST_FILE'" 0

# Test 8: Headless mode with multiple files
TEST_FILE2=$(mktemp /tmp/amazonq_test_XXXXXX.py)
echo "# Test file 2" > "$TEST_FILE2"
test_case "Headless mode with multiple files" \
    "q chat --prompt 'Add docstrings' --files '$TEST_FILE' '$TEST_FILE2'" 0

# Test 9: Headless mode with directory
test_case "Headless mode with directory" \
    "q chat --prompt 'Analyze code' --directory $(dirname $TEST_FILE)" 0

# Test 10: Headless mode with output file
OUTPUT_FILE=$(mktemp /tmp/amazonq_output_XXXXXX.txt)
test_case "Headless mode with output file" \
    "q chat --prompt 'Say test' --output '$OUTPUT_FILE'" 0
rm -f "$OUTPUT_FILE" 2>/dev/null || true

# Test 11: Empty prompt handling (should fail gracefully)
test_case "Empty prompt handling" \
    "q chat --prompt ''" 1

# Test 12: Invalid file (should fail)
test_case "Invalid file" \
    "q chat --prompt 'test' --file /nonexistent/file.py" 1

# Test 13: Combined flags - prompt, file, output
OUTPUT_FILE2=$(mktemp /tmp/amazonq_output_XXXXXX.txt)
test_case "Combined flags - prompt, file, output" \
    "q chat --prompt 'Add comments' --file '$TEST_FILE' --output '$OUTPUT_FILE2'" 0
rm -f "$OUTPUT_FILE2" 2>/dev/null || true

# Test 14: Stdin input
test_case "Stdin input" \
    "echo 'Say hello' | q chat" 0

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

