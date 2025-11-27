#!/bin/bash
# Reusable Script Patterns for GitHub Copilot CLI
# This file contains common patterns and utilities for using Copilot CLI in automation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
COPILOT_MODEL="${COPILOT_MODEL:-claude-sonnet-4.5}"
COPILOT_SILENT="${COPILOT_SILENT:-true}"
COPILOT_NO_COLOR="${COPILOT_NO_COLOR:-true}"
COPILOT_LOG_LEVEL="${COPILOT_LOG_LEVEL:-error}"

# Function: Check if Copilot CLI is installed
check_copilot_installed() {
    if ! command -v copilot &> /dev/null; then
        echo -e "${RED}Error: Copilot CLI not found. Install with: npm install -g @github/copilot${NC}" >&2
        exit 1
    fi
}

# Function: Run Copilot with standard CI/CD flags
run_copilot() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$COPILOT_MODEL}"
    
    local cmd="copilot -p \"$prompt\""
    
    # Add model if specified
    [ -n "$model" ] && cmd="$cmd --model $model"
    
    # Add CI/CD flags
    [ "$COPILOT_SILENT" = "true" ] && cmd="$cmd --silent"
    [ "$COPILOT_NO_COLOR" = "true" ] && cmd="$cmd --no-color"
    [ -n "$COPILOT_LOG_LEVEL" ] && cmd="$cmd --log-level $COPILOT_LOG_LEVEL"
    
    # Add tool approval
    cmd="$cmd --allow-all-tools"
    
    # Redirect output if file specified
    if [ -n "$output_file" ]; then
        cmd="$cmd > \"$output_file\" 2>&1"
    fi
    
    eval "$cmd"
    return $?
}

# Function: Run Copilot with error handling
run_copilot_safe() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$COPILOT_MODEL}"
    local max_retries="${4:-3}"
    
    local attempt=1
    while [ $attempt -le $max_retries ]; do
        echo -e "${BLUE}Attempt $attempt/$max_retries: Running Copilot...${NC}" >&2
        
        if run_copilot "$prompt" "$output_file" "$model"; then
            echo -e "${GREEN}Copilot command succeeded${NC}" >&2
            return 0
        else
            local exit_code=$?
            echo -e "${YELLOW}Copilot command failed with exit code $exit_code${NC}" >&2
            
            if [ $attempt -lt $max_retries ]; then
                echo -e "${YELLOW}Retrying in 2 seconds...${NC}" >&2
                sleep 2
            fi
        fi
        
        attempt=$((attempt + 1))
    done
    
    echo -e "${RED}Copilot command failed after $max_retries attempts${NC}" >&2
    return 1
}

# Function: Batch process files with Copilot
batch_process_files() {
    local pattern="$1"
    local prompt_template="$2"
    local output_dir="${3:-./reports}"
    local model="${4:-$COPILOT_MODEL}"
    
    mkdir -p "$output_dir"
    
    local processed=0
    local failed=0
    
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local output_file="$output_dir/${filename}.review"
            local prompt=$(echo "$prompt_template" | sed "s|{FILE}|$file|g")
            
            echo -e "${BLUE}Processing: $file${NC}" >&2
            
            if run_copilot "$prompt" "$output_file" "$model"; then
                processed=$((processed + 1))
                echo -e "${GREEN}✓ Processed: $file${NC}" >&2
            else
                failed=$((failed + 1))
                echo -e "${RED}✗ Failed: $file${NC}" >&2
            fi
        fi
    done < <(find . -type f -name "$pattern" 2>/dev/null)
    
    echo -e "${GREEN}Batch processing complete: $processed processed, $failed failed${NC}" >&2
    return $failed
}

# Function: Generate code review for git diff
review_git_diff() {
    local base_branch="${1:-main}"
    local output_file="${2:-code-review.txt}"
    local model="${3:-$COPILOT_MODEL}"
    
    echo -e "${BLUE}Generating code review for changes from $base_branch...${NC}" >&2
    
    local prompt="Review these code changes for bugs, security issues, code quality, and best practices. Provide specific, actionable feedback."
    
    git diff "origin/$base_branch...HEAD" | \
        run_copilot "$prompt" "$output_file" "$model"
    
    return $?
}

