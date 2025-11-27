#!/bin/bash
# OpenCode CLI Script Patterns for Automation and CI/CD
# This file contains reusable patterns for using OpenCode in automation workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Pattern 1: Basic headless execution with error handling
opencode_basic() {
    local prompt="$1"
    local files="$2"
    
    echo "Running OpenCode with prompt: $prompt"
    
    if opencode --headless --prompt "$prompt" --files $files; then
        echo -e "${GREEN}✅ OpenCode completed successfully${NC}"
        return 0
    else
        echo -e "${RED}❌ OpenCode failed${NC}"
        return 1
    fi
}

# Pattern 2: Headless execution with file context
opencode_with_file() {
    local prompt="$1"
    local file="$2"
    local output="${3:-}"
    
    echo "Running OpenCode with file: $file"
    
    if [ -n "$output" ]; then
        opencode --headless --prompt "$prompt" --file "$file" --output "$output"
    else
        opencode --headless --prompt "$prompt" --file "$file"
    fi
}

# Pattern 3: Batch processing multiple files
opencode_batch() {
    local prompt="$1"
    shift
    local files=("$@")
    
    echo "Processing ${#files[@]} files with OpenCode"
    
    opencode --headless --prompt "$prompt" --files "${files[@]}"
}

# Pattern 4: CI/CD pattern with exit code validation
opencode_cicd() {
    local prompt="$1"
    local files="$2"
    local output="${3:-}"
    
    echo "Running OpenCode in CI/CD mode"
    
    if [ -n "$output" ]; then
        if opencode --headless --prompt "$prompt" --files $files --output "$output"; then
            echo "✅ OpenCode completed successfully"
            return 0
        else
            echo "❌ OpenCode failed"
            return 1
        fi
    else
        if opencode --headless --prompt "$prompt" --files $files; then
            echo "✅ OpenCode completed successfully"
            return 0
        else
            echo "❌ OpenCode failed"
            return 1
        fi
    fi
}

# Pattern 5: Code review automation
opencode_review() {
    local files="$1"
    local output="${2:-review-output.txt}"
    
    echo "Running code review with OpenCode"
    
    opencode --headless --prompt "Review these code changes for potential bugs, security vulnerabilities, and adherence to best practices. Provide actionable suggestions for improvement." \
        --files $files \
        --output "$output"
}

# Pattern 6: Code transformation
opencode_transform() {
    local files="$1"
    local transformation_type="${2:-general}"
    
    echo "Transforming code with OpenCode"
    
    case "$transformation_type" in
        "async")
            opencode --headless --prompt "Refactor to use async/await patterns where appropriate." \
                --files $files
            ;;
        "type_hints")
            opencode --headless --prompt "Add comprehensive type hints to all functions and classes." \
                --files $files
            ;;
        "error_handling")
            opencode --headless --prompt "Add comprehensive error handling and input validation to all functions." \
                --files $files
            ;;
        "modernize")
            opencode --headless --prompt "Modernize legacy code: update to latest language features and best practices." \
                --files $files
            ;;
        *)
            opencode --headless --prompt "Refactor code to improve readability, maintainability, and performance." \
                --files $files
            ;;
    esac
}

# Pattern 7: Documentation generation
opencode_add_docs() {
    local files="$1"
    local style="${2:-google}"
    
    echo "Adding documentation with OpenCode"
    
    opencode --headless --prompt "Add comprehensive docstrings following $style style guide to all functions and classes." \
        --files $files
}

# Pattern 8: Test generation
opencode_generate_tests() {
    local source_file="$1"
    local test_file="$2"
    local coverage="${3:-80}"
    
    echo "Generating tests with OpenCode"
    
    opencode --headless --prompt "Generate comprehensive unit tests with ${coverage}%+ coverage for $source_file. Write tests to $test_file." \
        --files "$source_file" "$test_file"
}

# Pattern 9: Security audit
opencode_security() {
    local files="$1"
    local output="${2:-security-audit.txt}"
    
    echo "Performing security audit with OpenCode"
    
    opencode --headless --prompt "Perform security audit: identify vulnerabilities, insecure patterns, and suggest fixes. Focus on: injection attacks, authentication issues, data exposure, and insecure configurations." \
        --files $files \
        --output "$output"
}

# Pattern 10: Process changed files from Git
opencode_git_changes() {
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
    
    opencode --headless --prompt "$prompt" --files $CHANGED_FILES
}

# Pattern 11: Directory-based analysis
opencode_analyze_directory() {
    local directory="$1"
    local prompt="${2:-Analyze codebase structure and suggest improvements}"
    local output="${3:-}"
    
    echo "Analyzing directory: $directory"
    
    if [ -n "$output" ]; then
        opencode --headless --prompt "$prompt" --directory "$directory" --output "$output"
    else
        opencode --headless --prompt "$prompt" --directory "$directory"
    fi
}

# Pattern 12: Timeout handling for long operations
opencode_with_timeout() {
    local timeout_seconds="${1:-300}"
    local prompt="$2"
    local files="$3"
    
    echo "Running OpenCode with ${timeout_seconds}s timeout"
    
    if command -v timeout &> /dev/null; then
        timeout "$timeout_seconds" opencode --headless --prompt "$prompt" --files $files
    else
        echo "Warning: timeout command not available, running without timeout"
        opencode --headless --prompt "$prompt" --files $files
    fi
}

# Pattern 13: Stdin input processing
opencode_stdin() {
    local file="${1:-}"
    
    echo "Processing stdin input with OpenCode"
    
    if [ -n "$file" ]; then
        cat | opencode --headless --file "$file"
    else
        cat | opencode --headless
    fi
}

# Pattern 14: Model-specific execution
opencode_with_model() {
    local model="$1"
    local prompt="$2"
    local files="$3"
    
    echo "Running OpenCode with model: $model"
    
    opencode --headless --model "$model" --prompt "$prompt" --files $files
}

# Example usage functions
example_basic_usage() {
    echo "=== Example: Basic Usage ==="
    opencode_basic "Add docstrings to all functions" "src/main.py"
}

example_batch_processing() {
    echo "=== Example: Batch Processing ==="
    opencode_batch "Add type hints" src/main.py src/utils.py src/helpers.py
}

example_cicd_workflow() {
    echo "=== Example: CI/CD Workflow ==="
    opencode_cicd "Fix linting issues" "src/*.py" "lint-fixes.txt"
}

example_git_integration() {
    echo "=== Example: Git Integration ==="
    opencode_git_changes "Add comprehensive documentation" "main"
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
    echo "Available patterns:"
    echo "  - opencode_basic: Basic headless execution"
    echo "  - opencode_with_file: With file context"
    echo "  - opencode_batch: Batch processing"
    echo "  - opencode_cicd: CI/CD pattern"
    echo "  - opencode_review: Code review"
    echo "  - opencode_transform: Code transformation"
    echo "  - opencode_add_docs: Add documentation"
    echo "  - opencode_generate_tests: Generate tests"
    echo "  - opencode_security: Security audit"
    echo "  - opencode_git_changes: Process Git changes"
    echo "  - opencode_analyze_directory: Directory analysis"
    echo "  - opencode_with_timeout: With timeout"
    echo "  - opencode_stdin: Stdin input processing"
    echo "  - opencode_with_model: Model-specific execution"
fi

