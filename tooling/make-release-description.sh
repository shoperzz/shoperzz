#!/bin/bash
# ── Shoperzz Release Note Aggregator v1.0 ──────────────────────────────────
# This script aggregates the latest changelog entries for a unified release.

set -e

OUTPUT="RELEASE.md"
echo "# Shoperzz Release Notes" > $OUTPUT
echo "" >> $OUTPUT
echo "Automatic aggregation of package changes:" >> $OUTPUT
echo "" >> $OUTPUT

# Find all CHANGELOG.md files in packages
CHANGELOGS=$(find packages -name "CHANGELOG.md")

for log in $CHANGELOGS; do
  PACKAGE_NAME=$(dirname $log | xargs basename)
  echo "### @shoperzz/$PACKAGE_NAME" >> $OUTPUT
  
  # Extract the last entry (from the first ## to the second ##)
  # We skip the first line (the title) and take everything until the next header
  sed -n '/^## / { :a; n; /^## /q; p; ba; }' "$log" >> $OUTPUT
  echo "" >> $OUTPUT
done

echo "🔗 [Full History](https://github.com/shoperzz/shoperzz/commits/main)" >> $OUTPUT
