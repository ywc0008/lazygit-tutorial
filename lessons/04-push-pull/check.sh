#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # Check: colleague.js exists in working directory (pull succeeded)
    if [ ! -f "colleague.js" ]; then
        exit 1
    fi
    exit 0
    ;;
  2)
    # Check: bare repo has all commits (both local and colleague)
    REMOTE_DIR="${PRACTICE_DIR}/.fake-remote"
    if [ ! -d "$REMOTE_DIR" ]; then
        exit 1
    fi

    # Check that the remote has the local "my feature" commit
    REMOTE_LOG=$(cd "$REMOTE_DIR" && git log --oneline --all)
    if ! printf '%s' "$REMOTE_LOG" | grep -q "my feature"; then
        exit 1
    fi
    if ! printf '%s' "$REMOTE_LOG" | grep -q "colleague"; then
        exit 1
    fi

    exit 0
    ;;
esac
exit 1
