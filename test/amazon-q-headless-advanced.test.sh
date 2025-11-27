#!/bin/bash
# Advanced Headless Mode Tests for Amazon Q Developer CLI
# Tests advanced features: file processing, directory analysis, error handling

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
    
    if [ "$exit_code" -eq "$expected_exit" ] || [ ! -d "$HOME/.amazonq" ] 2>/dev/null; then
        if [ ! -d "$HOME/.amazonq" ] 2>/dev/null; then
            echo -e "${YELLOW}SKIP (Not authenticated)${NC}"
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
echo "Amazon Q Developer Headless Mode - Advanced Tests"
echo "=========================================="
echo ""

# Check if Amazon Q Developer CLI is installed
if ! command -v q &> /dev/null; then
    echo -e "${RED}Error: Amazon Q Developer CLI not found.${NC}"
    exit 1
fi

# Check if authenticated
if [ ! -d "$HOME/.amazonq" ] 2>/dev/null; then
    echo -e "${YELLOW}Warning: Not authenticated. Run 'q login' first. Tests will be skipped.${NC}"
    echo ""
fi

# Create temporary test directory
TEST_DIR=$(mktemp -d /tmp/amazonq_test_XXXXXX)
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

# Test 1: Code review workflow
test_case "Code review workflow" \
    "q chat --prompt 'Review this code for bugs, security issues, and best practices' --file main.py" 0

# Test 2: Code transformation workflow
test_case "Code transformation workflow" \
    "q chat --prompt 'Add type hints to all functions' --file main.py" 0

# Test 3: Documentation generation workflow
test_case "Documentation generation workflow" \
    "q chat --prompt 'Add comprehensive docstrings following Google style guide' --file main.py" 0

# Test 4: Multi-file processing
test_case "Multi-file processing" \
    "q chat --prompt 'Add type hints and docstrings to all functions' --files main.py utils.py" 0

# Test 5: Directory-based analysis
test_case "Directory-based analysis" \
    "q chat --prompt 'Analyze codebase structure and suggest improvements' --directory ." 0

# Test 6: Code generation with output
OUTPUT_FILE=$(mktemp /tmp/amazonq_output_XXXXXX.txt)
test_case "Code generation with output file" \
    "q chat --prompt 'Generate unit tests' --file main.py --output '$OUTPUT_FILE'" 0
rm -f "$OUTPUT_FILE" 2>/dev/null || true

# Test 7: Complex prompt processing
test_case "Complex prompt processing" \
    "q chat --prompt 'Refactor code to use async/await patterns, add error handling, and improve code quality' --file main.py" 0

# Test 8: Security audit workflow
test_case "Security audit workflow" \
    "q chat --prompt 'Perform security audit: identify vulnerabilities and suggest fixes' --directory ." 0

# Test 9: Error handling - invalid directory
test_case "Error handling - invalid directory" \
    "q chat --prompt 'test' --directory /nonexistent/dir" 1

# Test 10: Error handling - invalid output path
test_case "Error handling - invalid output path" \
    "q chat --prompt 'test' --file main.py --output /nonexistent/path/output.txt" 1

# Test 11: Batch file processing
test_case "Batch file processing" \
    "q chat --prompt 'Add comprehensive documentation' --files *.py" 0

# Test 12: Stdin with file context
test_case "Stdin with file context" \
    "echo 'Add error handling' | q chat --file main.py" 0

# Test 13: Combined advanced options
OUTPUT_FILE2=$(mktemp /tmp/amazonq_output_XXXXXX.txt)
test_case "Combined advanced options" \
    "q chat --prompt 'Refactor and improve code' --directory . --output '$OUTPUT_FILE2'" 0
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

