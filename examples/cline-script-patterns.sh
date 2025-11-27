#!/bin/bash
# Reusable Script Patterns for Cline CLI
# This file contains common patterns and utilities for using Cline CLI in automation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CLINE_INSTANCE="${CLINE_INSTANCE:-default}"

# Function: Check if Cline CLI is installed
check_cline_installed() {
    if ! command -v cline &> /dev/null; then
        echo -e "${RED}Error: Cline CLI not found. Install with: npm install -g cline${NC}" >&2
        exit 1
    fi
}

# Function: Check if API key is set
check_api_key() {
    if [ -z "$CLINE_API_KEY" ]; then
        echo -e "${YELLOW}Warning: CLINE_API_KEY is not set.${NC}" >&2
        echo "Run 'cline auth' to configure API keys." >&2
    fi
}

# Function: Initialize Cline instance
init_cline_instance() {
    local instance_name="${1:-default}"
    echo -e "${BLUE}Initializing Cline instance: $instance_name${NC}" >&2
    
    if [ "$instance_name" = "default" ]; then
        cline instance new --default 2>&1 || {
            echo -e "${YELLOW}Instance may already exist, continuing...${NC}" >&2
        }
    else
        cline instance new --name "$instance_name" 2>&1 || {
            echo -e "${YELLOW}Instance may already exist, continuing...${NC}" >&2
        }
    fi
}

# Function: Run Cline task in headless mode
run_cline_task() {
    local prompt="$1"
    local instance_name="${2:-$CLINE_INSTANCE}"
    
    echo -e "${BLUE}Running Cline task: $prompt${NC}" >&2
    
    # Ensure instance exists
    init_cline_instance "$instance_name"
    
    # Run task in headless mode
    cline task new -y "$prompt"
    return $?
}

# Function: Run Cline task with error handling
run_cline_task_safe() {
    local prompt="$1"
    local instance_name="${2:-$CLINE_INSTANCE}"
    local max_retries="${3:-3}"
    
    local attempt=1
    while [ $attempt -le $max_retries ]; do
        echo -e "${BLUE}Attempt $attempt/$max_retries: Running Cline task...${NC}" >&2
        
        if run_cline_task "$prompt" "$instance_name"; then
            echo -e "${GREEN}Cline task succeeded${NC}" >&2
            return 0
        else
            local exit_code=$?
            echo -e "${YELLOW}Cline task failed with exit code $exit_code${NC}" >&2
            
            if [ $attempt -lt $max_retries ]; then
                echo -e "${YELLOW}Retrying in 2 seconds...${NC}" >&2
                sleep 2
            fi
        fi
        
        attempt=$((attempt + 1))
    done
    
    echo -e "${RED}Cline task failed after $max_retries attempts${NC}" >&2
    return 1
}

# Function: Generate unit tests
generate_unit_tests() {
    local file_pattern="${1:-*.js}"
    local instance_name="${2:-$CLINE_INSTANCE}"
    
    echo -e "${BLUE}Generating unit tests for: $file_pattern${NC}" >&2
    
    local prompt="Generate comprehensive unit tests for all files matching pattern: $file_pattern"
    run_cline_task "$prompt" "$instance_name"
    return $?
}

# Function: Code review
code_review() {
    local output_file="${1:-review.md}"
    local instance_name="${2:-$CLINE_INSTANCE}"
    
    echo -e "${BLUE}Running code review...${NC}" >&2
    
    # Ensure instance exists
    init_cline_instance "$instance_name"
    
    cline review --output="$output_file"
    return $?
}

# Function: Refactor code
refactor_code() {
    local description="$1"
    local instance_name="${2:-$CLINE_INSTANCE}"
    
    echo -e "${BLUE}Refactoring code: $description${NC}" >&2
    
    local prompt="Refactor code: $description"
    run_cline_task "$prompt" "$instance_name"
    return $?
}

# Function: List instances
list_instances() {
    echo -e "${BLUE}Listing Cline instances...${NC}" >&2
    cline instance list
    return $?
}

# Function: Switch instance
switch_instance() {
    local instance_id="$1"
    echo -e "${BLUE}Switching to instance: $instance_id${NC}" >&2
    cline instance switch "$instance_id"
    return $?
}

# Function: List tasks
list_tasks() {
    echo -e "${BLUE}Listing Cline tasks...${NC}" >&2
    cline task list
    return $?
}

# Function: View task
view_task() {
    local follow="${1:-false}"
    echo -e "${BLUE}Viewing Cline task...${NC}" >&2
    
    if [ "$follow" = "true" ]; then
        cline task view --follow
    else
        cline task view
    fi
    return $?
}

# Function: Batch process files
batch_process_files() {
    local pattern="$1"
    local prompt_template="$2"
    local instance_name="${3:-$CLINE_INSTANCE}"
    
    echo -e "${BLUE}Batch processing files matching: $pattern${NC}" >&2
    
    # Ensure instance exists
    init_cline_instance "$instance_name"
    
    local processed=0
    local failed=0
    
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local prompt=$(echo "$prompt_template" | sed "s|{FILE}|$file|g")
            
            echo -e "${BLUE}Processing: $file${NC}" >&2
            
            if run_cline_task "$prompt" "$instance_name"; then
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
    check_cline_installed
    check_api_key
    
    case "${1:-help}" in
        task)
            run_cline_task "${2:-}" "${3:-$CLINE_INSTANCE}"
            ;;
        review)
            code_review "${2:-review.md}" "${3:-$CLINE_INSTANCE}"
            ;;
        refactor)
            refactor_code "${2:-}" "${3:-$CLINE_INSTANCE}"
            ;;
        generate-tests)
            generate_unit_tests "${2:-*.js}" "${3:-$CLINE_INSTANCE}"
            ;;
        batch)
            batch_process_files "${2:-*.js}" "${3:-Review {FILE} for improvements}" "${4:-$CLINE_INSTANCE}"
            ;;
        instance)
            case "${2:-list}" in
                new)
                    init_cline_instance "${3:-default}"
                    ;;
                list)
                    list_instances
                    ;;
                switch)
                    switch_instance "${3:-}"
                    ;;
                *)
                    echo "Usage: $0 instance {new|list|switch} [args...]"
                    exit 1
                    ;;
            esac
            ;;
        task-list)
            list_tasks
            ;;
        task-view)
            view_task "${2:-false}"
            ;;
        *)
            echo "Usage: $0 {task|review|refactor|generate-tests|batch|instance|task-list|task-view} [args...]"
            echo ""
            echo "Examples:"
            echo "  $0 task 'Generate unit tests'"
            echo "  $0 review review.md"
            echo "  $0 refactor 'Improve code quality'"
            echo "  $0 generate-tests '*.js'"
            echo "  $0 batch '*.js' 'Review {FILE}'"
            echo "  $0 instance new my-instance"
            echo "  $0 instance list"
            echo "  $0 instance switch instance-id"
            echo "  $0 task-list"
            echo "  $0 task-view true"
            exit 1
            ;;
    esac
fi

