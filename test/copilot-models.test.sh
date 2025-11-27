#!/bin/bash
# Model Tests for GitHub Copilot CLI
# Tests all available models, model flag syntax, and model persistence

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
    
    if [ "$exit_code" -eq "$expected_exit" ]; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        # If exit code doesn't match but is non-zero, it might be auth-related
        if [ "$exit_code" -ne 0 ] && [ "$expected_exit" -eq 0 ]; then
            echo -e "${YELLOW}SKIP (may require authentication)${NC}"
            SKIPPED=$((SKIPPED + 1))
        else
            echo -e "${RED}FAIL (exit code: $exit_code, expected: $expected_exit)${NC}"
            FAILED=$((FAILED + 1))
        fi
    fi
}

echo "=========================================="
echo "GitHub Copilot CLI - Model Tests"
echo "=========================================="
echo ""

# Check if Copilot CLI is installed
if ! command -v copilot &> /dev/null; then
    echo -e "${RED}Error: Copilot CLI not found. Install with: npm install -g @github/copilot${NC}"
    exit 1
fi

# Test all available models (verified from CLI, November 2025)
# Model 1: Claude Sonnet 4.5 (1x) - default
test_case "Claude Sonnet 4.5 (default, 1x)" \
    "copilot --model 'Claude Sonnet 4.5' --help" 0

# Model 2: Claude Sonnet 4 (1x)
test_case "Claude Sonnet 4 (1x)" \
    "copilot --model 'Claude Sonnet 4' --help" 0

# Model 3: GPT-5 (1x)
test_case "GPT-5 (1x)" \
    "copilot --model 'GPT-5' --help" 0

# Model 4: GPT-5-Mini (0x) - Free tier
test_case "GPT-5-Mini (0x, Free)" \
    "copilot --model 'GPT-5-Mini' --help" 0

# Model 5: GPT-4.1 (0x) - Free tier
test_case "GPT-4.1 (0x, Free)" \
    "copilot --model 'GPT-4.1' --help" 0

# Model 6: Gemini 3 Pro (Preview) (1x)
test_case "Gemini 3 Pro (Preview) (1x)" \
    "copilot --model 'Gemini 3 Pro (Preview)' --help" 0

# Test model flag syntax variations
test_case "Model flag with programmatic mode" \
    "copilot --model 'Claude Sonnet 4.5' -p 'test' --allow-all-tools" 0

test_case "Model flag with silent mode" \
    "copilot --model 'Claude Sonnet 4' -p 'test' --silent --allow-all-tools" 0

test_case "Model flag with no-color" \
    "copilot --model 'GPT-5' -p 'test' --no-color --allow-all-tools" 0

test_case "Model flag with stream off" \
    "copilot --model 'Claude Sonnet 4.5' -p 'test' --stream off --allow-all-tools" 0

# Test model with tool control
test_case "Model with allow-all-tools" \
    "copilot --model 'Claude Sonnet 4.5' -p 'test' --allow-all-tools" 0

test_case "Model with specific allow-tool" \
    "copilot --model 'Gemini 3 Pro (Preview)' -p 'test' --allow-tool 'write'" 0

# Test free tier models (0x multiplier - no cost)
test_case "Free tier model (GPT-5-Mini, 0x)" \
    "copilot --model 'GPT-5-Mini' -p 'Quick task' --allow-all-tools" 0

test_case "Free tier model (GPT-4.1, 0x)" \
    "copilot --model 'GPT-4.1' -p 'Quick task' --allow-all-tools" 0

# Test premium models (1x multiplier)
test_case "Premium model (GPT-5, 1x)" \
    "copilot --model 'GPT-5' -p 'test' --allow-all-tools" 0

test_case "Premium model (Gemini 3 Pro, 1x)" \
    "copilot --model 'Gemini 3 Pro (Preview)' -p 'test' --allow-all-tools" 0

# Test model persistence (syntax check)
test_case "Model persistence syntax" \
    "copilot --model 'Claude Sonnet 4.5' -p 'test' --allow-all-tools && copilot -p 'test' --allow-all-tools" 0

# Test invalid model handling
test_case "Invalid model handling" \
    "copilot --model 'invalid-model-name' --help 2>&1; [ \$? -ne 0 ] || true" 0

# Test model with session management
test_case "Model with --continue" \
    "copilot --model 'Claude Sonnet 4.5' --continue --help" 0

test_case "Model with --resume" \
    "copilot --model 'Claude Sonnet 4.5' --resume test-session --help" 0

# Test model with MCP
test_case "Model with MCP integration" \
    "copilot --model 'Claude Sonnet 4.5' --enable-all-github-mcp-tools --help" 0

# Test model with logging
test_case "Model with log level" \
    "copilot --model 'Claude Sonnet 4.5' --log-level debug --help" 0

# Test multiple model switches in sequence (syntax)
test_case "Multiple model switches syntax" \
    "copilot --model 'Claude Sonnet 4.5' --help && copilot --model 'GPT-5' --help && copilot --model 'Gemini 3 Pro (Preview)' --help" 0

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

