#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

# ── Base file ────────────────────────────────────────────────────────────────
cat > greeting.txt << 'CONTENT'
Hello, World!
Welcome to the project.
Have a great day.
CONTENT

git add -A
git commit -m "Initial: add greeting"

# ── Feature branch: modify same lines ────────────────────────────────────────
git checkout -b feature/friendly-greeting

cat > greeting.txt << 'CONTENT'
Hi there, Friend!
Welcome to our amazing project.
Have a wonderful day!
CONTENT

git add -A
git commit -m "feature: make greeting friendlier"

# ── Back to main: different modification to same lines (creates conflict) ────
git checkout main

cat > greeting.txt << 'CONTENT'
Hey, Developer!
Welcome to the dev project.
Happy coding today!
CONTENT

git add -A
git commit -m "main: update greeting for developers"
