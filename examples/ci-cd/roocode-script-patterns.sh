#!/bin/bash
# RooCode CLI Script Patterns for Automation and CI/CD
# This file contains reusable patterns for using RooCode in automation workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Pattern 1: Basic headless execution with error handling
roocode_basic() {
    local prompt="$1"
    local files="$2"
    
    echo "Running RooCode with prompt: $prompt"
    
    if roocode --headless --prompt "$prompt" --files $files; then
        echo -e "${GREEN}✅ RooCode completed successfully${NC}"
        return 0
    else
        echo -e "${RED}❌ RooCode failed${NC}"
        return 1
    fi
}

# Pattern 2: Headless execution with file context
roocode_with_file() {
    local prompt="$1"
    local file="$2"
    local output="${3:-}"
    
    echo "Running RooCode with file: $file"
    
    if [ -n "$output" ]; then
        roocode --headless --prompt "$prompt" --file "$file" --output "$output"
    else
        roocode --headless --prompt "$prompt" --file "$file"
    fi
}

# Pattern 3: Batch processing multiple files
roocode_batch() {
    local prompt="$1"
    shift
    local files=("$@")
    
    echo "Processing ${#files[@]} files with RooCode"
    
    roocode --headless --prompt "$prompt" --files "${files[@]}"
}

# Pattern 4: CI/CD pattern with exit code validation
roocode_cicd() {
    local prompt="$1"
    local files="$2"
    local output="${3:-}"
    
    echo "Running RooCode in CI/CD mode"
    
    if [ -n "$output" ]; then
        if roocode --headless --prompt "$prompt" --files $files --output "$output"; then
            echo "✅ RooCode completed successfully"
            return 0
        else
            echo "❌ RooCode failed"
            return 1
        fi
    else
        if roocode --headless --prompt "$prompt" --files $files; then
            echo "✅ RooCode completed successfully"
            return 0
        else
            echo "❌ RooCode failed"
            return 1
        fi
    fi
}

# Pattern 5: Code review automation
roocode_review() {
    local files="$1"
    local output="${2:-review-output.txt}"
    
    echo "Running code review with RooCode"
    
    roocode --headless --prompt "Review these code changes for potential bugs, security vulnerabilities, and adherence to best practices. Provide actionable suggestions for improvement." \
        --files $files \
        --output "$output"
}

# Pattern 6: Code transformation
roocode_transform() {
    local files="$1"
    local transformation_type="${2:-general}"
    
    echo "Transforming code with RooCode"
    
    case "$transformation_type" in
        "async")
            roocode --headless --prompt "Refactor to use async/await patterns where appropriate." \
                --files $files
            ;;
        "type_hints")
            roocode --headless --prompt "Add comprehensive type hints to all functions and classes." \
                --files $files
            ;;
        "error_handling")
            roocode --headless --prompt "Add comprehensive error handling and input validation to all functions." \
                --files $files
            ;;
        "modernize")
            roocode --headless --prompt "Modernize legacy code: update to latest language features and best practices." \
                --files $files
            ;;
        *)
            roocode --headless --prompt "Refactor code to improve readability, maintainability, and performance." \
                --files $files
            ;;
    esac
}

# Pattern 7: Documentation generation
roocode_add_docs() {
    local files="$1"
    local style="${2:-google}"
    
    echo "Adding documentation with RooCode"
    
    roocode --headless --prompt "Add comprehensive docstrings following $style style guide to all functions and classes." \
        --files $files
}

# Pattern 8: Test generation
roocode_generate_tests() {
    local source_file="$1"
    local test_file="$2"
    local coverage="${3:-80}"
    
    echo "Generating tests with RooCode"
    
    roocode --headless --prompt "Generate comprehensive unit tests with ${coverage}%+ coverage for $source_file. Write tests to $test_file." \
        --files "$source_file" "$test_file"
}

# Pattern 9: Security audit
roocode_security() {
    local files="$1"
    local output="${2:-security-audit.txt}"
    
    echo "Performing security audit with RooCode"
    
    roocode --headless --prompt "Perform security audit: identify vulnerabilities, insecure patterns, and suggest fixes. Focus on: injection attacks, authentication issues, data exposure, and insecure configurations." \
        --files $files \
        --output "$output"
}

