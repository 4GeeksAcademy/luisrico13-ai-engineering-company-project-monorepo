#!/usr/bin/env bash
# Verifies the acceptance criteria of the update-memory-bank skill.
# Usage: verify_memory_bank.sh [--base <git-ref>] [--today YYYY-MM-DD]
#   --base   ref to diff the working tree against (default: HEAD; use origin/main for a PR)
#   --today  date expected in progress.md (default: local date)
set -uo pipefail

BASE="HEAD"
TODAY="$(date +%F)"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --base) BASE="$2"; shift 2 ;;
    --today) TODAY="$2"; shift 2 ;;
    -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "Not inside a git repository" >&2; exit 2; }
cd "$ROOT" || exit 2
MB="memory-bank"
FAILURES=0

pass() { echo "PASS  $1"; }
fail() { echo "FAIL  $1"; FAILURES=$((FAILURES + 1)); }

declare -A HEADINGS=(
  ["$MB/projectbrief.md"]="## Business description|## Problem it solves|## Project objectives"
  ["$MB/techContext.md"]="## Tech stack|## Monorepo map|## Architectural decisions|## Technical constraints"
  ["$MB/progress.md"]="## Current state|## Next steps|## Changelog"
)

# AC1 — required files exist and are not empty
ac1_ok=1
for f in "${!HEADINGS[@]}"; do
  [[ -s "$f" ]] || { fail "AC1 $f is missing or empty"; ac1_ok=0; }
done
[[ $ac1_ok -eq 1 ]] && pass "AC1 required memory-bank files exist and are not empty"

# AC2 — required sections present
ac2_ok=1
for f in "${!HEADINGS[@]}"; do
  [[ -s "$f" ]] || continue
  IFS='|' read -ra hs <<< "${HEADINGS[$f]}"
  for h in "${hs[@]}"; do
    grep -qxF "$h" "$f" || { fail "AC2 $f is missing section '$h'"; ac2_ok=0; }
  done
done
[[ $ac2_ok -eq 1 ]] && pass "AC2 every file contains its required sections"

# AC3 — progress.md has a valid 'Last updated' date
LAST_UPDATED="$(grep -oE '^Last updated: [0-9]{4}-[0-9]{2}-[0-9]{2}$' "$MB/progress.md" 2>/dev/null | head -1 | awk '{print $3}')"
if [[ -n "$LAST_UPDATED" ]] && date -d "$LAST_UPDATED" >/dev/null 2>&1; then
  pass "AC3 progress.md has 'Last updated: $LAST_UPDATED'"
else
  fail "AC3 progress.md needs a line 'Last updated: YYYY-MM-DD' with a valid date"
fi

# Files changed against BASE (staged + unstaged + untracked)
if ! git rev-parse --verify --quiet "$BASE" >/dev/null; then
  echo "Unknown git ref: $BASE" >&2; exit 2
fi
CHANGED="$( { git diff --name-only "$BASE"; git ls-files --others --exclude-standard; } | sort -u)"

# AC4 — any change must be recorded in progress.md today
if [[ -z "$CHANGED" ]]; then
  pass "AC4 no changes against $BASE — nothing to record"
else
  ac4_ok=1
  grep -qxF "$MB/progress.md" <<< "$CHANGED" || { fail "AC4 there are changes but $MB/progress.md was not updated"; ac4_ok=0; }
  [[ "$LAST_UPDATED" == "$TODAY" ]] || { fail "AC4 'Last updated' is '$LAST_UPDATED', expected '$TODAY'"; ac4_ok=0; }
  grep -qxF "### $TODAY" "$MB/progress.md" || { fail "AC4 Changelog has no '### $TODAY' entry"; ac4_ok=0; }
  [[ $ac4_ok -eq 1 ]] && pass "AC4 changes are recorded in progress.md (Last updated + Changelog for $TODAY)"
fi

# AC5 — technical changes must update techContext.md
TECH_PATTERN='^(uis|services|packages|infra|mcps|agents|workflows|data/pipelines|internal|\.devcontainer)/|(^|/)(package\.json|pyproject\.toml|pnpm-lock\.yaml|uv\.lock|requirements[^/]*\.txt|Dockerfile|docker-compose\.ya?ml)$'
TECH_CHANGES="$(grep -E "$TECH_PATTERN" <<< "$CHANGED" || true)"
if [[ -z "$TECH_CHANGES" ]]; then
  pass "AC5 no technical changes — techContext.md update not required"
elif grep -qxF "$MB/techContext.md" <<< "$CHANGED"; then
  pass "AC5 technical changes are accompanied by a techContext.md update"
else
  fail "AC5 technical files changed but $MB/techContext.md was not updated:"
  sed 's/^/        /' <<< "$TECH_CHANGES"
fi

# AC6 — no unfilled placeholders
PLACEHOLDERS="$(grep -nE '\{\{|\[TODO\]|TODO:|FIXME|lorem ipsum|<fill' "$MB"/*.md 2>/dev/null || true)"
if [[ -z "$PLACEHOLDERS" ]]; then
  pass "AC6 no unfilled placeholders in memory-bank/"
else
  fail "AC6 unfilled placeholders found:"
  sed 's/^/        /' <<< "$PLACEHOLDERS"
fi

echo
if [[ $FAILURES -eq 0 ]]; then
  echo "Memory bank verification PASSED"
  exit 0
fi
echo "Memory bank verification FAILED ($FAILURES issue(s))"
exit 1
