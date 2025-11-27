#!/bin/bash
# Reusable Script Patterns for Cursor Agent CLI
# This file contains common patterns and utilities for using Cursor Agent CLI in automation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CURSOR_MODEL="${CURSOR_MODEL:-auto}"
CURSOR_OUTPUT_FORMAT="${CURSOR_OUTPUT_FORMAT:-json}"
CURSOR_TIMEOUT="${CURSOR_TIMEOUT:-300}" # 5 minutes default timeout (known issue: process may not release terminal)

# Function: Check if Cursor Agent CLI is installed
check_cursor_installed() {
    if ! command -v cursor-agent &> /dev/null; then
        echo -e "${RED}Error: Cursor Agent CLI not found. Install with: curl https://cursor.com/install -fsS | bash${NC}" >&2
        exit 1
    fi
}

# Function: Check if API key is set
check_api_key() {
    if [ -z "$CURSOR_API_KEY" ]; then
        echo -e "${RED}Error: CURSOR_API_KEY must be set${NC}" >&2
        exit 1
    fi
}

# Function: Run Cursor with standard CI/CD flags
run_cursor() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$CURSOR_MODEL}"
    local use_force="${4:-false}"
    local use_json="${5:-true}"
    local timeout="${6:-$CURSOR_TIMEOUT}"
    
    local cmd="timeout $timeout cursor-agent -p"
    
    # Add force flag if needed
    [ "$use_force" = "true" ] && cmd="$cmd --force"
    
    # Add model if specified
    [ -n "$model" ] && cmd="$cmd --model $model"
    
    # Add output format
    if [ "$use_json" = "true" ]; then
        cmd="$cmd --output-format json"
    fi
    
    # Add prompt
    cmd="$cmd \"$prompt\""
    
    # Redirect output if file specified
    if [ -n "$output_file" ]; then
        cmd="$cmd > \"$output_file\" 2>&1"
    fi
    
    eval "$cmd"
    return $?
}

# Function: Run Cursor with error handling
run_cursor_safe() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$CURSOR_MODEL}"
    local max_retries="${4:-3}"
    local timeout="${5:-$CURSOR_TIMEOUT}"
    
    local attempt=1
    while [ $attempt -le $max_retries ]; do
        echo -e "${BLUE}Attempt $attempt/$max_retries: Running Cursor Agent...${NC}" >&2
        
        if run_cursor "$prompt" "$output_file" "$model" "true" "true" "$timeout"; then
            echo -e "${GREEN}Cursor command succeeded${NC}" >&2
            return 0
        else
            local exit_code=$?
            echo -e "${YELLOW}Cursor command failed with exit code $exit_code${NC}" >&2
            
            # Check if it's a timeout (exit code 124)
            if [ $exit_code -eq 124 ]; then
                echo -e "${YELLOW}Command timed out (known issue: process may not release terminal)${NC}" >&2
            fi
            
            if [ $attempt -lt $max_retries ]; then
                echo -e "${YELLOW}Retrying in 2 seconds...${NC}" >&2
                sleep 2
            fi
        fi
        
        attempt=$((attempt + 1))
    done
    
    echo -e "${RED}Cursor command failed after $max_retries attempts${NC}" >&2
    return 1
}

# Function: Generate code review for git diff
review_git_diff() {
    local base_branch="${1:-main}"
    local output_file="${2:-cursor-review.json}"
    local model="${3:-$CURSOR_MODEL}"
    
    echo -e "${BLUE}Generating code review for changes from $base_branch...${NC}" >&2
    
    local prompt="Review these code changes for bugs, security issues, code quality, and best practices. Provide specific, actionable feedback."
    
    git diff "origin/$base_branch...HEAD" | \
        run_cursor "$prompt" "$output_file" "$model" "false" "true"
    
    return $?
}

# Function: Extract result from JSON
extract_result() {
    local json_file="$1"
    local output_file="${2:-}"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Cannot extract result.${NC}" >&2
        # Fallback: try grep
        if [ -n "$output_file" ]; then
            grep -o '"result":"[^"]*"' "$json_file" | cut -d'"' -f4 > "$output_file" 2>/dev/null || echo "" > "$output_file"
        else
            grep -o '"result":"[^"]*"' "$json_file" | cut -d'"' -f4
        fi
        return $?
    fi
    
    if [ -n "$output_file" ]; then
        jq -r '.result // empty' "$json_file" > "$output_file"
    else
        jq -r '.result // empty' "$json_file"
    fi
    
    return $?
}

