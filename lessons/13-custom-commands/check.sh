#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    if git tag -l "v1.0" | grep -q "v1.0"; then
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
esac
exit 1
