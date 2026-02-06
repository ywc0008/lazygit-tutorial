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
esac
exit 1
