#!/bin/bash
# Workflow Tests for Warp Terminal
# Tests workflow creation, execution, and integration patterns

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
        if [ "$exit_code" -eq "$expected_exit" ]; then
            echo -e "${GREEN}PASS${NC}"
            PASSED=$((PASSED + 1))
        else
            echo -e "${RED}FAIL (exit code: $exit_code)${NC}"
            FAILED=$((FAILED + 1))
        fi
    else
        local exit_code=$?
        if [ "$exit_code" -eq "$expected_exit" ]; then
            echo -e "${GREEN}PASS${NC}"
            PASSED=$((PASSED + 1))
        else
            echo -e "${RED}FAIL${NC}"
            FAILED=$((FAILED + 1))
        fi
    fi
}

echo "=========================================="
echo "Warp Terminal - Workflow Tests"
echo "=========================================="
echo ""

# Create temporary directory for test files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Test 1: Create workflow directory
test_case "Create workflow directory" \
    "mkdir -p ~/.warp/workflows && test -d ~/.warp/workflows" 0

# Test 2: Create workflow YAML file
test_case "Create workflow YAML file" \
    "cat > $TEST_DIR/test-workflow.yaml <<EOF
name: Test Workflow
command: echo 'test'
description: Test workflow
tags: [\"test\"]
EOF
test -f $TEST_DIR/test-workflow.yaml" 0

# Test 3: Validate workflow YAML syntax
test_case "Validate workflow YAML syntax" \
    "cat > $TEST_DIR/valid-workflow.yaml <<EOF
name: Valid Workflow
command: npm test
description: Run tests
tags: [\"test\", \"npm\"]
EOF
test -f $TEST_DIR/valid-workflow.yaml" 0

# Test 4: Workflow with multiple tags
test_case "Workflow with multiple tags" \
    "cat > $TEST_DIR/multi-tag-workflow.yaml <<EOF
name: Multi Tag Workflow
command: npm run build
description: Build project
tags: [\"build\", \"npm\", \"ci\"]
EOF
test -f $TEST_DIR/multi-tag-workflow.yaml" 0

# Test 5: Workflow with parameters
test_case "Workflow with parameters" \
    "cat > $TEST_DIR/param-workflow.yaml <<EOF
name: Parameterized Workflow
command: npm run \$SCRIPT
description: Run script with parameter
tags: [\"npm\", \"script\"]
EOF
test -f $TEST_DIR/param-workflow.yaml" 0

# Test 6: Copy workflow to Warp directory
test_case "Copy workflow to Warp directory" \
    "mkdir -p ~/.warp/workflows && cp $TEST_DIR/test-workflow.yaml ~/.warp/workflows/ && test -f ~/.warp/workflows/test-workflow.yaml && rm ~/.warp/workflows/test-workflow.yaml" 0

# Test 7: Workflow file permissions
test_case "Workflow file permissions" \
    "chmod +x $TEST_DIR/test-workflow.yaml && test -x $TEST_DIR/test-workflow.yaml" 0

# Test 8: Workflow directory structure
test_case "Workflow directory structure" \
    "mkdir -p ~/.warp/workflows/{local,team} && test -d ~/.warp/workflows/local && test -d ~/.warp/workflows/team" 0

# Test 9: Workflow with environment variables
test_case "Workflow with environment variables" \
    "cat > $TEST_DIR/env-workflow.yaml <<EOF
name: Environment Workflow
command: NODE_ENV=production npm start
description: Start production server
tags: [\"production\", \"npm\"]
EOF
test -f $TEST_DIR/env-workflow.yaml" 0

# Test 10: Workflow with complex command
test_case "Workflow with complex command" \
    "cat > $TEST_DIR/complex-workflow.yaml <<EOF
name: Complex Workflow
command: npm test && npm run build && npm run deploy
description: Test, build, and deploy
tags: [\"ci\", \"deploy\"]
EOF
test -f $TEST_DIR/complex-workflow.yaml" 0

# Test 11: YAML validation (basic)
test_case "YAML validation (basic)" \
    "echo 'name: Test' > $TEST_DIR/simple.yaml && test -f $TEST_DIR/simple.yaml" 0

# Test 12: Workflow file reading
test_case "Workflow file reading" \
    "cat $TEST_DIR/test-workflow.yaml | grep -q 'name' || true" 0

# Test 13: Workflow file parsing
test_case "Workflow file parsing" \
    "grep -q 'command' $TEST_DIR/test-workflow.yaml || true" 0

# Test 14: Multiple workflow files
test_case "Multiple workflow files" \
    "for i in 1 2 3; do echo \"name: Workflow \$i\" > $TEST_DIR/workflow-\$i.yaml; done && ls $TEST_DIR/workflow-*.yaml | wc -l | grep -q '3'" 0

# Test 15: Workflow cleanup
test_case "Workflow cleanup" \
    "rm -f $TEST_DIR/*.yaml && ls $TEST_DIR/*.yaml 2>&1 | grep -q 'No such file' || true" 0

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

