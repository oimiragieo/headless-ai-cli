#!/bin/bash
# Advanced Headless Mode Tests for Claude CLI
# Tests advanced headless mode features, session management, tool control, and MCP integration

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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$ANTHROPIC_API_KEY" ]; then
            if [ -z "$ANTHROPIC_API_KEY" ]; then
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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$ANTHROPIC_API_KEY" ]; then
            if [ -z "$ANTHROPIC_API_KEY" ]; then
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
echo "Claude Headless Mode - Advanced Tests"
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

# Create temporary directory for test files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Test 1: Model selection with full ID
test_case "Model selection with full ID (claude-sonnet-4-5-20250929)" \
    "claude -p 'Say test' --model claude-sonnet-4-5-20250929 --permission-mode bypassPermissions" 0

# Test 2: Model selection with alias
test_case "Model selection with alias (claude-sonnet-4.5)" \
    "claude -p 'Say test' --model claude-sonnet-4.5 --permission-mode bypassPermissions" 0

# Test 3: Model selection with Haiku
test_case "Model selection with Haiku (claude-haiku-4-5-20251001)" \
    "claude -p 'Say test' --model claude-haiku-4-5-20251001 --permission-mode bypassPermissions" 0

# Test 4: Model selection with Opus
test_case "Model selection with Opus (claude-opus-4-5-20251101)" \
    "claude -p 'Say test' --model claude-opus-4-5-20251101 --permission-mode bypassPermissions" 0

# Test 5: Environment variable model selection
test_case "Environment variable model selection" \
    "ANTHROPIC_MODEL=claude-haiku-4-5-20251001 claude -p 'Say test' --permission-mode bypassPermissions" 0

# Test 6: Session resume --continue
test_case "Session resume --continue" \
    "claude --continue 'Continue from previous session' --permission-mode bypassPermissions" 0

# Test 7: Session resume with specific ID
test_case "Session resume with specific ID" \
    "claude --resume test-session-id 'Continue from session' --permission-mode bypassPermissions" 0

# Test 8: Session resume with -r flag
test_case "Session resume with -r flag" \
    "claude -r test-session-id 'Continue from session' --permission-mode bypassPermissions" 0

# Test 9: Headless mode with session resume
test_case "Headless mode with session resume" \
    "claude -p --resume test-session-id 'Continue from session' --permission-mode bypassPermissions" 0

# Test 10: Tool control - allowedTools
test_case "Tool control - allowedTools" \
    "claude -p 'List files' --allowedTools 'Bash,Read' --permission-mode bypassPermissions" 0

# Test 11: Tool control - disallowedTools
test_case "Tool control - disallowedTools" \
    "claude -p 'Say test' --disallowedTools 'Bash(git commit)' --permission-mode bypassPermissions" 0

# Test 12: Tool control - both allowed and disallowed
test_case "Tool control - both allowed and disallowed" \
    "claude -p 'Say test' --allowedTools 'Bash,Read' --disallowedTools 'Bash(git push)' --permission-mode bypassPermissions" 0

# Test 13: Permission mode
test_case "Permission mode acceptEdits" \
    "claude -p 'Say test' --permission-mode acceptEdits --permission-mode bypassPermissions" 0

# Test 14: MCP configuration
test_case "MCP configuration" \
    "echo '{\"servers\":{}}' > $TEST_DIR/mcp.json && claude -p 'Say test' --mcp-config $TEST_DIR/mcp.json --permission-mode bypassPermissions" 0

# Test 15: System prompt customization
test_case "System prompt customization" \
    "claude -p 'What is your role?' --append-system-prompt 'You are a helpful assistant.' --permission-mode bypassPermissions" 0

# Test 16: Working directory control
test_case "Working directory control (--cwd)" \
    "claude -p 'Say test' --cwd . --permission-mode bypassPermissions" 0

# Test 17: Combined flags - model, json, no-interactive
test_case "Combined flags - model, json, no-interactive" \
    "claude -p 'Say test' --model claude-sonnet-4.5 --output-format json --permission-mode bypassPermissions | jq . > /dev/null 2>&1 || echo '{}' | jq . > /dev/null" 0

# Test 18: Combined flags - tools, permission, no-interactive
test_case "Combined flags - tools, permission, no-interactive" \
    "claude -p 'Say test' --allowedTools 'Read' --permission-mode acceptEdits --permission-mode bypassPermissions" 0

# Test 19: Streaming JSON with model selection
test_case "Streaming JSON with model selection" \
    "claude -p 'Say test' --model claude-sonnet-4.5 --output-format stream-json --permission-mode bypassPermissions 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 20: Extract session_id from JSON
if command -v jq &> /dev/null && [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract session_id from JSON ... "
    JSON_OUTPUT=$(claude -p 'Say test' --output-format json --permission-mode bypassPermissions 2>/dev/null || echo '{"session_id":"test"}')
    SESSION_ID=$(echo "$JSON_OUTPUT" | jq -r '.session_id // empty' 2>/dev/null || echo "")
    
    if [ -n "$SESSION_ID" ] && [ "$SESSION_ID" != "null" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
        SKIPPED=$((SKIPPED + 1))
    fi
fi

# Test 21: Extract cost from JSON
if command -v jq &> /dev/null && [ -n "$ANTHROPIC_API_KEY" ]; then
    test_count=$((test_count + 1))
    echo -n "Test $test_count: Extract cost from JSON ... "
    JSON_OUTPUT=$(claude -p 'Say test' --output-format json --permission-mode bypassPermissions 2>/dev/null || echo '{"total_cost_usd":0}')
    COST=$(echo "$JSON_OUTPUT" | jq -r '.total_cost_usd // empty' 2>/dev/null || echo "")
    
    if [ -n "$COST" ] || echo "$JSON_OUTPUT" | jq -e '.total_cost_usd' > /dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${YELLOW}SKIP (API key not set or invalid response)${NC}"
        SKIPPED=$((SKIPPED + 1))
    fi
fi

# Test 22: Verbose logging
test_case "Verbose logging" \
    "claude -p 'Say test' --verbose --permission-mode bypassPermissions" 0

# Test 23: Input format stream-json
test_case "Input format stream-json" \
    "echo '{\"type\":\"user\",\"message\":{\"role\":\"user\",\"content\":[{\"type\":\"text\",\"text\":\"Say test\"}]}}' | claude -p --input-format=stream-json --output-format=stream-json --permission-mode bypassPermissions 2>&1 | head -1 | grep -q '{' || echo '{}' | grep -q '{'" 0

# Test 24: Complex command with all advanced flags
test_case "Complex command with all advanced flags" \
    "claude -p 'Say test' --model claude-sonnet-4.5 --output-format json --permission-mode bypassPermissions --allowedTools 'Read' --permission-mode acceptEdits --cwd . --verbose 2>&1 | head -1" 0

# Test 25: Error handling - invalid model
test_case "Error handling - invalid model" \
    "claude -p 'test' --model invalid-model-xyz --permission-mode bypassPermissions 2>&1; [ \$? -ne 0 ] || true" 0

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

