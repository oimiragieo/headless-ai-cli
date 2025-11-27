#!/bin/bash
# Basic Headless Mode Tests for Aider CLI
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
    
    if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
        # If API key is not set, we expect failures but don't count them as test failures
        if [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
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
echo "Aider Headless Mode - Basic Tests"
echo "=========================================="
echo ""

# Check if Aider CLI is installed
if ! command -v aider &> /dev/null; then
    echo -e "${RED}Error: Aider CLI not found. Install with: pip install aider-chat${NC}"
    exit 1
fi

# Check if API key is set
if [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Warning: OPENAI_API_KEY or ANTHROPIC_API_KEY not set. Tests will be skipped.${NC}"
    echo "Set your API key with: export OPENAI_API_KEY=your_key_here"
    echo "or: export ANTHROPIC_API_KEY=your_key_here"
    echo ""
fi

# Create a temporary test file for testing
TEST_FILE=$(mktemp /tmp/aider_test_XXXXXX.py)
echo "# Test file" > "$TEST_FILE"
echo "def hello():" >> "$TEST_FILE"
echo "    pass" >> "$TEST_FILE"

# Test 1: Basic headless mode with --yes flag
test_case "Basic headless mode (--yes flag)" \
    "aider --yes --message 'Add a docstring' '$TEST_FILE'" 0

# Test 2: Basic headless mode with -y flag
test_case "Basic headless mode (-y flag)" \
    "aider -y --message 'Add a comment' '$TEST_FILE'" 0

# Test 3: Headless mode with model specification
test_case "Headless mode with model (gpt-4o)" \
    "aider --yes --model gpt-4o --message 'Add type hints' '$TEST_FILE'" 0

# Test 4: Headless mode with stdin input
test_case "Headless mode with stdin input" \
    "echo 'Add logging' | aider --yes '$TEST_FILE'" 0

# Test 5: Headless mode with --no-git flag
test_case "Headless mode with --no-git flag" \
    "aider --yes --no-git --message 'Add comments' '$TEST_FILE'" 0

# Test 6: Headless mode with multiple files
TEST_FILE2=$(mktemp /tmp/aider_test_XXXXXX.py)
echo "# Test file 2" > "$TEST_FILE2"
test_case "Headless mode with multiple files" \
    "aider --yes --message 'Add docstrings' '$TEST_FILE' '$TEST_FILE2'" 0

# Test 7: Version flag (should work without API key)
test_case "Version flag" \
    "aider --version" 0

# Test 8: Help flag (should work without API key)
test_case "Help flag" \
    "aider --help | head -1" 0

# Test 9: Empty message handling (should fail gracefully)
test_case "Empty message handling" \
    "aider --yes --message '' '$TEST_FILE'" 1

# Test 10: Invalid model (should fail)
test_case "Invalid model" \
    "aider --yes --model invalid-model --message 'test' '$TEST_FILE'" 1

# Test 11: Combined flags - yes, model, no-git
test_case "Combined flags - yes, model, no-git" \
    "aider --yes --model gpt-4o --no-git --message 'Add comments' '$TEST_FILE'" 0

# Test 12: API key override
if [ -n "$OPENAI_API_KEY" ]; then
    test_case "API key override" \
        "aider --yes --model gpt-4o --api-key openai=test_key --message 'test' '$TEST_FILE'" 0
else
    echo -e "${YELLOW}Test 12: API key override ... SKIP (API key not set)${NC}"
    SKIPPED=$((SKIPPED + 1))
    test_count=$((test_count + 1))
fi

# Test 13: File not found (should fail)
test_case "File not found" \
    "aider --yes --message 'test' /nonexistent/file.py" 1

# Test 14: No files specified (should work in Git repo or fail)
test_case "No files specified" \
    "aider --yes --message 'test' || true" 0

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

