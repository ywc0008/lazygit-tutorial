#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # Check 1: latest commit message contains "user" (case-insensitive)
    COMMIT_MSG=$(git log -1 --pretty=%B)
    if ! echo "$COMMIT_MSG" | grep -i "user" >/dev/null; then
        echo "Latest commit message should contain 'user'."
        exit 1
    fi

    # Check 2: committed version contains "Getting user"
    if ! git show HEAD:app.js | grep "Getting user" >/dev/null; then
        echo "The committed app.js should contain 'Getting user'."
        exit 1
    fi

    # Check 3: committed version does NOT contain "Getting product"
    if git show HEAD:app.js | grep "Getting product" >/dev/null; then
        echo "The committed app.js should NOT contain 'Getting product' — only user-related changes should be staged."
        exit 1
    fi

    # Check 4: unstaged changes still contain "Getting product"
    if ! git diff -- app.js | grep "Getting product" >/dev/null; then
        echo "Unstaged changes should still contain 'Getting product'."
        exit 1
    fi

    exit 0
    ;;
  2)
    # Check 1: working directory is clean
    if [ -n "$(git status --porcelain)" ]; then
        echo "FAIL: Working directory is not clean — commit the remaining changes"
        exit 1
    fi

    # Check 2: latest commit message contains "product" (case-insensitive)
    COMMIT_MSG=$(git log -1 --pretty=%B)
    if ! echo "$COMMIT_MSG" | grep -i "product" >/dev/null; then
        echo "FAIL: Latest commit message should contain 'product'"
        exit 1
    fi

    # Check 3: committed version now contains "Getting product"
    if ! git show HEAD:app.js | grep "Getting product" >/dev/null; then
        echo "FAIL: The committed app.js should contain 'Getting product'"
        exit 1
    fi

    exit 0
    ;;
esac
exit 1
