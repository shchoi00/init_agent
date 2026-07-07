#!/usr/bin/env python3
"""Minimal PreToolUse guard for shell commands.

The hook reads Codex event JSON from stdin and exits non-zero when a command
looks like an obvious destructive operation. Keep this conservative; it is a
prompt-time guard, not a security boundary.
"""

from __future__ import annotations

import json
import re
import sys


BLOCKED_PATTERNS = [
    r"\brm\s+-rf\s+/",
    r"\bgit\s+reset\s+--hard\b",
    r"\bgit\s+clean\s+-fdx\b",
    r"\bmkfs\b",
    r"\bdd\s+if=",
]


def extract_command(event: dict) -> str:
    tool_input = event.get("tool_input") or event.get("input") or {}
    if isinstance(tool_input, dict):
        command = tool_input.get("cmd") or tool_input.get("command") or ""
        if isinstance(command, str):
            return command
    return ""


def main() -> int:
    try:
        event = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 0

    command = extract_command(event)
    if not command:
        return 0

    for pattern in BLOCKED_PATTERNS:
        if re.search(pattern, command):
            print(f"Blocked command by project hook: {pattern}", file=sys.stderr)
            return 2

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
