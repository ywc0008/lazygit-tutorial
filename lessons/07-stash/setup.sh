#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

# ── Initial commit ───────────────────────────────────────────────────────────
cat > README.md << 'EOF'
# My Project

A sample project for learning git stash with lazygit.
EOF

cat > app.js << 'EOF'
function main() {
    console.log('Application started');
    initialize();
}

function initialize() {
    console.log('Initializing...');
}

module.exports = { main, initialize };
EOF

git add -A
git commit -m "Initial commit: README and app"

# ── Create release branch with a commit ──────────────────────────────────────
git checkout -b release

cat > CHANGELOG.md << 'EOF'
# Changelog

## v1.0.0
- Initial release
EOF

git add -A
git commit -m "release: add changelog"

# ── Switch back to main ──────────────────────────────────────────────────────
git checkout main

# ── Make uncommitted changes (user needs to stash these) ─────────────────────
cat > app.js << 'EOF'
function main() {
    console.log('Application started');
    initialize();
    runHealthCheck();
}

function initialize() {
    console.log('Initializing...');
}

function runHealthCheck() {
    console.log('Health check: OK');
    return true;
}

module.exports = { main, initialize, runHealthCheck };
EOF

cat > temp-notes.txt << 'EOF'
TODO: Remember to add error handling
TODO: Set up CI/CD pipeline
TODO: Write unit tests for runHealthCheck
EOF
