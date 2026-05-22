#!/bin/bash
# ── Shoperzz Release Note Generator v2.0 ─────────────────────────────────────
# Generates rich, full-project release notes from git log.
# - Covers all changes (not just package bumps)
# - Groups by commit type (feat, fix, docs, ci, refactor...)
# - Attributes each commit to its author (@github-handle or git name)
# - No emoji, plain Markdown
#
# Usage: bash ./tooling/release/make-release-description.sh
# Output: RELEASE.md (used by create-github-release.sh)

set -euo pipefail

OUTPUT="RELEASE.md"

# ── Resolve version and previous tag ─────────────────────────────────────────
CURRENT_VERSION=$(node -p "require('./packages/core/package.json').version" 2>/dev/null || echo "0.0.0")
PREV_TAG=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")

# ── Collect commits since last tag (or all if first release) ─────────────────
if [[ -n "$PREV_TAG" ]]; then
  LOG_RANGE="${PREV_TAG}..HEAD"
else
  LOG_RANGE="HEAD"
fi

# Format: TYPE(SCOPE): subject ||| AUTHOR ||| HASH
COMMITS=$(git log "$LOG_RANGE" --pretty=format:"%s ||| %aN ||| %h" --no-merges 2>/dev/null || echo "")

# ── Categorize commits ────────────────────────────────────────────────────────
declare -A CATEGORIES=(
  ["feat"]="Features"
  ["fix"]="Bug Fixes"
  ["docs"]="Documentation"
  ["ci"]="CI / Infrastructure"
  ["refactor"]="Refactoring"
  ["chore"]="Maintenance"
  ["test"]="Tests"
  ["perf"]="Performance"
  ["build"]="Build"
  ["release"]="Release Governance"
)

declare -A BUCKETS

while IFS= read -r line; do
  [[ -z "$line" ]] && continue

  SUBJECT=$(echo "$line" | awk -F' \|\|\| ' '{print $1}')
  AUTHOR=$(echo "$line" | awk -F' \|\|\| ' '{print $2}')
  HASH=$(echo "$line" | awk -F' \|\|\| ' '{print $3}')

  # Extract type prefix (feat, fix, etc.)
  TYPE=$(echo "$SUBJECT" | grep -oP '^[a-z]+(?=[\(!\:])' || echo "other")

  ENTRY="- ${SUBJECT} (${HASH}) — @${AUTHOR}"

  if [[ -n "${CATEGORIES[$TYPE]+x}" ]]; then
    BUCKETS["$TYPE"]+="${ENTRY}"$'\n'
  else
    BUCKETS["other"]+="${ENTRY}"$'\n'
    CATEGORIES["other"]="Other"
  fi
done <<< "$COMMITS"

# ── Write RELEASE.md ──────────────────────────────────────────────────────────
{
  echo "$CURRENT_VERSION"
  echo ""
  echo "What changed"
  echo ""

  # Output in a defined order
  for TYPE in feat fix refactor ci docs build test perf chore release other; do
    if [[ -n "${BUCKETS[$TYPE]+x}" && -n "${BUCKETS[$TYPE]}" ]]; then
      echo "${CATEGORIES[$TYPE]}"
      echo ""
      echo "${BUCKETS[$TYPE]}"
    fi
  done

  echo "---"
  echo "Full changelog: CHANGELOG.md"
} > "$OUTPUT"

echo "Release notes written to $OUTPUT."
