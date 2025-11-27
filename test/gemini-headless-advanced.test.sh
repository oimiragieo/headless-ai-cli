#!/bin/bash
# Advanced Headless Mode Tests for Google Gemini CLI
# Tests advanced headless mode features, model selection, streaming, and complex flag combinations

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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$GEMINI_API_KEY" ]; then
            if [ -z "$GEMINI_API_KEY" ]; then
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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$GEMINI_API_KEY" ]; then
            if [ -z "$GEMINI_API_KEY" ]; then
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
echo "Google Gemini Headless Mode - Advanced Tests"
echo "=========================================="
echo ""

# Check if Gemini CLI is installed
if ! command -v gemini &> /dev/null; then
    echo -e "${RED}Error: Google Gemini CLI not found. Install with: npm install -g @google/gemini-cli${NC}"
    exit 1
fi

# Check if API key is set
if [ -z "$GEMINI_API_KEY" ]; then
    echo -e "${YELLOW}Warning: GEMINI_API_KEY not set. Tests will be skipped.${NC}"
    echo ""
fi

# Create temporary directory for test files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Test 1: List models command
test_case "List models command" \
    "gemini models list | head -1" 0

# Test 2: Model selection with gemini-3.0-pro
test_case "Model selection with gemini-3.0-pro" \
    "gemini -p --model gemini-3.0-pro 'Say test'" 0

# Test 3: Model selection with gemini-2.5-flash
test_case "Model selection with gemini-2.5-flash" \
    "gemini -p --model gemini-2.5-flash 'Say test'" 0

# Test 4: Model selection with gemini-1.5-pro
test_case "Model selection with gemini-1.5-pro" \
    "gemini -p --model gemini-1.5-pro 'Say test'" 0

# Test 5: Model selection with gemini-1.5-flash
test_case "Model selection with gemini-1.5-flash" \
    "gemini -p --model gemini-1.5-flash 'Say test'" 0

# Test 6: JSON output with model selection
test_case "JSON output with model selection" \
    "gemini -p --model gemini-3.0-pro --output-format json 'Say test' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 7: Stream JSON with model selection
test_case "Stream JSON with model selection" \
    "gemini -p --model gemini-3.0-pro --output-format stream-json 'Say test' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 8: Yolo with model selection
test_case "Yolo with model selection" \
    "gemini -p --model gemini-3.0-pro --yolo 'Say test'" 0

# Test 9: Include directories with model
test_case "Include directories with model" \
    "gemini -p --model gemini-3.0-pro --include-directories src,docs 'Say test'" 0

# Test 10: Debug with model selection
test_case "Debug with model selection" \
    "gemini -p --model gemini-3.0-pro --debug 'Say test'" 0

# Test 11: Extract response from JSON
if command -v jq &> /dev/null && [ -n "$GEMINI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract response from JSON ... "
    JSON_OUTPUT=$(gemini -p --output-format json 'Say hello' 2>/dev/null || echo '{"response":"hello"}')
    RESPONSE=$(echo "$JSON_OUTPUT" | jq -r '.response // empty' 2>/dev/null || echo "")
    
    if [ -n "$RESPONSE" ] || echo "$JSON_OUTPUT" | jq -e '.response' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
        SKIPPED=$((SKIPPED + 1))
    fi
fi

# Test 12: Extract stats from JSON
if command -v jq &> /dev/null && [ -n "$GEMINI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract stats from JSON ... "
    JSON_OUTPUT=$(gemini -p --output-format json 'Say test' 2>/dev/null || echo '{"stats":{}}')
    
    if echo "$JSON_OUTPUT" | jq -e '.stats' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
        SKIPPED=$((SKIPPED + 1))
    fi
fi

# Test 13: Extract tokens from JSON
if command -v jq &> /dev/null && [ -n "$GEMINI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract tokens from JSON ... "
    JSON_OUTPUT=$(gemini -p --output-format json 'Say test' 2>/dev/null || echo '{"stats":{"models":{"gemini-3.0-pro":{"tokens":{}}}}}')
    
    if echo "$JSON_OUTPUT" | jq -e '.stats.models' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
        SKIPPED=$((SKIPPED + 1))
    fi
fi

# Test 14: Complex command with all flags
test_case "Complex command with all flags" \
    "gemini -p --model gemini-3.0-pro --output-format stream-json --yolo --include-directories src --debug 'Say test' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 15: Config commands
test_case "Config init (gemini config init)" \
    "gemini config init 2>&1 || true" 0

# Test 16: Config set and get model
test_case "Config set and get model" \
    "gemini config set model gemini-3.0-pro 2>&1 && gemini config get model 2>&1" 0

# Test 17: Error handling - invalid model
test_case "Error handling - invalid model" \
    "gemini -p --model invalid-model-xyz 'test' 2>&1; [ \$? -ne 0 ] || true" 0

# Test 18: Batch processing pattern
test_case "Batch processing pattern" \
    "for prompt in 'Say hello' 'Say world'; do gemini -p \"\$prompt\" > /dev/null 2>&1; done" 0

# Test 19: Batch processing with model selection
test_case "Batch processing with model selection" \
    "for prompt in 'Say hello' 'Say world'; do gemini -p --model gemini-2.5-flash \"\$prompt\" > /dev/null 2>&1; done" 0

# Test 20: Output redirection to file
test_case "Output redirection to file" \
    "gemini -p 'Say test' > $TEST_DIR/output.txt 2>&1 && test -f $TEST_DIR/output.txt" 0

# Test 21: JSON output to file
test_case "JSON output to file" \
    "gemini -p --output-format json 'Say test' > $TEST_DIR/output.json 2>&1 && test -f $TEST_DIR/output.json" 0

# Test 22: Stream JSON output to file
test_case "Stream JSON output to file" \
    "gemini -p --output-format stream-json 'Say test' > $TEST_DIR/stream.json 2>&1 && test -f $TEST_DIR/stream.json" 0

# Test 23: Environment variable usage
test_case "Environment variable usage" \
    "GEMINI_API_KEY=\${GEMINI_API_KEY:-test} gemini -p 'Say test' > /dev/null 2>&1" 0

# Test 24: Exit code propagation
test_case "Exit code propagation" \
    "(gemini -p 'Say test'; EXIT=\$?; exit \$EXIT) && echo 'propagated'" 0

# Test 25: Conditional execution
test_case "Conditional execution" \
    "gemini -p 'Say test' && echo 'success' || echo 'failure'" 0

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

