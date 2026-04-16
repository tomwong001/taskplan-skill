#!/usr/bin/env bash
set -euo pipefail

VERSION=$(cat VERSION)
OUT="taskplan.skill"
TMP=$(mktemp -d)

echo "Building taskplan skill v${VERSION}..."

# Copy skill files
cp skill/SKILL.md "$TMP/SKILL.md"
cp -r skill/references "$TMP/references"

# Create ZIP archive
(cd "$TMP" && zip -r - .) > "$OUT"

# Cleanup
rm -rf "$TMP"

SIZE=$(du -h "$OUT" | cut -f1)
echo "Built $OUT ($SIZE)"
