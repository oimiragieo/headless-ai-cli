#!/bin/bash
# Advanced Headless Mode Tests for Aider CLI
# Tests advanced features: model selection, API keys, Git integration, error handling

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
    
    # Run command and capture exit code
    eval "$command" > /dev/null 2>&1
    local exit_code=$?
    
    if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
        if [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
            echo -e "${YELLOW}SKIP (API key not set)${NC}"
            SKIPPED=$((SKIPPED + 1))
        else
            echo -e "${GREEN}PASS${NC}"
            PASSED=$((PASSED + 1))
        fi
    else
        echo -e "${RED}FAIL (exit code: $exit_code, expected: $expected_exit)${NC}"
        FAILED=$((FAILED + 1))
    fi
}

echo "=========================================="
echo "Aider Headless Mode - Advanced Tests"
echo "=========================================="
echo ""

# Check if Aider CLI is installed
if ! command -v aider &> /dev/null; then
    echo -e "${RED}Error: Aider CLI not found. Install with: pip install aider-chat${NC}"
    exit 1
fi

# Check if API key is set
if [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Warning: OPENAI_API_KEY or ANTHROPIC_API_KEY not set. Tests will be skipped.${NC}"
    echo ""
fi

# Create temporary test directory
TEST_DIR=$(mktemp -d /tmp/aider_test_XXXXXX)
cd "$TEST_DIR"

# Initialize Git repo for Git integration tests
git init > /dev/null 2>&1 || true
git config user.email "test@example.com" > /dev/null 2>&1 || true
git config user.name "Test User" > /dev/null 2>&1 || true

# Create test files
cat > test_file.py << 'EOF'
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b
EOF

# Test 1: Model selection - OpenAI models
if [ -n "$OPENAI_API_KEY" ]; then
    test_case "Model selection - gpt-4o" \
        "aider --yes --model gpt-4o --message 'Add docstrings' test_file.py" 0
    
    test_case "Model selection - o1" \
        "aider --yes --model o1 --message 'Add type hints' test_file.py" 0
else
    echo -e "${YELLOW}Test 1-2: Model selection (OpenAI) ... SKIP (OPENAI_API_KEY not set)${NC}"
    SKIPPED=$((SKIPPED + 2))
    test_count=$((test_count + 2))
fi

# Test 3: Model selection - Anthropic models
if [ -n "$ANTHROPIC_API_KEY" ]; then
    test_case "Model selection - claude-3.7-sonnet" \
        "aider --yes --model claude-3.7-sonnet --message 'Add docstrings' test_file.py" 0
    
    test_case "Model selection - claude-3-opus" \
        "aider --yes --model claude-3-opus --message 'Add type hints' test_file.py" 0
else
    echo -e "${YELLOW}Test 3-4: Model selection (Anthropic) ... SKIP (ANTHROPIC_API_KEY not set)${NC}"
    SKIPPED=$((SKIPPED + 2))
    test_count=$((test_count + 2))
fi

# Test 5: API key override
if [ -n "$OPENAI_API_KEY" ]; then
    test_case "API key override - OpenAI" \
        "aider --yes --model gpt-4o --api-key openai=$OPENAI_API_KEY --message 'Add comments' test_file.py" 0
else
    echo -e "${YELLOW}Test 5: API key override ... SKIP (OPENAI_API_KEY not set)${NC}"
    SKIPPED=$((SKIPPED + 1))
    test_count=$((test_count + 1))
fi

# Test 6: Git integration (default)
test_case "Git integration (default)" \
    "aider --yes --message 'Add docstrings' test_file.py" 0

# Test 7: No Git integration
test_case "No Git integration (--no-git)" \
    "aider --yes --no-git --message 'Add comments' test_file.py" 0

# Test 8: Multiple files with different operations
cat > test_file2.py << 'EOF'
def multiply(a, b):
    return a * b
EOF

test_case "Multiple files processing" \
    "aider --yes --message 'Add type hints to all functions' test_file.py test_file2.py" 0

# Test 9: Directory-based processing (requires Git)
test_case "Directory-based processing" \
    "aider --yes --message 'Add docstrings' ." 0

# Test 10: Error handling - invalid file
test_case "Error handling - invalid file" \
    "aider --yes --message 'test' /nonexistent/file.py" 1

# Test 11: Error handling - invalid model
test_case "Error handling - invalid model" \
    "aider --yes --model invalid-model-name --message 'test' test_file.py" 1

# Test 12: Complex prompt with multiple requirements
test_case "Complex prompt processing" \
    "aider --yes --message 'Add docstrings, type hints, and error handling to all functions' test_file.py" 0

# Test 13: Stdin with complex input
test_case "Stdin with complex input" \
    "echo 'Refactor to use async/await patterns and add comprehensive error handling' | aider --yes test_file.py" 0

# Test 14: Combined advanced options
test_case "Combined advanced options" \
    "aider --yes --no-git --model gpt-4o --message 'Add comprehensive documentation' test_file.py" 0

# Cleanup
cd - > /dev/null
rm -rf "$TEST_DIR"

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

