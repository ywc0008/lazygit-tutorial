#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # Check: git worktree list shows more than 1 worktree
    WORKTREE_COUNT=$(git worktree list | wc -l | tr -d ' ')
    if [ "$WORKTREE_COUNT" -lt 2 ]; then
        exit 1
    fi

    exit 0
    ;;
  2)
    # Check: only 1 worktree remains (the main one)
    WORKTREE_COUNT=$(git worktree list | wc -l | tr -d ' ')
    if [ "$WORKTREE_COUNT" -gt 1 ]; then
        echo "FAIL: More than 1 worktree still exists — remove the extra worktree"
        exit 1
    fi

    exit 0
    ;;
esac
exit 1
