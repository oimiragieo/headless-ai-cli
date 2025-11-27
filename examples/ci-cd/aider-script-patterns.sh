#!/bin/bash
# Aider CLI Script Patterns for Automation and CI/CD
# This file contains reusable patterns for using Aider in automation workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Pattern 1: Basic headless execution with error handling
aider_basic() {
    local prompt="$1"
    local files="$2"
    
    echo "Running Aider with prompt: $prompt"
    
    if aider --yes --message "$prompt" $files; then
        echo -e "${GREEN}✅ Aider completed successfully${NC}"
        return 0
    else
        echo -e "${RED}❌ Aider failed${NC}"
        return 1
    fi
}

# Pattern 2: Headless execution with model specification
aider_with_model() {
    local model="$1"
    local prompt="$2"
    local files="$3"
    
    echo "Running Aider with model: $model"
    
    aider --yes --model "$model" --message "$prompt" $files
}

# Pattern 3: Batch processing multiple files
aider_batch() {
    local prompt="$1"
    shift
    local files=("$@")
    
    echo "Processing ${#files[@]} files with Aider"
    
    aider --yes --message "$prompt" "${files[@]}"
}

# Pattern 4: CI/CD pattern with exit code validation
aider_cicd() {
    local prompt="$1"
    local files="$2"
    local model="${3:-gpt-4o}"
    
    echo "Running Aider in CI/CD mode"
    
    if aider --yes --no-git --model "$model" --message "$prompt" $files; then
        echo "✅ Aider completed successfully"
        return 0
    else
        echo "❌ Aider failed"
        return 1
    fi
}

# Pattern 5: Code review automation
aider_review() {
    local files="$1"
    
    echo "Running code review with Aider"
    
    aider --yes \
        --model claude-3.7-sonnet \
        --message "Review these code changes for potential bugs, security vulnerabilities, and adherence to best practices. Provide actionable suggestions for improvement." \
        $files
}

# Pattern 6: Linting fixes
aider_fix_linting() {
    local files="$1"
    
    echo "Fixing linting issues with Aider"
    
    aider --yes \
        --model gpt-4o \
        --message "Fix all linting issues, add missing type hints, and ensure code follows PEP 8 style guide. Do not change functionality." \
        $files
}

# Pattern 7: Documentation generation
aider_add_docs() {
    local files="$1"
    
    echo "Adding documentation with Aider"
    
    aider --yes \
        --model gpt-4o \
        --message "Add comprehensive docstrings following Google style guide to all functions and classes." \
        $files
}

# Pattern 8: Test generation
aider_generate_tests() {
    local source_file="$1"
    local test_file="$2"
    
    echo "Generating tests with Aider"
    
    aider --yes \
        --model gpt-4o \
        --message "Generate comprehensive unit tests with 80%+ coverage for $source_file. Write tests to $test_file." \
        "$source_file" "$test_file"
}

# Pattern 9: Refactoring
aider_refactor() {
    local files="$1"
    local refactor_type="${2:-general}"
    
    echo "Refactoring code with Aider"
    
    case "$refactor_type" in
        "async")
            aider --yes --model claude-3.7-sonnet \
                --message "Refactor to use async/await patterns where appropriate." \
                $files
            ;;
        "type_hints")
            aider --yes --model gpt-4o \
                --message "Add comprehensive type hints to all functions and classes." \
                $files
            ;;
        "error_handling")
            aider --yes --model claude-3.7-sonnet \
                --message "Add comprehensive error handling and input validation to all functions." \
                $files
            ;;
        *)
            aider --yes --model gpt-4o \
                --message "Refactor code to improve readability, maintainability, and performance." \
                $files
            ;;
    esac
}

# Pattern 10: Security improvements
aider_security() {
    local files="$1"
    
    echo "Improving security with Aider"
    
    aider --yes \
        --model claude-3.7-sonnet \
        --message "Review and fix security vulnerabilities. Add input validation, sanitize user inputs, and follow security best practices." \
        $files
}

# Pattern 11: Process changed files from Git
aider_git_changes() {
    local prompt="$1"
    local base_branch="${2:-main}"
    
    echo "Processing changed files from Git"
    
    # Get changed Python files
    CHANGED_FILES=$(git diff --name-only origin/$base_branch...HEAD | grep '\.py$' || true)
    
    if [ -z "$CHANGED_FILES" ]; then
        echo "No Python files changed."
        return 0
    fi
    
    echo "Changed files: $CHANGED_FILES"
    
    aider --yes --message "$prompt" $CHANGED_FILES
}

# Pattern 12: Timeout handling for long operations
aider_with_timeout() {
    local timeout_seconds="${1:-300}"
    local prompt="$2"
    local files="$3"
    
    echo "Running Aider with ${timeout_seconds}s timeout"
    
    if command -v timeout &> /dev/null; then
        timeout "$timeout_seconds" aider --yes --message "$prompt" $files
    else
        echo "Warning: timeout command not available, running without timeout"
        aider --yes --message "$prompt" $files
    fi
}

# Pattern 13: Environment variable configuration
aider_with_env() {
    local provider="$1"  # "openai" or "anthropic"
    local api_key="$2"
    local prompt="$3"
    local files="$4"
    
    echo "Running Aider with $provider API key"
    
    if [ "$provider" == "openai" ]; then
        OPENAI_API_KEY="$api_key" aider --yes --message "$prompt" $files
    elif [ "$provider" == "anthropic" ]; then
        ANTHROPIC_API_KEY="$api_key" aider --yes --message "$prompt" $files
    else
        echo "Error: Unknown provider. Use 'openai' or 'anthropic'"
        return 1
    fi
}

# Example usage functions
example_basic_usage() {
    echo "=== Example: Basic Usage ==="
    aider_basic "Add docstrings to all functions" "src/main.py"
}

example_batch_processing() {
    echo "=== Example: Batch Processing ==="
    aider_batch "Add type hints" src/main.py src/utils.py src/helpers.py
}

example_cicd_workflow() {
    echo "=== Example: CI/CD Workflow ==="
    aider_cicd "Fix linting issues" "src/*.py" "gpt-4o"
}

example_git_integration() {
    echo "=== Example: Git Integration ==="
    aider_git_changes "Add comprehensive documentation" "main"
}

# Main execution (if script is run directly)
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo "Aider CLI Script Patterns"
    echo "========================="
    echo ""
    echo "This script contains reusable patterns for Aider automation."
    echo "Source this file to use the functions in your scripts:"
    echo "  source aider-script-patterns.sh"
    echo ""
    echo "Available patterns:"
    echo "  - aider_basic: Basic headless execution"
    echo "  - aider_with_model: With model specification"
    echo "  - aider_batch: Batch processing"
    echo "  - aider_cicd: CI/CD pattern"
    echo "  - aider_review: Code review"
    echo "  - aider_fix_linting: Fix linting"
    echo "  - aider_add_docs: Add documentation"
    echo "  - aider_generate_tests: Generate tests"
    echo "  - aider_refactor: Refactoring"
    echo "  - aider_security: Security improvements"
    echo "  - aider_git_changes: Process Git changes"
    echo "  - aider_with_timeout: With timeout"
    echo "  - aider_with_env: With environment variables"
fi

