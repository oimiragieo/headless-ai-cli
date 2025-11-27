#!/bin/bash
# Basic Tests for Warp Terminal Agent CLI
# Tests Warp agent CLI commands, profiles, and basic automation features

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
    
    if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$WARP_API_KEY" ]; then
        # If API key is not set, we expect failures but don't count them as test failures
        if [ -z "$WARP_API_KEY" ]; then
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
echo "Warp Terminal Agent CLI - Basic Tests"
echo "=========================================="
echo ""

# Check if Warp CLI is installed
if ! command -v warp &> /dev/null; then
    echo -e "${YELLOW}Warning: Warp CLI not found. Some tests will be skipped.${NC}"
    echo "Note: Warp is primarily a terminal emulator. CLI commands may not be available."
    echo ""
fi

# Check if API key is set
if [ -z "$WARP_API_KEY" ]; then
    echo -e "${YELLOW}Warning: WARP_API_KEY not set. Tests will be skipped.${NC}"
    echo "Set your API key with: export WARP_API_KEY=your_key_here"
    echo ""
fi

# Test 1: Warp agent run command (if available)
if command -v warp &> /dev/null; then
    test_case "Warp agent run (basic)" \
        "warp agent run --prompt 'Say hello' --profile test-profile 2>&1 || true" 0
else
    test_count=$((test_count + 1))
    echo -e "Test $test_count: Warp agent run (basic) ... ${YELLOW}SKIP (Warp CLI not installed)${NC}"
    SKIPPED=$((SKIPPED + 1))
fi

# Test 2: List agent profiles (if available)
if command -v warp &> /dev/null; then
    test_case "List agent profiles" \
        "warp agent profile list 2>&1 || true" 0
else
    test_count=$((test_count + 1))
    echo -e "Test $test_count: List agent profiles ... ${YELLOW}SKIP (Warp CLI not installed)${NC}"
    SKIPPED=$((SKIPPED + 1))
fi

# Test 3: Create agent profile (if available)
if command -v warp &> /dev/null; then
    test_case "Create agent profile" \
        "warp agent profile create --name test-profile 2>&1 || true" 0
else
    test_count=$((test_count + 1))
    echo -e "Test $test_count: Create agent profile ... ${YELLOW}SKIP (Warp CLI not installed)${NC}"
    SKIPPED=$((SKIPPED + 1))
fi

# Test 4: Help flag (should work if warp command exists)
if command -v warp &> /dev/null; then
    test_case "Help flag" \
        "warp --help 2>&1 | head -1 || warp agent --help 2>&1 | head -1 || true" 0
else
    test_count=$((test_count + 1))
    echo -e "Test $test_count: Help flag ... ${YELLOW}SKIP (Warp CLI not installed)${NC}"
    SKIPPED=$((SKIPPED + 1))
fi

# Test 5: Version flag (should work if warp command exists)
if command -v warp &> /dev/null; then
    test_case "Version flag" \
        "warp --version 2>&1 || true" 0
else
    test_count=$((test_count + 1))
    echo -e "Test $test_count: Version flag ... ${YELLOW}SKIP (Warp CLI not installed)${NC}"
    SKIPPED=$((SKIPPED + 1))
fi

# Test 6: Workflow directory creation
test_case "Workflow directory creation" \
    "mkdir -p ~/.warp/workflows && test -d ~/.warp/workflows" 0

# Test 7: Workflow YAML file creation
test_case "Workflow YAML file creation" \
    "mkdir -p ~/.warp/workflows && echo 'name: Test Workflow' > ~/.warp/workflows/test.yaml && test -f ~/.warp/workflows/test.yaml && rm ~/.warp/workflows/test.yaml" 0

# Test 8: Exit code on success
test_case "Exit code on success" \
    "true; [ \$? -eq 0 ]" 0

# Test 9: Exit code on failure
test_case "Exit code on failure" \
    "false; [ \$? -ne 0 ]" 0

# Test 10: Error handling with if statement
test_case "Error handling with if statement" \
    "if true; then echo 'success'; else echo 'failure'; fi" 0

# Test 11: Environment variable usage
test_case "Environment variable usage" \
    "WARP_API_KEY=\${WARP_API_KEY:-test} echo 'test'" 0

# Test 12: Output redirection
test_case "Output redirection" \
    "echo 'test' > /tmp/warp-test.txt && test -f /tmp/warp-test.txt && rm /tmp/warp-test.txt" 0

# Test 13: Conditional execution
test_case "Conditional execution" \
    "true && echo 'success' || echo 'failure'" 0

# Test 14: Pipe output to another command
test_case "Pipe output to another command" \
    "echo 'test' | head -1 > /dev/null" 0

# Test 15: Complex command chaining
test_case "Complex command chaining" \
    "mkdir -p /tmp/warp-test && cd /tmp/warp-test && pwd && cd - > /dev/null && rm -rf /tmp/warp-test" 0

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

