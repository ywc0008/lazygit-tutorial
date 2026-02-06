#!/usr/bin/env bash
set -euo pipefail

# ── Script Directory Detection ───────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPT_DIR

# ── Parse --lang flag FIRST (before sourcing libs that use LANG_CODE) ────────
REMAINING_ARGS=()
while [ $# -gt 0 ]; do
    case "$1" in
        --lang)
            if [ $# -lt 2 ]; then
                printf "Error: --lang requires a language code (e.g., en, ko)\n" >&2
                exit 1
            fi
            LANG_CODE="$2"
            shift 2
            ;;
        *)
            REMAINING_ARGS+=("$1")
            shift
            ;;
    esac
done
set -- "${REMAINING_ARGS[@]+"${REMAINING_ARGS[@]}"}"

# ── Source Libraries ─────────────────────────────────────────────────────────
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

# Detect language from env if --lang was not provided
if [ "$LANG_CODE" = "en" ]; then
    detect_language
fi

# ── Cleanup Trap ─────────────────────────────────────────────────────────────
cleanup() {
    printf "\n"
}
trap cleanup EXIT

# ── Difficulty Badge ─────────────────────────────────────────────────────────
difficulty_badge() {
    local level="$1"
    case "$level" in
        beginner)     printf "${GREEN}%s${RESET}" "$(msg difficulty_beginner)" ;;
        intermediate) printf "${YELLOW}%s${RESET}" "$(msg difficulty_intermediate)" ;;
        advanced)     printf "${RED}%s${RESET}" "$(msg difficulty_advanced)" ;;
        *)            printf "%s" "$level" ;;
    esac
}

# ── Show Lesson List ─────────────────────────────────────────────────────────
show_lesson_list() {
    print_header "$(msg welcome_title)"
    printf "\n"

    # Show prerequisites
    check_prerequisites
    printf "\n"
    print_separator

    local index=0
    local dir
    while IFS= read -r dir; do
        if [ -z "$dir" ]; then
            continue
        fi
        index=$((index + 1))

        local yaml_file
        yaml_file="$(get_lesson_yaml "$dir")"
        if [ -z "$yaml_file" ]; then
            continue
        fi

        local title difficulty lesson_name
        title="$(parse_yaml title "$yaml_file")"
        difficulty="$(parse_yaml difficulty "$yaml_file")"
        lesson_name="$(basename "$dir")"

        # Completion marker
        local marker="  "
        if is_completed "$lesson_name"; then
            marker="$(success_icon) "
        fi

        # Print lesson line
        printf "  %s %s%2d. %s " "$marker" "${BOLD}" "$index" "${RESET}"
        printf "%s " "$title"
        difficulty_badge "$difficulty"
        printf "\n"
    done <<EOF
$(get_lesson_dirs)
EOF

    printf "\n"
    print_separator
    local completed total
    completed="$(count_completed)"
    total="$(count_lessons)"
    printf "  %s: %s/%s\n\n" "$(msg progress_label)" "$completed" "$total"
}

# ── Get Lesson Dir by Index ──────────────────────────────────────────────────
get_lesson_dir_by_index() {
    local target_index="$1"
    local index=0
    local dir
    while IFS= read -r dir; do
        if [ -z "$dir" ]; then
            continue
        fi
        index=$((index + 1))
        if [ "$index" -eq "$target_index" ]; then
            printf '%s' "$dir"
            return 0
        fi
    done <<EOF
$(get_lesson_dirs)
EOF
    return 1
}

# ── Run Lesson ───────────────────────────────────────────────────────────────
run_lesson() {
    local lesson_num="$1"

    # Resolve lesson directory
    local lesson_dir
    lesson_dir="$(get_lesson_dir_by_index "$lesson_num")"
    if [ -z "$lesson_dir" ]; then
        print_error "Invalid lesson number: $lesson_num"
        exit 1
    fi

    local lesson_name
    lesson_name="$(basename "$lesson_dir")"

    # Resolve YAML
    local yaml_file
    yaml_file="$(get_lesson_yaml "$lesson_dir")"
    if [ -z "$yaml_file" ]; then
        print_error "No lesson YAML found in $lesson_dir"
        exit 1
    fi

    local title step_count
    title="$(parse_yaml title "$yaml_file")"
    step_count="$(parse_yaml step_count "$yaml_file")"

    print_header "$title"
    printf "\n"

    # Prepare practice directory
    local practice="${PRACTICE_DIR}/${lesson_name}"
    printf "  %s\n" "$(msg scenario_preparing)"

    # Clean and recreate practice dir
    rm -rf "$practice"
    mkdir -p "$practice"

    # Run setup script if it exists
    if [ -f "${lesson_dir}/setup.sh" ]; then
        (cd "$practice" && bash "${lesson_dir}/setup.sh" "$practice")
    fi

    printf "  %s\n" "$(msg scenario_ready)"
    printf "  %s: %s\n\n" "$(msg path_label)" "$practice"
    print_separator

    # ── Step Loop ────────────────────────────────────────────────────────
    local current_step=1
    while [ "$current_step" -le "$step_count" ]; do
        printf "\n"
        printf "  ${BOLD}${CYAN}[$(msg step_label) %d/%d]${RESET}\n\n" "$current_step" "$step_count"

        # Show instruction
        local instruction
        instruction="$(parse_yaml_step step_instruction "$current_step" "$yaml_file")"
        printf "%s\n\n" "$instruction"

        # Prompt for action
        printf "  %s " "$(msg enter_prompt)"
        local action
        read -r action

        case "$action" in
            s|S)
                # Skip this step
                printf "  %s\n" "$(msg next_step)"
                current_step=$((current_step + 1))
                continue
                ;;
            q|Q)
                # Quit lesson
                return
                ;;
            *)
                # Open lazygit in practice directory
                (cd "$practice" && lazygit)

                # Verify step
                printf "\n  %s\n" "$(msg verifying)"

                local check_result=1
                if [ -f "${lesson_dir}/check.sh" ]; then
                    if (cd "$practice" && bash "${lesson_dir}/check.sh" "$current_step" "$practice"); then
                        check_result=0
                    fi
                fi

                if [ "$check_result" -eq 0 ]; then
                    # Step passed
                    printf "  %s\n" "$(msg pass)"
                    current_step=$((current_step + 1))

                    if [ "$current_step" -le "$step_count" ]; then
                        printf "  %s\n" "$(msg next_step)"
                    fi
                else
                    # Step failed -- show retry menu
                    printf "  %s\n\n" "$(msg fail)"
                    _show_retry_menu "$lesson_dir" "$lesson_name" "$practice" "$yaml_file" "$current_step"
                    local retry_result=$?
                    case $retry_result in
                        0) continue ;;              # retry or reset: re-show same step
                        2) current_step=$((current_step + 1)); continue ;;  # skip
                        3) return ;;                # quit
                    esac
                fi
                ;;
        esac
    done

    # All steps complete
    printf "\n"
    print_separator
    printf "\n  🎉 %s\n\n" "$(msg lesson_complete)"
    save_progress "$lesson_name"
}

