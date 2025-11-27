#!/bin/bash
# Workflow Automation Tests for Aider CLI
# Tests common workflow patterns: code generation, refactoring, testing, documentation

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
echo "Aider Workflow Automation Tests"
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
TEST_DIR=$(mktemp -d /tmp/aider_workflow_test_XXXXXX)
cd "$TEST_DIR"

# Initialize Git repo
git init > /dev/null 2>&1 || true
git config user.email "test@example.com" > /dev/null 2>&1 || true
git config user.name "Test User" > /dev/null 2>&1 || true

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

# Test 1: Code generation workflow
test_case "Code generation workflow" \
    "aider --yes --message 'Generate a new function calculate_power(a, b) that raises a to the power of b' calculator.py" 0

# Test 2: Refactoring workflow
test_case "Refactoring workflow" \
    "aider --yes --message 'Refactor all functions to use type hints' calculator.py" 0

# Test 3: Documentation generation workflow
test_case "Documentation generation workflow" \
    "aider --yes --message 'Add comprehensive docstrings following Google style guide to all functions' calculator.py" 0

# Test 4: Test generation workflow
cat > test_calculator.py << 'EOF'
# Placeholder for tests
EOF

test_case "Test generation workflow" \
    "aider --yes --message 'Generate comprehensive unit tests with 80%+ coverage for calculator.py' test_calculator.py calculator.py" 0

# Test 5: Code quality improvement workflow
test_case "Code quality improvement workflow" \
    "aider --yes --message 'Improve code quality: add error handling, input validation, and follow PEP 8' calculator.py" 0

# Test 6: Security enhancement workflow
test_case "Security enhancement workflow" \
    "aider --yes --message 'Add input validation and security checks to prevent division by zero and handle edge cases' calculator.py" 0

# Test 7: Multi-file refactoring workflow
cat > utils.py << 'EOF'
def helper_function():
    pass
EOF

test_case "Multi-file refactoring workflow" \
    "aider --yes --message 'Add type hints and docstrings to all functions in both files' calculator.py utils.py" 0

# Test 8: Batch processing workflow
test_case "Batch processing workflow" \
    "aider --yes --message 'Add logging statements to all functions' *.py" 0

# Test 9: Code review workflow
test_case "Code review workflow" \
    "aider --yes --message 'Review code for potential bugs, performance issues, and suggest improvements' calculator.py" 0

# Test 10: Migration workflow
test_case "Migration workflow" \
    "aider --yes --message 'Convert all functions to use async/await patterns' calculator.py" 0

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

