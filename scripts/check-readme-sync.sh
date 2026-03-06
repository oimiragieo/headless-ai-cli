#!/usr/bin/env bash
set -euo pipefail

# README Sync Validator
# Validates that README.md tool counts, comparison table entries, and internal links
# match the actual files in tools/major/.
# Usage: bash scripts/check-readme-sync.sh

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXIT_CODE=0
TOOLS_DIR="$REPO_ROOT/tools/major"
README="$REPO_ROOT/README.md"
QUICK_REF="$REPO_ROOT/QUICK_REFERENCE.md"

echo "=== README Sync Validation ==="
echo ""

# Get actual tool files
TOOL_FILES=()
for f in "$TOOLS_DIR"/*.md; do
  TOOL_FILES+=("$(basename "$f" .md)")
done
ACTUAL_COUNT=${#TOOL_FILES[@]}
echo "Actual tool files in tools/major/: $ACTUAL_COUNT"
echo ""

# Check 1: README badge count
echo "--- Check 1: README Badge Tool Count ---"
badge_count=$(grep -oE 'Tools%20Documented-[0-9]+' "$README" | sed 's/.*-//' || echo "0")
if [[ "$badge_count" -ne "$ACTUAL_COUNT" ]]; then
  echo "  FAIL: Badge says $badge_count, found $ACTUAL_COUNT files"
  EXIT_CODE=1
else
  echo "  PASS: Badge count ($badge_count) matches"
fi
echo ""

# Check 2: Comparison table has all tools
echo "--- Check 2: Comparison Table Completeness ---"
for tool in "${TOOL_FILES[@]}"; do
  if ! grep -q "tools/major/${tool}.md" "$README"; then
    echo "  FAIL: $tool.md not linked in README comparison table"
    EXIT_CODE=1
  else
    echo "  PASS: $tool.md linked in README"
  fi
done
echo ""

# Check 3: QUICK_REFERENCE tool count
echo "--- Check 3: QUICK_REFERENCE Tool Count ---"
qr_count=$(grep -oE '[0-9]+ Tools Documented' "$QUICK_REF" | grep -oE '^[0-9]+' | head -1 || echo "0")
if [[ "$qr_count" -ne "$ACTUAL_COUNT" ]]; then
  echo "  FAIL: QUICK_REFERENCE says $qr_count, found $ACTUAL_COUNT files"
  EXIT_CODE=1
else
  echo "  PASS: QUICK_REFERENCE count ($qr_count) matches"
fi
echo ""

# Check 4: No broken internal links to tools/major/
echo "--- Check 4: Internal Link Validation ---"
broken=0
while IFS= read -r link; do
  if [[ ! -f "$REPO_ROOT/$link" ]]; then
    echo "  FAIL: Broken link: $link"
    EXIT_CODE=1
    broken=$((broken + 1))
  fi
done < <(grep -oE 'tools/major/[a-z0-9-]+\.md' "$README" | sort -u)
if [[ $broken -eq 0 ]]; then
  echo "  PASS: All internal links resolve"
fi
echo ""

# Check 5: Installation section references all tools
echo "--- Check 5: Installation Section Coverage ---"
install_section=$(sed -n '/## .* Installation Commands/,/^## /p' "$README")
missing_install=0
for tool in "${TOOL_FILES[@]}"; do
  # Skip checking for tools that might be referenced by different names
  tool_lower=$(echo "$tool" | tr '[:upper:]' '[:lower:]')
  if ! echo "$install_section" | grep -qi "$tool_lower\|${tool_lower//-/ }"; then
    echo "  WARN: $tool may not be mentioned in Installation section"
    missing_install=$((missing_install + 1))
  fi
done
if [[ $missing_install -eq 0 ]]; then
  echo "  PASS: All tools referenced in Installation section"
fi
echo ""

if [[ $EXIT_CODE -eq 0 ]]; then
  echo "=== All sync checks PASSED ==="
else
  echo "=== Some sync checks FAILED ==="
fi
exit $EXIT_CODE