# ── Retry Menu (after failed check) ─────────────────────────────────────────
# Returns: 0=retry, 2=skip, 3=quit
_show_retry_menu() {
    local lesson_dir="$1"
    local lesson_name="$2"
    local practice="$3"
    local yaml_file="$4"
    local current_step="$5"

    while true; do
        printf "  ${BOLD}r${RESET}) %s\n" "$(msg retry_option)"
        printf "  ${BOLD}h${RESET}) %s\n" "$(msg hint_option)"
        printf "  ${BOLD}R${RESET}) %s\n" "$(msg reset_option)"
        printf "  ${BOLD}s${RESET}) %s\n" "$(msg skip_option)"
        printf "  ${BOLD}q${RESET}) %s\n" "$(msg quit_option)"
        printf "\n  > "

        local choice
        read -r choice

        case "$choice" in
            r)
                # Retry: go back to prompt for this step
                return 0
                ;;
            h)
                # Show hints
                printf "\n"
                parse_yaml_step step_hints "$current_step" "$yaml_file"
                printf "\n"
                # Loop back to show menu again
                ;;
            R)
                # Reset scenario
                rm -rf "$practice"
                mkdir -p "$practice"
                if [ -f "${lesson_dir}/setup.sh" ]; then
                    (cd "$practice" && bash "${lesson_dir}/setup.sh" "$practice")
                fi
                printf "\n  %s\n\n" "$(msg scenario_reset)"
                return 0
                ;;
            s)
                # Skip step
                printf "  %s\n" "$(msg next_step)"
                return 2
                ;;
            q)
                return 3
                ;;
            *)
                # Unknown input, show menu again
                ;;
        esac
    done
}

# ── Reset All ────────────────────────────────────────────────────────────────
do_reset() {
    reset_progress
    rm -rf "$PRACTICE_DIR"
    print_success "$(msg all_reset)"
}

# ── Usage Help ───────────────────────────────────────────────────────────────
show_help() {
    printf "Usage: %s [command] [options]\n\n" "$(basename "$0")"
    printf "Commands:\n"
    printf "  list              Show available lessons (default)\n"
    printf "  start <n>         Start lesson number N\n"
    printf "  s <n>             Shorthand for start\n"
    printf "  reset             Reset all progress and practice data\n"
    printf "  help              Show this help message\n"
    printf "\nOptions:\n"
    printf "  --lang <code>     Set language (en, ko)\n"
    printf "\nExamples:\n"
    printf "  %s                    # Show lesson list\n" "$(basename "$0")"
    printf "  %s start 1            # Start lesson 1\n" "$(basename "$0")"
    printf "  %s --lang ko list     # Show lessons in Korean\n" "$(basename "$0")"
    printf "  %s --lang ko s 3      # Start lesson 3 in Korean\n" "$(basename "$0")"
}

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
    local command="${1:-list}"

    case "$command" in
        list|ls)
            show_lesson_list

            # Prompt for lesson selection
            printf "  %s " "$(msg select_lesson)"
            local selection
            read -r selection

            case "$selection" in
                q|Q) exit 0 ;;
                ''|*[!0-9]*)
                    print_error "Invalid selection"
                    exit 1
                    ;;
                *)
                    run_lesson "$selection"
                    ;;
            esac
            ;;
        start|s)
            if [ -z "${2:-}" ]; then
                print_error "Usage: $(basename "$0") start <lesson_number>"
                exit 1
            fi
            run_lesson "$2"
            ;;
        reset)
            do_reset
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
