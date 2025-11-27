#!/bin/bash
# Reusable Script Patterns for OpenAI Codex CLI
# This file contains common patterns and utilities for using Codex CLI in automation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CODEX_MODEL="${CODEX_MODEL:-gpt-5-codex-latest}"
CODEX_COLOR="${CODEX_COLOR:-never}"
CODEX_SANDBOX="${CODEX_SANDBOX:-read-only}"

# Function: Check if Codex CLI is installed
check_codex_installed() {
    if ! command -v codex &> /dev/null; then
        echo -e "${RED}Error: Codex CLI not found. Install with: npm install -g @openai/codex${NC}" >&2
        exit 1
    fi
}

# Function: Check if API key is set
check_api_key() {
    if [ -z "$OPENAI_API_KEY" ] && [ -z "$CODEX_API_KEY" ]; then
        echo -e "${RED}Error: OPENAI_API_KEY or CODEX_API_KEY must be set${NC}" >&2
        exit 1
    fi
}

# Function: Run Codex with standard CI/CD flags
run_codex() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$CODEX_MODEL}"
    local sandbox="${4:-$CODEX_SANDBOX}"
    local use_json="${5:-false}"
    
    local cmd="codex exec"
    
    # Add model if specified
    [ -n "$model" ] && cmd="$cmd --model $model"
    
    # Add sandbox mode
    if [ "$sandbox" = "workspace-write" ] || [ "$sandbox" = "full-auto" ]; then
        cmd="$cmd --full-auto"
    else
        cmd="$cmd --sandbox $sandbox"
    fi
    
    # Add CI/CD flags
    cmd="$cmd --color $CODEX_COLOR"
    [ "$use_json" = "true" ] && cmd="$cmd --json"
    
    # Add prompt
    cmd="$cmd \"$prompt\""
    
    # Redirect output if file specified
    if [ -n "$output_file" ]; then
        if [ "$use_json" = "true" ]; then
            cmd="$cmd > \"$output_file\" 2>&1"
        else
            cmd="$cmd -o \"$output_file\" 2>&1"
        fi
    fi
    
    eval "$cmd"
    return $?
}

# Function: Run Codex with error handling
run_codex_safe() {
    local prompt="$1"
    local output_file="${2:-}"
    local model="${3:-$CODEX_MODEL}"
    local max_retries="${4:-3}"
    
    local attempt=1
    while [ $attempt -le $max_retries ]; do
        echo -e "${BLUE}Attempt $attempt/$max_retries: Running Codex...${NC}" >&2
        
        if run_codex "$prompt" "$output_file" "$model"; then
            echo -e "${GREEN}Codex command succeeded${NC}" >&2
            return 0
        else
            local exit_code=$?
            echo -e "${YELLOW}Codex command failed with exit code $exit_code${NC}" >&2
            
            if [ $attempt -lt $max_retries ]; then
                echo -e "${YELLOW}Retrying in 2 seconds...${NC}" >&2
                sleep 2
            fi
        fi
        
        attempt=$((attempt + 1))
    done
    
    echo -e "${RED}Codex command failed after $max_retries attempts${NC}" >&2
    return 1
}

# Function: Batch process files with Codex
batch_process_files() {
    local pattern="$1"
    local prompt_template="$2"
    local output_dir="${3:-./reports}"
    local model="${4:-$CODEX_MODEL}"
    local use_json="${5:-true}"
    
    mkdir -p "$output_dir"
    
    local processed=0
    local failed=0
    
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local output_file="$output_dir/${filename}.review"
            local prompt=$(echo "$prompt_template" | sed "s|{FILE}|$file|g")
            
            echo -e "${BLUE}Processing: $file${NC}" >&2
            
            if [ "$use_json" = "true" ]; then
                if run_codex "$prompt" "${output_file}.jsonl" "$model" "read-only" "true"; then
                    processed=$((processed + 1))
                    echo -e "${GREEN}✓ Processed: $file${NC}" >&2
                else
                    failed=$((failed + 1))
                    echo -e "${RED}✗ Failed: $file${NC}" >&2
                fi
            else
                if run_codex "$prompt" "$output_file" "$model"; then
                    processed=$((processed + 1))
                    echo -e "${GREEN}✓ Processed: $file${NC}" >&2
                else
                    failed=$((failed + 1))
                    echo -e "${RED}✗ Failed: $file${NC}" >&2
                fi
            fi
        fi
    done < <(find . -type f -name "$pattern" 2>/dev/null | head -20)
    
    echo -e "${GREEN}Batch processing complete: $processed processed, $failed failed${NC}" >&2
    return $failed
}

