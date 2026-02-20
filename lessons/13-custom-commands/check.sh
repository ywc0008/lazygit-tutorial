#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    if git tag -l "v1.0" | grep "v1.0" >/dev/null; then
      exit 0
    fi

    TAG_COUNT=$(git tag -l | wc -l | tr -d ' ')
    if [ "$TAG_COUNT" -gt 0 ]; then
      echo "Found tags but 'v1.0' is missing. Create a tag named exactly 'v1.0'."
      exit 1
    fi

    echo "No tags found. Configure the custom command and use it to create tag 'v1.0'."
    exit 1
    ;;
  2)
    # Check 1: v1.0 tag exists
    if ! git tag -l "v1.0" | grep "v1.0" >/dev/null; then
      echo "FAIL: Tag 'v1.0' not found — complete step 1 first"
      exit 1
    fi

    # Check 2: v2.0 tag exists
    if ! git tag -l "v2.0" | grep "v2.0" >/dev/null; then
      echo "FAIL: Tag 'v2.0' not found — create a 'v2.0' tag using the custom command or git tag"
      exit 1
    fi

    exit 0
    ;;
esac
exit 1
