#!/bin/bash
# Batch File Processing with Codex
# Processes multiple files using Codex CLI for code review, refactoring, or analysis

set -e

# Configuration
REPO_PATH="${1:-.}"
OUTPUT_DIR="${2:-./codex-reviews}"
OPENAI_API_KEY="${OPENAI_API_KEY:-}"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "🔍 Starting batch code processing with Codex"
echo "📁 Repository path: $REPO_PATH"
echo "📁 Output directory: $OUTPUT_DIR"
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

# Function to process a single file
process_file() {
    local file="$1"
    local output="$2"
    
    echo "  🤖 Processing: $file"
    
    # Process file with Codex
    codex exec --json --color never --sandbox read-only \
        "Review this code file for bugs, security issues, and improvements: $(cat "$file")" \
        > "$output.jsonl" 2>&1 || true
    
    # Extract agent message if available
    if command -v jq &> /dev/null && [ -f "$output.jsonl" ]; then
        jq -r 'select(.type=="item.completed" and .item.type=="agent_message") | .item.text' \
            "$output.jsonl" > "$output.txt" 2>/dev/null || echo "Review completed" > "$output.txt"
    else
        echo "Review completed" > "$output.txt"
    fi
    
    echo "  ✅ Completed: $file"
}

# Find all code files
echo "📂 Finding code files..."
FILES=$(find "$REPO_PATH" -type f \( \
    -name "*.py" -o \
    -name "*.js" -o \
    -name "*.ts" -o \
    -name "*.java" -o \
    -name "*.go" -o \
    -name "*.rs" -o \
    -name "*.cpp" -o \
    -name "*.c" \
\) -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/venv/*" -not -path "*/__pycache__/*" | head -20)

TOTAL=$(echo "$FILES" | wc -l)
CURRENT=0

# Process each file
echo "$FILES" | while IFS= read -r file; do
    if [ -n "$file" ]; then
        CURRENT=$((CURRENT + 1))
        echo "[$CURRENT/$TOTAL] Processing: $file"
        
        # Create safe output filename
        safe_name=$(echo "$file" | tr '/' '_' | tr ' ' '_' | sed 's/^\._//')
        output="$OUTPUT_DIR/$safe_name"
        
        # Process file
        process_file "$file" "$output"
        
        echo ""
    fi
done

echo "🎉 Batch processing complete!"
echo "📊 Results saved to: $OUTPUT_DIR"
echo ""
echo "To view results:"
echo "  ls -la $OUTPUT_DIR"
echo "  cat $OUTPUT_DIR/*.txt | head -20"