# Function: Batch process files with Cursor
batch_process_files() {
    local pattern="$1"
    local prompt_template="$2"
    local output_dir="${3:-./reports}"
    local model="${4:-$CURSOR_MODEL}"
    local use_force="${5:-false}"
    
    mkdir -p "$output_dir"
    
    local processed=0
    local failed=0
    
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local output_file="$output_dir/${filename}.review.json"
            local prompt=$(echo "$prompt_template" | sed "s|{FILE}|$file|g")
            
            echo -e "${BLUE}Processing: $file${NC}" >&2
            
            if run_cursor "$prompt" "$output_file" "$model" "$use_force" "true"; then
                processed=$((processed + 1))
                echo -e "${GREEN}✓ Processed: $file${NC}" >&2
            else
                failed=$((failed + 1))
                echo -e "${RED}✗ Failed: $file${NC}" >&2
            fi
        fi
    done < <(find . -type f -name "$pattern" 2>/dev/null | head -20)
    
    echo -e "${GREEN}Batch processing complete: $processed processed, $failed failed${NC}" >&2
    return $failed
}

# Function: Refactor code
refactor_code() {
    local target="${1:-.}"
    local output_file="${2:-refactor-result.json}"
    local model="${3:-$CURSOR_MODEL}"
    
    echo -e "${BLUE}Refactoring code in: $target${NC}" >&2
    
    local prompt="Refactor the code in $target to use modern ES6+ syntax, improve readability, and follow best practices. Apply changes directly."
    
    run_cursor "$prompt" "$output_file" "$model" "true" "true"
    return $?
}

# Function: Generate tests for a file
generate_tests() {
    local file="$1"
    local output_file="${2:-}"
    local model="${3:-$CURSOR_MODEL}"
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: File not found: $file${NC}" >&2
        return 1
    fi
    
    echo -e "${BLUE}Generating tests for: $file${NC}" >&2
    
    local prompt="Generate comprehensive unit tests for the following code file: $file. Create test files with the same structure in the tests/ directory."
    
    run_cursor "$prompt" "$output_file" "$model" "true" "false"
    return $?
}

# Function: Add documentation
add_documentation() {
    local target="${1:-.}"
    local output_file="${2:-doc-result.json}"
    local model="${3:-$CURSOR_MODEL}"
    
    echo -e "${BLUE}Adding documentation to: $target${NC}" >&2
    
    local prompt="Add comprehensive JSDoc comments to all functions and classes in $target. Include parameter descriptions, return types, and usage examples."
    
    run_cursor "$prompt" "$output_file" "$model" "true" "true"
    return $?
}

# Function: Parse stream JSON output
parse_stream_json() {
    local jsonl_file="$1"
    local event_type="${2:-result}"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Cannot parse stream JSON.${NC}" >&2
        return 1
    fi
    
    case "$event_type" in
        system_init)
            jq -r 'select(.type=="system" and .subtype=="init")' "$jsonl_file"
            ;;
        assistant)
            jq -r 'select(.type=="assistant")' "$jsonl_file"
            ;;
        tool_call)
            jq -r 'select(.type=="tool_call")' "$jsonl_file"
            ;;
        result)
            jq -r 'select(.type=="result")' "$jsonl_file"
            ;;
        *)
            echo -e "${RED}Error: Unknown event type: $event_type${NC}" >&2
            return 1
            ;;
    esac
}

# Main execution
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # Script is being executed directly
    check_cursor_installed
    check_api_key
    
    case "${1:-help}" in
        review)
            review_git_diff "${2:-main}" "${3:-cursor-review.json}"
            ;;
        batch)
            batch_process_files "${2:-*.js}" "${3:-Review {FILE} for security issues}" "${4:-./reports}" "$CURSOR_MODEL" "${5:-false}"
            ;;
        refactor)
            refactor_code "${2:-.}" "${3:-refactor-result.json}"
            ;;
        tests)
            generate_tests "${2:-}" "${3:-}"
            ;;
        docs)
            add_documentation "${2:-.}" "${3:-doc-result.json}"
            ;;
        extract)
            if [ -z "$3" ]; then
                echo "Usage: $0 extract <json_file> {result|system_init|assistant|tool_call|result}"
                exit 1
            fi
            case "$3" in
                result)
                    extract_result "$2"
                    ;;
                *)
                    parse_stream_json "$2" "$3"
                    ;;
            esac
            ;;
        *)
            echo "Usage: $0 {review|batch|refactor|tests|docs|extract} [args...]"
            echo ""
            echo "Examples:"
            echo "  $0 review main cursor-review.json"
            echo "  $0 batch '*.js' 'Review {FILE}' ./reports"
            echo "  $0 refactor . refactor-result.json"
            echo "  $0 tests src/main.js test-main.js"
            echo "  $0 docs . doc-result.json"
            echo "  $0 extract output.json result"
            exit 1
            ;;
    esac
fi

