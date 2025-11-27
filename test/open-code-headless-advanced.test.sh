#!/bin/bash
# Advanced Headless Mode Tests for OpenCode CLI
# Tests advanced features: model selection, file processing, directory analysis, error handling

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
echo "OpenCode Headless Mode - Advanced Tests"
echo "=========================================="
echo ""

# Check if OpenCode CLI is installed
if ! command -v opencode &> /dev/null; then
    echo -e "${RED}Error: OpenCode CLI not found.${NC}"
    exit 1
fi

# Check if API key is set
if [ -z "$OPENAI_API_KEY" ] && [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Warning: OPENAI_API_KEY or ANTHROPIC_API_KEY not set. Tests will be skipped.${NC}"
    echo ""
fi

# Create temporary test directory
TEST_DIR=$(mktemp -d /tmp/opencode_test_XXXXXX)
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
        "opencode --headless --prompt 'Add docstrings' --file main.py --model gpt-4o" 0
    
    test_case "Model selection - o1" \
        "opencode --headless --prompt 'Add type hints' --file main.py --model o1" 0
else
    echo -e "${YELLOW}Test 1-2: Model selection (OpenAI) ... SKIP (OPENAI_API_KEY not set)${NC}"
    SKIPPED=$((SKIPPED + 2))
    test_count=$((test_count + 2))
fi

# Test 3: Model selection - Anthropic models
if [ -n "$ANTHROPIC_API_KEY" ]; then
    test_case "Model selection - claude-3.7-sonnet" \
        "opencode --headless --prompt 'Add docstrings' --file main.py --model claude-3.7-sonnet" 0
    
    test_case "Model selection - claude-3-opus" \
        "opencode --headless --prompt 'Add type hints' --file main.py --model claude-3-opus" 0
else
    echo -e "${YELLOW}Test 3-4: Model selection (Anthropic) ... SKIP (ANTHROPIC_API_KEY not set)${NC}"
    SKIPPED=$((SKIPPED + 2))
    test_count=$((test_count + 2))
fi

# Test 5: Code review workflow
test_case "Code review workflow" \
    "opencode --headless --prompt 'Review this code for bugs, security issues, and best practices' --file main.py" 0

# Test 6: Code transformation workflow
test_case "Code transformation workflow" \
    "opencode --headless --prompt 'Add type hints to all functions' --file main.py" 0

# Test 7: Documentation generation workflow
test_case "Documentation generation workflow" \
    "opencode --headless --prompt 'Add comprehensive docstrings following Google style guide' --file main.py" 0

# Test 8: Multi-file processing
test_case "Multiple files processing" \
    "opencode --headless --prompt 'Add type hints to all functions' --files main.py utils.py" 0

# Test 9: Directory-based processing
test_case "Directory-based processing" \
    "opencode --headless --prompt 'Add docstrings' --directory ." 0

# Test 10: Code generation with output
OUTPUT_FILE=$(mktemp /tmp/opencode_output_XXXXXX.txt)
test_case "Code generation with output file" \
    "opencode --headless --prompt 'Generate unit tests' --file main.py --output '$OUTPUT_FILE'" 0
rm -f "$OUTPUT_FILE" 2>/dev/null || true

# Test 11: Complex prompt processing
test_case "Complex prompt processing" \
    "opencode --headless --prompt 'Refactor code to use async/await patterns, add error handling, and improve code quality' --file main.py" 0

# Test 12: Security audit workflow
test_case "Security audit workflow" \
    "opencode --headless --prompt 'Perform security audit: identify vulnerabilities and suggest fixes' --directory ." 0

# Test 13: Error handling - invalid directory
test_case "Error handling - invalid directory" \
    "opencode --headless --prompt 'test' --directory /nonexistent/dir" 1

# Test 14: Error handling - invalid output path
test_case "Error handling - invalid output path" \
    "opencode --headless --prompt 'test' --file main.py --output /nonexistent/path/output.txt" 1

# Test 15: Combined advanced options
OUTPUT_FILE2=$(mktemp /tmp/opencode_output_XXXXXX.txt)
test_case "Combined advanced options" \
    "opencode --headless --prompt 'Add comprehensive documentation' --directory . --output '$OUTPUT_FILE2'" 0
rm -f "$OUTPUT_FILE2" 2>/dev/null || true

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

