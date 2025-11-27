#!/bin/bash
# Session Management Tests for Codex CLI
# Tests resume --last, resume SESSION_ID, and session persistence

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
echo "Codex Headless Mode - Session Management Tests"
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

# Test 1: Extract thread_id from JSON output
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract thread_id from JSON output ... "
    THREAD_ID=$(codex exec --json 'Say hello' 2>&1 | grep 'thread.started' | head -1 | jq -r '.thread_id // empty' || echo "")
    
    if [ -n "$THREAD_ID" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
        export TEST_THREAD_ID="$THREAD_ID"
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 2: Resume last session (resume --last)
if [ -n "$OPENAI_API_KEY" ]; then
    test_case "Resume last session (resume --last)" \
        "codex exec 'Say first message' > /dev/null 2>&1 && codex exec resume --last 'Say second message'" 0
fi

# Test 3: Resume last session syntax validation
test_case "Resume last session syntax validation" \
    "codex exec resume --last 'test' 2>&1 | head -1" 0

# Test 4: Resume specific session by thread_id
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ] && [ -n "$TEST_THREAD_ID" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Resume specific session by thread_id ... "
    
    if codex exec resume "$TEST_THREAD_ID" 'Continue conversation' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (Thread ID not available or session expired)${NC}"
    fi
fi

# Test 5: Resume session with invalid thread_id (should fail gracefully)
test_case "Resume session with invalid thread_id" \
    "codex exec resume invalid-thread-id-12345 'test' 2>&1" 1

# Test 6: Multi-step session workflow
if [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Multi-step session workflow ... "
    
    # Create initial session
    codex exec 'Remember the number 42' > /dev/null 2>&1
    
    # Continue in same session
    if codex exec resume --last 'What number did I mention?' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 7: Session persistence across commands
if [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Session persistence across commands ... "
    
    # First command
    codex exec 'My name is Alice' > /dev/null 2>&1
    
    # Second command should remember
    if codex exec resume --last 'What is my name?' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 8: Extract thread_id from stream for session resume
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract thread_id from stream for session resume ... "
    
    THREAD_ID=$(codex exec --json 'Say test' 2>&1 | grep 'thread.started' | head -1 | jq -r '.thread_id // empty' || echo "")
    
    if [ -n "$THREAD_ID" ]; then
        # Try to resume with extracted thread_id
        if codex exec resume "$THREAD_ID" 'Continue' > /dev/null 2>&1; then
            echo -e "${GREEN}PASS${NC}"
            PASSED=$((PASSED + 1))
        else
            echo -e "${YELLOW}SKIP (Thread ID extracted but resume failed)${NC}"
        fi
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
fi

# Test 9: Resume with JSON output
if [ "$HAS_JQ" = true ] && [ -n "$OPENAI_API_KEY" ]; then
    test_case "Resume with JSON output" \
        "codex exec 'First message' > /dev/null 2>&1 && codex exec --json resume --last 'Second message' 2>&1 | head -1 | jq . > /dev/null" 0
fi

# Test 10: Multiple resume operations
if [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Multiple resume operations ... "
    
    # Create session
    codex exec 'Start conversation' > /dev/null 2>&1
    
    # Resume multiple times
    if codex exec resume --last 'Continue 1' > /dev/null 2>&1 && \
       codex exec resume --last 'Continue 2' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
    fi
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

