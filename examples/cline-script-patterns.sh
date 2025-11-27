#!/bin/bash
# Reusable Script Patterns for Cline CLI
# This file contains common patterns and utilities for using Cline CLI in automation
#
# Two approaches are available:
# 1. Simple Direct Syntax (recommended for most use cases)
# 2. Advanced Task/Instance Management (for complex workflows)

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

#############################################
# SIMPLE DIRECT SYNTAX FUNCTIONS (Recommended)
#############################################

# Function: Run Cline with direct prompt (simple)
run_cline_direct() {
    local prompt="$1"
    local output_format="${2:-rich}"  # rich, json, or plain

    echo -e "${BLUE}Running Cline: $prompt${NC}" >&2

    cline "$prompt" --yolo --output-format "$output_format"
    return $?
}

# Function: Run Cline with file attachment
run_cline_with_file() {
    local prompt="$1"
    local file="$2"

    echo -e "${BLUE}Running Cline with file: $file${NC}" >&2

    cline "$prompt" -f "$file" --yolo
    return $?
}

# Function: Run Cline in plan mode
run_cline_plan() {
    local prompt="$1"

    echo -e "${BLUE}Running Cline in plan mode: $prompt${NC}" >&2

    cline "$prompt" --mode plan --yolo
    return $?
}

# Function: Generate unit tests (simple)
generate_tests_simple() {
    local file_pattern="${1:-*.js}"

    echo -e "${BLUE}Generating unit tests for: $file_pattern${NC}" >&2

    local prompt="Generate comprehensive unit tests for all files matching pattern: $file_pattern"
    cline "$prompt" --yolo --output-format json
    return $?
}

# Function: Code review with git diff (simple)
code_review_simple() {
    local output_format="${1:-plain}"

    echo -e "${BLUE}Running code review on git diff...${NC}" >&2

    git diff | cline "Review these code changes for bugs and security issues" --yolo --output-format "$output_format"
    return $?
}

# Function: Batch process files (simple)
batch_process_simple() {
    local pattern="$1"
    local prompt_template="$2"

    echo -e "${BLUE}Batch processing files matching: $pattern${NC}" >&2

    local processed=0
    local failed=0

    for file in $(find . -type f -name "$pattern" 2>/dev/null | head -20); do
        if [ -f "$file" ]; then
            local prompt="${prompt_template/\{FILE\}/$file}"

            echo -e "${BLUE}Processing: $file${NC}" >&2

            if cline "$prompt" -f "$file" --yolo; then
                processed=$((processed + 1))
                echo -e "${GREEN}✓ Processed: $file${NC}" >&2
            else
                failed=$((failed + 1))
                echo -e "${RED}✗ Failed: $file${NC}" >&2
            fi
        fi
    done

    echo -e "${GREEN}Batch processing complete: $processed processed, $failed failed${NC}" >&2
    return $failed
}

#############################################
# ADVANCED TASK/INSTANCE FUNCTIONS
#############################################

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
        # Simple direct syntax commands (recommended)
        direct)
            run_cline_direct "${2:-}" "${3:-rich}"
            ;;
        plan)
            run_cline_plan "${2:-}"
            ;;
        with-file)
            run_cline_with_file "${2:-}" "${3:-}"
            ;;
        review-simple)
            code_review_simple "${2:-plain}"
            ;;
        generate-tests-simple)
            generate_tests_simple "${2:-*.js}"
            ;;
        batch-simple)
            batch_process_simple "${2:-*.js}" "${3:-Review {FILE} for improvements}"
            ;;

        # Advanced task/instance commands
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
            echo "Usage: $0 {COMMAND} [args...]"
            echo ""
            echo "Simple Direct Syntax (Recommended):"
            echo "  $0 direct 'Your prompt' [json|rich|plain]"
            echo "  $0 plan 'Design architecture'"
            echo "  $0 with-file 'Review this code' path/to/file"
            echo "  $0 review-simple [json|plain]"
            echo "  $0 generate-tests-simple '*.js'"
            echo "  $0 batch-simple '*.js' 'Review {FILE}'"
            echo ""
            echo "Advanced Task/Instance Management:"
            echo "  $0 task 'Generate unit tests' [instance-name]"
            echo "  $0 review review.md [instance-name]"
            echo "  $0 refactor 'Improve code quality' [instance-name]"
            echo "  $0 generate-tests '*.js' [instance-name]"
            echo "  $0 batch '*.js' 'Review {FILE}' [instance-name]"
            echo "  $0 instance new my-instance"
            echo "  $0 instance list"
            echo "  $0 instance switch instance-id"
            echo "  $0 task-list"
            echo "  $0 task-view [true|false]"
            exit 1
            ;;
    esac
fi

