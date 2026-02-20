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
    if ! git branch --list "feature/mixed-work" | grep "feature/mixed-work" >/dev/null; then
        exit 1
    fi

    exit 0
    ;;
  2)
    # Check 1: utils.js should NOT exist (reverted)
    if [ -f "utils.js" ]; then
        echo "FAIL: utils.js still exists — revert the cherry-picked commit"
        exit 1
    fi

    # Check 2: a revert commit should exist
    if ! git log --oneline | grep -i "revert" >/dev/null; then
        echo "FAIL: No revert commit found — use 't' in Commits panel to revert"
        exit 1
    fi

    exit 0
    ;;
esac
exit 1