# Pattern 10: Process changed files from Git
roocode_git_changes() {
    local prompt="$1"
    local base_branch="${2:-main}"
    
    echo "Processing changed files from Git"
    
    # Get changed code files
    CHANGED_FILES=$(git diff --name-only origin/$base_branch...HEAD | grep -E '\.(py|js|ts|java|go|rs)$' || true)
    
    if [ -z "$CHANGED_FILES" ]; then
        echo "No code files changed."
        return 0
    fi
    
    echo "Changed files: $CHANGED_FILES"
    
    roocode --headless --prompt "$prompt" --files $CHANGED_FILES
}

# Pattern 11: Directory-based analysis
roocode_analyze_directory() {
    local directory="$1"
    local prompt="${2:-Analyze codebase structure and suggest improvements}"
    local output="${3:-}"
    
    echo "Analyzing directory: $directory"
    
    if [ -n "$output" ]; then
        roocode --headless --prompt "$prompt" --directory "$directory" --output "$output"
    else
        roocode --headless --prompt "$prompt" --directory "$directory"
    fi
}

# Pattern 12: MCP server management
roocode_mcp_setup() {
    echo "Setting up MCP server for RooCode"
    
    roocode mcp setup
    roocode mcp start --daemon
}

# Pattern 13: Memory Bank integration
roocode_with_memory_bank() {
    local prompt="$1"
    local files="$2"
    local memory_bank_path="${3:-.memory-bank}"
    
    echo "Running RooCode with Memory Bank: $memory_bank_path"
    
    roocode --headless --prompt "$prompt" --files $files --memory-bank "$memory_bank_path"
}

# Pattern 14: Timeout handling for long operations
roocode_with_timeout() {
    local timeout_seconds="${1:-300}"
    local prompt="$2"
    local files="$3"
    
    echo "Running RooCode with ${timeout_seconds}s timeout"
    
    if command -v timeout &> /dev/null; then
        timeout "$timeout_seconds" roocode --headless --prompt "$prompt" --files $files
    else
        echo "Warning: timeout command not available, running without timeout"
        roocode --headless --prompt "$prompt" --files $files
    fi
}

# Example usage functions
example_basic_usage() {
    echo "=== Example: Basic Usage ==="
    roocode_basic "Add docstrings to all functions" "src/main.py"
}

example_batch_processing() {
    echo "=== Example: Batch Processing ==="
    roocode_batch "Add type hints" src/main.py src/utils.py src/helpers.py
}

example_cicd_workflow() {
    echo "=== Example: CI/CD Workflow ==="
    roocode_cicd "Fix linting issues" "src/*.py" "lint-fixes.txt"
}

example_git_integration() {
    echo "=== Example: Git Integration ==="
    roocode_git_changes "Add comprehensive documentation" "main"
}

# Main execution (if script is run directly)
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo "RooCode CLI Script Patterns"
    echo "==========================="
    echo ""
    echo "This script contains reusable patterns for RooCode automation."
    echo "Source this file to use the functions in your scripts:"
    echo "  source roocode-script-patterns.sh"
    echo ""
    echo "Available patterns:"
    echo "  - roocode_basic: Basic headless execution"
    echo "  - roocode_with_file: With file context"
    echo "  - roocode_batch: Batch processing"
    echo "  - roocode_cicd: CI/CD pattern"
    echo "  - roocode_review: Code review"
    echo "  - roocode_transform: Code transformation"
    echo "  - roocode_add_docs: Add documentation"
    echo "  - roocode_generate_tests: Generate tests"
    echo "  - roocode_security: Security audit"
    echo "  - roocode_git_changes: Process Git changes"
    echo "  - roocode_analyze_directory: Directory analysis"
    echo "  - roocode_mcp_setup: MCP server setup"
    echo "  - roocode_with_memory_bank: Memory Bank integration"
    echo "  - roocode_with_timeout: With timeout"
fi

