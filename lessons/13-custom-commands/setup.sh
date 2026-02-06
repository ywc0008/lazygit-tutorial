#!/usr/bin/env bash
set -euo pipefail
PRACTICE_DIR="${1:-.}"
cd "$PRACTICE_DIR"

git init
git config user.name "Tutorial User"
git config user.email "tutorial@lazygit.dev"

echo "# Project" > README.md
git add . && git commit -m "Initial commit"

echo "feature code" > feature.js
git add . && git commit -m "feat: add feature"

echo "more code" > utils.js
git add . && git commit -m "feat: add utils"

# Create lazygit config directory with template
mkdir -p "${PRACTICE_DIR}/.config/lazygit"

cat > "${PRACTICE_DIR}/.config/lazygit/config.yml" << 'CONFIG'
# lazygit Custom Commands Configuration
#
# Your task: Add a custom command that creates a git tag.
#
# Uncomment and complete the section below:
#
# customCommands:
#   - key: "T"
#     command: "git tag -a {{.Form.TagName}} -m 'Tagged via lazygit custom command'"
#     context: "commits"
#     prompts:
#       - type: "input"
#         title: "Tag Name"
#         key: "TagName"
CONFIG
