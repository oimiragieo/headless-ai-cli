#!/bin/bash
# Automated Code Review Script
# Uses multiple AI CLI tools for comprehensive code review

set -e

# Configuration
REPO_PATH="${1:-.}"
OUTPUT_DIR="${2:-./reviews}"
GEMINI_API_KEY="${GEMINI_API_KEY:-}"
CLAUDE_API_KEY="${ANTHROPIC_API_KEY:-}"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "🔍 Starting automated code review for: $REPO_PATH"
echo "📁 Output directory: $OUTPUT_DIR"
echo ""

# Function to run Gemini review
run_gemini_review() {
    local file="$1"
    local output="$2"
    
    if [ -n "$GEMINI_API_KEY" ]; then
        echo "  🤖 Running Gemini review..."
        cat "$file" | gemini -p "Review this code for bugs, security issues, and improvements" \
            --output-format json > "$output.gemini.json" 2>/dev/null || true
    fi
}

# Function to run Claude review
run_claude_review() {
    local file="$1"
    local output="$2"
    
    if [ -n "$CLAUDE_API_KEY" ]; then
        echo "  🧠 Running Claude review..."
        claude -p "Review this code: $(cat "$file")" \
            --output-format json > "$output.claude.json" 2>/dev/null || true
    fi
}

# Find all code files
echo "📂 Finding code files..."
FILES=$(find "$REPO_PATH" -type f \( \
    -name "*.py" -o \
    -name "*.js" -o \
    -name "*.ts" -o \
    -name "*.java" -o \
    -name "*.go" -o \
    -name "*.rs" \
\) -not -path "*/node_modules/*" -not -path "*/.git/*" | head -20)

TOTAL=$(echo "$FILES" | wc -l)
CURRENT=0

# Review each file
echo "$FILES" | while IFS= read -r file; do
    CURRENT=$((CURRENT + 1))
    echo "[$CURRENT/$TOTAL] Reviewing: $file"
    
    # Create safe output filename
    safe_name=$(echo "$file" | tr '/' '_' | tr ' ' '_')
    output="$OUTPUT_DIR/$safe_name"
    
    # Run reviews
    run_gemini_review "$file" "$output"
    run_claude_review "$file" "$output"
    
    echo "  ✅ Completed"
    echo ""
done

echo "🎉 Code review complete!"
echo "📊 Results saved to: $OUTPUT_DIR"
echo ""
echo "To view results:"
echo "  ls -la $OUTPUT_DIR"
echo "  cat $OUTPUT_DIR/*.json | jq"

