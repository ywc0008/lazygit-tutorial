# lazygit 인터랙티브 튜토리얼 / lazygit Interactive Tutorial

**손으로 직접 배우는 lazygit | Learn lazygit through hands-on practice**

A shell-based interactive tutorial that teaches lazygit through practical exercises with automated verification. All practice happens locally in isolated environments — completely safe for learning.

쉘 기반 인터랙티브 튜토리얼로 lazygit을 실습하며 배웁니다. 모든 실습은 격리된 로컬 환경에서 진행되어 안전하게 학습할 수 있습니다.

---

## Quick Start

```bash
git clone https://github.com/your-username/lazygit-tutorial.git
cd lazygit-tutorial
./tutorial.sh
```

---

## Prerequisites / 사전 요구사항

**Required:**
- `git` (version 2.23+)
- `lazygit` ([installation guide](https://github.com/jesseduffield/lazygit#installation))
  - macOS: `brew install lazygit`
  - Linux: `brew install lazygit` or download binary from releases
- `python3` + PyYAML: `pip3 install pyyaml`

**필수:**
- `git` (2.23 이상)
- `lazygit` ([설치 가이드](https://github.com/jesseduffield/lazygit#installation))
  - macOS: `brew install lazygit`
  - Linux: `brew install lazygit` 또는 릴리스에서 바이너리 다운로드
- `python3` + PyYAML: `pip3 install pyyaml`

---

## Usage / 사용법

```bash
# Show lesson list and select interactively
# 레슨 목록 보고 선택하기
./tutorial.sh

# Start a specific lesson directly
# 특정 레슨 바로 시작하기
./tutorial.sh start <lesson-number>

# Force language (auto-detected by default)
# 언어 강제 설정 (기본값은 자동 감지)
./tutorial.sh --lang ko  # Korean / 한국어
./tutorial.sh --lang en  # English / 영어

# Reset all progress
# 진행 상황 초기화
./tutorial.sh reset
```

---

## Lessons / 레슨 목록

| # | Lesson | 레슨 | Difficulty |
|---|--------|------|-----------|
| 01 | UI Navigation | UI 패널 탐색하기 | Beginner |
| 02 | Staging & Commit | 파일 스테이징과 커밋 | Beginner |
| 03 | Branching | 브랜치 만들고 전환하기 | Beginner |
| 04 | Push & Pull | Push와 Pull | Beginner |
| 05 | Diff Viewing | Diff 확인하기 | Beginner |
| 06 | Merge Conflicts | 머지 충돌 해결하기 | Intermediate |
| 07 | Stash | Stash 사용하기 | Intermediate |
| 08 | Interactive Rebase | 인터랙티브 리베이스 | Intermediate |
| 09 | Cherry-pick | Cherry-pick | Intermediate |
| 10 | Worktree | Worktree | Advanced |
| 11 | Patch Building | 패치 빌딩 (부분 스테이징) | Advanced |
| 12 | Bisect | Bisect로 버그 찾기 | Advanced |
| 13 | Custom Commands | 커스텀 명령어 설정 | Advanced |

---

## How It Works / 작동 원리

### English

Each lesson follows a simple three-step workflow:

1. **Setup**: `setup.sh` creates an isolated Git scenario in `/tmp/lazygit-tutorial/`
2. **Practice**: You open lazygit and complete the task using what you've learned
3. **Verify**: `check.sh` automatically verifies your work and provides feedback

All practice happens in temporary directories — your real Git repositories are never touched. Progress is saved in `.progress` file in the project root, so you can resume anytime.

### 한국어

각 레슨은 간단한 3단계 워크플로우를 따릅니다:

1. **준비**: `setup.sh`가 `/tmp/lazygit-tutorial/`에 격리된 Git 시나리오 생성
2. **실습**: lazygit을 열고 배운 내용을 사용하여 작업 완료
3. **검증**: `check.sh`가 자동으로 작업을 확인하고 피드백 제공

모든 실습은 임시 디렉토리에서 진행되므로 실제 Git 저장소는 절대 건드리지 않습니다. 진행 상황은 프로젝트 루트의 `.progress` 파일에 저장되어 언제든지 재개할 수 있습니다.

---

## Language Support / 언어 지원

The tutorial automatically detects your system locale and displays content in Korean or English. You can override this with `--lang ko` or `--lang en`.

튜토리얼은 시스템 로케일을 자동으로 감지하여 한국어 또는 영어로 콘텐츠를 표시합니다. `--lang ko` 또는 `--lang en`으로 언어를 강제 설정할 수 있습니다.

Currently supported languages:
- 한국어 (Korean)
- English

---

## Contributing / 기여하기

### Adding a New Lesson / 새 레슨 추가하기

1. Create a new directory under `lessons/`:
   ```
   lessons/XX-lesson-name/
   ├── setup.sh        # Creates the practice scenario
   ├── check.sh        # Verifies completion
   ├── lesson.ko.yaml   # Korean instructions
   └── lesson.en.yaml   # English instructions
   ```

2. Each YAML file should include:
   - `title`: Lesson title
   - `objective`: What the student will learn
   - `instructions`: Step-by-step guide
   - `hints`: Tips for completing the task

3. Test your lesson thoroughly before submitting a PR

### Translation / 번역

If you'd like to add support for another language, please:
- Add `intro.<lang>.yaml` files to existing lessons
- Update `tutorial.sh` to detect and support the new locale
- Submit a PR with your translations

We welcome contributions! Feel free to open issues for bugs, suggestions, or new lesson ideas.

기여는 언제나 환영합니다! 버그, 제안 사항, 새로운 레슨 아이디어가 있으면 이슈를 열어주세요.

---

## Project Structure / 프로젝트 구조

```
lazygit-tutorial/
├── tutorial.sh           # Main entry point
├── lessons/              # All lessons
│   ├── 01-ui-navigation/
│   ├── 02-staging-commit/
│   └── ...
├── lib/                  # Shared utilities
│   ├── colors.sh
│   ├── common.sh
│   ├── i18n.sh
│   ├── progress.sh
│   └── yaml_parser.py
└── .progress             # Progress tracking (auto-generated)
```

---

## License / 라이선스

MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

---

## Acknowledgments / 감사의 말

This project was inspired by the excellent [lazygit](https://github.com/jesseduffield/lazygit) tool by Jesse Duffield. Special thanks to the lazygit community for creating such an amazing Git UI.

이 프로젝트는 Jesse Duffield의 훌륭한 [lazygit](https://github.com/jesseduffield/lazygit) 도구에서 영감을 받았습니다. 멋진 Git UI를 만들어준 lazygit 커뮤니티에 특별히 감사드립니다.
