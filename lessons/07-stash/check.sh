#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # Tracked modifications must be stashed (untracked files are OK)
    if [ -n "$(git status --porcelain -uno)" ]; then
      echo "FAIL: Tracked file changes remain — stash your changes first"
      exit 1
    fi

    # Stash must have at least 1 entry
    STASH_COUNT=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    if [ "$STASH_COUNT" -lt 1 ]; then
      echo "FAIL: No stash entries found — use 's' in the Files panel to stash"
      exit 1
    fi

    exit 0
    ;;
  2)
    # Working directory must have modifications (files restored)
    if [ -z "$(git status --porcelain)" ]; then
      echo "FAIL: Working directory is clean — stash was not popped"
      exit 1
    fi

    # Stash must be empty (popped, not just applied)
    STASH_COUNT=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
    if [ "$STASH_COUNT" -gt 0 ]; then
      echo "FAIL: Stash still has entries — use 'g' (pop) instead of Space (apply)"
      exit 1
    fi

    exit 0
    ;;
esac
exit 1
