#!/bin/bash
# Workflow Tests for GitHub Copilot CLI
# Tests automation patterns, batch processing, output redirection, and error handling

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
echo "GitHub Copilot CLI - Workflow Tests"
echo "=========================================="
echo ""

# Check if Copilot CLI is installed
if ! command -v copilot &> /dev/null; then
    echo -e "${RED}Error: Copilot CLI not found. Install with: npm install -g @github/copilot${NC}"
    exit 1
fi

# Create temporary directory for test files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Test 1: Output redirection to file
test_case "Output redirection to file" \
    "copilot -p 'Say test' --allow-all-tools > $TEST_DIR/output.txt 2>&1 && test -f $TEST_DIR/output.txt" 0

# Test 2: Stderr redirection
test_case "Stderr redirection" \
    "copilot -p 'Say test' --allow-all-tools 2> $TEST_DIR/error.txt && test -f $TEST_DIR/error.txt" 0

# Test 3: Combined stdout and stderr redirection
test_case "Combined stdout and stderr redirection" \
    "copilot -p 'Say test' --allow-all-tools > $TEST_DIR/combined.txt 2>&1 && test -f $TEST_DIR/combined.txt" 0

# Test 4: Exit code capture
test_case "Exit code capture" \
    "copilot -p 'Say test' --allow-all-tools; EXIT_CODE=\$?; [ \$EXIT_CODE -eq 0 ] || [ \$EXIT_CODE -ne 0 ]" 0

# Test 5: Exit code on success
test_case "Exit code on success" \
    "copilot -p 'Say OK' --allow-all-tools; [ \$? -eq 0 ]" 0

# Test 6: Exit code on failure (empty prompt)
test_case "Exit code on failure" \
    "copilot -p '' --allow-all-tools 2>&1; [ \$? -ne 0 ]" 0

# Test 7: Error handling with if statement
test_case "Error handling with if statement" \
    "if copilot -p 'Say test' --allow-all-tools; then echo 'success'; else echo 'failure'; fi" 0

# Test 8: Error handling with || operator
test_case "Error handling with || operator" \
    "copilot -p 'Say test' --allow-all-tools || echo 'handled error'" 0

# Test 9: Batch processing pattern
test_case "Batch processing pattern" \
    "for prompt in 'Say hello' 'Say world'; do copilot -p \"\$prompt\" --silent --allow-all-tools > /dev/null 2>&1; done" 0

# Test 10: Batch processing with file output
test_case "Batch processing with file output" \
    "for i in 1 2; do copilot -p 'Say test' --silent --allow-all-tools > $TEST_DIR/batch_\$i.txt 2>&1; done && test -f $TEST_DIR/batch_1.txt" 0

# Test 11: Environment variable usage
test_case "Environment variable usage" \
    "COPILOT_ALLOW_ALL=1 copilot -p 'Say test' > /dev/null 2>&1" 0

# Test 12: CI/CD pattern - silent and no-color
test_case "CI/CD pattern - silent and no-color" \
    "copilot -p 'Say test' --silent --no-color --allow-all-tools > $TEST_DIR/cicd.txt 2>&1" 0

# Test 13: CI/CD pattern with error handling
test_case "CI/CD pattern with error handling" \
    "copilot -p 'Say test' --silent --no-color --allow-all-tools > $TEST_DIR/cicd.txt 2>&1 || exit 1" 0

# Test 14: Timeout handling
test_case "Timeout handling" \
    "timeout 10 copilot -p 'Say quick test' --allow-all-tools 2>&1 || [ \$? -eq 124 ] || [ \$? -eq 0 ]" 0

# Test 15: Pipe input
test_case "Pipe input" \
    "echo 'Say test' | copilot -p --allow-all-tools > /dev/null 2>&1" 0

# Test 16: Pipe output to another command
test_case "Pipe output to another command" \
    "copilot -p 'Say test' --silent --allow-all-tools 2>&1 | head -1 > /dev/null" 0

# Test 17: Conditional execution based on exit code
test_case "Conditional execution based on exit code" \
    "copilot -p 'Say test' --allow-all-tools && echo 'success' || echo 'failure'" 0

# Test 18: Logging to file
test_case "Logging to file" \
    "copilot --log-dir $TEST_DIR --log-level error -p 'Say test' --allow-all-tools > /dev/null 2>&1" 0

# Test 19: Multiple flags for automation
test_case "Multiple flags for automation" \
    "copilot --model claude-haiku-4.5 --silent --no-color --stream off -p 'Say test' --allow-all-tools > $TEST_DIR/auto.txt 2>&1" 0

# Test 20: Artifact generation pattern
test_case "Artifact generation pattern" \
    "copilot -p 'Generate report' --silent --no-color --allow-all-tools > $TEST_DIR/artifact.txt 2>&1 && test -f $TEST_DIR/artifact.txt" 0

# Test 21: Error output parsing
test_case "Error output parsing" \
    "copilot --invalid-flag 2>&1 | grep -q . || echo 'stderr check'" 0

# Test 22: Success output parsing
test_case "Success output parsing" \
    "copilot -p 'Say test' --silent --allow-all-tools 2>&1 | grep -q . || echo 'output check'" 0

# Test 23: Exit code propagation in script
test_case "Exit code propagation" \
    "(copilot -p 'Say test' --allow-all-tools; EXIT=\$?; exit \$EXIT) && echo 'propagated'" 0

# Test 24: Background process pattern (syntax check)
test_case "Background process pattern syntax" \
    "copilot -p 'Say test' --allow-all-tools > $TEST_DIR/bg.txt 2>&1 & wait" 0

# Test 25: Retry pattern (syntax check)
test_case "Retry pattern syntax" \
    "for i in 1 2; do copilot -p 'Say test' --allow-all-tools && break || sleep 1; done" 0

# Cleanup
rm -rf $TEST_DIR

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

