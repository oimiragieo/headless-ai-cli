#!/bin/bash
# Warp Agent Profile Management Examples
# Demonstrates how to create and manage Warp agent profiles for automation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=========================================="
echo "Warp Agent Profile Management Examples"
echo "=========================================="
echo ""

# Check if Warp CLI is installed
if ! command -v warp &> /dev/null; then
    echo -e "${YELLOW}Warning: Warp CLI not found.${NC}"
    echo "Note: Warp is primarily a terminal emulator. CLI commands may not be available."
    echo "These examples show the expected syntax when Warp CLI is available."
    echo ""
fi

# Example 1: List available profiles
echo -e "${BLUE}Example 1: List available profiles${NC}"
echo "Command: warp agent profile list"
echo ""
if command -v warp &> /dev/null; then
    warp agent profile list 2>&1 || echo "Profile list command not available"
else
    echo "# warp agent profile list"
    echo "# Output: List of available profiles with IDs"
fi
echo ""

# Example 2: Create a new profile
echo -e "${BLUE}Example 2: Create a new profile${NC}"
echo "Command: warp agent profile create --name code-review-profile"
echo ""
if command -v warp &> /dev/null; then
    warp agent profile create --name code-review-profile 2>&1 || echo "Profile create command not available"
else
    echo "# warp agent profile create --name code-review-profile"
    echo "# Output: Profile created with ID"
fi
echo ""

# Example 3: Run agent with profile
echo -e "${BLUE}Example 3: Run agent with profile${NC}"
echo "Command: warp agent run --prompt 'Review code' --profile code-review-profile"
echo ""
if command -v warp &> /dev/null && [ -n "$WARP_API_KEY" ]; then
    warp agent run --prompt "Review code" --profile code-review-profile 2>&1 || echo "Agent run command not available"
else
    echo "# warp agent run --prompt 'Review code' --profile code-review-profile"
    echo "# Output: Agent execution results"
fi
echo ""

# Example 4: Run agent with output redirection
echo -e "${BLUE}Example 4: Run agent with output redirection${NC}"
echo "Command: warp agent run --prompt 'Generate report' --profile report-profile > report.txt"
echo ""
if command -v warp &> /dev/null && [ -n "$WARP_API_KEY" ]; then
    warp agent run --prompt "Generate report" --profile report-profile > /tmp/warp-report.txt 2>&1 || echo "Agent run command not available"
    if [ -f /tmp/warp-report.txt ]; then
        echo "Report generated at /tmp/warp-report.txt"
        rm -f /tmp/warp-report.txt
    fi
else
    echo "# warp agent run --prompt 'Generate report' --profile report-profile > report.txt"
    echo "# Output: Report saved to report.txt"
fi
echo ""

# Example 5: Error handling
echo -e "${BLUE}Example 5: Error handling${NC}"
echo "Command: warp agent run --prompt 'Task' --profile profile-id || echo 'Failed'"
echo ""
if command -v warp &> /dev/null; then
    warp agent run --prompt "Task" --profile invalid-profile 2>&1 || echo "Command failed as expected"
else
    echo "# warp agent run --prompt 'Task' --profile profile-id || echo 'Failed'"
    echo "# Output: Error message or 'Failed'"
fi
echo ""

echo -e "${GREEN}Profile management examples completed!${NC}"
echo ""
echo "Note: Warp CLI commands require:"
echo "  1. Warp CLI installed"
echo "  2. WARP_API_KEY environment variable set"
echo "  3. Agent profiles configured"
echo ""
echo "For more information, see: https://docs.warp.dev/developers/cli"

