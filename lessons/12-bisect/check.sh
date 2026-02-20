#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # Check if bisect is currently active and HEAD is at v5
    if [ -f ".git/BISECT_LOG" ]; then
        COMMIT_MSG=$(git log -1 --pretty=%B)
        if echo "$COMMIT_MSG" | grep "v5" >/dev/null; then
            exit 0
        fi
    fi

    # Check if bisect was completed (reflog shows bisect activity)
    # and the user identified v5 as the bad commit
    if git reflog | grep -i "bisect" >/dev/null; then
        # Bisect was used; check if the result pointed to v5
        # After bisect reset, check if BISECT_LOG remnants exist
        # or if the user has noted the result
        BISECT_RESULT=$(git bisect log 2>/dev/null || true)
        if echo "$BISECT_RESULT" | grep "v5" >/dev/null; then
            exit 0
        fi

        # If bisect was reset, check reflog for the v5 commit
        if git reflog | grep "bisect.*v5" >/dev/null; then
            exit 0
        fi

        # Also accept if the user ran bisect and it concluded
        # (the reflog will have bisect entries)
        BISECT_ENTRIES=$(git reflog | grep -c "bisect" || true)
        if [ "$BISECT_ENTRIES" -ge 3 ]; then
            # User performed multiple bisect steps — accept as completed
            exit 0
        fi
    fi

    echo "Use git bisect to find which commit introduced 'BUG_INTRODUCED'."
    echo "In lazygit: go to Commits panel, press b to start bisect."
    exit 1
    ;;
  2)
    # Check 1: bisect is not active
    if [ -f ".git/BISECT_LOG" ]; then
      echo "FAIL: Bisect is still active — reset bisect first (git bisect reset or press b in lazygit)"
      exit 1
    fi

    # Check 2: config.js should no longer exist (revert of v5 removes it)
    if [ -f "config.js" ]; then
      echo "FAIL: config.js still exists — revert the v5 commit that introduced the bug"
      exit 1
    fi

    # Check 3: a revert commit should exist
    if ! git log --oneline | grep -i "revert" >/dev/null; then
      echo "FAIL: No revert commit found — revert the v5 commit that introduced the bug"
      exit 1
    fi

    exit 0
    ;;
esac
exit 1
