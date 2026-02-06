#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

# ── Initial commit on main ────────────────────────────────────────────────────

echo "# Main Project" > README.md
git add . && git commit -m "Initial commit"

# ── Feature branch with 3 commits ─────────────────────────────────────────────
# User should cherry-pick only the "utils" one to main

git checkout -b feature/mixed-work

echo "experimental code" > experiment.js
git add . && git commit -m "experiment: try new approach"

echo "function utils() { return 'useful'; }" > utils.js
git add . && git commit -m "feat: add utility functions"

echo "more experimental" >> experiment.js
git add . && git commit -m "experiment: continue testing"

# ── Back to main ──────────────────────────────────────────────────────────────

git checkout main
