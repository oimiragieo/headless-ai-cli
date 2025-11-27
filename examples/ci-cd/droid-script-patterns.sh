#!/bin/bash
# Reusable Script Patterns for Factory AI Droid CLI
# This file contains common patterns and utilities for using Droid CLI in automation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DROID_MODEL="${DROID_MODEL:-Sonnet 4.5}"
DROID_AUTONOMY="${DROID_AUTONOMY:-}"
DROID_OUTPUT_FORMAT="${DROID_OUTPUT_FORMAT:-json}"

# Function: Check if Droid CLI is installed
check_droid_installed() {
    if ! command -v droid &> /dev/null; then
        echo -e "${RED}Error: Factory AI Droid CLI not found. Install with: curl -fsSL https://app.factory.ai/cli | sh${NC}" >&2
        exit 1
    fi
}

# Function: Check if API key is set
check_api_key() {
    if [ -z "$FACTORY_API_KEY" ]; then
        echo -e "${RED}Error: FACTORY_API_KEY must be set${NC}" >&2
        exit 1
    fi
}

# Function: Run Droid with standard CI/CD flags
run_droid() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$DROID_MODEL}"
    local autonomy="${4:-}"
    local use_json="${5:-true}"
    
    local cmd="droid exec"
    
    # Add model if specified
    [ -n "$model" ] && cmd="$cmd -m $model"
    
    # Add autonomy level if specified
    if [ -n "$autonomy" ]; then
        cmd="$cmd -r $autonomy"
    fi
    
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

# Function: Run Droid with error handling
run_droid_safe() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$DROID_MODEL}"
    local autonomy="${4:-}"
    local max_retries="${5:-3}"
    
    local attempt=1
    while [ $attempt -le $max_retries ]; do
        echo -e "${BLUE}Attempt $attempt/$max_retries: Running Droid...${NC}" >&2
        
        if run_droid "$prompt" "$output_file" "$model" "$autonomy" "true"; then
            echo -e "${GREEN}Droid command succeeded${NC}" >&2
            return 0
        else
            local exit_code=$?
            echo -e "${YELLOW}Droid command failed with exit code $exit_code${NC}" >&2
            
            if [ $attempt -lt $max_retries ]; then
                echo -e "${YELLOW}Retrying in 2 seconds...${NC}" >&2
                sleep 2
            fi
        fi
        
        attempt=$((attempt + 1))
    done
    
    echo -e "${RED}Droid command failed after $max_retries attempts${NC}" >&2
    return 1
}

# Function: Generate code review for git diff
review_git_diff() {
    local base_branch="${1:-main}"
    local output_file="${2:-droid-review.json}"
    local model="${3:-$DROID_MODEL}"
    
    echo -e "${BLUE}Generating code review for changes from $base_branch...${NC}" >&2
    
    local prompt="Review these code changes for bugs, security issues, code quality, and best practices. Provide specific, actionable feedback."
    
    git diff "origin/$base_branch...HEAD" | \
        run_droid "$prompt" "$output_file" "$model" "" "true"
    
    return $?
}

# Function: Extract result from JSON
extract_result() {
    local json_file="$1"
    local output_file="${2:-}"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Using grep fallback.${NC}" >&2
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

# Function: Security audit
security_audit() {
    local directory="${1:-.}"
    local output_file="${2:-security-audit.json}"
    local model="${3:-$DROID_MODEL}"
    local autonomy="${4:-low}"
    
    echo -e "${BLUE}Running security audit on: $directory${NC}" >&2
    
    local prompt="Perform a security audit of the code in $directory. Check for common vulnerabilities, insecure patterns, SQL injection risks, XSS vulnerabilities, and compliance issues. Generate a detailed security report."
    
    run_droid "$prompt" "$output_file" "$model" "$autonomy" "true"
    return $?
}

# Function: License enforcement
enforce_license() {
    local pattern="${1:-*.ts}"
    local license_header="${2:-Apache-2.0}"
    local model="${3:-$DROID_MODEL}"
    local autonomy="${4:-low}"
    
    echo -e "${BLUE}Enforcing $license_header license headers on: $pattern${NC}" >&2
    
    local processed=0
    local failed=0
    
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            local prompt="Ensure $file begins with the $license_header header; add it if missing."
            
            if run_droid "$prompt" "/dev/null" "$model" "$autonomy" "false"; then
                processed=$((processed + 1))
                echo -e "${GREEN}✓ Processed: $file${NC}" >&2
            else
                failed=$((failed + 1))
                echo -e "${RED}✗ Failed: $file${NC}" >&2
            fi
        fi
    done < <(git ls-files "$pattern" 2>/dev/null | head -20)
    
    echo -e "${GREEN}License enforcement complete: $processed processed, $failed failed${NC}" >&2
    return $failed
}

# Function: Batch process files with Droid
batch_process_files() {
    local pattern="$1"
    local prompt_template="$2"
    local output_dir="${3:-./reports}"
    local model="${4:-$DROID_MODEL}"
    local autonomy="${5:-}"
    
    mkdir -p "$output_dir"
    
    local processed=0
    local failed=0
    
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local output_file="$output_dir/${filename}.review.json"
            local prompt=$(echo "$prompt_template" | sed "s|{FILE}|$file|g")
            
            echo -e "${BLUE}Processing: $file${NC}" >&2
            
            if run_droid "$prompt" "$output_file" "$model" "$autonomy" "true"; then
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

# Function: Add documentation
add_documentation() {
    local target="${1:-.}"
    local output_file="${2:-doc-result.json}"
    local model="${3:-$DROID_MODEL}"
    local autonomy="${4:-low}"
    
    echo -e "${BLUE}Adding documentation to: $target${NC}" >&2
    
    local prompt="Add comprehensive JSDoc comments to all functions and classes in $target. Include parameter descriptions, return types, and usage examples."
    
    run_droid "$prompt" "$output_file" "$model" "$autonomy" "true"
    return $?
}

# Main execution
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # Script is being executed directly
    check_droid_installed
    check_api_key
    
    case "${1:-help}" in
        review)
            review_git_diff "${2:-main}" "${3:-droid-review.json}"
            ;;
        batch)
            batch_process_files "${2:-*.js}" "${3:-Review {FILE} for security issues}" "${4:-./reports}" "$DROID_MODEL" "${5:-}"
            ;;
        security)
            security_audit "${2:-.}" "${3:-security-audit.json}"
            ;;
        license)
            enforce_license "${2:-*.ts}" "${3:-Apache-2.0}"
            ;;
        docs)
            add_documentation "${2:-.}" "${3:-doc-result.json}"
            ;;
        extract)
            if [ -z "$3" ]; then
                echo "Usage: $0 extract <json_file> {result}"
                exit 1
            fi
            extract_result "$2" "$3"
            ;;
        *)
            echo "Usage: $0 {review|batch|security|license|docs|extract} [args...]"
            echo ""
            echo "Examples:"
            echo "  $0 review main droid-review.json"
            echo "  $0 batch '*.js' 'Review {FILE}' ./reports"
            echo "  $0 security . security-report.json"
            echo "  $0 license '*.ts' Apache-2.0"
            echo "  $0 docs . doc-result.json"
            echo "  $0 extract output.json result"
            exit 1
            ;;
    esac
fi

