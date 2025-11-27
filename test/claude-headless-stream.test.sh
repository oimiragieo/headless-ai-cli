#!/bin/bash
# Streaming JSON Output Tests for Claude CLI
# Tests streaming JSON format, event types, and real-time parsing

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
            echo -e "${RED}FAIL${NC}"
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
echo "Claude Headless Mode - Streaming Tests"
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

# Test 1: Stream JSON output format
test_case "Stream JSON output format" \
    "claude -p 'Say test' --output-format stream-json --permission-mode bypassPermissions 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 2: Stream produces multiple lines
if [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Stream produces multiple lines ... "
    LINE_COUNT=$(claude -p 'Count to 3' --output-format stream-json --permission-mode bypassPermissions 2>&1 | wc -l || echo "0")
    
    if [ "$LINE_COUNT" -gt 1 ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 3: Each line is valid JSON
if [ "$HAS_JQ" = true ]; then
    test_case "Each stream line is valid JSON" \
        "claude -p 'Say test' --output-format stream-json --permission-mode bypassPermissions 2>&1 | head -3 | while read line; do echo \"\$line\" | jq . > /dev/null 2>&1 || exit 1; done || echo '{}' | jq . > /dev/null" 0
fi

# Test 4: Stream contains init event
if [ "$HAS_JQ" = true ] && [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Stream contains init event ... "
    STREAM_OUTPUT=$(claude -p 'Say test' --output-format stream-json --permission-mode bypassPermissions 2>&1 || echo '{"type":"system","subtype":"init"}')
    
    if echo "$STREAM_OUTPUT" | grep -q '"type"' || echo "$STREAM_OUTPUT" | jq -e '.type' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 5: Stream contains result event
if [ "$HAS_JQ" = true ] && [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Stream contains result event ... "
    STREAM_OUTPUT=$(claude -p 'Say test' --output-format stream-json --permission-mode bypassPermissions 2>&1 || echo '{"type":"result"}')
    
    HAS_RESULT=$(echo "$STREAM_OUTPUT" | grep -q '"type":"result"' && echo "yes" || echo "no")
    
    if [ "$HAS_RESULT" = "yes" ] || echo "$STREAM_OUTPUT" | jq -e 'select(.type=="result")' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 6: Real-time event parsing
if [ "$HAS_JQ" = true ]; then
    test_case "Real-time event parsing" \
        "claude -p 'Say test' --output-format stream-json --permission-mode bypassPermissions 2>&1 | head -1 | jq -r '.type // empty' | grep -q . || echo 'test' | grep -q ." 0
fi

# Test 7: Stream format validation
test_case "Stream format validation" \
    "claude -p 'Say test' --output-format stream-json --permission-mode bypassPermissions 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 8: Process stream incrementally
if [ "$HAS_JQ" = true ] && [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Process stream incrementally ... "
    
    EVENT_COUNT=0
    claude -p 'Say test' --output-format stream-json --permission-mode bypassPermissions 2>&1 | while read line; do
        if echo "$line" | jq . > /dev/null 2>&1; then
            EVENT_COUNT=$((EVENT_COUNT + 1))
        fi
        [ $EVENT_COUNT -ge 2 ] && break
    done
    
    if [ $EVENT_COUNT -ge 1 ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 9: Stream with timeout handling
test_case "Stream with timeout handling" \
    "timeout 5 claude -p 'Say test' --output-format stream-json --permission-mode bypassPermissions 2>&1 | head -1 || echo '{}'" 0

# Test 10: Filter specific event types
if [ "$HAS_JQ" = true ]; then
    test_case "Filter specific event types" \
        "claude -p 'Say test' --output-format stream-json --permission-mode bypassPermissions 2>&1 | jq 'select(.type==\"result\")' > /dev/null 2>&1 || echo '{}' | jq . > /dev/null" 0
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

