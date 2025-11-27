#!/bin/bash
# Security Audit Workflow
# Multi-tool security audit using Droid, Claude, and Gemini

set -e

REPO_PATH="${1:-.}"
OUTPUT_DIR="${2:-./security-audit-$(date +%Y%m%d-%H%M%S)}"

mkdir -p "$OUTPUT_DIR"

echo "🔒 Starting Security Audit Workflow"
echo "📁 Repository: $REPO_PATH"
echo "📁 Output: $OUTPUT_DIR"
echo ""

# Step 1: Droid Security Audit
echo "🤖 Step 1: Running Droid security audit..."
droid exec --auto low \
  "Run a comprehensive security audit of this codebase. Check for:
  - SQL injection vulnerabilities
  - XSS vulnerabilities
  - Insecure authentication patterns
  - Hardcoded secrets and credentials
  - Insecure dependencies
  - Missing input validation
  - Insecure file operations
  - Missing security headers
  
  Write findings to security-audit-droid.json in JSON format." \
  --output-format json > "$OUTPUT_DIR/droid-audit.json" 2>&1 || true

echo "✅ Droid audit complete"
echo ""

# Step 2: Claude Security Review
echo "🧠 Step 2: Running Claude security review..."
if [ -n "$ANTHROPIC_API_KEY" ]; then
    find "$REPO_PATH" -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" \) \
        -not -path "*/node_modules/*" -not -path "*/.git/*" | \
        head -20 | while read file; do
            claude -p "Review this code for security vulnerabilities: $(cat "$file")" \
                --append-system-prompt "You are a security expert. Focus on OWASP Top 10 vulnerabilities." \
                --output-format json > "$OUTPUT_DIR/claude-$(basename "$file").json" 2>/dev/null || true
        done
    echo "✅ Claude review complete"
else
    echo "⚠️  Claude API key not set, skipping Claude review"
fi
echo ""

# Step 3: Gemini Dependency Analysis
echo "🚀 Step 3: Running Gemini dependency analysis..."
if [ -n "$GEMINI_API_KEY" ]; then
    if [ -f "package.json" ] || [ -f "requirements.txt" ] || [ -f "Pipfile" ]; then
        gemini -p "Analyze dependencies in this project for:
        - Known vulnerabilities (CVEs)
        - Outdated packages
        - License compliance issues
        - Security best practices
        
        Provide a prioritized list of recommendations." \
        --output-format json > "$OUTPUT_DIR/gemini-deps.json" 2>/dev/null || true
        echo "✅ Gemini dependency analysis complete"
    else
        echo "⚠️  No dependency files found, skipping dependency analysis"
    fi
else
    echo "⚠️  Gemini API key not set, skipping Gemini analysis"
fi
echo ""

# Step 4: Generate Summary Report
echo "📝 Step 4: Generating summary report..."
cat > "$OUTPUT_DIR/security-audit-summary.md" << EOF
# Security Audit Report

**Date:** $(date)
**Repository:** $REPO_PATH

## Audit Results

### Droid Audit
- Report: droid-audit.json
- Status: $(if [ -f "$OUTPUT_DIR/droid-audit.json" ]; then echo "✅ Complete"; else echo "❌ Failed"; fi)

### Claude Review
- Reports: claude-*.json
- Status: $(if ls "$OUTPUT_DIR"/claude-*.json 1> /dev/null 2>&1; then echo "✅ Complete"; else echo "⚠️  Partial or skipped"; fi)

### Gemini Dependency Analysis
- Report: gemini-deps.json
- Status: $(if [ -f "$OUTPUT_DIR/gemini-deps.json" ]; then echo "✅ Complete"; else echo "⚠️  Skipped"; fi)

## Next Steps

1. Review all audit reports
2. Prioritize findings by severity
3. Create tickets for critical issues
4. Schedule remediation work
5. Re-run audit after fixes

## Files Generated

$(ls -lh "$OUTPUT_DIR" | tail -n +2 | awk '{print "- " $9 " (" $5 ")"}')
EOF

echo "✅ Summary report generated"
echo ""

# Step 5: Display Results
echo "📊 Audit Results Summary:"
echo "========================"
echo ""
echo "📁 Output directory: $OUTPUT_DIR"
echo ""
echo "Generated files:"
ls -lh "$OUTPUT_DIR" | tail -n +2 | awk '{print "  - " $9 " (" $5 ")"}'
echo ""
echo "🎯 Next Steps:"
echo "  1. Review: cat $OUTPUT_DIR/security-audit-summary.md"
echo "  2. Check Droid: cat $OUTPUT_DIR/droid-audit.json | jq"
echo "  3. Review findings and prioritize fixes"
echo ""
echo "🎉 Security audit workflow complete!"

