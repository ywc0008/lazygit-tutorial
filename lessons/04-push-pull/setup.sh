#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

# ── Create bare repo as simulated "remote" ──────────────────────────────────
REMOTE_DIR="${PRACTICE_DIR}/.fake-remote"
mkdir -p "$REMOTE_DIR"
cd "$REMOTE_DIR"
git init --bare

# ── Create working repo ────────────────────────────────────────────────────
cd "$PRACTICE_DIR"
git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"
git config pull.rebase false
git remote add origin "$REMOTE_DIR"

# Ignore the fake-remote directory
echo ".fake-remote/" > .gitignore

# Initial commit + push to remote
cat > README.md << 'EOF'
# Team Project

A collaborative project for the team.
EOF

git add -A
git commit -m "Initial commit"
git push -u origin main

# ── Simulate a colleague pushing changes ────────────────────────────────────
TEMP_DIR=$(mktemp -d)
git clone "$REMOTE_DIR" "$TEMP_DIR/colleague"
cd "$TEMP_DIR/colleague"
git config user.name "Colleague"
git config user.email "colleague@company.com"

cat > colleague.js << 'EOF'
function colleagueFeature() {
    console.log('This feature was added by your colleague');
    return true;
}

module.exports = { colleagueFeature };
EOF

git add -A
git commit -m "feat: colleague added feature"
git push origin main

# ── Back to working directory - add a local change ──────────────────────────
cd "$PRACTICE_DIR"

cat > myfile.js << 'EOF'
function myFeature() {
    console.log('This is my local feature');
    return true;
}

module.exports = { myFeature };
EOF

git add -A
git commit -m "feat: my feature"

# ── Cleanup temp directory ──────────────────────────────────────────────────
rm -rf "$TEMP_DIR"
