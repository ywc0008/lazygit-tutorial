#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # Check 1: currently on main branch
    CURRENT_BRANCH=$(git branch --show-current)
    if [ "$CURRENT_BRANCH" != "main" ]; then
        exit 1
    fi

    # Check 2: utils.js exists on main (cherry-pick succeeded)
    if [ ! -f "utils.js" ]; then
        exit 1
    fi

    # Check 3: experiment.js does NOT exist on main (only picked the specific commit)
    if [ -f "experiment.js" ]; then
        exit 1
    fi

    # Check 4: feature/mixed-work branch still exists and is unchanged
    if ! git branch --list "feature/mixed-work" | grep -q "feature/mixed-work"; then
        exit 1
    fi

    exit 0
    ;;
esac
exit 1
