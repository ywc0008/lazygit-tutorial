#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # Check 1: working tree is clean (everything committed)
    if [ -n "$(git status --porcelain)" ]; then
        exit 1
    fi

    # Check 2: at least 2 commits exist (initial + user's)
    COMMIT_COUNT=$(git rev-list --count HEAD)
    if [ "$COMMIT_COUNT" -lt 2 ]; then
        exit 1
    fi

    # Check 3: latest commit message contains "first" (case-insensitive)
    LATEST_MSG=$(git log -1 --format='%s')
    if ! printf '%s' "$LATEST_MSG" | grep -iq "first"; then
        exit 1
    fi

    exit 0
    ;;
esac
exit 1
