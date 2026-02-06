#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # Check 1: latest commit message contains "user" (case-insensitive)
    COMMIT_MSG=$(git log -1 --pretty=%B)
    if ! echo "$COMMIT_MSG" | grep -qi "user"; then
        echo "Latest commit message should contain 'user'."
        exit 1
    fi

    # Check 2: committed version contains "Getting user"
    if ! git show HEAD:app.js | grep -q "Getting user"; then
        echo "The committed app.js should contain 'Getting user'."
        exit 1
    fi

    # Check 3: committed version does NOT contain "Getting product"
    if git show HEAD:app.js | grep -q "Getting product"; then
        echo "The committed app.js should NOT contain 'Getting product' — only user-related changes should be staged."
        exit 1
    fi

    # Check 4: unstaged changes still contain "Getting product"
    if ! git diff -- app.js | grep -q "Getting product"; then
        echo "Unstaged changes should still contain 'Getting product'."
        exit 1
    fi

    exit 0
    ;;
esac
exit 1
