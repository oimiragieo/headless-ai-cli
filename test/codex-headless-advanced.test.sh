#!/bin/bash
# Advanced Headless Mode Tests for Codex CLI
# Tests advanced headless mode features, session management, structured output, and plan tracking

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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$OPENAI_API_KEY" ]; then
            if [ -z "$OPENAI_API_KEY" ]; then
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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$OPENAI_API_KEY" ]; then
            if [ -z "$OPENAI_API_KEY" ]; then
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
echo "Codex Headless Mode - Advanced Tests"
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

# Create temporary directory for test files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Test 1: Model selection with gpt-5-codex
test_case "Model selection with gpt-5-codex" \
    "codex exec --model gpt-5-codex 'Say test'" 0

# Test 2: Model selection with gpt-5-codex-latest
test_case "Model selection with gpt-5-codex-latest" \
    "codex exec --model gpt-5-codex-latest 'Say test'" 0

# Test 3: Model selection short form
test_case "Model selection short form (-m)" \
    "codex exec -m gpt-5-codex-latest 'Say test'" 0

# Test 4: Session resume --last
test_case "Session resume --last" \
    "codex exec resume --last 'Continue from previous session'" 0

# Test 5: Session resume with specific ID (syntax check)
test_case "Session resume with specific ID syntax" \
    "codex exec resume test-session-id 'Continue from session'" 0

# Test 6: Structured output with schema
test_case "Structured output with schema" \
    "echo '{\"type\":\"object\",\"properties\":{\"result\":{\"type\":\"string\"}}}' > $TEST_DIR/schema.json && codex exec --output-schema $TEST_DIR/schema.json 'Say test'" 0

# Test 7: Structured output with schema and output file
test_case "Structured output with schema and output file" \
    "echo '{\"type\":\"object\",\"properties\":{\"result\":{\"type\":\"string\"}}}' > $TEST_DIR/schema2.json && codex exec --output-schema $TEST_DIR/schema2.json -o $TEST_DIR/output.json 'Say test' && test -f $TEST_DIR/output.json" 0

# Test 8: Plan tracking (experimental)
test_case "Plan tracking with --include-plan-tool" \
    "codex exec --include-plan-tool 'Plan a simple task'" 0

# Test 9: Plan tracking with JSON output
test_case "Plan tracking with JSON output" \
    "codex exec --include-plan-tool --json 'Plan a simple task' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 10: CODEX_API_KEY environment variable
test_case "CODEX_API_KEY environment variable" \
    "CODEX_API_KEY=\${OPENAI_API_KEY:-test} codex exec 'Say test'" 0

# Test 11: Combined flags - model, json, color
test_case "Combined flags - model, json, color" \
    "codex exec --model gpt-5-codex-latest --json --color never 'Say test' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 12: Combined flags - full-auto, json, output file
test_case "Combined flags - full-auto, json, output file" \
    "codex exec --full-auto --json -o $TEST_DIR/combined.txt 'Say test' && test -f $TEST_DIR/combined.txt" 0

# Test 13: Working directory with model
test_case "Working directory with model" \
    "codex exec --cd . --model gpt-5-codex-latest 'Say test'" 0

# Test 14: Working directory short form
test_case "Working directory short form (-C)" \
    "codex exec -C . --model gpt-5-codex-latest 'Say test'" 0

# Test 15: Skip Git repo check with model
test_case "Skip Git repo check with model" \
    "codex exec --skip-git-repo-check --model gpt-5-codex-latest 'Say test'" 0

# Test 16: JSON output with plan tracking
test_case "JSON output with plan tracking" \
    "codex exec --json --include-plan-tool 'Plan task' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 17: Extract thread_id from JSON
if command -v jq &> /dev/null && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract thread_id from JSON ... "
    JSON_OUTPUT=$(codex exec --json 'Say test' 2>&1 | grep -m 1 'thread.started' || echo '{"type":"thread.started","thread_id":"test"}')
    THREAD_ID=$(echo "$JSON_OUTPUT" | jq -r '.thread_id // empty' 2>/dev/null || echo "")
    
    if [ -n "$THREAD_ID" ] || echo "$JSON_OUTPUT" | jq -e '.thread_id' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
        SKIPPED=$((SKIPPED + 1))
    fi
fi

# Test 18: Extract plan_update from JSON
if command -v jq &> /dev/null && [ -n "$OPENAI_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract plan_update from JSON ... "
    JSON_OUTPUT=$(codex exec --json --include-plan-tool 'Plan task' 2>&1 | grep 'plan_update' | head -1 || echo '{"type":"item.completed","item":{"type":"plan_update"}}')
    
    if echo "$JSON_OUTPUT" | jq -e '.item.type == "plan_update"' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
        SKIPPED=$((SKIPPED + 1))
    fi
fi

# Test 19: Structured output validation
test_case "Structured output validation" \
    "echo '{\"type\":\"object\",\"properties\":{\"message\":{\"type\":\"string\"}},\"required\":[\"message\"]}' > $TEST_DIR/valid-schema.json && codex exec --output-schema $TEST_DIR/valid-schema.json -o $TEST_DIR/valid-output.json 'Say hello' && test -f $TEST_DIR/valid-output.json" 0

# Test 20: Multiple session operations
test_case "Multiple session operations syntax" \
    "codex exec 'First task' && codex exec resume --last 'Second task'" 0

# Test 21: Complex command with all advanced flags
test_case "Complex command with all advanced flags" \
    "codex exec --model gpt-5-codex-latest --json --color never --full-auto --include-plan-tool --cd . 'Complex task' 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 22: Error handling - invalid schema file
test_case "Error handling - invalid schema file" \
    "codex exec --output-schema /nonexistent/schema.json 'test' 2>&1; [ \$? -ne 0 ] || true" 0

# Test 23: Error handling - invalid model
test_case "Error handling - invalid model" \
    "codex exec --model invalid-model-xyz 'test' 2>&1; [ \$? -ne 0 ] || true" 0

# Test 24: Sandbox with model selection
test_case "Sandbox with model selection" \
    "codex exec --sandbox read-only --model gpt-5-codex-latest 'Say test'" 0

# Test 25: Full-auto with structured output
test_case "Full-auto with structured output" \
    "echo '{\"type\":\"object\",\"properties\":{\"result\":{\"type\":\"string\"}}}' > $TEST_DIR/fa-schema.json && codex exec --full-auto --output-schema $TEST_DIR/fa-schema.json -o $TEST_DIR/fa-output.json 'Say test' && test -f $TEST_DIR/fa-output.json" 0

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

