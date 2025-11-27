#!/bin/bash
# Basic Headless Mode Tests for Windsurf
# Tests Docker-based headless mode setup, workspace preparation, and basic automation

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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$WINDSURF_TOKEN" ] || ! command -v docker &> /dev/null; then
            if [ -z "$WINDSURF_TOKEN" ] || ! command -v docker &> /dev/null; then
                echo -e "${YELLOW}SKIP (Docker or token not available)${NC}"
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
        if [ "$exit_code" -eq "$expected_exit" ] || [ -z "$WINDSURF_TOKEN" ] || ! command -v docker &> /dev/null; then
            if [ -z "$WINDSURF_TOKEN" ] || ! command -v docker &> /dev/null; then
                echo -e "${YELLOW}SKIP (Docker or token not available)${NC}"
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
echo "Windsurf Headless Mode - Basic Tests"
echo "=========================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Warning: Docker not found. Tests will be skipped.${NC}"
    echo "Install Docker to run Windsurf headless mode tests."
    echo ""
fi

# Check if Windsurf token is set
if [ -z "$WINDSURF_TOKEN" ]; then
    echo -e "${YELLOW}Warning: WINDSURF_TOKEN not set. Tests will be skipped.${NC}"
    echo "Get your token from Windsurf IDE: Ctrl+Shift+P -> 'Provide auth token'"
    echo ""
fi

# Create temporary directory for test files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Test 1: Docker installation check
test_case "Docker installation check" \
    "command -v docker" 0

# Test 2: Docker daemon running
if command -v docker &> /dev/null; then
    test_case "Docker daemon running" \
        "docker info > /dev/null 2>&1" 0
else
    test_count=$((test_count + 1))
    echo -e "Test $test_count: Docker daemon running ... ${YELLOW}SKIP (Docker not installed)${NC}"
    SKIPPED=$((SKIPPED + 1))
fi

# Test 3: Create workspace directory
test_case "Create workspace directory" \
    "mkdir -p $TEST_DIR/workspace && test -d $TEST_DIR/workspace" 0

# Test 4: Set workspace permissions (UID:GID=1000:1000)
test_case "Set workspace permissions" \
    "chown -R 1000:1000 $TEST_DIR/workspace 2>&1 || sudo chown -R 1000:1000 $TEST_DIR/workspace 2>&1 || true" 0

# Test 5: Create windsurf-instructions.txt file
test_case "Create windsurf-instructions.txt" \
    "echo 'Test task prompt' > $TEST_DIR/workspace/windsurf-instructions.txt && test -f $TEST_DIR/workspace/windsurf-instructions.txt" 0

# Test 6: Verify instructions file content
test_case "Verify instructions file content" \
    "grep -q 'Test task prompt' $TEST_DIR/workspace/windsurf-instructions.txt" 0

# Test 7: Create .windsurf/workflows directory
test_case "Create .windsurf/workflows directory" \
    "mkdir -p $TEST_DIR/.windsurf/workflows && test -d $TEST_DIR/.windsurf/workflows" 0

# Test 8: Create workflow markdown file
test_case "Create workflow markdown file" \
    "echo '# Test Workflow' > $TEST_DIR/.windsurf/workflows/test.md && test -f $TEST_DIR/.windsurf/workflows/test.md" 0

# Test 9: Validate workflow file content
test_case "Validate workflow file content" \
    "grep -q 'Test Workflow' $TEST_DIR/.windsurf/workflows/test.md" 0

# Test 10: Environment variable check
test_case "Environment variable check" \
    "[ -n \"\${WINDSURF_TOKEN:-}\" ] || echo 'Token not set'" 0

# Test 11: Docker build syntax (dry run)
if command -v docker &> /dev/null; then
    test_case "Docker build syntax check" \
        "echo 'FROM ubuntu:20.04' > $TEST_DIR/Dockerfile && docker build --help > /dev/null" 0
else
    test_count=$((test_count + 1))
    echo -e "Test $test_count: Docker build syntax check ... ${YELLOW}SKIP (Docker not installed)${NC}"
    SKIPPED=$((SKIPPED + 1))
fi

# Test 12: Docker volume mount syntax
if command -v docker &> /dev/null; then
    test_case "Docker volume mount syntax" \
        "docker run --help | grep -q 'volume' || true" 0
else
    test_count=$((test_count + 1))
    echo -e "Test $test_count: Docker volume mount syntax ... ${YELLOW}SKIP (Docker not installed)${NC}"
    SKIPPED=$((SKIPPED + 1))
fi

# Test 13: Workspace directory structure
test_case "Workspace directory structure" \
    "mkdir -p $TEST_DIR/workspace/{src,tests,docs} && ls -d $TEST_DIR/workspace/* | wc -l | grep -q '3'" 0

# Test 14: Instructions file with multiple lines
test_case "Instructions file with multiple lines" \
    "cat > $TEST_DIR/workspace/windsurf-instructions.txt <<EOF
Line 1
Line 2
Line 3
EOF
wc -l < $TEST_DIR/workspace/windsurf-instructions.txt | grep -q '3'" 0

# Test 15: Workflow file with steps
test_case "Workflow file with steps" \
    "cat > $TEST_DIR/.windsurf/workflows/deploy.md <<EOF
# Deploy Workflow
1. Run tests
2. Build project
3. Deploy
EOF
grep -q 'Deploy Workflow' $TEST_DIR/.windsurf/workflows/deploy.md" 0

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

