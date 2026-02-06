#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

# ── Initial commit ──────────────────────────────────────────────────────────
cat > README.md << 'EOF'
# Todo App

A simple todo application.
EOF

cat > app.js << 'EOF'
function createApp() {
    return {
        todos: [],
        addTodo(text) {
            this.todos.push({ text, done: false });
        }
    };
}

module.exports = { createApp };
EOF

cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Todo App</title>
</head>
<body>
    <h1>My Todos</h1>
    <div id="app"></div>
</body>
</html>
EOF

git add -A
git commit -m "Initial project setup"

# ── Make changes to be staged by the user ───────────────────────────────────

# Modify app.js - add a removeTodo function
cat > app.js << 'EOF'
function createApp() {
    return {
        todos: [],
        addTodo(text) {
            this.todos.push({ text, done: false });
        },
        removeTodo(index) {
            this.todos.splice(index, 1);
        },
        toggleTodo(index) {
            this.todos[index].done = !this.todos[index].done;
        }
    };
}

module.exports = { createApp };
EOF

# Modify index.html - add a footer
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Todo App</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>My Todos</h1>
    <div id="app"></div>
    <footer>
        <p>Built with lazygit tutorial</p>
    </footer>
</body>
</html>
EOF

# Create a new untracked file
cat > style.css << 'EOF'
body {
    font-family: Arial, sans-serif;
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
}

h1 {
    color: #333;
}

footer {
    margin-top: 40px;
    color: #999;
}
EOF
