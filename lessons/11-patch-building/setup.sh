#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

cat > app.js << 'CONTENT'
// ── Section A: User Management ──
function getUser(id) {
    return database.find(id);
}

function deleteUser(id) {
    return database.remove(id);
}

// ── Section B: Product Management ──
function getProduct(id) {
    return products.find(id);
}

function deleteProduct(id) {
    return products.remove(id);
}
CONTENT

git add . && git commit -m "Initial commit: app with two sections"

cat > app.js << 'CONTENT'
// ── Section A: User Management ──
function getUser(id) {
    console.log("Getting user:", id);
    return database.find(id);
}

function deleteUser(id) {
    console.log("Deleting user:", id);
    return database.remove(id);
}

// ── Section B: Product Management ──
function getProduct(id) {
    console.log("Getting product:", id);
    return products.find(id);
}

function deleteProduct(id) {
    console.log("Deleting product:", id);
    return products.remove(id);
}
CONTENT
