#!/bin/bash
# Reusable Script Patterns for Anthropic Claude CLI
# This file contains common patterns and utilities for using Claude CLI in automation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CLAUDE_MODEL="${CLAUDE_MODEL:-claude-sonnet-4.5}"
CLAUDE_OUTPUT_FORMAT="${CLAUDE_OUTPUT_FORMAT:-json}"

# Function: Check if Claude CLI is installed
check_claude_installed() {
    if ! command -v claude &> /dev/null; then
        echo -e "${RED}Error: Claude CLI not found. Install with: npm install -g @anthropic-ai/claude-code${NC}" >&2
        exit 1
    fi
}

# Function: Check if API key is set
check_api_key() {
    if [ -z "$ANTHROPIC_API_KEY" ]; then
        echo -e "${RED}Error: ANTHROPIC_API_KEY must be set${NC}" >&2
        exit 1
    fi
}

# Function: Run Claude with standard CI/CD flags
run_claude() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$CLAUDE_MODEL}"
    local allowed_tools="${4:-Read}"
    local use_json="${5:-true}"
    
    local cmd="claude -p \"$prompt\""
    
    # Add model if specified
    [ -n "$model" ] && cmd="$cmd --model $model"
    
    # Add CI/CD flags
    cmd="$cmd --no-interactive"
    
    # Add output format
    if [ "$use_json" = "true" ]; then
        cmd="$cmd --output-format json"
    fi
    
    # Add tool control
    [ -n "$allowed_tools" ] && cmd="$cmd --allowedTools \"$allowed_tools\""
    
    # Redirect output if file specified
    if [ -n "$output_file" ]; then
        cmd="$cmd > \"$output_file\" 2>&1"
    fi
    
    eval "$cmd"
    return $?
}

# Function: Run Claude with error handling
run_claude_safe() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$CLAUDE_MODEL}"
    local max_retries="${4:-3}"
    
    local attempt=1
    while [ $attempt -le $max_retries ]; do
        echo -e "${BLUE}Attempt $attempt/$max_retries: Running Claude...${NC}" >&2
        
        if run_claude "$prompt" "$output_file" "$model"; then
            echo -e "${GREEN}Claude command succeeded${NC}" >&2
            return 0
        else
            local exit_code=$?
            echo -e "${YELLOW}Claude command failed with exit code $exit_code${NC}" >&2
            
            if [ $attempt -lt $max_retries ]; then
                echo -e "${YELLOW}Retrying in 2 seconds...${NC}" >&2
                sleep 2
            fi
        fi
        
        attempt=$((attempt + 1))
    done
    
    echo -e "${RED}Claude command failed after $max_retries attempts${NC}" >&2
    return 1
}

# Function: Generate code review for git diff
review_git_diff() {
    local base_branch="${1:-main}"
    local output_file="${2:-claude-review.json}"
    local model="${3:-$CLAUDE_MODEL}"
    
    echo -e "${BLUE}Generating code review for changes from $base_branch...${NC}" >&2
    
    local prompt="Review these code changes for bugs, security issues, code quality, and best practices. Provide specific, actionable feedback."
    
    git diff "origin/$base_branch...HEAD" | \
        run_claude "$prompt" "$output_file" "$model" "Read,Grep" "true"
    
    return $?
}

# Function: Extract result from JSON
extract_result() {
    local json_file="$1"
    local output_file="${2:-}"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Cannot extract result.${NC}" >&2
        return 1
    fi
    
    if [ -n "$output_file" ]; then
        jq -r '.result // empty' "$json_file" > "$output_file"
    else
        jq -r '.result // empty' "$json_file"
    fi
    
    return $?
}

# Function: Extract cost from JSON
extract_cost() {
    local json_file="$1"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Cannot extract cost.${NC}" >&2
        return 1
    fi
    
    jq -r '.total_cost_usd // "N/A"' "$json_file"
    return $?
}

# Function: Extract session_id from JSON
extract_session_id() {
    local json_file="$1"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Cannot extract session ID.${NC}" >&2
        return 1
    fi
    
    jq -r '.session_id // empty' "$json_file"
    return $?
}

# Function: Security audit
security_audit() {
    local directory="${1:-.}"
    local output_file="${2:-security-audit.json}"
    local model="${3:-$CLAUDE_MODEL}"
    
    echo -e "${BLUE}Running security audit on: $directory${NC}" >&2
    
    local prompt="Perform a security audit of the code in $directory. Check for common vulnerabilities, insecure patterns, SQL injection risks, XSS vulnerabilities, and compliance issues. Generate a detailed security report."
    
    run_claude "$prompt" "$output_file" "$model" "Read,Grep,WebSearch" "true"
    return $?
}

