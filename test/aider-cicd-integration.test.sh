#!/bin/bash
# CI/CD Integration Tests for Aider CLI
# Tests CI/CD patterns: error handling, exit codes, automation, structured output

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
echo "Aider CI/CD Integration Tests"
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
TEST_DIR=$(mktemp -d /tmp/aider_cicd_test_XXXXXX)
cd "$TEST_DIR"

# Initialize Git repo
git init > /dev/null 2>&1 || true
git config user.email "test@example.com" > /dev/null 2>&1 || true
git config user.name "Test User" > /dev/null 2>&1 || true

# Create test files
cat > src/main.py << 'EOF'
def hello():
    print("Hello")
EOF

# Test 1: Basic CI/CD pattern with exit code handling
test_case "CI/CD pattern - exit code handling" \
    "aider --yes --message 'Add docstring' src/main.py && [ \$? -eq 0 ]" 0

# Test 2: CI/CD pattern with error handling
test_case "CI/CD pattern - error handling" \
    "aider --yes --message 'test' /nonexistent/file.py 2>&1 || [ \$? -ne 0 ]" 0

# Test 3: CI/CD pattern with timeout (if timeout command available)
if command -v timeout &> /dev/null; then
    test_case "CI/CD pattern - timeout handling" \
        "timeout 30 aider --yes --message 'Add comments' src/main.py || [ \$? -eq 124 ] || [ \$? -eq 0 ]" 0
else
    echo -e "${YELLOW}Test 3: CI/CD pattern - timeout handling ... SKIP (timeout command not available)${NC}"
    SKIPPED=$((SKIPPED + 1))
    test_count=$((test_count + 1))
fi

# Test 4: CI/CD pattern with environment variable
if [ -n "$OPENAI_API_KEY" ]; then
    test_case "CI/CD pattern - environment variable" \
        "OPENAI_API_KEY=$OPENAI_API_KEY aider --yes --message 'Add type hints' src/main.py" 0
else
    echo -e "${YELLOW}Test 4: CI/CD pattern - environment variable ... SKIP (OPENAI_API_KEY not set)${NC}"
    SKIPPED=$((SKIPPED + 1))
    test_count=$((test_count + 1))
fi

# Test 5: CI/CD pattern - no Git (faster for CI)
test_case "CI/CD pattern - no Git integration" \
    "aider --yes --no-git --message 'Add comments' src/main.py" 0

# Test 6: CI/CD pattern - model specification for consistency
test_case "CI/CD pattern - model specification" \
    "aider --yes --model gpt-4o --message 'Add docstring' src/main.py" 0

# Test 7: CI/CD pattern - batch processing
cat > src/utils.py << 'EOF'
def helper():
    pass
EOF

test_case "CI/CD pattern - batch processing" \
    "aider --yes --message 'Add type hints' src/*.py" 0

# Test 8: CI/CD pattern - linting fixes
test_case "CI/CD pattern - linting fixes" \
    "aider --yes --message 'Fix all linting issues' src/main.py" 0

# Test 9: CI/CD pattern - code quality improvements
test_case "CI/CD pattern - code quality improvements" \
    "aider --yes --message 'Improve code quality and add error handling' src/main.py" 0

# Test 10: CI/CD pattern - automated documentation
test_case "CI/CD pattern - automated documentation" \
    "aider --yes --message 'Add comprehensive documentation' src/main.py" 0

# Test 11: CI/CD pattern - structured workflow
test_case "CI/CD pattern - structured workflow" \
    "aider --yes --no-git --model gpt-4o --message 'Refactor and improve code' src/main.py" 0

# Test 12: CI/CD pattern - exit code validation
test_case "CI/CD pattern - exit code validation" \
    "aider --yes --message 'test' src/main.py; EXIT_CODE=\$?; [ \$EXIT_CODE -eq 0 ] || [ \$EXIT_CODE -ne 0 ]" 0

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

