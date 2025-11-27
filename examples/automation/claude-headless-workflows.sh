#!/bin/bash
# Claude Headless Mode Workflows
# Demonstrates various headless mode patterns for automation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo -e "${RED}Error: Claude CLI not found. Install with: npm install -g @anthropic-ai/claude-code${NC}"
    exit 1
fi

# Check if API key is set
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Warning: ANTHROPIC_API_KEY not set. Some operations may fail.${NC}"
fi

echo -e "${GREEN}=== Claude Headless Mode Workflows ===${NC}\n"

# Example 1: Basic headless execution
echo -e "${YELLOW}Example 1: Basic Headless Execution${NC}"
echo "Command: claude -p 'Explain what headless mode means' --permission-mode bypassPermissions"
claude -p "Explain what headless mode means in one sentence" --permission-mode bypassPermissions || echo "Command failed (API key may be required)"
echo ""

# Example 2: JSON output for automation
echo -e "${YELLOW}Example 2: JSON Output for Automation${NC}"
echo "Command: claude -p 'What is 2+2?' --output-format json --permission-mode bypassPermissions"
RESULT=$(claude -p "What is 2+2? Answer with just the number." --output-format json --permission-mode bypassPermissions 2>/dev/null || echo '{"type":"result","subtype":"error","result":"Command failed"}')
echo "$RESULT" | jq '.' 2>/dev/null || echo "$RESULT"
echo ""

# Example 3: Session management
echo -e "${YELLOW}Example 3: Session Management${NC}"
echo "Creating initial session..."
SESSION_OUTPUT=$(claude -p "Remember the number 42. Respond with just 'OK'." --output-format json --permission-mode bypassPermissions 2>/dev/null || echo '{"session_id":"test"}')
SESSION_ID=$(echo "$SESSION_OUTPUT" | jq -r '.session_id // empty' 2>/dev/null || echo "")

if [ -n "$SESSION_ID" ] && [ "$SESSION_ID" != "null" ] && [ "$SESSION_ID" != "" ]; then
    echo "Session ID: $SESSION_ID"
    echo "Resuming session..."
    claude -p --resume "$SESSION_ID" "What number did I ask you to remember?" --permission-mode bypassPermissions || echo "Resume failed"
else
    echo "Could not extract session ID (API key may be required)"
fi
echo ""

# Example 4: Tool control
echo -e "${YELLOW}Example 4: Tool Control${NC}"
echo "Command with allowed tools:"
claude -p "List files in current directory" \
    --allowedTools "Bash" \
    --permission-mode bypassPermissions \
    --output-format json 2>/dev/null || echo "Command failed (API key may be required)"
echo ""

# Example 5: Streaming JSON output
echo -e "${YELLOW}Example 5: Streaming JSON Output${NC}"
echo "Command: claude -p 'Count to 3' --output-format stream-json --permission-mode bypassPermissions"
echo "Streaming events (first 3 lines):"
claude -p "Count to 3, one number per line" --output-format stream-json --permission-mode bypassPermissions 2>/dev/null | head -3 || echo "Streaming failed (API key may be required)"
echo ""

# Example 6: Multi-turn conversation with input format
echo -e "${YELLOW}Example 6: Multi-turn Conversation${NC}"
echo "Using streaming JSON input format:"
echo '{"type":"user","message":{"role":"user","content":[{"type":"text","text":"Say hello"}]}}' | \
    claude -p --output-format=stream-json --input-format=stream-json --permission-mode bypassPermissions 2>/dev/null | head -2 || echo "Multi-turn failed (API key may be required)"
echo ""

# Example 7: System prompt customization
echo -e "${YELLOW}Example 7: System Prompt Customization${NC}"
echo "Command with custom system prompt:"
claude -p "What is your role?" \
    --append-system-prompt "You are a helpful coding assistant." \
    --permission-mode bypassPermissions \
    --output-format json 2>/dev/null || echo "Command failed (API key may be required)"
echo ""

# Example 8: Error handling in automation
echo -e "${YELLOW}Example 8: Error Handling${NC}"
echo "Testing error handling with invalid input:"
if claude -p "" --permission-mode bypassPermissions --output-format json 2>/dev/null; then
    echo "Command succeeded"
else
    echo "Command failed as expected (empty prompt)"
fi
echo ""

# Example 9: Cost tracking
echo -e "${YELLOW}Example 9: Cost Tracking${NC}"
echo "Extracting cost from JSON response:"
COST_OUTPUT=$(claude -p "Say 'test'" --output-format json --permission-mode bypassPermissions 2>/dev/null || echo '{"total_cost_usd":0}')
COST=$(echo "$COST_OUTPUT" | jq -r '.total_cost_usd // "N/A"' 2>/dev/null || echo "N/A")
echo "Cost: $COST USD"
echo ""

# Example 10: CI/CD pattern
echo -e "${YELLOW}Example 10: CI/CD Pattern${NC}"
echo "Simulating CI/CD workflow:"
set +e  # Don't exit on error for this example
CI_RESULT=$(claude -p "Analyze this code: echo 'hello'" \
    --output-format json \
    --permission-mode bypassPermissions \
    --append-system-prompt "You are a code reviewer. Provide brief feedback." \
    --allowedTools "Read" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$CI_RESULT" ]; then
    REVIEW=$(echo "$CI_RESULT" | jq -r '.result // .response // "Review completed"' 2>/dev/null || echo "Review completed")
    echo "Review result: $REVIEW"
    echo "Exit code: 0 (success)"
else
    echo "Review failed or API key not set"
    echo "Exit code: 1 (failure)"
fi
set -e
echo ""

echo -e "${GREEN}=== Workflows Complete ===${NC}"
echo ""
echo "Note: Some examples may fail if ANTHROPIC_API_KEY is not set."
echo "Set your API key with: export ANTHROPIC_API_KEY=your_key_here"

