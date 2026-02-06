#!/usr/bin/env python3
"""
yaml_parser.py - Parse lesson YAML files for the lazygit tutorial.

Usage: python3 yaml_parser.py <yaml_file> <command> [args]

Commands:
  title                  - Print lesson title
  description            - Print lesson description
  difficulty             - Print difficulty level
  step_count             - Print number of steps
  step_instruction <n>   - Print step N instruction (1-indexed)
  step_hints <n>         - Print step N hints (one per line, prefixed with emoji)
  step_id <n>            - Print step N id
  metadata               - Print all metadata as key=value lines
"""

import sys
import os

def ensure_yaml():
    """Try to import yaml, give helpful message if missing."""
    try:
        import yaml
        return yaml
    except ImportError:
        print(
            "Error: PyYAML is not installed.\n"
            "Install it with: pip3 install pyyaml",
            file=sys.stderr,
        )
        sys.exit(1)


def load_lesson(yaml_path):
    """Load and parse a YAML lesson file."""
    yaml = ensure_yaml()
    if not os.path.isfile(yaml_path):
        print(f"Error: file not found: {yaml_path}", file=sys.stderr)
        sys.exit(1)
    with open(yaml_path, "r", encoding="utf-8") as f:
        try:
            data = yaml.safe_load(f)
        except yaml.YAMLError as exc:
            print(f"Error: invalid YAML in {yaml_path}: {exc}", file=sys.stderr)
            sys.exit(1)
    if data is None:
        print(f"Error: empty YAML file: {yaml_path}", file=sys.stderr)
        sys.exit(1)
    return data


def get_step(data, step_num_str):
    """Return a step dict by 1-indexed number, or exit on error."""
    try:
        n = int(step_num_str)
    except ValueError:
        print(f"Error: step number must be an integer, got: {step_num_str}", file=sys.stderr)
        sys.exit(1)

    steps = data.get("steps", [])
    if not steps:
        print("Error: lesson has no steps", file=sys.stderr)
        sys.exit(1)
    if n < 1 or n > len(steps):
        print(
            f"Error: step {n} out of range (1-{len(steps)})",
            file=sys.stderr,
        )
        sys.exit(1)
    return steps[n - 1]


def cmd_title(data, _args):
    print(data.get("title", ""))


def cmd_description(data, _args):
    print(data.get("description", ""))


def cmd_difficulty(data, _args):
    print(data.get("difficulty", ""))


def cmd_step_count(data, _args):
    print(len(data.get("steps", [])))


def cmd_step_instruction(data, args):
    if not args:
        print("Error: step_instruction requires a step number", file=sys.stderr)
        sys.exit(1)
    step = get_step(data, args[0])
    instruction = step.get("instruction", "").rstrip("\n")
    print(instruction)


def cmd_step_hints(data, args):
    if not args:
        print("Error: step_hints requires a step number", file=sys.stderr)
        sys.exit(1)
    step = get_step(data, args[0])
    hints = step.get("hints", [])
    for hint in hints:
        print(f"\U0001f4a1 {hint}")


def cmd_step_id(data, args):
    if not args:
        print("Error: step_id requires a step number", file=sys.stderr)
        sys.exit(1)
    step = get_step(data, args[0])
    print(step.get("id", ""))


def cmd_metadata(data, _args):
    for key in ("id", "title", "description", "difficulty", "estimatedMinutes"):
        value = data.get(key, "")
        print(f"{key}={value}")


COMMANDS = {
    "title": cmd_title,
    "description": cmd_description,
    "difficulty": cmd_difficulty,
    "step_count": cmd_step_count,
    "step_instruction": cmd_step_instruction,
    "step_hints": cmd_step_hints,
    "step_id": cmd_step_id,
    "metadata": cmd_metadata,
}


def usage():
    print(__doc__.strip(), file=sys.stderr)
    sys.exit(1)


def main():
    if len(sys.argv) < 3:
        usage()

    yaml_path = sys.argv[1]
    command = sys.argv[2]
    extra_args = sys.argv[3:]

    if command not in COMMANDS:
        print(f"Error: unknown command: {command}", file=sys.stderr)
        print(f"Available commands: {', '.join(sorted(COMMANDS.keys()))}", file=sys.stderr)
        sys.exit(1)

    data = load_lesson(yaml_path)
    COMMANDS[command](data, extra_args)


if __name__ == "__main__":
    main()
