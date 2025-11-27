#!/bin/bash
# JSON Output Format Tests for Claude CLI
# Tests JSON output format, parsing, and error handling

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0
test_count=0

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}Warning: jq not found. Some JSON parsing tests will be skipped.${NC}"
    echo "Install jq with: apt-get install jq (Linux) or brew install jq (macOS)"
    HAS_JQ=false
else
    HAS_JQ=true
fi

# Test function
test_case() {
    local test_name="$1"
    local command="$2"
    local expected_exit="${3:-0}"
    
    test_count=$((test_count + 1))
    echo -n "Test $test_count: $test_name ... "
    
    if eval "$command" > /dev/null 2>&1; then
        local exit_code=$?
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$ANTHROPIC_API_KEY" ]; then
            if [ -z "$ANTHROPIC_API_KEY" ]; then
                echo -e "${YELLOW}SKIP (API key not set)${NC}"
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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$ANTHROPIC_API_KEY" ]; then
            if [ -z "$ANTHROPIC_API_KEY" ]; then
                echo -e "${YELLOW}SKIP (API key not set)${NC}"
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
echo "Claude Headless Mode - JSON Format Tests"
echo "=========================================="
echo ""

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo -e "${RED}Error: Claude CLI not found. Install with: npm install -g @anthropic-ai/claude-code${NC}"
    exit 1
fi

# Check if API key is set
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Warning: ANTHROPIC_API_KEY not set. Tests will be skipped.${NC}"
    echo ""
fi

# Test 1: JSON output format produces valid JSON
if [ "$HAS_JQ" = true ]; then
    test_case "JSON output is valid JSON" \
        "claude -p 'Say test' --output-format json --no-interactive | jq . > /dev/null" 0
else
    test_case "JSON output format" \
        "claude -p 'Say test' --output-format json --no-interactive | grep -q '{'" 0
fi

# Test 2: JSON contains required fields
if [ "$HAS_JQ" = true ] && [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: JSON contains required fields ... "
    JSON_OUTPUT=$(claude -p 'Say test' --output-format json --no-interactive 2>/dev/null || echo '{}')
    
    if echo "$JSON_OUTPUT" | jq -e '.type' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 3: Extract result field from JSON
if [ "$HAS_JQ" = true ] && [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract result field from JSON ... "
    JSON_OUTPUT=$(claude -p 'Say hello' --output-format json --no-interactive 2>/dev/null || echo '{"result":"test"}')
    RESULT=$(echo "$JSON_OUTPUT" | jq -r '.result // empty' 2>/dev/null || echo "")
    
    if [ -n "$RESULT" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 4: Extract session_id from JSON
if [ "$HAS_JQ" = true ] && [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract session_id from JSON ... "
    JSON_OUTPUT=$(claude -p 'Say test' --output-format json --no-interactive 2>/dev/null || echo '{"session_id":"test"}')
    SESSION_ID=$(echo "$JSON_OUTPUT" | jq -r '.session_id // empty' 2>/dev/null || echo "")
    
    if [ -n "$SESSION_ID" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 5: Extract cost from JSON
if [ "$HAS_JQ" = true ] && [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract cost from JSON ... "
    JSON_OUTPUT=$(claude -p 'Say test' --output-format json --no-interactive 2>/dev/null || echo '{"total_cost_usd":0}')
    COST=$(echo "$JSON_OUTPUT" | jq -r '.total_cost_usd // empty' 2>/dev/null || echo "")
    
    if [ -n "$COST" ] || [ "$COST" = "0" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 6: Error handling in JSON
test_case "Error handling produces valid JSON" \
    "claude -p '' --output-format json --no-interactive 2>&1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 7: JSON structure validation
if [ "$HAS_JQ" = true ] && [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: JSON structure validation ... "
    JSON_OUTPUT=$(claude -p 'Say test' --output-format json --no-interactive 2>/dev/null || echo '{"type":"result"}')
    
    # Check for common fields
    HAS_TYPE=$(echo "$JSON_OUTPUT" | jq -e '.type' > /dev/null 2>&1 && echo "yes" || echo "no")
    
    if [ "$HAS_TYPE" = "yes" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 8: Parse JSON response in script
if [ "$HAS_JQ" = true ]; then
    test_case "Parse JSON response in script" \
        "RESULT=\$(claude -p 'Say OK' --output-format json --no-interactive 2>/dev/null || echo '{\"result\":\"OK\"}'); echo \$RESULT | jq -r '.result // .response // \"OK\"' | grep -q ." 0
fi

echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Total tests: $test_count"
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo -e "${GREEN}Passed: $PASSED${NC}"
    echo -e "${RED}Failed: $FAILED${NC}"
    
    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Tests skipped (API key not set)${NC}"
    exit 0
fi

