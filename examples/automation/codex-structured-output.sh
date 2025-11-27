#!/bin/bash
# Structured Output with Codex using JSON Schema
# Demonstrates how to use --output-schema for consistent, parseable output

set -e

# Configuration
SCHEMA_FILE="${1:-./schema.json}"
OUTPUT_FILE="${2:-./codex-output.json}"
PROMPT="${3:-Extract project metadata from this codebase}"

echo "📋 Codex Structured Output Example"
echo "📄 Schema file: $SCHEMA_FILE"
echo "📄 Output file: $OUTPUT_FILE"
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

# Create example schema if it doesn't exist
if [ ! -f "$SCHEMA_FILE" ]; then
    echo "📝 Creating example schema file: $SCHEMA_FILE"
    cat > "$SCHEMA_FILE" <<'EOF'
{
  "type": "object",
  "properties": {
    "project_name": {
      "type": "string",
      "description": "Name of the project"
    },
    "programming_languages": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "List of programming languages used"
    },
    "dependencies": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "List of main dependencies"
    },
    "test_framework": {
      "type": "string",
      "description": "Primary testing framework used"
    },
    "build_tool": {
      "type": "string",
      "description": "Build tool or package manager used"
    }
  },
  "required": ["project_name", "programming_languages"],
  "additionalProperties": false
}
EOF
    echo "✅ Schema file created"
    echo ""
fi

# Validate schema with jq if available
if command -v jq &> /dev/null; then
    echo "🔍 Validating schema file..."
    if jq . "$SCHEMA_FILE" > /dev/null 2>&1; then
        echo "✅ Schema is valid JSON"
    else
        echo "❌ Error: Schema file is not valid JSON"
        exit 1
    fi
    echo ""
fi

# Run Codex with structured output
echo "🤖 Running Codex with structured output..."
echo "   Prompt: $PROMPT"
echo ""

codex exec \
    --output-schema "$SCHEMA_FILE" \
    --output-last-message "$OUTPUT_FILE" \
    --json \
    --color never \
    --sandbox read-only \
    "$PROMPT" > /tmp/codex-structured.jsonl 2>&1 || true

# Check if output file was created
if [ -f "$OUTPUT_FILE" ]; then
    echo "✅ Output file created: $OUTPUT_FILE"
    echo ""
    
    # Validate and display output
    if command -v jq &> /dev/null; then
        echo "📊 Output content:"
        echo "---"
        jq . "$OUTPUT_FILE"
        echo "---"
        echo ""
        
        # Extract specific fields
        echo "📋 Extracted fields:"
        PROJECT_NAME=$(jq -r '.project_name // "N/A"' "$OUTPUT_FILE" 2>/dev/null || echo "N/A")
        LANGUAGES=$(jq -r '.programming_languages // [] | join(", ")' "$OUTPUT_FILE" 2>/dev/null || echo "N/A")
        
        echo "  Project Name: $PROJECT_NAME"
        echo "  Languages: $LANGUAGES"
        echo ""
        
        # Validate against schema
        echo "🔍 Validating output against schema..."
        # Note: Full schema validation would require a JSON Schema validator
        # This is a basic check for required fields
        if jq -e '.project_name' "$OUTPUT_FILE" > /dev/null 2>&1; then
            echo "✅ Output contains required fields"
        else
            echo "⚠️  Warning: Output may not match schema requirements"
        fi
    else
        echo "📄 Output file content:"
        cat "$OUTPUT_FILE"
        echo ""
        echo "💡 Install jq for better output parsing: apt-get install jq (Linux) or brew install jq (macOS)"
    fi
else
    echo "⚠️  Warning: Output file was not created"
    echo "   Check /tmp/codex-structured.jsonl for details"
    
    if [ -f /tmp/codex-structured.jsonl ]; then
        echo ""
        echo "📄 Last few lines of output:"
        tail -5 /tmp/codex-structured.jsonl
    fi
fi

echo ""
echo "🎉 Structured output example complete!"
echo ""
echo "💡 Usage tips:"
echo "  - Modify $SCHEMA_FILE to customize the output structure"
echo "  - Use the output JSON in your automation scripts"
echo "  - Combine with CI/CD pipelines for automated metadata extraction"

