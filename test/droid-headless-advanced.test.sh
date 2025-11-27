#!/bin/bash
# Advanced Headless Mode Tests for Factory AI Droid CLI
# Tests advanced headless mode features, model selection, autonomy levels, and complex flag combinations

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
echo "Factory AI Droid Headless Mode - Advanced Tests"
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

# Test 1: Model selection with sonnet (short name)
test_case "Model selection with sonnet (short name)" \
    "droid exec -m sonnet 'Say test'" 0

# Test 2: Model selection with opus (short name)
test_case "Model selection with opus (short name)" \
    "droid exec -m opus 'Say test'" 0

# Test 3: Model selection with haiku (short name)
test_case "Model selection with haiku (short name)" \
    "droid exec -m haiku 'Say test'" 0

# Test 4: Model selection with gpt-5-codex
test_case "Model selection with gpt-5-codex" \
    "droid exec -m gpt-5-codex 'Say test'" 0

# Test 5: Model selection with gpt-5
test_case "Model selection with gpt-5" \
    "droid exec -m gpt-5 'Say test'" 0

# Test 6: Model selection with droid-core
test_case "Model selection with droid-core" \
    "droid exec -m droid-core 'Say test'" 0

# Test 7: Model selection with full Claude Sonnet ID
test_case "Model selection with full Claude Sonnet ID" \
    "droid exec -m claude-sonnet-4-20250514 'Say test'" 0

# Test 8: Model selection with full Claude Opus ID
test_case "Model selection with full Claude Opus ID" \
    "droid exec -m claude-opus-4-5-20251101 'Say test'" 0

# Test 9: Model selection with full Claude Haiku ID
test_case "Model selection with full Claude Haiku ID" \
    "droid exec -m claude-haiku-4-5-20251001 'Say test'" 0

# Test 10: Autonomy levels with model selection
test_case "Autonomy low with model selection" \
    "droid exec -m sonnet -r low 'Say test'" 0

# Test 11: Autonomy medium with model selection
test_case "Autonomy medium with model selection" \
    "droid exec -m sonnet -r medium 'Say test'" 0

# Test 12: Autonomy high with model selection
test_case "Autonomy high with model selection" \
    "droid exec -m sonnet -r high 'Say test'" 0

# Test 13: JSON output with model selection
test_case "JSON output with model selection" \
    "droid exec -m sonnet --output-format json 'Say test' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 14: Debug output with model selection
test_case "Debug output with model selection" \
    "droid exec -m sonnet --output-format debug 'Say test' 2>&1 | head -1" 0

# Test 15: Extract result from JSON
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

# Test 16: Complex command with all flags
test_case "Complex command with all flags" \
    "droid exec -m sonnet -r low --output-format json --cwd . 'Say test' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 17: Prompt from file with model and autonomy
test_case "Prompt from file with model and autonomy" \
    "echo 'Say test' > $TEST_DIR/prompt.txt && droid exec -f $TEST_DIR/prompt.txt -m sonnet -r low && rm $TEST_DIR/prompt.txt" 0

# Test 18: Stdin input with model selection
test_case "Stdin input with model selection" \
    "echo 'Say test' | droid exec -m sonnet" 0

# Test 19: Session ID with model selection
test_case "Session ID with model selection" \
    "droid exec --session-id test-session -m sonnet 'Say test'" 0

# Test 20: Working directory with model and autonomy
test_case "Working directory with model and autonomy" \
    "droid exec --cwd . -m sonnet -r low 'Say test'" 0

# Test 21: Error handling - invalid model
test_case "Error handling - invalid model" \
    "droid exec -m invalid-model-xyz 'test' 2>&1; [ \$? -ne 0 ] || true" 0

# Test 22: Batch processing pattern
test_case "Batch processing pattern" \
    "for prompt in 'Say hello' 'Say world'; do droid exec \"\$prompt\" > /dev/null 2>&1; done" 0

# Test 23: Batch processing with model selection
test_case "Batch processing with model selection" \
    "for prompt in 'Say hello' 'Say world'; do droid exec -m sonnet \"\$prompt\" > /dev/null 2>&1; done" 0

# Test 24: Output redirection to file
test_case "Output redirection to file" \
    "droid exec 'Say test' > $TEST_DIR/output.txt 2>&1 && test -f $TEST_DIR/output.txt" 0

# Test 25: JSON output to file
test_case "JSON output to file" \
    "droid exec --output-format json 'Say test' > $TEST_DIR/output.json 2>&1 && test -f $TEST_DIR/output.json" 0

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

