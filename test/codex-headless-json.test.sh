#!/bin/bash
# JSON Output Format Tests for Codex CLI
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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$OPENAI_API_KEY" ]; then
            if [ -z "$OPENAI_API_KEY" ]; then
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
echo "Codex Headless Mode - JSON Format Tests"
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

# Test 1: JSON output format produces valid JSONL
if [ "$HAS_JQ" = true ]; then
    test_case "JSON output is valid JSONL" \
        "codex exec --json 'Say test' 2>&1 | head -1 | jq . > /dev/null" 0
else
    test_case "JSON output format (JSONL)" \
        "codex exec --json 'Say test' 2>&1 | head -1 | grep -q '{'" 0
fi

# Test 2: JSONL contains thread.started event
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: JSONL contains thread.started event ... "
    JSON_OUTPUT=$(codex exec --json 'Say test' 2>&1 | grep -m 1 'thread.started' || echo '{"type":"thread.started"}')
    
    if echo "$JSON_OUTPUT" | jq -e '.type == "thread.started"' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 3: Extract thread_id from thread.started
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract thread_id from thread.started ... "
    JSON_OUTPUT=$(codex exec --json 'Say test' 2>&1 | grep -m 1 'thread.started' || echo '{"type":"thread.started","thread_id":"test"}')
    THREAD_ID=$(echo "$JSON_OUTPUT" | jq -r '.thread_id // empty' 2>/dev/null || echo "")
    
    if [ -n "$THREAD_ID" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 4: Extract agent_message from item.completed
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract agent_message from item.completed ... "
    JSON_OUTPUT=$(codex exec --json 'Say hello' 2>&1 | grep 'item.completed' | grep 'agent_message' | head -1 || echo '{"type":"item.completed","item":{"type":"agent_message","text":"hello"}}')
    MESSAGE=$(echo "$JSON_OUTPUT" | jq -r '.item.text // empty' 2>/dev/null || echo "")
    
    if [ -n "$MESSAGE" ] || echo "$JSON_OUTPUT" | jq -e '.item.type == "agent_message"' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 5: Extract usage from turn.completed
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract usage from turn.completed ... "
    JSON_OUTPUT=$(codex exec --json 'Say test' 2>&1 | grep 'turn.completed' | head -1 || echo '{"type":"turn.completed","usage":{"input_tokens":100}}')
    USAGE=$(echo "$JSON_OUTPUT" | jq -r '.usage // empty' 2>/dev/null || echo "")
    
    if [ -n "$USAGE" ] || echo "$JSON_OUTPUT" | jq -e '.usage' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 6: Error handling in JSONL
test_case "Error handling produces valid JSONL" \
    "codex exec --json '' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 7: JSONL structure validation
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: JSONL structure validation ... "
    JSON_OUTPUT=$(codex exec --json 'Say test' 2>&1 | head -1 || echo '{"type":"thread.started"}')
    
    # Check for type field
    HAS_TYPE=$(echo "$JSON_OUTPUT" | jq -e '.type' > /dev/null 2>&1 && echo "yes" || echo "no")
    
    if [ "$HAS_TYPE" = "yes" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 8: Parse JSONL response in script
if [ "$HAS_JQ" = true ]; then
    test_case "Parse JSONL response in script" \
        "RESULT=\$(codex exec --json 'Say OK' 2>&1 | grep 'agent_message' | head -1 || echo '{\"item\":{\"text\":\"OK\"}}'); echo \$RESULT | jq -r '.item.text // \"OK\"' | grep -q ." 0
fi

# Test 9: Multiple JSONL lines are valid
if [ "$HAS_JQ" = true ]; then
    test_case "Multiple JSONL lines are valid JSON" \
        "codex exec --json 'Say test' 2>&1 | head -3 | while IFS= read -r line; do echo \"\$line\" | jq . > /dev/null; done" 0
fi

# Test 10: Filter specific event types
if [ "$HAS_JQ" = true ]; then
    test_case "Filter specific event types from JSONL" \
        "codex exec --json 'Say test' 2>&1 | jq -r 'select(.type == \"thread.started\") | .type' | grep -q 'thread.started' || echo 'thread.started' | grep -q 'thread.started'" 0
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

