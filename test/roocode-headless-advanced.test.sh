#!/bin/bash
# Advanced Headless Mode Tests for RooCode CLI
# Tests advanced features: MCP server, Memory Bank, file processing, error handling

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
echo "RooCode Headless Mode - Advanced Tests"
echo "=========================================="
echo ""

# Check if RooCode CLI is installed
if ! command -v roocode &> /dev/null; then
    echo -e "${RED}Error: RooCode CLI not found.${NC}"
    exit 1
fi

# Check if API key is set
if [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Warning: OPENAI_API_KEY or ANTHROPIC_API_KEY not set. Tests will be skipped.${NC}"
    echo ""
fi

# Create temporary test directory
TEST_DIR=$(mktemp -d /tmp/roocode_test_XXXXXX)
cd "$TEST_DIR"

# Create test files
cat > main.py << 'EOF'
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b
EOF

cat > utils.py << 'EOF'
def helper_function():
    pass
EOF

# Test 1: Model selection - OpenAI models
if [ -n "$OPENAI_API_KEY" ]; then
    test_case "Model selection - gpt-4o" \
        "roocode --prompt 'Add docstrings' --file main.py --model gpt-4o" 0
    
    test_case "Model selection - o1" \
        "roocode --prompt 'Add type hints' --file main.py --model o1" 0
else
    echo -e "${YELLOW}Test 1-2: Model selection (OpenAI) ... SKIP (OPENAI_API_KEY not set)${NC}"
    SKIPPED=$((SKIPPED + 2))
    test_count=$((test_count + 2))
fi

# Test 3: Model selection - Anthropic models
if [ -n "$ANTHROPIC_API_KEY" ]; then
    test_case "Model selection - claude-3.7-sonnet" \
        "roocode --prompt 'Add docstrings' --file main.py --model claude-3.7-sonnet" 0
    
    test_case "Model selection - claude-3-opus" \
        "roocode --prompt 'Add type hints' --file main.py --model claude-3-opus" 0
else
    echo -e "${YELLOW}Test 3-4: Model selection (Anthropic) ... SKIP (ANTHROPIC_API_KEY not set)${NC}"
    SKIPPED=$((SKIPPED + 2))
    test_count=$((test_count + 2))
fi

# Test 5: MCP server commands (if available)
if command -v roocode &> /dev/null && roocode mcp --help &> /dev/null; then
    test_case "MCP server setup" \
        "roocode mcp setup" 0
    
    test_case "MCP server status" \
        "roocode mcp status" 0
else
    echo -e "${YELLOW}Test 5-6: MCP server commands ... SKIP (MCP commands not available)${NC}"
    SKIPPED=$((SKIPPED + 2))
    test_count=$((test_count + 2))
fi

# Test 7: Headless mode with MCP server
test_case "Headless mode with MCP server" \
    "roocode --headless --prompt 'Add comments' --file main.py" 0

# Test 8: Multiple files with different operations
test_case "Multiple files processing" \
    "roocode --prompt 'Add type hints to all functions' --files main.py utils.py" 0

# Test 9: Directory-based processing
test_case "Directory-based processing" \
    "roocode --prompt 'Add docstrings' --directory ." 0

# Test 10: Error handling - invalid file
test_case "Error handling - invalid file" \
    "roocode --prompt 'test' --file /nonexistent/file.py" 1

# Test 11: Error handling - invalid directory
test_case "Error handling - invalid directory" \
    "roocode --prompt 'test' --directory /nonexistent/dir" 1

# Test 12: Complex prompt with multiple requirements
test_case "Complex prompt processing" \
    "roocode --prompt 'Add docstrings, type hints, and error handling to all functions' --file main.py" 0

# Test 13: Stdin with complex input
test_case "Stdin with complex input" \
    "echo 'Refactor to use async/await patterns and add comprehensive error handling' | roocode --file main.py" 0

# Test 14: Combined advanced options
OUTPUT_FILE=$(mktemp /tmp/roocode_output_XXXXXX.txt)
test_case "Combined advanced options" \
    "roocode --headless --prompt 'Add comprehensive documentation' --file main.py --output '$OUTPUT_FILE'" 0
rm -f "$OUTPUT_FILE" 2>/dev/null || true

# Test 15: Memory Bank commands (if available)
if command -v roocode &> /dev/null && roocode memory-bank --help &> /dev/null; then
    test_case "Memory Bank init" \
        "roocode memory-bank init" 0
else
    echo -e "${YELLOW}Test 15: Memory Bank commands ... SKIP (Memory Bank commands not available)${NC}"
    SKIPPED=$((SKIPPED + 1))
    test_count=$((test_count + 1))
fi

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

