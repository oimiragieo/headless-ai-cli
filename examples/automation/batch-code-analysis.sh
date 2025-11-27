#!/bin/bash
# Batch Code Analysis Script
# Analyzes multiple files using AI CLI tools in parallel

set -e

# Configuration
REPO_PATH="${1:-.}"
OUTPUT_DIR="${2:-./analysis-reports}"
GEMINI_API_KEY="${GEMINI_API_KEY:-}"
CLAUDE_API_KEY="${ANTHROPIC_API_KEY:-}"
MAX_PARALLEL="${MAX_PARALLEL:-4}"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "🔍 Starting batch code analysis for: $REPO_PATH"
echo "📁 Output directory: $OUTPUT_DIR"
echo "⚡ Max parallel jobs: $MAX_PARALLEL"
echo ""

# Function to analyze file with Gemini
analyze_with_gemini() {
    local file="$1"
    local output="$2"
    
    if [ -n "$GEMINI_API_KEY" ]; then
        cat "$file" | gemini -p "Analyze this code for:
        - Code quality issues
        - Potential bugs
        - Security vulnerabilities
        - Performance improvements
        - Best practices violations
        
        Provide specific suggestions with line numbers." \
        --output-format json > "$output.gemini.json" 2>/dev/null || true
    fi
}

# Function to analyze file with Claude
analyze_with_claude() {
    local file="$1"
    local output="$2"
    
    if [ -n "$CLAUDE_API_KEY" ]; then
        claude -p "Analyze this code: $(cat "$file")" \
            --output-format json > "$output.claude.json" 2>/dev/null || true
    fi
}

# Export functions for parallel execution
export -f analyze_with_gemini
export -f analyze_with_claude
export GEMINI_API_KEY
export CLAUDE_API_KEY

# Find all code files
echo "📂 Finding code files..."
FILES=$(find "$REPO_PATH" -type f \( \
    -name "*.py" -o \
    -name "*.js" -o \
    -name "*.ts" -o \
    -name "*.java" -o \
    -name "*.go" -o \
    -name "*.rs" \
\) -not -path "*/node_modules/*" -not -path "*/.git/*" | head -50)

TOTAL=$(echo "$FILES" | wc -l)
echo "Found $TOTAL files to analyze"
echo ""

# Analyze files in parallel
echo "$FILES" | xargs -P "$MAX_PARALLEL" -I {} bash -c '
    file="{}"
    safe_name=$(echo "$file" | tr "/" "_" | tr " " "_")
    output="'"$OUTPUT_DIR"'/$safe_name"
    
    echo "[$(date +%H:%M:%S)] Analyzing: $file"
    
    analyze_with_gemini "$file" "$output"
    analyze_with_claude "$file" "$output"
    
    echo "[$(date +%H:%M:%S)] ✅ Completed: $file"
'

echo ""
echo "🎉 Batch analysis complete!"
echo "📊 Results saved to: $OUTPUT_DIR"
echo ""
echo "To view results:"
echo "  ls -la $OUTPUT_DIR"
echo "  cat $OUTPUT_DIR/*.json | jq"

