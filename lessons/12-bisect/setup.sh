#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

echo "version 1" > app.js
git add . && git commit -m "v1: initial release"

echo "version 2 - add login" >> app.js
git add . && git commit -m "v2: add login feature"

echo "version 3 - add dashboard" >> app.js
git add . && git commit -m "v3: add dashboard"

echo "version 4 - add settings" >> app.js
git add . && git commit -m "v4: add settings page"

# THIS commit introduces the bug in a separate file (does NOT touch app.js)
echo "BUG_INTRODUCED" > config.js
git add . && git commit -m "v5: add notifications"

echo "version 6 - add themes" >> app.js
git add . && git commit -m "v6: add themes"

echo "version 7 - add export" >> app.js
git add . && git commit -m "v7: add export feature"

echo "version 8 - latest" >> app.js
git add . && git commit -m "v8: latest release"
