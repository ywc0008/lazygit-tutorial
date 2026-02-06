#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # Check: branch "feature" exists
    if ! git rev-parse --verify feature >/dev/null 2>&1; then
        exit 1
    fi

    # Check: HEAD is on "feature"
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [ "$CURRENT_BRANCH" != "feature" ]; then
        exit 1
    fi

    exit 0
    ;;
  2)
    # Check: "feature" branch has at least 1 more commit than main
    EXTRA_COMMITS=$(git rev-list main..feature --count 2>/dev/null || echo "0")
    if [ "$EXTRA_COMMITS" -lt 1 ]; then
        exit 1
    fi

    exit 0
    ;;
esac
exit 1
