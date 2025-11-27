#!/bin/bash
# Multi-Tool AI CLI Orchestration Example
# Demonstrates using multiple AI CLI tools in a workflow

set -e

echo "🚀 Multi-Tool AI CLI Workflow"
echo "=============================="
echo ""

# Step 1: Analyze codebase structure with Gemini
echo "📊 Step 1: Analyzing codebase structure (Gemini)..."
gemini -p "Analyze this codebase structure and identify:
- Main components and their relationships
- Potential architectural improvements
- Dependencies and their purposes

Provide a structured analysis." --output-format json > analysis.json

echo "✅ Analysis complete"
echo ""

# Step 2: Generate improvement plan with Claude
echo "📋 Step 2: Generating improvement plan (Claude)..."
ANALYSIS=$(cat analysis.json | jq -r '.response // .result // empty')
claude -p "Based on this analysis, create a prioritized improvement plan:

$ANALYSIS

Provide:
1. High-priority improvements
2. Medium-priority improvements
3. Low-priority improvements
4. Estimated effort for each" --output-format json > plan.json

echo "✅ Plan generated"
echo ""

# Step 3: Generate code improvements with Codex
echo "🔧 Step 3: Generating code improvements (Codex)..."
codex exec "Review the improvement plan in plan.json and implement the highest priority item" \
    --full-auto --json > improvements.json

echo "✅ Improvements generated"
echo ""

# Step 4: Security audit with Droid
echo "🔒 Step 4: Running security audit (Droid)..."
droid exec --auto low "Run a security audit on the codebase. Check for common vulnerabilities and write findings to security-report.json" \
    --output-format json > audit.json

echo "✅ Security audit complete"
echo ""

# Step 5: Generate summary with Gemini
echo "📝 Step 5: Generating workflow summary (Gemini)..."
SUMMARY=$(cat plan.json improvements.json audit.json | jq -s '.')
gemini -p "Summarize this workflow execution:

$SUMMARY

Provide:
- What was accomplished
- Key findings
- Next steps
- Recommendations" --output-format json > summary.json

echo "✅ Summary generated"
echo ""

# Display results
echo "📊 Workflow Results:"
echo "===================="
cat summary.json | jq -r '.response // .result // empty'

echo ""
echo "📁 Generated Files:"
echo "  - analysis.json: Codebase analysis"
echo "  - plan.json: Improvement plan"
echo "  - improvements.json: Code improvements"
echo "  - audit.json: Security audit"
echo "  - summary.json: Workflow summary"
echo ""
echo "🎉 Workflow complete!"