# Function: Generate code review for git diff
review_git_diff() {
    local base_branch="${1:-main}"
    local output_file="${2:-code-review.jsonl}"
    local model="${3:-$CODEX_MODEL}"
    
    echo -e "${BLUE}Generating code review for changes from $base_branch...${NC}" >&2
    
    local prompt="Review these code changes for bugs, security issues, code quality, and best practices. Provide specific, actionable feedback."
    
    git diff "origin/$base_branch...HEAD" | \
        run_codex "$prompt" "$output_file" "$model" "read-only" "true"
    
    return $?
}

# Function: Extract agent message from JSONL
extract_agent_message() {
    local jsonl_file="$1"
    local output_file="${2:-}"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Cannot extract agent message.${NC}" >&2
        return 1
    fi
    
    if [ -n "$output_file" ]; then
        jq -r 'select(.type=="item.completed" and .item.type=="agent_message") | .item.text' \
            "$jsonl_file" > "$output_file"
    else
        jq -r 'select(.type=="item.completed" and .item.type=="agent_message") | .item.text' \
            "$jsonl_file"
    fi
    
    return $?
}

# Function: Generate structured output
generate_structured_output() {
    local prompt="$1"
    local schema_file="$2"
    local output_file="${3:-output.json}"
    local model="${4:-$CODEX_MODEL}"
    
    if [ ! -f "$schema_file" ]; then
        echo -e "${RED}Error: Schema file not found: $schema_file${NC}" >&2
        return 1
    fi
    
    echo -e "${BLUE}Generating structured output...${NC}" >&2
    
    codex exec "$prompt" \
        --model "$model" \
        --output-schema "$schema_file" \
        --color never \
        -o "$output_file"
    
    return $?
}

# Function: Autofix CI failures
autofix_ci() {
    local ci_log_file="${1:-}"
    local output_file="${2:-autofix-patch.jsonl}"
    local model="${3:-$CODEX_MODEL}"
    
    echo -e "${BLUE}Running autofix for CI failures...${NC}" >&2
    
    local prompt="The CI workflow failed. Diagnose the failures and create a minimal patch that fixes the issues without breaking existing functionality."
    
    if [ -n "$ci_log_file" ] && [ -f "$ci_log_file" ]; then
        prompt="$prompt\n\nCI Log:\n$(cat "$ci_log_file" | head -100)"
    fi
    
    run_codex "$prompt" "$output_file" "$model" "workspace-write" "true"
    
    return $?
}

# Function: Generate tests for a file
generate_tests() {
    local file="$1"
    local output_file="${2:-}"
    local model="${3:-$CODEX_MODEL}"
    
    if [ ! -f "$file" ]; then
        echo -e "${RED}Error: File not found: $file${NC}" >&2
        return 1
    fi
    
    echo -e "${BLUE}Generating tests for: $file${NC}" >&2
    
    local prompt="Generate comprehensive unit tests for the following code file: $file. Create test files with the same structure in the tests/ directory."
    
    run_codex "$prompt" "$output_file" "$model" "workspace-write" "false"
    return $?
}

# Function: Security audit
security_audit() {
    local directory="${1:-.}"
    local output_file="${2:-security-audit.jsonl}"
    local model="${3:-$CODEX_MODEL}"
    
    echo -e "${BLUE}Running security audit on: $directory${NC}" >&2
    
    local prompt="Perform a security audit of the code in $directory. Check for common vulnerabilities, insecure patterns, SQL injection risks, XSS vulnerabilities, and compliance issues. Generate a detailed security report."
    
    run_codex "$prompt" "$output_file" "$model" "read-only" "true"
    return $?
}

