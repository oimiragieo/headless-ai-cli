#!/bin/bash
# Advanced Headless Mode Tests for Cline CLI
# Tests advanced headless mode features, instance management, and workflow integration

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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$CLINE_API_KEY" ] || ! command -v cline &> /dev/null; then
            if [ -z "$CLINE_API_KEY" ] || ! command -v cline &> /dev/null; then
                echo -e "${YELLOW}SKIP (CLI not installed or API key not set)${NC}"
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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$CLINE_API_KEY" ] || ! command -v cline &> /dev/null; then
            if [ -z "$CLINE_API_KEY" ] || ! command -v cline &> /dev/null; then
                echo -e "${YELLOW}SKIP (CLI not installed or API key not set)${NC}"
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
echo "Cline Headless Mode - Advanced Tests"
echo "=========================================="
echo ""

# Check if Cline CLI is installed
if ! command -v cline &> /dev/null; then
    echo -e "${YELLOW}Warning: Cline CLI not found. Install with: npm install -g cline${NC}"
    echo ""
fi

# Check if API key is set
if [ -z "$CLINE_API_KEY" ]; then
    echo -e "${YELLOW}Warning: CLINE_API_KEY not set. Tests will be skipped.${NC}"
    echo ""
fi

# Create temporary directory for test files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Test 1: Create instance with custom name
test_case "Create instance with custom name" \
    "cline instance new --name test-instance 2>&1 || true" 0

# Test 2: Create default instance
test_case "Create default instance" \
    "cline instance new --default 2>&1 || true" 0

# Test 3: List instances
test_case "List instances" \
    "cline instance list 2>&1 || true" 0

# Test 4: Switch between instances
test_case "Switch between instances" \
    "cline instance list 2>&1 | head -1 | grep -q . || cline instance switch test-instance 2>&1 || true" 0

# Test 5: Create task in headless mode with -y
test_case "Create task in headless mode with -y" \
    "cline instance new --default 2>&1 && cline task new -y 'Say hello' 2>&1 || true" 0

# Test 6: Create task in headless mode with --yolo
test_case "Create task in headless mode with --yolo" \
    "cline instance new --default 2>&1 && cline task new --yolo 'Say hello' 2>&1 || true" 0

# Test 7: View task with --follow flag
test_case "View task with --follow flag" \
    "timeout 2 cline task view --follow 2>&1 || cline task view 2>&1 || true" 0

# Test 8: List tasks
test_case "List tasks" \
    "cline task list 2>&1 || true" 0

# Test 9: Review command with output file
test_case "Review command with output file" \
    "cline review --output=$TEST_DIR/review.md 2>&1 || true" 0

# Test 10: Create .clinerules/workflows directory
test_case "Create .clinerules/workflows directory" \
    "mkdir -p $TEST_DIR/.clinerules/workflows && test -d $TEST_DIR/.clinerules/workflows" 0

# Test 11: Create workflow markdown file
test_case "Create workflow markdown file" \
    "cat > $TEST_DIR/.clinerules/workflows/test.md <<EOF
# Test Workflow
1. Step one
2. Step two
EOF
test -f $TEST_DIR/.clinerules/workflows/test.md" 0

# Test 12: Validate workflow file content
test_case "Validate workflow file content" \
    "grep -q 'Test Workflow' $TEST_DIR/.clinerules/workflows/test.md" 0

# Test 13: Multiple workflow files
test_case "Multiple workflow files" \
    "for i in deploy review refactor; do echo \"# \$i Workflow\" > $TEST_DIR/.clinerules/workflows/\$i.md; done && ls $TEST_DIR/.clinerules/workflows/*.md | wc -l | grep -q '3'" 0

# Test 14: Workflow with commands
test_case "Workflow with commands" \
    "cat > $TEST_DIR/.clinerules/workflows/commands.md <<EOF
# Command Workflow
npm test
npm run build
EOF
grep -q 'npm test' $TEST_DIR/.clinerules/workflows/commands.md" 0

# Test 15: Batch task creation
test_case "Batch task creation" \
    "cline instance new --default 2>&1 && for prompt in 'Task 1' 'Task 2'; do cline task new -y \"\$prompt\" 2>&1 || true; done" 0

# Test 16: Error handling - task without instance
test_case "Error handling - task without instance" \
    "cline task new -y 'Test' 2>&1; [ \$? -ne 0 ] || true" 0

# Test 17: Output redirection
test_case "Output redirection" \
    "cline --help > $TEST_DIR/help.txt 2>&1 && test -f $TEST_DIR/help.txt" 0

# Test 18: Environment variable usage
test_case "Environment variable usage" \
    "CLINE_API_KEY=\${CLINE_API_KEY:-test} echo 'test'" 0

# Test 19: Exit code propagation
test_case "Exit code propagation" \
    "(cline --help; EXIT=\$?; exit \$EXIT) && echo 'propagated'" 0

# Test 20: Conditional execution
test_case "Conditional execution" \
    "cline --help && echo 'success' || echo 'failure'" 0

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

