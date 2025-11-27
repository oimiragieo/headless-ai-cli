#!/bin/bash
# Amazon Q Developer CLI Script Patterns for Automation and CI/CD
# This file contains reusable patterns for using Amazon Q Developer in automation workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Pattern 1: Basic headless execution with error handling
amazonq_basic() {
    local prompt="$1"
    local files="$2"
    
    echo "Running Amazon Q Developer with prompt: $prompt"
    
    if q chat --prompt "$prompt" --files $files; then
        echo -e "${GREEN}✅ Amazon Q Developer completed successfully${NC}"
        return 0
    else
        echo -e "${RED}❌ Amazon Q Developer failed${NC}"
        return 1
    fi
}

# Pattern 2: Headless execution with file context
amazonq_with_file() {
    local prompt="$1"
    local file="$2"
    local output="${3:-}"
    
    echo "Running Amazon Q Developer with file: $file"
    
    if [ -n "$output" ]; then
        q chat --prompt "$prompt" --file "$file" --output "$output"
    else
        q chat --prompt "$prompt" --file "$file"
    fi
}

# Pattern 3: Batch processing multiple files
amazonq_batch() {
    local prompt="$1"
    shift
    local files=("$@")
    
    echo "Processing ${#files[@]} files with Amazon Q Developer"
    
    q chat --prompt "$prompt" --files "${files[@]}"
}

# Pattern 4: CI/CD pattern with exit code validation
amazonq_cicd() {
    local prompt="$1"
    local files="$2"
    local output="${3:-}"
    
    echo "Running Amazon Q Developer in CI/CD mode"
    
    if [ -n "$output" ]; then
        if q chat --prompt "$prompt" --files $files --output "$output"; then
            echo "✅ Amazon Q Developer completed successfully"
            return 0
        else
            echo "❌ Amazon Q Developer failed"
            return 1
        fi
    else
        if q chat --prompt "$prompt" --files $files; then
            echo "✅ Amazon Q Developer completed successfully"
            return 0
        else
            echo "❌ Amazon Q Developer failed"
            return 1
        fi
    fi
}

# Pattern 5: Code review automation
amazonq_review() {
    local files="$1"
    local output="${2:-review-output.txt}"
    
    echo "Running code review with Amazon Q Developer"
    
    q chat --prompt "Review these code changes for potential bugs, security vulnerabilities, and adherence to best practices. Provide actionable suggestions for improvement." \
        --files $files \
        --output "$output"
}

# Pattern 6: Code transformation
amazonq_transform() {
    local files="$1"
    local transformation_type="${2:-general}"
    
    echo "Transforming code with Amazon Q Developer"
    
    case "$transformation_type" in
        "async")
            q chat --prompt "Refactor to use async/await patterns where appropriate." \
                --files $files
            ;;
        "type_hints")
            q chat --prompt "Add comprehensive type hints to all functions and classes." \
                --files $files
            ;;
        "error_handling")
            q chat --prompt "Add comprehensive error handling and input validation to all functions." \
                --files $files
            ;;
        "modernize")
            q chat --prompt "Modernize legacy code: update to latest language features and best practices." \
                --files $files
            ;;
        *)
            q chat --prompt "Refactor code to improve readability, maintainability, and performance." \
                --files $files
            ;;
    esac
}

# Pattern 7: Documentation generation
amazonq_add_docs() {
    local files="$1"
    local style="${2:-google}"
    
    echo "Adding documentation with Amazon Q Developer"
    
    q chat --prompt "Add comprehensive docstrings following $style style guide to all functions and classes." \
        --files $files
}

# Pattern 8: Test generation
amazonq_generate_tests() {
    local source_file="$1"
    local test_file="$2"
    local coverage="${3:-80}"
    
    echo "Generating tests with Amazon Q Developer"
    
    q chat --prompt "Generate comprehensive unit tests with ${coverage}%+ coverage for $source_file. Write tests to $test_file." \
        --files "$source_file" "$test_file"
}

# Pattern 9: Security audit
amazonq_security() {
    local files="$1"
    local output="${2:-security-audit.txt}"
    
    echo "Performing security audit with Amazon Q Developer"
    
    q chat --prompt "Perform security audit: identify vulnerabilities, insecure patterns, and suggest fixes. Focus on: injection attacks, authentication issues, data exposure, and insecure configurations." \
        --files $files \
        --output "$output"
}

# Pattern 10: Process changed files from Git
amazonq_git_changes() {
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
    
    q chat --prompt "$prompt" --files $CHANGED_FILES
}

# Pattern 11: Directory-based analysis
amazonq_analyze_directory() {
    local directory="$1"
    local prompt="${2:-Analyze codebase structure and suggest improvements}"
    local output="${3:-}"
    
    echo "Analyzing directory: $directory"
    
    if [ -n "$output" ]; then
        q chat --prompt "$prompt" --directory "$directory" --output "$output"
    else
        q chat --prompt "$prompt" --directory "$directory"
    fi
}

# Pattern 12: Timeout handling for long operations
amazonq_with_timeout() {
    local timeout_seconds="${1:-300}"
    local prompt="$2"
    local files="$3"
    
    echo "Running Amazon Q Developer with ${timeout_seconds}s timeout"
    
    if command -v timeout &> /dev/null; then
        timeout "$timeout_seconds" q chat --prompt "$prompt" --files $files
    else
        echo "Warning: timeout command not available, running without timeout"
        q chat --prompt "$prompt" --files $files
    fi
}

# Pattern 13: Stdin input processing
amazonq_stdin() {
    local file="${1:-}"
    
    echo "Processing stdin input with Amazon Q Developer"
    
    if [ -n "$file" ]; then
        cat | q chat --file "$file"
    else
        cat | q chat
    fi
}

# Example usage functions
example_basic_usage() {
    echo "=== Example: Basic Usage ==="
    amazonq_basic "Add docstrings to all functions" "src/main.py"
}

example_batch_processing() {
    echo "=== Example: Batch Processing ==="
    amazonq_batch "Add type hints" src/main.py src/utils.py src/helpers.py
}

example_cicd_workflow() {
    echo "=== Example: CI/CD Workflow ==="
    amazonq_cicd "Fix linting issues" "src/*.py" "lint-fixes.txt"
}

example_git_integration() {
    echo "=== Example: Git Integration ==="
    amazonq_git_changes "Add comprehensive documentation" "main"
}

# Main execution (if script is run directly)
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo "Amazon Q Developer CLI Script Patterns"
    echo "======================================="
    echo ""
    echo "This script contains reusable patterns for Amazon Q Developer automation."
    echo "Source this file to use the functions in your scripts:"
    echo "  source amazon-q-script-patterns.sh"
    echo ""
    echo "Available patterns:"
    echo "  - amazonq_basic: Basic headless execution"
    echo "  - amazonq_with_file: With file context"
    echo "  - amazonq_batch: Batch processing"
    echo "  - amazonq_cicd: CI/CD pattern"
    echo "  - amazonq_review: Code review"
    echo "  - amazonq_transform: Code transformation"
    echo "  - amazonq_add_docs: Add documentation"
    echo "  - amazonq_generate_tests: Generate tests"
    echo "  - amazonq_security: Security audit"
    echo "  - amazonq_git_changes: Process Git changes"
    echo "  - amazonq_analyze_directory: Directory analysis"
    echo "  - amazonq_with_timeout: With timeout"
    echo "  - amazonq_stdin: Stdin input processing"
fi

