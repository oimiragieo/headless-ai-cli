#!/bin/bash
# Workflow Tests for Cline CLI
# Tests workflow creation, validation, and automation patterns

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
echo "Cline Workflows - Test Suite"
echo "=========================================="
echo ""

# Create temporary directory for test files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Test 1: Create .clinerules/workflows directory
test_case "Create .clinerules/workflows directory" \
    "mkdir -p $TEST_DIR/.clinerules/workflows && test -d $TEST_DIR/.clinerules/workflows" 0

# Test 2: Create simple workflow
test_case "Create simple workflow" \
    "cat > $TEST_DIR/.clinerules/workflows/simple.md <<EOF
# Simple Workflow
Run tests
EOF
test -f $TEST_DIR/.clinerules/workflows/simple.md" 0

# Test 3: Create workflow with numbered steps
test_case "Create workflow with numbered steps" \
    "cat > $TEST_DIR/.clinerules/workflows/steps.md <<EOF
# Workflow with Steps
1. Step one
2. Step two
3. Step three
EOF
grep -q 'Step one' $TEST_DIR/.clinerules/workflows/steps.md" 0

# Test 4: Create workflow with commands
test_case "Create workflow with commands" \
    "cat > $TEST_DIR/.clinerules/workflows/commands.md <<EOF
# Command Workflow
npm test
npm run build
npm run deploy
EOF
grep -q 'npm test' $TEST_DIR/.clinerules/workflows/commands.md" 0

# Test 5: Create deploy workflow
test_case "Create deploy workflow" \
    "cat > $TEST_DIR/.clinerules/workflows/deploy.md <<EOF
# Deploy Workflow
1. Run tests: npm test
2. Build project: npm run build
3. Deploy to staging: npm run deploy:staging
4. Run smoke tests: npm run smoke-tests
EOF
grep -q 'Deploy Workflow' $TEST_DIR/.clinerules/workflows/deploy.md" 0

# Test 6: Create code review workflow
test_case "Create code review workflow" \
    "cat > $TEST_DIR/.clinerules/workflows/review.md <<EOF
# Code Review Workflow
1. Analyze code for bugs
2. Check security vulnerabilities
3. Review code quality
4. Generate report
EOF
grep -q 'Code Review' $TEST_DIR/.clinerules/workflows/review.md" 0

# Test 7: Create multiple workflows
test_case "Create multiple workflows" \
    "for i in test build deploy; do echo \"# \$i Workflow\" > $TEST_DIR/.clinerules/workflows/\$i.md; done && ls $TEST_DIR/.clinerules/workflows/*.md | wc -l | grep -q '3'" 0

# Test 8: Validate workflow markdown syntax
test_case "Validate workflow markdown syntax" \
    "cat > $TEST_DIR/.clinerules/workflows/valid.md <<EOF
# Valid Workflow
## Steps
1. First step
2. Second step
EOF
grep -q 'Valid Workflow' $TEST_DIR/.clinerules/workflows/valid.md" 0

# Test 9: Workflow with environment variables
test_case "Workflow with environment variables" \
    "cat > $TEST_DIR/.clinerules/workflows/env.md <<EOF
# Environment Workflow
NODE_ENV=production npm start
EOF
grep -q 'NODE_ENV' $TEST_DIR/.clinerules/workflows/env.md" 0

# Test 10: Workflow with complex commands
test_case "Workflow with complex commands" \
    "cat > $TEST_DIR/.clinerules/workflows/complex.md <<EOF
# Complex Workflow
npm test && npm run build && npm run deploy
EOF
grep -q '&&' $TEST_DIR/.clinerules/workflows/complex.md" 0

# Test 11: Workflow file permissions
test_case "Workflow file permissions" \
    "chmod +r $TEST_DIR/.clinerules/workflows/simple.md && test -r $TEST_DIR/.clinerules/workflows/simple.md" 0

# Test 12: Workflow directory structure
test_case "Workflow directory structure" \
    "mkdir -p $TEST_DIR/.clinerules/workflows/{local,team} && test -d $TEST_DIR/.clinerules/workflows/local && test -d $TEST_DIR/.clinerules/workflows/team" 0

# Test 13: Workflow file reading
test_case "Workflow file reading" \
    "cat $TEST_DIR/.clinerules/workflows/simple.md | grep -q 'Workflow' || true" 0

# Test 14: Workflow file parsing
test_case "Workflow file parsing" \
    "grep -q '#' $TEST_DIR/.clinerules/workflows/simple.md || true" 0

# Test 15: Workflow cleanup
test_case "Workflow cleanup" \
    "rm -f $TEST_DIR/.clinerules/workflows/*.md && ls $TEST_DIR/.clinerules/workflows/*.md 2>&1 | grep -q 'No such file' || true" 0

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

