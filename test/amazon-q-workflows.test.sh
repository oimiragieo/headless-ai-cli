#!/bin/bash
# Workflow Automation Tests for Amazon Q Developer CLI
# Tests common workflow patterns: code review, transformation, testing, documentation

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
echo "Amazon Q Developer Workflow Automation Tests"
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
TEST_DIR=$(mktemp -d /tmp/amazonq_workflow_test_XXXXXX)
cd "$TEST_DIR"

# Create test files for workflows
cat > calculator.py << 'EOF'
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    return a / b
EOF

# Test 1: Code review workflow
test_case "Code review workflow" \
    "q chat --prompt 'Review this code for bugs, security issues, and best practices' --file calculator.py" 0

# Test 2: Code transformation workflow
test_case "Code transformation workflow" \
    "q chat --prompt 'Refactor all functions to use type hints' --file calculator.py" 0

# Test 3: Documentation generation workflow
test_case "Documentation generation workflow" \
    "q chat --prompt 'Add comprehensive docstrings following Google style guide to all functions' --file calculator.py" 0

# Test 4: Test generation workflow
cat > test_calculator.py << 'EOF'
# Placeholder for tests
EOF

test_case "Test generation workflow" \
    "q chat --prompt 'Generate comprehensive unit tests with 80%+ coverage for calculator.py' --files calculator.py test_calculator.py" 0

# Test 5: Code quality improvement workflow
test_case "Code quality improvement workflow" \
    "q chat --prompt 'Improve code quality: add error handling, input validation, and follow PEP 8' --file calculator.py" 0

# Test 6: Security enhancement workflow
test_case "Security enhancement workflow" \
    "q chat --prompt 'Add input validation and security checks to prevent division by zero and handle edge cases' --file calculator.py" 0

# Test 7: Multi-file refactoring workflow
cat > utils.py << 'EOF'
def helper_function():
    pass
EOF

test_case "Multi-file refactoring workflow" \
    "q chat --prompt 'Add type hints and docstrings to all functions in both files' --files calculator.py utils.py" 0

# Test 8: Batch processing workflow
test_case "Batch processing workflow" \
    "q chat --prompt 'Add logging statements to all functions' --files *.py" 0

# Test 9: Code review workflow (directory-based)
test_case "Code review workflow (directory-based)" \
    "q chat --prompt 'Review code for potential bugs, performance issues, and suggest improvements' --directory ." 0

# Test 10: Migration workflow
test_case "Migration workflow" \
    "q chat --prompt 'Convert all functions to use async/await patterns' --file calculator.py" 0

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

