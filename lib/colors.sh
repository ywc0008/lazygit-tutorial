#!/usr/bin/env bash
# colors.sh - Terminal colors and formatting utilities
# Uses printf for portability (NOT echo -e)

# ── Color Variables ──────────────────────────────────────────────────────────
# Use $'...' ANSI-C quoting so variables contain actual ESC bytes.
# This allows them to work both in printf format strings AND as %s arguments.
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
CYAN=$'\033[0;36m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
RESET=$'\033[0m'

# ── Color Functions ──────────────────────────────────────────────────────────
# Wrap text with color codes. Usage: red "some text"

red() {
    printf "${RED}%s${RESET}" "$*"
}

green() {
    printf "${GREEN}%s${RESET}" "$*"
}

yellow() {
    printf "${YELLOW}%s${RESET}" "$*"
}

cyan() {
    printf "${CYAN}%s${RESET}" "$*"
}

bold() {
    printf "${BOLD}%s${RESET}" "$*"
}

dim() {
    printf "${DIM}%s${RESET}" "$*"
}

# ── Icons ────────────────────────────────────────────────────────────────────

success_icon() {
    printf "✅"
}

error_icon() {
    printf "❌"
}

# ── Print Helpers ────────────────────────────────────────────────────────────

print_success() {
    printf "${GREEN}✅ %s${RESET}\n" "$*"
}

print_error() {
    printf "${RED}❌ %s${RESET}\n" "$*"
}

print_info() {
    printf "${CYAN}ℹ  %s${RESET}\n" "$*"
}

print_warning() {
    printf "${YELLOW}⚠  %s${RESET}\n" "$*"
}

# ── Box Drawing ──────────────────────────────────────────────────────────────

print_header() {
    local title="$1"
    # Calculate display width (CJK/emoji = 2 columns each)
    local len
    if command -v python3 >/dev/null 2>&1; then
        len=$(printf '%s' "$title" | python3 -c "
import sys, unicodedata
s = sys.stdin.read()
print(sum(2 if unicodedata.east_asian_width(c) in ('W','F') else 1 for c in s))")
    else
        len=${#title}
    fi
    local border_len=$((len + 4))
    local border=""
    local i=0
    while [ "$i" -lt "$border_len" ]; do
        border="${border}─"
        i=$((i + 1))
    done

    printf "${BOLD}${CYAN}"
    printf "┌%s┐\n" "$border"
    printf "│  %s  │\n" "$title"
    printf "└%s┘\n" "$border"
    printf "${RESET}"
}

print_separator() {
    printf "${DIM}────────────────────────────────────────────────────────${RESET}\n"
}
