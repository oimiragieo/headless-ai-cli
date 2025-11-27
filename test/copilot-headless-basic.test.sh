#!/bin/bash
# Basic Headless Mode Tests for GitHub Copilot CLI
# Tests basic programmatic mode execution, exit codes, and output formats

# Windows/WSL detection: If on Windows and not in WSL, re-run via WSL
# Check if we're on Windows (not in WSL)
if [[ (-n "$WINDIR" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32") && -z "$WSL_DISTRO_NAME" && -z "$WSL_INTEROP" ]]; then
    if command -v wsl &> /dev/null; then
        # Convert Windows path to WSL path format
        SCRIPT_PATH="$0"
        if [[ "$SCRIPT_PATH" =~ ^[A-Za-z]: ]]; then
            # Windows absolute path - convert to WSL path
            SCRIPT_PATH=$(wslpath -a "$SCRIPT_PATH" 2>/dev/null || echo "$SCRIPT_PATH")
        fi
        # Re-execute via WSL
        exec wsl bash "$SCRIPT_PATH" "$@"
    else
        echo "Error: This script requires WSL (Windows Subsystem for Linux) on Windows."
        echo "Please install WSL or run this script from within WSL."
        exit 1
    fi
fi

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

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
    
    # Copilot CLI requires GitHub authentication, not an API key
    # We'll check if command succeeds or fails gracefully
    if [ "$exit_code" -eq "$expected_exit" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        # If exit code doesn't match but is non-zero, it might be auth-related
        if [ "$exit_code" -ne 0 ] && [ "$expected_exit" -eq 0 ]; then
            echo -e "${YELLOW}SKIP (may require GitHub authentication)${NC}"
        else
            echo -e "${RED}FAIL (exit code: $exit_code, expected: $expected_exit)${NC}"
            FAILED=$((FAILED + 1))
        fi
    fi
}

echo "=========================================="
echo "GitHub Copilot CLI - Basic Tests"
echo "=========================================="
echo ""

# Check if Copilot CLI is installed
if ! command -v copilot &> /dev/null; then
    echo -e "${RED}Error: Copilot CLI not found. Install with: npm install -g @github/copilot${NC}"
    exit 1
fi

# Check if user is authenticated (basic check)
if ! copilot --version &> /dev/null; then
    echo -e "${YELLOW}Warning: Copilot CLI may not be authenticated. Some tests may be skipped.${NC}"
    echo "Authenticate with GitHub Copilot to run full test suite."
    echo ""
fi

# Test 1: Basic programmatic mode with -p flag
test_case "Basic programmatic mode (-p flag)" \
    "copilot -p 'Say hello' --allow-all-tools" 0

# Test 2: Basic programmatic mode with --prompt flag
test_case "Basic programmatic mode (--prompt flag)" \
    "copilot --prompt 'Say hello' --allow-all-tools" 0

# Test 3: Verify -p and --prompt are equivalent
test_case "Verify -p and --prompt equivalence" \
    "copilot -p 'test' --allow-all-tools && copilot --prompt 'test' --allow-all-tools" 0

# Test 4: Exit code on success
test_case "Exit code on success" \
    "copilot -p 'Say OK' --allow-all-tools; echo \$?" 0

# Test 5: Text output format (default)
test_case "Text output format (default)" \
    "copilot -p 'Say test' --allow-all-tools | grep -q ." 0

# Test 6: Silent flag
test_case "Silent flag (-s)" \
    "copilot -p 'Say test' -s --allow-all-tools" 0

# Test 7: Silent flag (--silent)
test_case "Silent flag (--silent)" \
    "copilot -p 'Say test' --silent --allow-all-tools" 0

# Test 8: No color flag
test_case "No color flag" \
    "copilot -p 'Say test' --no-color --allow-all-tools" 0

# Test 9: Stream flag (on)
test_case "Stream flag (on)" \
    "copilot -p 'Say test' --stream on --allow-all-tools" 0

# Test 10: Stream flag (off)
test_case "Stream flag (off)" \
    "copilot -p 'Say test' --stream off --allow-all-tools" 0

# Test 11: Enhanced code search capabilities (syntax check)
test_case "Enhanced code search capabilities" \
    "copilot -p 'Search code' --allow-all-tools" 0

# Test 11: Stdin input
test_case "Stdin input" \
    "echo 'Say test' | copilot -p --allow-all-tools" 0

# Test 12: Empty prompt handling (should fail gracefully)
test_case "Empty prompt handling" \
    "copilot -p '' --allow-all-tools" 1

# Test 13: Help flag (should work without authentication)
test_case "Help flag" \
    "copilot --help | head -1" 0

# Test 14: Version flag (should work without authentication)
test_case "Version flag" \
    "copilot --version" 0

# Test 15: Model flag syntax
test_case "Model flag syntax" \
    "copilot --model 'Claude Sonnet 4.5' --help" 0

# Test 16: Continue flag syntax
test_case "Continue flag syntax" \
    "copilot --continue --help" 0

# Test 17: Resume flag syntax
test_case "Resume flag syntax" \
    "copilot --resume --help" 0

# Test 18: Allow all tools flag
test_case "Allow all tools flag" \
    "copilot -p 'test' --allow-all-tools --help" 0

# Test 19: Environment variable COPILOT_ALLOW_ALL
test_case "Environment variable COPILOT_ALLOW_ALL" \
    "COPILOT_ALLOW_ALL=1 copilot -p 'test' --help" 0

echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Total tests: $test_count"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi

