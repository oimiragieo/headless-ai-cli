#!/bin/bash
# Continue Dev CLI Script Patterns for Automation and CI/CD
# This file contains reusable patterns for using Continue Dev in automation workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Determine which command to use
CN_CMD="cn"
if ! command -v cn &> /dev/null; then
    CN_CMD="continue"
fi

# Pattern 1: Basic headless execution with error handling
continue_basic() {
    local prompt="$1"
    local files="${2:-}"
    
    echo "Running Continue Dev with prompt: $prompt"
    
    if [ -n "$files" ]; then
        if $CN_CMD -p "$prompt" --files $files; then
            echo -e "${GREEN}✅ Continue Dev completed successfully${NC}"
            return 0
        else
            echo -e "${RED}❌ Continue Dev failed${NC}"
            return 1
        fi
    else
        if $CN_CMD -p "$prompt"; then
            echo -e "${GREEN}✅ Continue Dev completed successfully${NC}"
            return 0
        else
            echo -e "${RED}❌ Continue Dev failed${NC}"
            return 1
        fi
    fi
}

# Pattern 2: Headless execution with file context
continue_with_file() {
    local prompt="$1"
    local file="$2"
    local output="${3:-}"
    
    echo "Running Continue Dev with file: $file"
    
    if [ -n "$output" ]; then
        $CN_CMD -p "$prompt" --file "$file" --output "$output"
    else
        $CN_CMD -p "$prompt" --file "$file"
    fi
}

# Pattern 3: Batch processing multiple files
continue_batch() {
    local prompt="$1"
    shift
    local files=("$@")
    
    echo "Processing ${#files[@]} files with Continue Dev"
    
    $CN_CMD -p "$prompt" --files "${files[@]}"
}

# Pattern 4: CI/CD pattern with exit code validation
continue_cicd() {
    local prompt="$1"
    local files="$2"
    local output="${3:-}"
    
    echo "Running Continue Dev in CI/CD mode"
    
    if [ -n "$output" ]; then
        if $CN_CMD -p "$prompt" --files $files --output "$output"; then
            echo "✅ Continue Dev completed successfully"
            return 0
        else
            echo "❌ Continue Dev failed"
            return 1
        fi
    else
        if $CN_CMD -p "$prompt" --files $files; then
            echo "✅ Continue Dev completed successfully"
            return 0
        else
            echo "❌ Continue Dev failed"
            return 1
        fi
    fi
}

# Pattern 5: Documentation update automation
continue_update_docs() {
    local files="${1:-}"
    
    echo "Updating documentation with Continue Dev"
    
    if [ -n "$files" ]; then
        $CN_CMD -p "Analyze recent code changes and update the documentation accordingly." --files $files
    else
        $CN_CMD -p "Analyze recent code changes and update the documentation accordingly."
    fi
}

# Pattern 6: Code review automation
continue_review() {
    local files="$1"
    local output="${2:-review-output.txt}"
    
    echo "Running code review with Continue Dev"
    
    $CN_CMD -p "Review these code changes for potential bugs, security vulnerabilities, and adherence to best practices. Provide actionable suggestions for improvement." \
        --files $files \
        --output "$output"
}

# Pattern 7: Code transformation
continue_transform() {
    local files="$1"
    local transformation_type="${2:-general}"
    
    echo "Transforming code with Continue Dev"
    
    case "$transformation_type" in
        "async")
            $CN_CMD -p "Refactor to use async/await patterns where appropriate." \
                --files $files
            ;;
        "type_hints")
            $CN_CMD -p "Add comprehensive type hints to all functions and classes." \
                --files $files
            ;;
        "error_handling")
            $CN_CMD -p "Add comprehensive error handling and input validation to all functions." \
                --files $files
            ;;
        "modernize")
            $CN_CMD -p "Modernize legacy code: update to latest language features and best practices." \
                --files $files
            ;;
        *)
            $CN_CMD -p "Refactor code to improve readability, maintainability, and performance." \
                --files $files
            ;;
    esac
}

