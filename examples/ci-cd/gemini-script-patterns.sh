#!/bin/bash
# Reusable Script Patterns for Google Gemini CLI
# This file contains common patterns and utilities for using Gemini CLI in automation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
GEMINI_MODEL="${GEMINI_MODEL:-gemini-3-pro-preview}"
GEMINI_OUTPUT_FORMAT="${GEMINI_OUTPUT_FORMAT:-json}"

# Function: Check if Gemini CLI is installed
check_gemini_installed() {
    if ! command -v gemini &> /dev/null; then
        echo -e "${RED}Error: Google Gemini CLI not found. Install with: npm install -g @google/gemini-cli${NC}" >&2
        exit 1
    fi
}

# Function: Check if API key is set
check_api_key() {
    if [ -z "$GEMINI_API_KEY" ]; then
        echo -e "${RED}Error: GEMINI_API_KEY must be set${NC}" >&2
        exit 1
    fi
}

# Function: Run Gemini with standard CI/CD flags
run_gemini() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$GEMINI_MODEL}"
    local use_yolo="${4:-false}"
    local use_json="${5:-true}"
    
    local cmd="gemini -p"
    
    # Add model if specified
    [ -n "$model" ] && cmd="$cmd --model $model"
    
    # Add yolo flag if needed
    [ "$use_yolo" = "true" ] && cmd="$cmd --yolo"
    
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

# Function: Run Gemini with error handling
run_gemini_safe() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$GEMINI_MODEL}"
    local max_retries="${4:-3}"
    
    local attempt=1
    while [ $attempt -le $max_retries ]; do
        echo -e "${BLUE}Attempt $attempt/$max_retries: Running Gemini...${NC}" >&2
        
        if run_gemini "$prompt" "$output_file" "$model" "false" "true"; then
            echo -e "${GREEN}Gemini command succeeded${NC}" >&2
            return 0
        else
            local exit_code=$?
            echo -e "${YELLOW}Gemini command failed with exit code $exit_code${NC}" >&2
            
            if [ $attempt -lt $max_retries ]; then
                echo -e "${YELLOW}Retrying in 2 seconds...${NC}" >&2
                sleep 2
            fi
        fi
        
        attempt=$((attempt + 1))
    done
    
    echo -e "${RED}Gemini command failed after $max_retries attempts${NC}" >&2
    return 1
}

# Function: Generate code review for git diff
review_git_diff() {
    local base_branch="${1:-main}"
    local output_file="${2:-gemini-review.json}"
    local model="${3:-$GEMINI_MODEL}"
    
    echo -e "${BLUE}Generating code review for changes from $base_branch...${NC}" >&2
    
    local prompt="Review these code changes for bugs, security issues, code quality, and best practices. Provide specific, actionable feedback."
    
    git diff "origin/$base_branch...HEAD" | \
        run_gemini "$prompt" "$output_file" "$model" "false" "true"
    
    return $?
}

# Function: Extract response from JSON
extract_response() {
    local json_file="$1"
    local output_file="${2:-}"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Using grep fallback.${NC}" >&2
        # Fallback: try grep
        if [ -n "$output_file" ]; then
            grep -o '"response":"[^"]*"' "$json_file" | cut -d'"' -f4 > "$output_file" 2>/dev/null || echo "" > "$output_file"
        else
            grep -o '"response":"[^"]*"' "$json_file" | cut -d'"' -f4
        fi
        return $?
    fi
    
    if [ -n "$output_file" ]; then
        jq -r '.response // empty' "$json_file" > "$output_file"
    else
        jq -r '.response // empty' "$json_file"
    fi
    
    return $?
}

# Function: Extract stats from JSON
extract_stats() {
    local json_file="$1"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Cannot extract stats.${NC}" >&2
        return 1
    fi
    
    jq '.stats // empty' "$json_file"
    return $?
}

# Function: Extract tokens from JSON
extract_tokens() {
    local json_file="$1"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Cannot extract tokens.${NC}" >&2
        return 1
    fi
    
    jq '.stats.models | to_entries[0].value.tokens // empty' "$json_file"
    return $?
}

# Function: Security audit
security_audit() {
    local directory="${1:-.}"
    local output_file="${2:-security-audit.json}"
    local model="${3:-$GEMINI_MODEL}"
    
    echo -e "${BLUE}Running security audit on: $directory${NC}" >&2
    
    local prompt="Perform a security audit of the code in $directory. Check for common vulnerabilities, insecure patterns, SQL injection risks, XSS vulnerabilities, and compliance issues. Generate a detailed security report."
    
    run_gemini "$prompt" "$output_file" "$model" "false" "true"
    return $?
}

