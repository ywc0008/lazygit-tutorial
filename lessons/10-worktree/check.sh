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
esac
exit 1
