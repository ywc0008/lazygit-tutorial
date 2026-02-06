#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

# ── First commit ────────────────────────────────────────────────────────────
cat > README.md << 'EOF'
# Calculator

A simple calculator application.
EOF

git add -A
git commit -m "Initial commit"

# ── Second commit ───────────────────────────────────────────────────────────
cat > app.js << 'EOF'
function add(a, b) {
    return a + b;
}

function subtract(a, b) {
    return a - b;
}

module.exports = { add, subtract };
EOF

git add -A
git commit -m "Add basic math functions"

# ── Third commit ────────────────────────────────────────────────────────────
cat > utils.js << 'EOF'
function formatResult(operation, a, b, result) {
    return `${a} ${operation} ${b} = ${result}`;
}

module.exports = { formatResult };
EOF

git add -A
git commit -m "Add result formatting utility"
