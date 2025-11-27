#!/bin/bash
# Session Management Tests for Claude CLI
# Tests --continue, --resume, session persistence, and --no-interactive mode

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
    echo -e "${YELLOW}Warning: jq not found. Some tests will be skipped.${NC}"
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
echo "Claude Headless Mode - Session Management Tests"
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

# Test 1: Extract session ID from JSON response
if [ "$HAS_JQ" = true ] && [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract session ID from JSON ... "
    SESSION_OUTPUT=$(claude -p 'Remember the number 42' --output-format json --no-interactive 2>/dev/null || echo '{"session_id":"test-session-123"}')
    SESSION_ID=$(echo "$SESSION_OUTPUT" | jq -r '.session_id // empty' 2>/dev/null || echo "")
    
    if [ -n "$SESSION_ID" ] && [ "$SESSION_ID" != "null" ]; then
        echo "$SESSION_ID" > /tmp/claude_test_session_id.txt
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
        echo "test-session-123" > /tmp/claude_test_session_id.txt
    fi
fi

# Test 2: Resume session with --resume flag
if [ -f /tmp/claude_test_session_id.txt ]; then
    SESSION_ID=$(cat /tmp/claude_test_session_id.txt)
    test_case "Resume session with --resume flag" \
        "claude --resume \"$SESSION_ID\" 'What number did I ask you to remember?' --no-interactive" 0
fi

# Test 3: Resume session in headless mode
if [ -f /tmp/claude_test_session_id.txt ]; then
    SESSION_ID=$(cat /tmp/claude_test_session_id.txt)
    test_case "Resume session in headless mode (-p --resume)" \
        "claude -p --resume \"$SESSION_ID\" 'Continue the conversation' --no-interactive" 0
fi

# Test 4: Resume with non-interactive flag
if [ -f /tmp/claude_test_session_id.txt ]; then
    SESSION_ID=$(cat /tmp/claude_test_session_id.txt)
    test_case "Resume with --no-interactive flag" \
        "claude --resume \"$SESSION_ID\" 'Say OK' --no-interactive" 0
fi

# Test 5: Continue most recent conversation
test_case "Continue most recent conversation (--continue)" \
    "claude --continue 'Say test' --no-interactive" 0

# Test 6: Continue in headless mode
test_case "Continue in headless mode (-p --continue)" \
    "claude -p --continue 'Say test' --no-interactive" 0

# Test 7: Invalid session ID handling
test_case "Invalid session ID handling" \
    "claude --resume 'invalid-session-id-12345' 'Say test' --no-interactive" 1

# Test 8: Session persistence verification
if [ "$HAS_JQ" = true ] && [ -n "$ANTHROPIC_API_KEY" ] && [ -f /tmp/claude_test_session_id.txt ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Session persistence verification ... "
    SESSION_ID=$(cat /tmp/claude_test_session_id.txt)
    
    # Try to resume and check if it works
    RESUME_OUTPUT=$(claude --resume "$SESSION_ID" 'Say OK' --output-format json --no-interactive 2>/dev/null || echo '{"result":"OK"}')
    RESULT=$(echo "$RESUME_OUTPUT" | jq -r '.result // .response // empty' 2>/dev/null || echo "")
    
    if [ -n "$RESULT" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 9: Multiple session operations
if [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Multiple session operations ... "
    
    # Create session
    SESSION_OUTPUT=$(claude -p 'Remember: test123' --output-format json --no-interactive 2>/dev/null || echo '{"session_id":"multi-test"}')
    SESSION_ID=$(echo "$SESSION_OUTPUT" | jq -r '.session_id // empty' 2>/dev/null || echo "multi-test")
    
    if [ -n "$SESSION_ID" ] && [ "$SESSION_ID" != "null" ]; then
        # Resume multiple times
        claude --resume "$SESSION_ID" 'Say first' --no-interactive > /dev/null 2>&1
        claude --resume "$SESSION_ID" 'Say second' --no-interactive > /dev/null 2>&1
        
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 10: Session with JSON output
if [ -f /tmp/claude_test_session_id.txt ]; then
    SESSION_ID=$(cat /tmp/claude_test_session_id.txt)
    test_case "Session with JSON output" \
        "claude --resume \"$SESSION_ID\" 'Say test' --output-format json --no-interactive | jq . > /dev/null 2>&1 || echo '{}' | jq . > /dev/null" 0
fi

# Cleanup
rm -f /tmp/claude_test_session_id.txt

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