# Function: Batch process files with Gemini
batch_process_files() {
    local pattern="$1"
    local prompt_template="$2"
    local output_dir="${3:-./reports}"
    local model="${4:-$GEMINI_MODEL}"
    
    mkdir -p "$output_dir"
    
    local processed=0
    local failed=0
    
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local output_file="$output_dir/${filename}.review.json"
            local prompt=$(echo "$prompt_template" | sed "s|{FILE}|$file|g")
            
            echo -e "${BLUE}Processing: $file${NC}" >&2
            
            if run_gemini "$prompt" "$output_file" "$model" "false" "true"; then
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

# Function: Generate commit messages
generate_commit_message() {
    local output_file="${1:-commit-message.txt}"
    local model="${2:-$GEMINI_MODEL}"
    
    echo -e "${BLUE}Generating commit message from staged changes...${NC}" >&2
    
    local prompt="Write a concise commit message for these changes. Follow conventional commit format."
    
    git diff --cached | \
        run_gemini "$prompt" "$output_file" "$model" "false" "true"
    
    return $?
}

# Function: Generate release notes
generate_release_notes() {
    local from_tag="${1:-}"
    local to_tag="${2:-HEAD}"
    local output_file="${3:-RELEASE_NOTES.md}"
    local model="${4:-$GEMINI_MODEL}"
    
    echo -e "${BLUE}Generating release notes from $from_tag to $to_tag...${NC}" >&2
    
    local prompt="Generate release notes from these commits. Include major features, bug fixes, and breaking changes."
    
    if [ -n "$from_tag" ]; then
        git log --oneline "$from_tag".."$to_tag" | \
            run_gemini "$prompt" "$output_file" "$model" "false" "true"
    else
        git log --oneline -20 | \
            run_gemini "$prompt" "$output_file" "$model" "false" "true"
    fi
    
    return $?
}

# Function: Analyze logs
analyze_logs() {
    local log_file="$1"
    local output_file="${2:-log-analysis.json}"
    local model="${3:-$GEMINI_MODEL}"
    
    if [ ! -f "$log_file" ]; then
        echo -e "${RED}Error: Log file not found: $log_file${NC}" >&2
        return 1
    fi
    
    echo -e "${BLUE}Analyzing logs: $log_file${NC}" >&2
    
    local prompt="Analyze these log entries. Identify errors, patterns, and suggest root causes and fixes."
    
    tail -100 "$log_file" | \
        run_gemini "$prompt" "$output_file" "$model" "false" "true"
    
    return $?
}

# Function: List available models
list_models() {
    echo -e "${BLUE}Listing available Gemini models...${NC}" >&2
    gemini models list
    return $?
}

# Function: Get current model
get_current_model() {
    echo -e "${BLUE}Getting current default model...${NC}" >&2
    gemini config get model
    return $?
}

# Function: Set default model
set_default_model() {
    local model="${1:-gemini-3-pro-preview}"
    echo -e "${BLUE}Setting default model to: $model${NC}" >&2
    gemini config set model "$model"
    return $?
}

# Main execution
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # Script is being executed directly
    check_gemini_installed
    check_api_key
    
    case "${1:-help}" in
        review)
            review_git_diff "${2:-main}" "${3:-gemini-review.json}"
            ;;
        batch)
            batch_process_files "${2:-*.js}" "${3:-Review {FILE} for security issues}" "${4:-./reports}" "$GEMINI_MODEL"
            ;;
        security)
            security_audit "${2:-.}" "${3:-security-audit.json}"
            ;;
        commit)
            generate_commit_message "${2:-commit-message.txt}"
            ;;
        release)
            generate_release_notes "${2:-}" "${3:-HEAD}" "${4:-RELEASE_NOTES.md}"
            ;;
        logs)
            analyze_logs "${2:-}" "${3:-log-analysis.json}"
            ;;
        extract)
            if [ -z "$3" ]; then
                echo "Usage: $0 extract <json_file> {response|stats|tokens}"
                exit 1
            fi
            case "$3" in
                response)
                    extract_response "$2"
                    ;;
                stats)
                    extract_stats "$2"
                    ;;
                tokens)
                    extract_tokens "$2"
                    ;;
                *)
                    echo "Unknown extraction type: $3"
                    exit 1
                    ;;
            esac
            ;;
        models)
            list_models
            ;;
        get-model)
            get_current_model
            ;;
        set-model)
            set_default_model "${2:-gemini-3-pro-preview}"
            ;;
        *)
            echo "Usage: $0 {review|batch|security|commit|release|logs|extract|models|get-model|set-model} [args...]"
            echo ""
            echo "Examples:"
            echo "  $0 review main gemini-review.json"
            echo "  $0 batch '*.js' 'Review {FILE}' ./reports"
            echo "  $0 security . security-report.json"
            echo "  $0 commit commit-message.txt"
            echo "  $0 release v1.0.0 HEAD RELEASE_NOTES.md"
            echo "  $0 logs /var/log/app.log log-analysis.json"
            echo "  $0 extract output.json response"
            echo "  $0 models"
            echo "  $0 get-model"
            echo "  $0 set-model gemini-3-pro-preview"
            exit 1
            ;;
    esac
fi

