#!/bin/bash
# OpenCode CLI Script Patterns for Automation and CI/CD
# This file contains reusable patterns for using OpenCode in automation workflows
#
# NOTE: OpenCode uses `opencode run "message"` for headless execution
# It requires authentication via `opencode auth login` before use

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
OPENCODE_MODEL="${OPENCODE_MODEL:-}"

# Function: Check if OpenCode CLI is installed
check_opencode_installed() {
    if ! command -v opencode &> /dev/null; then
        echo -e "${RED}Error: OpenCode CLI not found. Install with: npm install -g open-code${NC}" >&2
        exit 1
    fi
}

# Function: Check authentication
check_auth() {
    if ! opencode auth list &> /dev/null; then
        echo -e "${YELLOW}Warning: OpenCode may not be authenticated. Run 'opencode auth login' first.${NC}" >&2
    fi
}

# Pattern 1: Basic headless execution with run command
opencode_basic() {
    local prompt="$1"
    local model="${2:-$OPENCODE_MODEL}"

    echo "Running OpenCode with prompt: $prompt"

    local cmd="opencode run \"$prompt\""

    # Add model if specified
    if [ -n "$model" ]; then
        cmd="$cmd --model $model"
    fi

    if eval "$cmd"; then
        echo -e "${GREEN}OpenCode completed successfully${NC}"
        return 0
    else
        echo -e "${RED}OpenCode failed${NC}"
        return 1
    fi
}

# Pattern 2: Run with specific model
opencode_with_model() {
    local prompt="$1"
    local model="${2:-opencode/big-pickle}"

    echo "Running OpenCode with model: $model"

    opencode run "$prompt" --model "$model"
}

# Pattern 3: Continue last session
opencode_continue() {
    local prompt="$1"

    echo "Continuing last OpenCode session"

    opencode run "$prompt" --continue
}

# Pattern 4: Resume specific session
opencode_resume() {
    local prompt="$1"
    local session_id="$2"

    echo "Resuming OpenCode session: $session_id"

    opencode run "$prompt" --session "$session_id"
}

# Pattern 5: CI/CD pattern with exit code validation
opencode_cicd() {
    local prompt="$1"
    local model="${2:-$OPENCODE_MODEL}"

    echo "Running OpenCode in CI/CD mode"

    local cmd="opencode run \"$prompt\""

    if [ -n "$model" ]; then
        cmd="$cmd --model $model"
    fi

    if eval "$cmd"; then
        echo "OpenCode completed successfully"
        return 0
    else
        echo "OpenCode failed"
        return 1
    fi
}

# Pattern 6: Code review automation (pipe git diff)
opencode_review() {
    local base_branch="${1:-main}"
    local model="${2:-$OPENCODE_MODEL}"

    echo "Running code review with OpenCode"

    local prompt="Review these code changes for potential bugs, security vulnerabilities, and adherence to best practices. Provide actionable suggestions for improvement."

    if [ -n "$model" ]; then
        git diff "origin/$base_branch...HEAD" | opencode run "$prompt" --model "$model"
    else
        git diff "origin/$base_branch...HEAD" | opencode run "$prompt"
    fi
}

# Pattern 7: Multi-message execution
opencode_multi_message() {
    local messages=("$@")

    echo "Running OpenCode with multiple message arguments"

    opencode run "${messages[@]}"
}

# Pattern 8: Security audit
opencode_security() {
    local model="${1:-$OPENCODE_MODEL}"

    echo "Performing security audit with OpenCode"

    local prompt="Perform security audit: identify vulnerabilities, insecure patterns, and suggest fixes. Focus on: injection attacks, authentication issues, data exposure, and insecure configurations."

    if [ -n "$model" ]; then
        opencode run "$prompt" --model "$model"
    else
        opencode run "$prompt"
    fi
}

# Pattern 9: Run with retry logic
opencode_with_retry() {
    local prompt="$1"
    local max_retries="${2:-3}"
    local model="${3:-$OPENCODE_MODEL}"

    local attempt=1
    while [ $attempt -le $max_retries ]; do
        echo "Attempt $attempt/$max_retries: Running OpenCode..."

        local cmd="opencode run \"$prompt\""
        [ -n "$model" ] && cmd="$cmd --model $model"

        if eval "$cmd"; then
            echo -e "${GREEN}OpenCode command succeeded${NC}"
            return 0
        else
            echo -e "${YELLOW}OpenCode command failed${NC}"

            if [ $attempt -lt $max_retries ]; then
                echo "Retrying in 2 seconds..."
                sleep 2
            fi
        fi

        attempt=$((attempt + 1))
    done

    echo -e "${RED}OpenCode command failed after $max_retries attempts${NC}"
    return 1
}

# Pattern 10: Timeout handling for long operations
opencode_with_timeout() {
    local timeout_seconds="${1:-300}"
    local prompt="$2"
    local model="${3:-$OPENCODE_MODEL}"

    echo "Running OpenCode with ${timeout_seconds}s timeout"

    local cmd="opencode run \"$prompt\""
    [ -n "$model" ] && cmd="$cmd --model $model"

    if command -v timeout &> /dev/null; then
        timeout "$timeout_seconds" bash -c "$cmd"
    else
        echo "Warning: timeout command not available, running without timeout"
        eval "$cmd"
    fi
}

# Pattern 11: View statistics
opencode_stats() {
    echo "Viewing OpenCode statistics"
    opencode stats
}

# Pattern 12: List available models
opencode_list_models() {
    echo "Listing available OpenCode models"
    opencode models
}

# Pattern 13: Export session data
opencode_export_session() {
    local session_id="${1:-}"
    local output_file="${2:-session.json}"

    echo "Exporting OpenCode session"

    if [ -n "$session_id" ]; then
        opencode export "$session_id" > "$output_file"
    else
        opencode export > "$output_file"
    fi
}

# Pattern 14: Import session data
opencode_import_session() {
    local session_file="$1"

    echo "Importing OpenCode session from: $session_file"

    opencode import "$session_file"
}

# Main execution (if script is run directly)
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo "OpenCode CLI Script Patterns"
    echo "============================"
    echo ""
    echo "This script contains reusable patterns for OpenCode automation."
    echo "Source this file to use the functions in your scripts:"
    echo "  source open-code-script-patterns.sh"
    echo ""
    echo "Prerequisites:"
    echo "  - Install: npm install -g open-code"
    echo "  - Authenticate: opencode auth login"
    echo ""
    echo "Available patterns:"
    echo "  - opencode_basic: Basic headless execution with 'opencode run'"
    echo "  - opencode_with_model: Run with specific model"
    echo "  - opencode_continue: Continue last session"
    echo "  - opencode_resume: Resume specific session"
    echo "  - opencode_cicd: CI/CD pattern with exit code validation"
    echo "  - opencode_review: Code review from git diff"
    echo "  - opencode_multi_message: Multiple message arguments"
    echo "  - opencode_security: Security audit"
    echo "  - opencode_with_retry: With retry logic"
    echo "  - opencode_with_timeout: With timeout handling"
    echo "  - opencode_stats: View usage statistics"
    echo "  - opencode_list_models: List available models"
    echo "  - opencode_export_session: Export session data"
    echo "  - opencode_import_session: Import session data"
    echo ""
    echo "OpenCode CLI Commands:"
    echo "  opencode run [message..]     - Run with a message (headless)"
    echo "  opencode serve               - Start headless server"
    echo "  opencode web                 - Start headless web server"
    echo "  opencode auth login          - Authenticate"
    echo "  opencode models              - List available models"
    echo "  opencode stats               - View usage statistics"
fi
