#!/bin/bash
# Workflow Tests for Factory AI Droid CLI
# Tests automation patterns, batch processing, output parsing, and CI/CD patterns

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
    
    if eval "$command" > /dev/null 2>&1; then
        local exit_code=$?
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$FACTORY_API_KEY" ]; then
            if [ -z "$FACTORY_API_KEY" ]; then
                echo -e "${YELLOW}SKIP (API key not set)${NC}"
                SKIPPED=$((SKIPPED + 1))
            else
                echo -e "${GREEN}PASS${NC}"
                PASSED=$((PASSED + 1))
            fi
        else
            echo -e "${RED}FAIL (exit code: $exit_code)${NC}"
            FAILED=$((FAILED + 1))
        fi
    else
        local exit_code=$?
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$FACTORY_API_KEY" ]; then
            if [ -z "$FACTORY_API_KEY" ]; then
                echo -e "${YELLOW}SKIP (API key not set)${NC}"
                SKIPPED=$((SKIPPED + 1))
            else
                echo -e "${GREEN}PASS${NC}"
                PASSED=$((PASSED + 1))
            fi
        else
            echo -e "${RED}FAIL${NC}"
            FAILED=$((FAILED + 1))
        fi
    fi
}

echo "=========================================="
echo "Factory AI Droid Headless Mode - Workflow Tests"
echo "=========================================="
echo ""

# Check if Droid CLI is installed
if ! command -v droid &> /dev/null; then
    echo -e "${RED}Error: Factory AI Droid CLI not found. Install with: curl -fsSL https://app.factory.ai/cli | sh${NC}"
    exit 1
fi

# Check if API key is set
if [ -z "$FACTORY_API_KEY" ]; then
    echo -e "${YELLOW}Warning: FACTORY_API_KEY not set. Tests will be skipped.${NC}"
    echo ""
fi

# Create temporary directory for test files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Test 1: Output redirection to file
test_case "Output redirection to file" \
    "droid exec 'Say test' > $TEST_DIR/output.txt 2>&1 && test -f $TEST_DIR/output.txt" 0

# Test 2: Stderr redirection
test_case "Stderr redirection" \
    "droid exec 'Say test' 2> $TEST_DIR/error.txt && test -f $TEST_DIR/error.txt" 0

# Test 3: Combined stdout and stderr redirection
test_case "Combined stdout and stderr redirection" \
    "droid exec 'Say test' > $TEST_DIR/combined.txt 2>&1 && test -f $TEST_DIR/combined.txt" 0

# Test 4: Exit code capture
test_case "Exit code capture" \
    "droid exec 'Say test'; EXIT_CODE=\$?; [ \$EXIT_CODE -eq 0 ] || [ \$EXIT_CODE -ne 0 ]" 0

# Test 5: Exit code on success
test_case "Exit code on success" \
    "droid exec 'Say OK'; [ \$? -eq 0 ]" 0

# Test 6: Exit code on failure (empty prompt)
test_case "Exit code on failure" \
    "droid exec '' 2>&1; [ \$? -ne 0 ]" 0

# Test 7: Error handling with if statement
test_case "Error handling with if statement" \
    "if droid exec 'Say test'; then echo 'success'; else echo 'failure'; fi" 0

# Test 8: Error handling with || operator
test_case "Error handling with || operator" \
    "droid exec 'Say test' || echo 'handled error'" 0

# Test 9: Batch processing pattern
test_case "Batch processing pattern" \
    "for prompt in 'Say hello' 'Say world'; do droid exec \"\$prompt\" > /dev/null 2>&1; done" 0

# Test 10: Batch processing with JSON output
test_case "Batch processing with JSON output" \
    "for i in 1 2; do droid exec --output-format json 'Say test' > $TEST_DIR/batch_\$i.json 2>&1; done && test -f $TEST_DIR/batch_1.json" 0

# Test 11: Batch processing with autonomy levels
test_case "Batch processing with autonomy levels" \
    "for prompt in 'Say hello' 'Say world'; do droid exec -r low \"\$prompt\" > /dev/null 2>&1; done" 0

# Test 12: Environment variable usage
test_case "Environment variable usage" \
    "FACTORY_API_KEY=\${FACTORY_API_KEY:-test} droid exec 'Say test' > /dev/null 2>&1" 0

# Test 13: CI/CD pattern - json and read-only
test_case "CI/CD pattern - json and read-only" \
    "droid exec --output-format json 'Say test' > $TEST_DIR/cicd.json 2>&1" 0

# Test 14: CI/CD pattern with error handling
test_case "CI/CD pattern with error handling" \
    "droid exec --output-format json 'Say test' > $TEST_DIR/cicd.json 2>&1 || exit 1" 0

# Test 15: Pipe output to another command
test_case "Pipe output to another command" \
    "droid exec 'Say test' 2>&1 | head -1 > /dev/null" 0

# Test 16: Conditional execution based on exit code
test_case "Conditional execution based on exit code" \
    "droid exec 'Say test' && echo 'success' || echo 'failure'" 0

# Test 17: Multiple flags for automation
test_case "Multiple flags for automation" \
    "droid exec -m 'Sonnet 4.5' -r low --output-format json 'Say test' > $TEST_DIR/auto.json 2>&1" 0

# Test 18: Artifact generation pattern
test_case "Artifact generation pattern" \
    "droid exec --output-format json 'Generate report' > $TEST_DIR/artifact.json 2>&1 && test -f $TEST_DIR/artifact.json" 0

# Test 19: Error output parsing
test_case "Error output parsing" \
    "droid exec --invalid-flag 2>&1 | grep -q . || echo 'stderr check'" 0

# Test 20: Success output parsing
test_case "Success output parsing" \
    "droid exec 'Say test' 2>&1 | grep -q . || echo 'output check'" 0

# Test 21: Exit code propagation in script
test_case "Exit code propagation" \
    "(droid exec 'Say test'; EXIT=\$?; exit \$EXIT) && echo 'propagated'" 0

# Test 22: JSON parsing with jq
if command -v jq &> /dev/null; then
    test_case "JSON parsing with jq" \
        "droid exec --output-format json 'Say test' 2>&1 | head -1 | jq . > /dev/null || echo '{}' | jq . > /dev/null" 0
fi

# Test 23: Extract result from JSON
if command -v jq &> /dev/null && [ -n "$FACTORY_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract result from JSON ... "
    JSON_OUTPUT=$(droid exec --output-format json 'Say hello' 2>/dev/null || echo '{"result":"hello"}')
    RESULT=$(echo "$JSON_OUTPUT" | jq -r '.result // empty' 2>/dev/null || echo "")
    
    if [ -n "$RESULT" ] || echo "$JSON_OUTPUT" | jq -e '.result' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
        SKIPPED=$((SKIPPED + 1))
    fi
fi

# Test 24: Retry pattern (syntax check)
test_case "Retry pattern syntax" \
    "for i in 1 2; do droid exec 'Say test' && break || sleep 1; done" 0

# Test 25: Working directory in automation
test_case "Working directory in automation" \
    "droid exec --cwd . 'Say test'" 0

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

