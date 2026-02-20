#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # Check 1: commit count is 4 or fewer (was 6, user squashed at least 2)
    COMMIT_COUNT=$(git rev-list --count HEAD)
    if [ "$COMMIT_COUNT" -gt 4 ]; then
        exit 1
    fi

    # Check 2: feature.js still exists (nothing lost)
    if [ ! -f "feature.js" ]; then
        exit 1
    fi

    # Check 3: feature-b.js still exists (nothing lost)
    if [ ! -f "feature-b.js" ]; then
        exit 1
    fi

    # Check 4: README.md still exists (nothing lost)
    if [ ! -f "README.md" ]; then
        exit 1
    fi

    exit 0
    ;;
  2)
    # Check: the oldest commit message contains "project" (case-insensitive)
    OLDEST_MSG=$(git log --reverse --format='%s' | head -1)
    if ! echo "$OLDEST_MSG" | grep -i "project" >/dev/null; then
        echo "FAIL: The oldest commit message should contain 'project' — use 'r' to reword it"
        exit 1
    fi

    # Verify all files still exist
    if [ ! -f "feature.js" ] || [ ! -f "feature-b.js" ] || [ ! -f "README.md" ]; then
        echo "FAIL: Some files are missing — make sure reword did not lose any changes"
        exit 1
    fi

    exit 0
    ;;
esac
exit 1
