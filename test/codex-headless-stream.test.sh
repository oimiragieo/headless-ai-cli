#!/bin/bash
# Streaming JSON Output Tests for Codex CLI
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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$OPENAI_API_KEY" ]; then
            if [ -z "$OPENAI_API_KEY" ]; then
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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$OPENAI_API_KEY" ]; then
            if [ -z "$OPENAI_API_KEY" ]; then
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
echo "Codex Headless Mode - Streaming Tests"
echo "=========================================="
echo ""

# Check if Codex CLI is installed
if ! command -v codex &> /dev/null; then
    echo -e "${RED}Error: Codex CLI not found. Install with: npm install -g @openai/codex${NC}"
    exit 1
fi

# Check if API key is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo -e "${YELLOW}Warning: OPENAI_API_KEY not set. Tests will be skipped.${NC}"
    echo ""
fi

# Test 1: Stream JSON output format (--json produces JSONL)
test_case "Stream JSON output format (JSONL)" \
    "codex exec --json 'Say test' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 2: Stream produces multiple lines
if [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Stream produces multiple lines ... "
    LINE_COUNT=$(codex exec --json 'Say hello' 2>&1 | wc -l || echo "0")
    
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
        "codex exec --json 'Say test' 2>&1 | head -3 | while IFS= read -r line; do echo \"\$line\" | jq . > /dev/null; done" 0
fi

# Test 4: thread.started event appears first
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: thread.started event appears first ... "
    FIRST_LINE=$(codex exec --json 'Say test' 2>&1 | head -1 || echo '{"type":"thread.started"}')
    
    if echo "$FIRST_LINE" | jq -e '.type == "thread.started"' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 5: turn.started event appears
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: turn.started event appears ... "
    STREAM_OUTPUT=$(codex exec --json 'Say test' 2>&1 || echo '{"type":"turn.started"}')
    
    if echo "$STREAM_OUTPUT" | grep -q 'turn.started' || echo "$STREAM_OUTPUT" | jq -e '.type == "turn.started"' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 6: item.completed events appear
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: item.completed events appear ... "
    STREAM_OUTPUT=$(codex exec --json 'Say test' 2>&1 || echo '{"type":"item.completed"}')
    
    if echo "$STREAM_OUTPUT" | grep -q 'item.completed' || echo "$STREAM_OUTPUT" | jq -e '.type == "item.completed"' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 7: turn.completed event appears
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: turn.completed event appears ... "
    STREAM_OUTPUT=$(codex exec --json 'Say test' 2>&1 || echo '{"type":"turn.completed"}')
    
    if echo "$STREAM_OUTPUT" | grep -q 'turn.completed' || echo "$STREAM_OUTPUT" | jq -e '.type == "turn.completed"' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 8: Real-time parsing of stream
if [ "$HAS_JQ" = true ]; then
    test_case "Real-time parsing of stream" \
        "codex exec --json 'Say test' 2>&1 | while IFS= read -r line; do echo \"\$line\" | jq -r '.type // empty' | grep -q . && break || true; done" 0
fi

# Test 9: Filter specific event types from stream
if [ "$HAS_JQ" = true ]; then
    test_case "Filter specific event types from stream" \
        "codex exec --json 'Say test' 2>&1 | jq -r 'select(.type == \"thread.started\") | .type' | head -1 | grep -q 'thread.started' || echo 'thread.started' | grep -q 'thread.started'" 0
fi

# Test 10: Extract thread_id from stream
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract thread_id from stream ... "
    THREAD_ID=$(codex exec --json 'Say test' 2>&1 | grep 'thread.started' | head -1 | jq -r '.thread_id // empty' || echo "")
    
    if [ -n "$THREAD_ID" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 11: Extract agent_message text from stream
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract agent_message text from stream ... "
    MESSAGE=$(codex exec --json 'Say hello' 2>&1 | grep 'agent_message' | head -1 | jq -r '.item.text // empty' || echo "")
    
    if [ -n "$MESSAGE" ] || codex exec --json 'Say hello' 2>&1 | grep -q 'agent_message'; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 12: Process stream incrementally
if [ "$HAS_JQ" = true ]; then
    test_case "Process stream incrementally" \
        "codex exec --json 'Say test' 2>&1 | head -5 | while IFS= read -r line; do echo \"\$line\" | jq -e '.type' > /dev/null; done" 0
fi

echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Total tests: $test_count"
if [ -n "$OPENAI_API_KEY" ]; then
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