# Pattern 8: Documentation generation
continue_add_docs() {
    local files="$1"
    local style="${2:-google}"
    
    echo "Adding documentation with Continue Dev"
    
    $CN_CMD -p "Add comprehensive docstrings following $style style guide to all functions and classes." \
        --files $files
}

# Pattern 9: Test generation
continue_generate_tests() {
    local source_file="$1"
    local test_file="$2"
    local coverage="${3:-80}"
    
    echo "Generating tests with Continue Dev"
    
    $CN_CMD -p "Generate comprehensive unit tests with ${coverage}%+ coverage for $source_file. Write tests to $test_file." \
        --files "$source_file" "$test_file"
}

# Pattern 10: Security audit
continue_security() {
    local files="$1"
    local output="${2:-security-audit.txt}"
    
    echo "Performing security audit with Continue Dev"
    
    $CN_CMD -p "Perform security audit: identify vulnerabilities, insecure patterns, and suggest fixes. Focus on: injection attacks, authentication issues, data exposure, and insecure configurations." \
        --files $files \
        --output "$output"
}

# Pattern 11: Process changed files from Git
continue_git_changes() {
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
    
    $CN_CMD -p "$prompt" --files $CHANGED_FILES
}

# Pattern 12: Directory-based analysis
continue_analyze_directory() {
    local directory="$1"
    local prompt="${2:-Analyze codebase structure and suggest improvements}"
    local output="${3:-}"
    
    echo "Analyzing directory: $directory"
    
    if [ -n "$output" ]; then
        $CN_CMD -p "$prompt" --directory "$directory" --output "$output"
    else
        $CN_CMD -p "$prompt" --directory "$directory"
    fi
}

# Pattern 13: Timeout handling for long operations
continue_with_timeout() {
    local timeout_seconds="${1:-300}"
    local prompt="$2"
    local files="$3"
    
    echo "Running Continue Dev with ${timeout_seconds}s timeout"
    
    if command -v timeout &> /dev/null; then
        timeout "$timeout_seconds" $CN_CMD -p "$prompt" --files $files
    else
        echo "Warning: timeout command not available, running without timeout"
        $CN_CMD -p "$prompt" --files $files
    fi
}

# Pattern 14: Model-specific execution
continue_with_model() {
    local model="$1"
    local prompt="$2"
    local files="$3"
    
    echo "Running Continue Dev with model: $model"
    
    $CN_CMD -p "$prompt" --model "$model" --files $files
}

# Example usage functions
example_basic_usage() {
    echo "=== Example: Basic Usage ==="
    continue_basic "Add docstrings to all functions" "src/main.py"
}

example_batch_processing() {
    echo "=== Example: Batch Processing ==="
    continue_batch "Add type hints" src/main.py src/utils.py src/helpers.py
}

example_cicd_workflow() {
    echo "=== Example: CI/CD Workflow ==="
    continue_cicd "Fix linting issues" "src/*.py" "lint-fixes.txt"
}

example_git_integration() {
    echo "=== Example: Git Integration ==="
    continue_git_changes "Add comprehensive documentation" "main"
}

# Main execution (if script is run directly)
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo "Continue Dev CLI Script Patterns"
    echo "================================"
    echo ""
    echo "This script contains reusable patterns for Continue Dev automation."
    echo "Source this file to use the functions in your scripts:"
    echo "  source continue-dev-script-patterns.sh"
    echo ""
    echo "Available patterns:"
    echo "  - continue_basic: Basic headless execution"
    echo "  - continue_with_file: With file context"
    echo "  - continue_batch: Batch processing"
    echo "  - continue_cicd: CI/CD pattern"
    echo "  - continue_update_docs: Documentation update"
    echo "  - continue_review: Code review"
    echo "  - continue_transform: Code transformation"
    echo "  - continue_add_docs: Add documentation"
    echo "  - continue_generate_tests: Generate tests"
    echo "  - continue_security: Security audit"
    echo "  - continue_git_changes: Process Git changes"
    echo "  - continue_analyze_directory: Directory analysis"
    echo "  - continue_with_timeout: With timeout"
    echo "  - continue_with_model: Model-specific execution"
fi

