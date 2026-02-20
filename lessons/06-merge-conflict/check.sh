#!/usr/bin/env bash
set -euo pipefail
STEP="${1:-1}"
PRACTICE_DIR="${2:-.}"
cd "$PRACTICE_DIR"

case "$STEP" in
  1)
    # Must be on main branch
    BRANCH=$(git branch --show-current 2>/dev/null || echo "")
    if [ "$BRANCH" != "main" ]; then
      echo "FAIL: Expected to be on 'main' branch, currently on '$BRANCH'"
      exit 1
    fi

    # feature/friendly-greeting must be an ancestor of HEAD (merged)
    if ! git merge-base --is-ancestor feature/friendly-greeting HEAD 2>/dev/null; then
      echo "FAIL: feature/friendly-greeting has not been merged into main"
      exit 1
    fi

    # No conflict markers in any tracked file
    if git grep -l '<<<<<<<' -- ':!*.sh' 2>/dev/null; then
      echo "FAIL: Conflict markers (<<<<<<) still present in files"
      exit 1
    fi
    if git grep -l '=======' -- ':!*.sh' 2>/dev/null; then
      echo "FAIL: Conflict markers (=======) still present in files"
      exit 1
    fi
    if git grep -l '>>>>>>>' -- ':!*.sh' 2>/dev/null; then
      echo "FAIL: Conflict markers (>>>>>>>) still present in files"
      exit 1
    fi

    # No MERGE_HEAD (merge is fully completed)
    if [ -f ".git/MERGE_HEAD" ]; then
      echo "FAIL: Merge is not completed (.git/MERGE_HEAD still exists)"
      exit 1
    fi

    # Working directory should be clean
    if [ -n "$(git status --porcelain)" ]; then
      echo "FAIL: Working directory is not clean after merge"
      exit 1
    fi

    exit 0
    ;;
  2)
    # Check: feature/friendly-greeting branch no longer exists
    if git branch --list "feature/friendly-greeting" | grep "feature/friendly-greeting" >/dev/null; then
      echo "FAIL: Branch 'feature/friendly-greeting' still exists — delete it with 'd' in Branches panel"
      exit 1
    fi

    exit 0
    ;;
esac
exit 1
