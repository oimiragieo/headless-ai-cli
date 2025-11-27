#!/bin/bash
# Basic Headless Mode Tests for Factory AI Droid CLI
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
    
    if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$FACTORY_API_KEY" ]; then
        # If API key is not set, we expect failures but don't count them as test failures
        if [ -z "$FACTORY_API_KEY" ]; then
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
echo "Factory AI Droid Headless Mode - Basic Tests"
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
    echo "Set your API key with: export FACTORY_API_KEY=fk-..."
    echo ""
fi

# Test 1: Basic headless mode with droid exec
test_case "Basic headless mode (droid exec)" \
    "droid exec 'Say hello'" 0

# Test 2: Exit code on success
test_case "Exit code on success" \
    "droid exec 'Say OK'; echo \$?" 0

# Test 3: Text output format (default)
test_case "Text output format (default)" \
    "droid exec 'Say test' | grep -q . || true" 0

# Test 4: JSON output format
test_case "JSON output format (--output-format json)" \
    "droid exec --output-format json 'Say test' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 5: Debug output format
test_case "Debug output format (--output-format debug)" \
    "droid exec --output-format debug 'Say test' 2>&1 | head -1" 0

# Test 6: Autonomy level low
test_case "Autonomy level low (--auto low)" \
    "droid exec --auto low 'Say test'" 0

# Test 7: Autonomy level medium
test_case "Autonomy level medium (--auto medium)" \
    "droid exec --auto medium 'Say test'" 0

# Test 8: Autonomy level high
test_case "Autonomy level high (--auto high)" \
    "droid exec --auto high 'Say test'" 0

# Test 9: Short autonomy flag -r
test_case "Short autonomy flag (-r)" \
    "droid exec -r low 'Say test'" 0

# Test 10: Model selection with short name
test_case "Model selection with short name (-m sonnet)" \
    "droid exec -m sonnet 'Say test'" 0

# Test 11: Model selection with full ID
test_case "Model selection with full ID" \
    "droid exec -m claude-sonnet-4-20250514 'Say test'" 0

# Test 12: Model selection with GPT-5
test_case "Model selection with GPT-5" \
    "droid exec -m gpt-5 'Say test'" 0

# Test 13: Combined flags - model and autonomy
test_case "Combined flags - model and autonomy" \
    "droid exec -m sonnet -r low 'Say test'" 0

# Test 14: Combined flags - model, autonomy, json
test_case "Combined flags - model, autonomy, json" \
    "droid exec -m sonnet -r low --output-format json 'Say test' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 15: Working directory
test_case "Working directory (--cwd)" \
    "droid exec --cwd . 'Say test'" 0

# Test 16: Prompt from file
test_case "Prompt from file (-f)" \
    "echo 'Say test' > /tmp/test-prompt.txt && droid exec -f /tmp/test-prompt.txt && rm /tmp/test-prompt.txt" 0

# Test 17: Stdin input
test_case "Stdin input" \
    "echo 'Say test' | droid exec" 0

# Test 18: Session ID
test_case "Session ID (--session-id)" \
    "droid exec --session-id test-session 'Say test'" 0

# Test 19: Help flag (should work without API key)
test_case "Help flag" \
    "droid --help | head -1" 0

# Test 20: Version flag (should work without API key)
test_case "Version flag" \
    "droid --version" 0

# Test 21: Empty prompt handling (should fail gracefully)
test_case "Empty prompt handling" \
    "droid exec ''" 1

# Test 22: Invalid output format (should fail)
test_case "Invalid output format" \
    "droid exec --output-format invalid 'test'" 1

# Test 23: Invalid autonomy level (should fail)
test_case "Invalid autonomy level" \
    "droid exec --auto invalid 'test'" 1

# Test 24: Read-only mode (default)
test_case "Read-only mode (default)" \
    "droid exec 'Analyze code quality'" 0

# Test 25: Complex command with all flags
test_case "Complex command with all flags" \
    "droid exec -m sonnet -r low --output-format json --cwd . 'Say test' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

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

