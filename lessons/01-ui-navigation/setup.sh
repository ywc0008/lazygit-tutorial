#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

# ── First commit: project skeleton ──────────────────────────────────────────
cat > README.md << 'EOF'
# My Awesome Project

A sample project for learning lazygit.

## Getting Started
Run `node app.js` to start the application.
EOF

cat > app.js << 'EOF'
const utils = require('./utils');

function main() {
    console.log('Hello, lazygit!');
    utils.greet('World');
}

main();
EOF

cat > utils.js << 'EOF'
function greet(name) {
    console.log(`Hello, ${name}!`);
}

module.exports = { greet };
EOF

git add -A
git commit -m "Initial commit: project skeleton"

# ── Second commit: add config ───────────────────────────────────────────────
cat > config.json << 'EOF'
{
    "appName": "my-app",
    "version": "1.0.0",
    "port": 3000
}
EOF

git add -A
git commit -m "Add configuration file"

# ── Third commit: update README ─────────────────────────────────────────────
cat >> README.md << 'EOF'

## Configuration
See `config.json` for app settings.
EOF

git add -A
git commit -m "Update README with config section"

# ── Create a feature branch with a commit ───────────────────────────────────
git checkout -b feature/add-logging

cat > logger.js << 'EOF'
function log(level, message) {
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] [${level}] ${message}`);
}

module.exports = { log };
EOF

git add -A
git commit -m "Add logging utility"

git checkout main

# ── Leave some uncommitted changes (visible in Files panel) ─────────────────
cat >> app.js << 'EOF'

// TODO: add error handling
EOF

cat >> config.json << 'CONF'

CONF
# Overwrite config with a small change
cat > config.json << 'EOF'
{
    "appName": "my-app",
    "version": "1.1.0",
    "port": 3000,
    "debug": true
}
EOF

echo "body { margin: 0; }" > style.css