# Function: Generate tests for a file
generate_tests() {
    local file="$1"
    local output_file="${2:-}"
    local model="${3:-claude-haiku-4.5}"
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: File not found: $file${NC}" >&2
        return 1
    fi
    
    echo -e "${BLUE}Generating tests for: $file${NC}" >&2
    
    local prompt="Generate comprehensive unit tests for the following code file: $file. Create test files with the same structure in the tests/ directory."
    
    run_copilot "$prompt" "$output_file" "$model"
    return $?
}

# Function: Security audit
security_audit() {
    local directory="${1:-.}"
    local output_file="${2:-security-audit.txt}"
    local model="${3:-claude-sonnet-4.5}"
    
    echo -e "${BLUE}Running security audit on: $directory${NC}" >&2
    
    local prompt="Perform a security audit of the code in $directory. Check for common vulnerabilities, insecure patterns, SQL injection risks, XSS vulnerabilities, and compliance issues. Generate a detailed security report."
    
    run_copilot "$prompt" "$output_file" "$model"
    return $?
}

# Function: Update documentation
update_documentation() {
    local doc_dir="${1:-docs}"
    local output_file="${2:-doc-update.log}"
    local model="${3:-claude-sonnet-4.5}"
    
    echo -e "${BLUE}Updating documentation in: $doc_dir${NC}" >&2
    
    local prompt="Review all documentation files in $doc_dir and update them to reflect the latest code changes. Ensure all code examples are current, accurate, and follow best practices."
    
    run_copilot "$prompt" "$output_file" "$model"
    return $?
}

# Function: Cost-optimized execution (uses cheaper models)
run_copilot_cost_optimized() {
    local prompt="$1"
    local output_file="${2:-}"
    
    # Use Haiku for cost-effective operations
    run_copilot "$prompt" "$output_file" "claude-haiku-4.5"
    return $?
}

# Function: High-quality execution (uses best models)
run_copilot_high_quality() {
    local prompt="$1"
    local output_file="${2:-}"
    
    # Use Sonnet for high-quality operations
    run_copilot "$prompt" "$output_file" "claude-sonnet-4.5"
    return $?
}

# Function: Parse Copilot output for actionable items
parse_copilot_output() {
    local input_file="$1"
    local output_file="${2:-actionable-items.txt}"
    
    if [ ! -f "$input_file" ]; then
        echo -e "${RED}Error: Input file not found: $input_file${NC}" >&2
        return 1
    fi
    
    # Extract actionable items (lines with TODO, FIXME, or action verbs)
    grep -iE "(TODO|FIXME|should|must|need to|recommend|suggest)" "$input_file" > "$output_file" || true
    
    echo -e "${GREEN}Actionable items extracted to: $output_file${NC}" >&2
    return 0
}

# Example usage functions
example_code_review() {
    echo -e "${BLUE}=== Example: Code Review ===${NC}"
    review_git_diff "main" "code-review.txt"
}

example_batch_processing() {
    echo -e "${BLUE}=== Example: Batch Processing ===${NC}"
    batch_process_files "*.js" "Review {FILE} for security issues and code quality" "./reviews"
}

example_test_generation() {
    echo -e "${BLUE}=== Example: Test Generation ===${NC}"
    if [ -n "$1" ] && [ -f "$1" ]; then
        generate_tests "$1" "test-generation.log"
    else
        echo -e "${YELLOW}Usage: example_test_generation <file_path>${NC}" >&2
    fi
}

# Main execution
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # Script is being executed directly
    check_copilot_installed
    
    case "${1:-help}" in
        review)
            review_git_diff "${2:-main}" "${3:-code-review.txt}"
            ;;
        batch)
            batch_process_files "${2:-*.js}" "${3:-Review {FILE}}" "${4:-./reports}"
            ;;
        tests)
            generate_tests "${2:-}" "${3:-test-generation.log}"
            ;;
        security)
            security_audit "${2:-.}" "${3:-security-audit.txt}"
            ;;
        docs)
            update_documentation "${2:-docs}" "${3:-doc-update.log}"
            ;;
        *)
            echo "Usage: $0 {review|batch|tests|security|docs} [args...]"
            echo ""
            echo "Examples:"
            echo "  $0 review main code-review.txt"
            echo "  $0 batch '*.js' 'Review {FILE}' ./reports"
            echo "  $0 tests src/main.js test-output.log"
            echo "  $0 security . security-report.txt"
            echo "  $0 docs docs/ doc-update.log"
            exit 1
            ;;
    esac
fi

