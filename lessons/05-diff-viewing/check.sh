#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # At least 2 commits
    COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo 0)
    if [ "$COMMIT_COUNT" -lt 2 ]; then
      echo "FAIL: Expected at least 2 commits, found $COMMIT_COUNT"
      exit 1
    fi

    # Second commit message contains "partial" (case-insensitive)
    SECOND_MSG=$(git log --format='%s' -1 HEAD)
    if ! echo "$SECOND_MSG" | grep -iq "partial"; then
      echo "FAIL: Latest commit message must contain 'partial', got: $SECOND_MSG"
      exit 1
    fi

    # config.json is still modified (not yet committed)
    if ! git status --porcelain | grep -q "config.json"; then
      echo "FAIL: config.json should still have uncommitted changes"
      exit 1
    fi

    exit 0
    ;;
  2)
    # Working directory is clean
    if [ -n "$(git status --porcelain)" ]; then
      echo "FAIL: Working directory should be clean"
      exit 1
    fi

    # At least 3 commits total
    COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo 0)
    if [ "$COMMIT_COUNT" -lt 3 ]; then
      echo "FAIL: Expected at least 3 commits, found $COMMIT_COUNT"
      exit 1
    fi

    exit 0
    ;;
esac
exit 1
