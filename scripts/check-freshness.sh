#!/usr/bin/env bash
set -euo pipefail

# Documentation Freshness Checker
# Validates that all "Verified"/"Last Updated" dates are within STALENESS_DAYS threshold.
# Usage: STALENESS_DAYS=90 bash scripts/check-freshness.sh

STALENESS_DAYS="${STALENESS_DAYS:-90}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXIT_CODE=0

echo "=== Documentation Freshness Check ==="
echo "Staleness threshold: ${STALENESS_DAYS} days"
echo ""

NOW=$(date +%s)

# Parse "Mon YYYY" or "Month YYYY" to epoch seconds
parse_month_year() {
  local date_str="$1"
  # Try GNU date first, then macOS gdate
  date -d "1 ${date_str}" +%s 2>/dev/null || \
  gdate -d "1 ${date_str}" +%s 2>/dev/null || \
  echo ""
}

check_date() {
  local label="$1" date_str="$2"
  local epoch age_days
  epoch=$(parse_month_year "$date_str")
  if [[ -z "$epoch" ]]; then
    echo "  WARN: Could not parse date '$date_str' for $label"
    EXIT_CODE=1
    return
  fi
  age_days=$(( (NOW - epoch) / 86400 ))
  if [[ $age_days -gt $STALENESS_DAYS ]]; then
    echo "  FAIL: $label - '$date_str' ($age_days days ago, threshold: $STALENESS_DAYS)"
    EXIT_CODE=1
  else
    echo "  PASS: $label - '$date_str' ($age_days days ago)"
  fi
}

# Check 1: README comparison table Verified column
echo "--- Check 1: Tool Verification Dates (README comparison table) ---"
while IFS='|' read -r _ tool _ _ _ _ verified _; do
  tool=$(echo "$tool" | xargs)
  verified=$(echo "$verified" | xargs)
  [[ -z "$tool" || "$tool" == "Tool" || "$tool" == -* ]] && continue
  if [[ "$verified" == "DEPRECATED" ]]; then
    echo "  SKIP: $tool (DEPRECATED)"
    continue
  fi
  check_date "$tool" "$verified"
done < <(grep -E '^\|.*\|.*\|.*\|.*\|.*\|.*\|$' "$REPO_ROOT/README.md" | tail -n +3)
echo ""

# Check 2: README "Last verification" date
echo "--- Check 2: README Last Verification ---"
last_verify=$(grep -oE 'Last verification:\*?\*?\s*[A-Za-z]+ [0-9]{4}' "$REPO_ROOT/README.md" | grep -oE '[A-Za-z]+ [0-9]{4}' || echo "")
if [[ -n "$last_verify" ]]; then
  check_date "README Last verification" "$last_verify"
else
  echo "  FAIL: 'Last verification:' not found in README.md"
  EXIT_CODE=1
fi
echo ""

# Check 3: QUICK_REFERENCE "Last Updated"
echo "--- Check 3: QUICK_REFERENCE Last Updated ---"
qr_date=$(grep -oE 'Last Updated:\s*[A-Za-z]+ [0-9]{4}' "$REPO_ROOT/QUICK_REFERENCE.md" | grep -oE '[A-Za-z]+ [0-9]{4}' | head -1 || echo "")
if [[ -n "$qr_date" ]]; then
  check_date "QUICK_REFERENCE" "$qr_date"
else
  echo "  FAIL: 'Last Updated:' not found in QUICK_REFERENCE.md"
  EXIT_CODE=1
fi
echo ""

# Check 4: Exa queries "Last run"
echo "--- Check 4: Exa Queries Last Run ---"
exa_date=$(grep -oE 'Last run:\*?\*?\s*[A-Za-z]+ [0-9]{4}' "$REPO_ROOT/scripts/exa-update-queries.md" | grep -oE '[A-Za-z]+ [0-9]{4}' | head -1 || echo "")
if [[ -n "$exa_date" ]]; then
  check_date "Exa queries" "$exa_date"
else
  echo "  FAIL: 'Last run:' not found in exa-update-queries.md"
  EXIT_CODE=1
fi
echo ""

if [[ $EXIT_CODE -eq 0 ]]; then
  echo "=== All freshness checks PASSED ==="
else
  echo "=== Some freshness checks FAILED ==="
fi
exit $EXIT_CODE