# Function: Generate tests for a file
generate_tests() {
    local file="$1"
    local output_file="${2:-}"
    local model="${3:-$CLAUDE_MODEL}"
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: File not found: $file${NC}" >&2
        return 1
    fi
    
    echo -e "${BLUE}Generating tests for: $file${NC}" >&2
    
    local prompt="Generate comprehensive unit tests for the following code file: $file. Create test files with the same structure in the tests/ directory."
    
    run_claude "$prompt" "$output_file" "$model" "Bash,Read" "false"
    return $?
}

# Function: Update documentation
update_documentation() {
    local doc_dir="${1:-docs}"
    local output_file="${2:-doc-update.md}"
    local model="${3:-$CLAUDE_MODEL}"
    
    echo -e "${BLUE}Updating documentation in: $doc_dir${NC}" >&2
    
    local prompt="Review all documentation files in $doc_dir and update them to reflect the latest code changes. Ensure all code examples are current, accurate, and follow best practices."
    
    run_claude "$prompt" "$output_file" "$model" "Bash,Read" "false"
    return $?
}

# Function: SRE Incident Response
investigate_incident() {
    local incident_description="$1"
    local severity="${2:-medium}"
    local output_file="${3:-incident-report.json}"
    local model="${4:-$CLAUDE_MODEL}"
    
    echo -e "${BLUE}Investigating incident: $incident_description (Severity: $severity)${NC}" >&2
    
    local prompt="Incident: $incident_description (Severity: $severity)"
    local system_prompt="You are an SRE expert. Diagnose the issue, assess impact, and provide immediate action items."
    
    claude -p "$prompt" \
        --append-system-prompt "$system_prompt" \
        --output-format json \
        --no-interactive \
        --allowedTools "Bash,Read,WebSearch" \
        --model "$model" \
        > "$output_file" 2>&1
    
    return $?
}

# Function: Batch process files
batch_process_files() {
    local pattern="$1"
    local prompt_template="$2"
    local output_dir="${3:-./reports}"
    local model="${4:-$CLAUDE_MODEL}"
    
    mkdir -p "$output_dir"
    
    local processed=0
    local failed=0
    
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local output_file="$output_dir/${filename}.review.json"
            local prompt=$(echo "$prompt_template" | sed "s|{FILE}|$file|g")
            
            echo -e "${BLUE}Processing: $file${NC}" >&2
            
            if run_claude "$prompt" "$output_file" "$model" "Read" "true"; then
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

# Main execution
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # Script is being executed directly
    check_claude_installed
    check_api_key
    
    case "${1:-help}" in
        review)
            review_git_diff "${2:-main}" "${3:-claude-review.json}"
            ;;
        batch)
            batch_process_files "${2:-*.js}" "${3:-Review {FILE} for security issues}" "${4:-./reports}" "$CLAUDE_MODEL"
            ;;
        security)
            security_audit "${2:-.}" "${3:-security-audit.json}"
            ;;
        tests)
            generate_tests "${2:-}" "${3:-}"
            ;;
        docs)
            update_documentation "${2:-docs}" "${3:-doc-update.md}"
            ;;
        incident)
            investigate_incident "${2:-}" "${3:-medium}" "${4:-incident-report.json}"
            ;;
        extract)
            if [ -z "$3" ]; then
                echo "Usage: $0 extract <json_file> {result|cost|session_id}"
                exit 1
            fi
            case "$3" in
                result)
                    extract_result "$2"
                    ;;
                cost)
                    extract_cost "$2"
                    ;;
                session_id)
                    extract_session_id "$2"
                    ;;
                *)
                    echo "Unknown extraction type: $3"
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "Usage: $0 {review|batch|security|tests|docs|incident|extract} [args...]"
            echo ""
            echo "Examples:"
            echo "  $0 review main claude-review.json"
            echo "  $0 batch '*.js' 'Review {FILE}' ./reports"
            echo "  $0 security . security-report.json"
            echo "  $0 tests src/main.js test-main.js"
            echo "  $0 docs docs/ doc-update.md"
            echo "  $0 incident 'Payment API down' high incident-report.json"
            echo "  $0 extract output.json result"
            exit 1
            ;;
    esac
fi