# Function: Update documentation
update_documentation() {
    local doc_dir="${1:-docs}"
    local output_file="${2:-doc-update.md}"
    local model="${3:-$CODEX_MODEL}"
    
    echo -e "${BLUE}Updating documentation in: $doc_dir${NC}" >&2
    
    local prompt="Review all documentation files in $doc_dir and update them to reflect the latest code changes. Ensure all code examples are current, accurate, and follow best practices."
    
    run_codex "$prompt" "$output_file" "$model" "workspace-write" "false"
    return $?
}

# Function: Parse Codex JSONL output
parse_codex_jsonl() {
    local jsonl_file="$1"
    local event_type="${2:-agent_message}"
    
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Cannot parse JSONL.${NC}" >&2
        return 1
    fi
    
    case "$event_type" in
        agent_message)
            jq -r 'select(.type=="item.completed" and .item.type=="agent_message") | .item.text' "$jsonl_file"
            ;;
        thread_id)
            jq -r 'select(.type=="thread.started") | .thread_id' "$jsonl_file" | head -1
            ;;
        usage)
            jq -r 'select(.type=="turn.completed") | .usage' "$jsonl_file" | head -1
            ;;
        file_changes)
            jq -r 'select(.type=="item.completed" and .item.type=="file_change") | .item' "$jsonl_file"
            ;;
        plan_updates)
            jq -r 'select(.type=="item.completed" and .item.type=="plan_update") | .item' "$jsonl_file"
            ;;
        *)
            echo -e "${RED}Error: Unknown event type: $event_type${NC}" >&2
            return 1
            ;;
    esac
}

# Example usage functions
example_code_review() {
    echo -e "${BLUE}=== Example: Code Review ===${NC}"
    review_git_diff "main" "code-review.jsonl"
    extract_agent_message "code-review.jsonl" "code-review-summary.txt"
}

example_batch_processing() {
    echo -e "${BLUE}=== Example: Batch Processing ===${NC}"
    batch_process_files "*.js" "Review {FILE} for security issues and code quality" "./reviews" "$CODEX_MODEL" "true"
}

example_autofix_ci() {
    echo -e "${BLUE}=== Example: Autofix CI ===${NC}"
    autofix_ci "ci-output.log" "autofix-patch.jsonl"
}

# Main execution
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # Script is being executed directly
    check_codex_installed
    check_api_key
    
    case "${1:-help}" in
        review)
            review_git_diff "${2:-main}" "${3:-code-review.jsonl}"
            ;;
        batch)
            batch_process_files "${2:-*.js}" "${3:-Review {FILE}}" "${4:-./reports}" "$CODEX_MODEL" "${5:-true}"
            ;;
        autofix)
            autofix_ci "${2:-}" "${3:-autofix-patch.jsonl}"
            ;;
        security)
            security_audit "${2:-.}" "${3:-security-audit.jsonl}"
            ;;
        docs)
            update_documentation "${2:-docs}" "${3:-doc-update.md}"
            ;;
        extract)
            if [ -z "$3" ]; then
                echo "Usage: $0 extract <jsonl_file> <event_type>"
                echo "Event types: agent_message, thread_id, usage, file_changes, plan_updates"
                exit 1
            fi
            parse_codex_jsonl "$2" "$3"
            ;;
        *)
            echo "Usage: $0 {review|batch|autofix|security|docs|extract} [args...]"
            echo ""
            echo "Examples:"
            echo "  $0 review main code-review.jsonl"
            echo "  $0 batch '*.js' 'Review {FILE}' ./reports"
            echo "  $0 autofix ci-output.log autofix-patch.jsonl"
            echo "  $0 security . security-report.jsonl"
            echo "  $0 docs docs/ doc-update.md"
            echo "  $0 extract output.jsonl agent_message"
            exit 1
            ;;
    esac
fi

