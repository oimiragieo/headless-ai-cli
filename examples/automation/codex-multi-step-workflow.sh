#!/bin/bash
# Multi-Step Workflow with Codex Session Management
# Demonstrates how to use session resume for multi-step tasks

set -e

# Configuration
WORKFLOW_TYPE="${1:-refactor}"

echo "🔄 Codex Multi-Step Workflow Example"
echo "📋 Workflow type: $WORKFLOW_TYPE"
echo ""

# Check if Codex CLI is installed
if ! command -v codex &> /dev/null; then
    echo "❌ Error: Codex CLI not found. Install with: npm install -g @openai/codex"
    exit 1
fi

# Check if API key is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "⚠️  Warning: OPENAI_API_KEY not set. Set it with: export OPENAI_API_KEY=your_key_here"
    exit 1
fi

# Function to extract thread_id from JSONL output
extract_thread_id() {
    local jsonl_file="$1"
    if [ -f "$jsonl_file" ] && command -v jq &> /dev/null; then
        jq -r 'select(.type=="thread.started") | .thread_id' "$jsonl_file" 2>/dev/null | head -1
    fi
}

# Function to run a step and capture thread_id
run_step() {
    local step_num="$1"
    local prompt="$2"
    local output_file="/tmp/codex-step${step_num}.jsonl"
    
    echo "📝 Step $step_num: $prompt"
    echo "   Running Codex..."
    
    codex exec --json --color never "$prompt" > "$output_file" 2>&1 || true
    
    # Extract thread_id for next step
    THREAD_ID=$(extract_thread_id "$output_file")
    
    if [ -n "$THREAD_ID" ]; then
        echo "   ✅ Thread ID: $THREAD_ID"
        echo "$THREAD_ID" > /tmp/codex-thread-id.txt
    else
        echo "   ⚠️  Could not extract thread ID"
    fi
    
    # Extract agent message if available
    if command -v jq &> /dev/null; then
        MESSAGE=$(jq -r 'select(.type=="item.completed" and .item.type=="agent_message") | .item.text' "$output_file" 2>/dev/null | head -1)
        if [ -n "$MESSAGE" ]; then
            echo "   💬 Response: ${MESSAGE:0:100}..."
        fi
    fi
    
    echo ""
}

# Function to resume session
resume_step() {
    local step_num="$1"
    local prompt="$2"
    local thread_id="$3"
    local output_file="/tmp/codex-step${step_num}.jsonl"
    
    echo "🔄 Step $step_num (Resume): $prompt"
    echo "   Thread ID: $thread_id"
    echo "   Running Codex..."
    
    if [ -n "$thread_id" ]; then
        codex exec resume "$thread_id" --json --color never "$prompt" > "$output_file" 2>&1 || true
    else
        # Fallback to resume --last
        codex exec resume --last --json --color never "$prompt" > "$output_file" 2>&1 || true
    fi
    
    # Extract agent message if available
    if command -v jq &> /dev/null; then
        MESSAGE=$(jq -r 'select(.type=="item.completed" and .item.type=="agent_message") | .item.text' "$output_file" 2>/dev/null | head -1)
        if [ -n "$MESSAGE" ]; then
            echo "   💬 Response: ${MESSAGE:0:100}..."
        fi
    fi
    
    echo ""
}

# Example workflow: Code Refactoring
if [ "$WORKFLOW_TYPE" = "refactor" ]; then
    echo "🔧 Refactoring Workflow"
    echo "======================"
    echo ""
    
    # Step 1: Analyze codebase
    run_step 1 "Analyze this codebase structure and identify areas that need refactoring"
    
    # Step 2: Create refactoring plan
    THREAD_ID=$(cat /tmp/codex-thread-id.txt 2>/dev/null || echo "")
    if [ -n "$THREAD_ID" ]; then
        resume_step 2 "Create a detailed refactoring plan based on your analysis" "$THREAD_ID"
    else
        resume_step 2 "Create a detailed refactoring plan based on your analysis" ""
    fi
    
    # Step 3: Execute refactoring (with file modifications)
    THREAD_ID=$(cat /tmp/codex-thread-id.txt 2>/dev/null || echo "")
    if [ -n "$THREAD_ID" ]; then
        echo "🔧 Step 3 (Resume): Execute the refactoring plan"
        echo "   Thread ID: $THREAD_ID"
        echo "   Running Codex with file write permissions..."
        codex exec resume "$THREAD_ID" --full-auto --json --color never \
            "Execute the refactoring plan. Make the necessary code changes." \
            > /tmp/codex-step3.jsonl 2>&1 || true
        echo ""
    fi
    
    echo "✅ Refactoring workflow complete!"
    
# Example workflow: Security Audit
elif [ "$WORKFLOW_TYPE" = "security" ]; then
    echo "🔒 Security Audit Workflow"
    echo "=========================="
    echo ""
    
    # Step 1: Initial security scan
    run_step 1 "Perform an initial security scan of this codebase"
    
    # Step 2: Deep dive into findings
    THREAD_ID=$(cat /tmp/codex-thread-id.txt 2>/dev/null || echo "")
    resume_step 2 "For each security issue found, provide detailed analysis and remediation steps" "$THREAD_ID"
    
    # Step 3: Generate security report
    THREAD_ID=$(cat /tmp/codex-thread-id.txt 2>/dev/null || echo "")
    resume_step 3 "Generate a comprehensive security audit report with severity levels" "$THREAD_ID"
    
    echo "✅ Security audit workflow complete!"
    
# Example workflow: Feature Development
elif [ "$WORKFLOW_TYPE" = "feature" ]; then
    echo "✨ Feature Development Workflow"
    echo "==============================="
    echo ""
    
    # Step 1: Plan feature
    run_step 1 "Plan a new feature: user authentication system"
    
    # Step 2: Design implementation
    THREAD_ID=$(cat /tmp/codex-thread-id.txt 2>/dev/null || echo "")
    resume_step 2 "Design the implementation details for the authentication system" "$THREAD_ID"
    
    # Step 3: Generate code
    THREAD_ID=$(cat /tmp/codex-thread-id.txt 2>/dev/null || echo "")
    echo "💻 Step 3 (Resume): Generate the authentication code"
    echo "   Thread ID: $THREAD_ID"
    echo "   Running Codex with file write permissions..."
    codex exec resume "$THREAD_ID" --full-auto --json --color never \
        "Generate the code for the authentication system based on the design" \
        > /tmp/codex-step3.jsonl 2>&1 || true
    echo ""
    
    # Step 4: Create tests
    THREAD_ID=$(cat /tmp/codex-thread-id.txt 2>/dev/null || echo "")
    resume_step 4 "Create comprehensive unit tests for the authentication system" "$THREAD_ID"
    
    echo "✅ Feature development workflow complete!"
    
else
    echo "❌ Unknown workflow type: $WORKFLOW_TYPE"
    echo ""
    echo "Available workflow types:"
    echo "  - refactor: Code refactoring workflow"
    echo "  - security: Security audit workflow"
    echo "  - feature: Feature development workflow"
    exit 1
fi

echo ""
echo "📊 Workflow Summary"
echo "==================="
echo "All step outputs saved to: /tmp/codex-step*.jsonl"
echo ""
echo "To view results:"
echo "  ls -la /tmp/codex-step*.jsonl"
echo "  jq 'select(.type==\"item.completed\" and .item.type==\"agent_message\") | .item.text' /tmp/codex-step*.jsonl"

