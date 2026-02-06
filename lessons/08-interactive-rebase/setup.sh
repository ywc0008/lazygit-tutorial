#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

# ── Create intentionally messy commit history ─────────────────────────────────

echo "# Project" > README.md
git add . && git commit -m "Initial commit"

echo "function featureA() { return 'A'; }" > feature.js
git add . && git commit -m "feat: add feature A"

# Oops typo fix (should be squashed into previous)
echo "function featureA() { return 'A fixed'; }" > feature.js
git add . && git commit -m "fix typo in feature A"

cat > feature.js << 'EOF'
function featureA() { return 'A fixed'; }
function featureAHelper() { return 'helper'; }
EOF
git add . && git commit -m "feat: complete feature A"

# Oops forgot to remove debug (should be squashed)
cat > feature.js << 'EOF'
function featureA() { return 'A fixed'; }
function featureAHelper() { return 'helper'; }
// cleaned up
EOF
git add . && git commit -m "remove debug code"

echo "function featureB() { return 'B'; }" > feature-b.js
git add . && git commit -m "feat: add feature B"
