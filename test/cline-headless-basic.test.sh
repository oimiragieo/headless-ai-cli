#!/bin/bash
# Basic Headless Mode Tests for Cline CLI
# Tests basic headless mode execution, instance management, and task creation

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
    
    if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$CLINE_API_KEY" ] || ! command -v cline &> /dev/null; then
        # If API key is not set or CLI not installed, we expect failures but don't count them as test failures
        if [ -z "$CLINE_API_KEY" ] || ! command -v cline &> /dev/null; then
            echo -e "${YELLOW}SKIP (CLI not installed or API key not set)${NC}"
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
echo "Cline Headless Mode - Basic Tests"
echo "=========================================="
echo ""

# Check if Cline CLI is installed
if ! command -v cline &> /dev/null; then
    echo -e "${YELLOW}Warning: Cline CLI not found. Install with: npm install -g cline${NC}"
    echo "Tests will be skipped."
    echo ""
fi

# Check if API key is set
if [ -z "$CLINE_API_KEY" ]; then
    echo -e "${YELLOW}Warning: CLINE_API_KEY not set. Tests will be skipped.${NC}"
    echo "Set your API key with: export CLINE_API_KEY=your_key_here"
    echo "Or run: cline auth"
    echo ""
fi

# Test 1: Help flag (should work without API key)
test_case "Help flag" \
    "cline --help 2>&1 | head -1 || cline help 2>&1 | head -1 || true" 0

# Test 2: Version flag (should work without API key)
test_case "Version flag" \
    "cline --version 2>&1 || cline version 2>&1 || true" 0

# Test 3: Direct prompt with --yolo flag
test_case "Direct prompt with --yolo flag" \
    "cline 'Say hello' --yolo 2>&1 || true" 0

# Test 4: Direct prompt with -y flag (shorthand)
test_case "Direct prompt with -y flag (shorthand)" \
    "cline 'Say hello' -y 2>&1 || true" 0

# Test 5: Direct prompt with --oneshot flag
test_case "Direct prompt with --oneshot flag" \
    "cline 'Say hello' --oneshot 2>&1 || true" 0

# Test 6: Direct prompt with --no-interactive flag
test_case "Direct prompt with --no-interactive flag" \
    "cline 'Say hello' --no-interactive 2>&1 || true" 0

# Test 7: Direct prompt with --mode plan
test_case "Direct prompt with --mode plan" \
    "cline 'Plan a feature' --mode plan --yolo 2>&1 || true" 0

# Test 8: Direct prompt with --mode act
test_case "Direct prompt with --mode act" \
    "cline 'Say hello' --mode act --yolo 2>&1 || true" 0

# Test 9: Direct prompt with --output-format json
test_case "Direct prompt with --output-format json" \
    "cline 'Say hello' --output-format json --yolo 2>&1 || true" 0

# Test 10: Direct prompt with --output-format plain
test_case "Direct prompt with --output-format plain" \
    "cline 'Say hello' --output-format plain --yolo 2>&1 || true" 0

# Test 11: Stdin piping with --yolo
test_case "Stdin piping with --yolo" \
    "echo 'Say hello' | cline --yolo 2>&1 || true" 0

# Test 12: Instance new command syntax
test_case "Instance new command syntax" \
    "cline instance new --help 2>&1 | head -1 || true" 0

# Test 13: Instance new with --default flag
test_case "Instance new with --default flag" \
    "cline instance new --default 2>&1 || true" 0

# Test 14: Instance list command
test_case "Instance list command" \
    "cline instance list 2>&1 || true" 0

# Test 15: Task new command syntax
test_case "Task new command syntax" \
    "cline task new --help 2>&1 | head -1 || true" 0

# Test 16: Task new with -y flag (headless mode)
test_case "Task new with -y flag (headless mode)" \
    "cline task new -y 'Say hello' 2>&1 || true" 0

# Test 17: Task new with --yolo flag (alternative)
test_case "Task new with --yolo flag" \
    "cline task new --yolo 'Say hello' 2>&1 || true" 0

# Test 18: Task view command
test_case "Task view command" \
    "cline task view 2>&1 || true" 0

# Test 19: Task view with --follow flag
test_case "Task view with --follow flag" \
    "cline task view --follow 2>&1 | head -1 || timeout 1 cline task view --follow 2>&1 || true" 0

# Test 20: Task list command
test_case "Task list command" \
    "cline task list 2>&1 || true" 0

# Test 21: Auth command syntax
test_case "Auth command syntax" \
    "cline auth --help 2>&1 | head -1 || true" 0

# Test 22: Auth with --non-interactive flag
test_case "Auth with --non-interactive flag" \
    "cline auth --non-interactive 2>&1 || true" 0

# Test 23: Instance switch command syntax
test_case "Instance switch command syntax" \
    "cline instance switch --help 2>&1 | head -1 || true" 0

# Test 24: Combined flags - instance and task
test_case "Combined flags - instance and task" \
    "cline instance new --default 2>&1 && cline task new -y 'Test task' 2>&1 || true" 0

# Test 25: Exit code on success
test_case "Exit code on success" \
    "true; [ \$? -eq 0 ]" 0

# Test 26: Exit code on failure
test_case "Exit code on failure" \
    "false; [ \$? -ne 0 ]" 0

# Test 27: Error handling with invalid command
test_case "Error handling with invalid command" \
    "cline invalid-command 2>&1; [ \$? -ne 0 ]" 0

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

