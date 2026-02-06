#!/usr/bin/env bash
# i18n.sh - Internationalization support
# Compatible with bash 3.2+ (no associative arrays)

# Global language code, default to English (preserves --lang flag if already set)
LANG_CODE="${LANG_CODE:-en}"

# ── Language Detection ───────────────────────────────────────────────────────

detect_language() {
    # --lang flag is handled externally and sets LANG_CODE before this is called.
    # Here we auto-detect from environment if LANG_CODE is still default.
    if [ "$LANG_CODE" = "en" ]; then
        local env_lang=""
        # Check environment variables in priority order
        if [ -n "${LC_ALL:-}" ]; then
            env_lang="$LC_ALL"
        elif [ -n "${LANGUAGE:-}" ]; then
            env_lang="$LANGUAGE"
        elif [ -n "${LANG:-}" ]; then
            env_lang="$LANG"
        fi

        # Extract two-letter language code (e.g., "ko_KR.UTF-8" -> "ko")
        if [ -n "$env_lang" ]; then
            local code
            code="$(printf '%s' "$env_lang" | sed 's/[_.\-].*//' | tr '[:upper:]' '[:lower:]')"
            case "$code" in
                ko) LANG_CODE="ko" ;;
                en) LANG_CODE="en" ;;
                # Add more languages here as translations are added
                *)  LANG_CODE="en" ;;
            esac
        fi
    fi
}

# ── Message Lookup ───────────────────────────────────────────────────────────
# Uses case statements for bash 3.2 compatibility (no associative arrays).

msg() {
    local key="$1"

    case "$LANG_CODE" in
        ko) _msg_ko "$key" ;;
        *)  _msg_en "$key" ;;
    esac
}

_msg_ko() {
    local key="$1"
    case "$key" in
        welcome_title)           printf '%s' "🎓 lazygit 인터랙티브 튜토리얼" ;;
        enter_prompt)            printf '%s' "lazygit을 열려면 Enter, 건너뛰려면 s, 나가려면 q:" ;;
        verifying)               printf '%s' "검증 중..." ;;
        pass)                    printf '%s' "✅ 정답입니다! 잘 하셨어요!" ;;
        fail)                    printf '%s' "❌ 아직 완료되지 않았습니다" ;;
        retry_option)            printf '%s' "다시 시도 (lazygit 재실행)" ;;
        hint_option)             printf '%s' "힌트 보기" ;;
        reset_option)            printf '%s' "처음부터 다시 (시나리오 초기화)" ;;
        skip_option)             printf '%s' "이 스텝 건너뛰기" ;;
        quit_option)             printf '%s' "레슨 종료" ;;
        lesson_complete)         printf '%s' "레슨 완료!" ;;
        scenario_preparing)      printf '%s' "시나리오를 준비하는 중..." ;;
        scenario_ready)          printf '%s' "시나리오 준비 완료" ;;
        scenario_reset)          printf '%s' "시나리오를 초기화했습니다" ;;
        path_label)              printf '%s' "경로" ;;
        progress_label)          printf '%s' "완료" ;;
        select_lesson)           printf '%s' "레슨 번호를 입력하세요 (q로 종료):" ;;
        next_step)               printf '%s' "다음 스텝으로 넘어갑니다..." ;;
        all_reset)               printf '%s' "모든 진행 상태와 연습 데이터를 초기화했습니다" ;;
        prereq_ok)               printf '%s' "" ;;
        prereq_missing_git)      printf '%s' "git이 설치되어 있지 않습니다" ;;
        prereq_missing_lazygit)  printf '%s' "lazygit이 설치되어 있지 않습니다" ;;
        prereq_missing_python)   printf '%s' "python3 또는 PyYAML이 설치되어 있지 않습니다" ;;
        install_guide_mac)       printf '%s' "macOS:   brew install lazygit" ;;
        install_guide_linux)     printf '%s' "Linux:   https://github.com/jesseduffield/lazygit#installation" ;;
        install_guide_windows)   printf '%s' "Windows: scoop install lazygit" ;;
        difficulty_beginner)     printf '%s' "[초급]" ;;
        difficulty_intermediate) printf '%s' "[중급]" ;;
        difficulty_advanced)     printf '%s' "[고급]" ;;
        step_label)              printf '%s' "스텝" ;;
        lesson_prefix)           printf '%s' "레슨" ;;
        *) printf '%s' "$key" ;;
    esac
}

_msg_en() {
    local key="$1"
    case "$key" in
        welcome_title)           printf '%s' "🎓 lazygit Interactive Tutorial" ;;
        enter_prompt)            printf '%s' "Press Enter to open lazygit, s to skip, q to quit:" ;;
        verifying)               printf '%s' "Verifying..." ;;
        pass)                    printf '%s' "✅ Correct! Well done!" ;;
        fail)                    printf '%s' "❌ Not completed yet" ;;
        retry_option)            printf '%s' "Retry (reopen lazygit)" ;;
        hint_option)             printf '%s' "Show hint" ;;
        reset_option)            printf '%s' "Start over (reset scenario)" ;;
        skip_option)             printf '%s' "Skip this step" ;;
        quit_option)             printf '%s' "Quit lesson" ;;
        lesson_complete)         printf '%s' "Lesson complete!" ;;
        scenario_preparing)      printf '%s' "Preparing scenario..." ;;
        scenario_ready)          printf '%s' "Scenario ready" ;;
        scenario_reset)          printf '%s' "Scenario has been reset" ;;
        path_label)              printf '%s' "Path" ;;
        progress_label)          printf '%s' "Completed" ;;
        select_lesson)           printf '%s' "Enter lesson number (q to quit):" ;;
        next_step)               printf '%s' "Moving to next step..." ;;
        all_reset)               printf '%s' "All progress and practice data has been reset" ;;
        prereq_ok)               printf '%s' "" ;;
        prereq_missing_git)      printf '%s' "git is not installed" ;;
        prereq_missing_lazygit)  printf '%s' "lazygit is not installed" ;;
        prereq_missing_python)   printf '%s' "python3 or PyYAML is not installed" ;;
        install_guide_mac)       printf '%s' "macOS:   brew install lazygit" ;;
        install_guide_linux)     printf '%s' "Linux:   https://github.com/jesseduffield/lazygit#installation" ;;
        install_guide_windows)   printf '%s' "Windows: scoop install lazygit" ;;
        difficulty_beginner)     printf '%s' "[Beginner]" ;;
        difficulty_intermediate) printf '%s' "[Intermediate]" ;;
        difficulty_advanced)     printf '%s' "[Advanced]" ;;
        step_label)              printf '%s' "Step" ;;
        lesson_prefix)           printf '%s' "Lesson" ;;
        *) printf '%s' "$key" ;;
    esac
}
