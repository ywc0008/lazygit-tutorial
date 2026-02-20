#!/usr/bin/env bash
# progress.sh - Progress tracking for completed lessons

# Progress file lives at the tutorial repo root
PROGRESS_FILE="${SCRIPT_DIR:-.}/.progress"

# ── Save Progress ────────────────────────────────────────────────────────────
# Append lesson name if not already recorded.
# Usage: save_progress "01-basic-staging"

save_progress() {
    local lesson_name="$1"
    if ! is_completed "$lesson_name"; then
        printf '%s\n' "$lesson_name" >> "$PROGRESS_FILE"
    fi
}

# ── Load Progress ────────────────────────────────────────────────────────────
# Print contents of progress file (empty string if none).

load_progress() {
    if [ -f "$PROGRESS_FILE" ]; then
        cat "$PROGRESS_FILE"
    else
        printf ''
    fi
}

# ── Check Completion ─────────────────────────────────────────────────────────
# Return 0 if lesson is completed, 1 if not.
# Usage: if is_completed "01-basic-staging"; then ...

is_completed() {
    local lesson_name="$1"
    if [ -f "$PROGRESS_FILE" ]; then
        # Use grep with fixed-string and whole-line matching
        grep -Fx "$lesson_name" "$PROGRESS_FILE" >/dev/null 2>&1
        return $?
    fi
    return 1
}

# ── Count Completed ──────────────────────────────────────────────────────────
# Print the number of completed lessons.

count_completed() {
    if [ -f "$PROGRESS_FILE" ]; then
        local count
        count="$(wc -l < "$PROGRESS_FILE" | tr -d ' ')"
        printf '%s' "$count"
    else
        printf '0'
    fi
}

# ── Reset Progress ───────────────────────────────────────────────────────────
# Remove the progress file entirely.

reset_progress() {
    if [ -f "$PROGRESS_FILE" ]; then
        rm -f "$PROGRESS_FILE"
    fi
}
