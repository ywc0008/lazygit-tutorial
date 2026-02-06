#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

# ── Initial commit: app.js with two functions, config.json, README.md ────────
cat > app.js << 'EOF'
// ── Authentication ──────────────────────────────────────────────────────────

function login(username, password) {
    console.log(`Logging in user: ${username}`);
    if (!username || !password) {
        return { success: false, error: 'Missing credentials' };
    }
    return { success: true, token: 'abc123' };
}

function logout(token) {
    console.log('Logging out...');
    return { success: true };
}

// ── Data Processing ─────────────────────────────────────────────────────────

function fetchData(url) {
    console.log(`Fetching data from: ${url}`);
    return { data: [], status: 200 };
}

function transformData(raw) {
    return raw.map(item => item.toUpperCase());
}

module.exports = { login, logout, fetchData, transformData };
EOF

cat > config.json << 'EOF'
{
    "appName": "my-app",
    "version": "1.0.0",
    "port": 3000,
    "logLevel": "info"
}
EOF

cat > README.md << 'EOF'
# My App

A sample application for the lazygit tutorial.
EOF

git add -A
git commit -m "Initial commit: app with auth and data modules"

# ── Now modify app.js in TWO separate locations (two distinct hunks) ─────────
cat > app.js << 'EOF'
// ── Authentication ──────────────────────────────────────────────────────────

function login(username, password) {
    console.log(`Logging in user: ${username}`);
    if (!username || !password) {
        return { success: false, error: 'Missing credentials' };
    }
    // Added: rate limiting check
    if (isRateLimited(username)) {
        return { success: false, error: 'Too many attempts' };
    }
    return { success: true, token: 'abc123' };
}

function logout(token) {
    console.log('Logging out...');
    invalidateSession(token);
    return { success: true };
}

// ── Data Processing ─────────────────────────────────────────────────────────

function fetchData(url, options = {}) {
    const timeout = options.timeout || 5000;
    console.log(`Fetching data from: ${url} (timeout: ${timeout}ms)`);
    return { data: [], status: 200 };
}

function transformData(raw) {
    if (!Array.isArray(raw)) {
        throw new Error('Input must be an array');
    }
    return raw.map(item => item.toUpperCase());
}

module.exports = { login, logout, fetchData, transformData };
EOF

# ── Also modify config.json ──────────────────────────────────────────────────
cat > config.json << 'EOF'
{
    "appName": "my-app",
    "version": "1.1.0",
    "port": 3000,
    "logLevel": "debug",
    "rateLimit": {
        "maxAttempts": 5,
        "windowMs": 60000
    }
}
EOF
