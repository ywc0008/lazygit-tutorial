#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

# ── Create some history ───────────────────────────────────────────────────────

echo "# Main Project" > README.md
echo "main code" > main.js
git add . && git commit -m "Initial commit"

echo "more main code" >> main.js
git add . && git commit -m "feat: extend main code"

# ── Create a branch that user will make a worktree for ─────────────────────────

git branch hotfix/urgent-bug
