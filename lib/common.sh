#!/usr/bin/env bash
# common.sh - Common utilities for the lazygit tutorial
# Sources all library files and provides shared helpers.

# Determine library directory (where this script lives)
_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source dependencies
# shellcheck source=lib/colors.sh
source "${_LIB_DIR}/colors.sh"
# shellcheck source=lib/i18n.sh
source "${_LIB_DIR}/i18n.sh"
# shellcheck source=lib/progress.sh
source "${_LIB_DIR}/progress.sh"

# ── Constants ────────────────────────────────────────────────────────────────

PRACTICE_DIR="/tmp/lazygit-tutorial"

# ── Prerequisites Check ─────────────────────────────────────────────────────
# Check that git, lazygit, and python3+PyYAML are installed.
# Exit 1 if git or lazygit missing. Warn if python3/PyYAML missing.

check_prerequisites() {
    local has_error=0

    # Check git
    if command -v git >/dev/null 2>&1; then
        local git_ver
        git_ver="$(git --version 2>/dev/null)"
        printf "  git:     %s\n" "$git_ver"
    else
        print_error "$(msg prereq_missing_git)"
        has_error=1
    fi

    # Check lazygit
    if command -v lazygit >/dev/null 2>&1; then
        local lg_ver
        lg_ver="$(lazygit --version 2>/dev/null | head -1)"
        printf "  lazygit: %s\n" "$lg_ver"
    else
        print_error "$(msg prereq_missing_lazygit)"
        printf "\n"
        print_info "$(msg install_guide_mac)"
        print_info "$(msg install_guide_linux)"
        print_info "$(msg install_guide_windows)"
        has_error=1
    fi

    # Check python3 + PyYAML
    if command -v python3 >/dev/null 2>&1 && python3 -c "import yaml" 2>/dev/null; then
        local py_ver
        py_ver="$(python3 --version 2>/dev/null)"
        printf "  python:  %s (PyYAML OK)\n" "$py_ver"
    else
        print_warning "$(msg prereq_missing_python)"
        printf "  pip3 install pyyaml\n"
    fi

    if [ "$has_error" -ne 0 ]; then
        printf "\n"
        exit 1
    fi
}

# ── Lesson YAML Helpers ──────────────────────────────────────────────────────

# Return path to the localized lesson YAML, falling back to English.
# Usage: get_lesson_yaml /path/to/lesson_dir
get_lesson_yaml() {
    local lesson_dir="$1"
    local localized="${lesson_dir}/lesson.${LANG_CODE}.yaml"
    local fallback="${lesson_dir}/lesson.en.yaml"

    if [ -f "$localized" ]; then
        printf '%s' "$localized"
    elif [ -f "$fallback" ]; then
        printf '%s' "$fallback"
    else
        # Last resort: try any lesson.*.yaml
        local any
        any="$(ls "${lesson_dir}"/lesson.*.yaml 2>/dev/null | head -1)"
        if [ -n "$any" ]; then
            printf '%s' "$any"
        else
            printf ''
        fi
    fi
}

# List all lesson directories sorted by name.
# Usage: get_lesson_dirs
get_lesson_dirs() {
    local lessons_dir="${SCRIPT_DIR}/lessons"
    if [ -d "$lessons_dir" ]; then
        ls -d "${lessons_dir}"/*/ 2>/dev/null | sort
    fi
}

# Count total number of lessons.
count_lessons() {
    local count=0
    local dir
    while IFS= read -r dir; do
        if [ -n "$dir" ]; then
            count=$((count + 1))
        fi
    done <<EOF
$(get_lesson_dirs)
EOF
    printf '%s' "$count"
}

# Parse a top-level field from lesson YAML.
# Usage: parse_yaml title /path/to/lesson.yaml
parse_yaml() {
    local field="$1"
    local yaml_file="$2"
    python3 "${SCRIPT_DIR}/lib/yaml_parser.py" "$yaml_file" "$field"
}

# Parse a step-related field from lesson YAML.
# Usage: parse_yaml_step step_instruction 1 /path/to/lesson.yaml
parse_yaml_step() {
    local command="$1"
    local step_num="$2"
    local yaml_file="$3"
    python3 "${SCRIPT_DIR}/lib/yaml_parser.py" "$yaml_file" "$command" "$step_num"
}
