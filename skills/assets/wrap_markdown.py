#!/usr/bin/env python3
"""Wrap prose lines in markdown files to 80 characters.

Respects Google Markdown Style Guide exemptions:
- Frontmatter, code blocks, tables, headings, links, reference definitions.
"""

from __future__ import annotations

import os
import re
import sys
import textwrap


def get_continuation_indent(text: str, base_indent: str) -> str:
    """Calculates the continuation indent for bulleted or numbered list items.

    Args:
        text: The stripped line content.
        base_indent: The base indentation string.

    Returns:
        The continuation indent string matching the list alignment.
    """
    stripped = text.lstrip()
    match = re.match(r"^([\-\*\+]\s+)", stripped)
    if match:
        return base_indent + " " * len(match.group(1))
    match = re.match(r"^(\d+\.\s+)", stripped)
    if match:
        return base_indent + " " * len(match.group(1))
    return base_indent


def wrap_line(raw: str, width: int) -> list[str] | None:
    """Wraps a single raw text line to the given character width.

    Args:
        raw: The raw text line to wrap.
        width: Maximum character width per line.

    Returns:
        A list of wrapped lines, or None if wrapping was skipped.
    """
    stripped = raw.rstrip("\n").rstrip("\r")
    if not stripped.strip():
        return [raw]

    indent = raw[:len(raw) - len(raw.lstrip())]
    content = raw.lstrip()

    cont_indent = get_continuation_indent(content, indent)
    avail = width - max(len(indent), len(cont_indent))
    if avail < 20:
        return [raw]

    wrapped = textwrap.wrap(
        content,
        width=avail,
        break_long_words=False,
        break_on_hyphens=False,
    )

    if len(wrapped) <= 1:
        return [raw]

    result = []
    for i, wl in enumerate(wrapped):
        if i == 0:
            result.append(indent + wl + "\n")
        else:
            result.append(cont_indent + wl + "\n")
    return result


def wrap_file(filepath: str, width: int = 80) -> bool:
    """Wraps prose lines in a Markdown file to the specified column width.

    Args:
        filepath: Path to the Markdown file.
        width: Maximum allowed column width for prose.

    Returns:
        True if the file was modified, False otherwise.
    """
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return False

    with open(filepath, "r", encoding="utf-8") as f:
        lines = f.readlines()

    frontmatter_end = -1
    if lines and lines[0].strip() == "---":
        for i, line in enumerate(lines[1:], 1):
            if line.strip() == "---":
                frontmatter_end = i
                break

    in_code_block = False
    new_lines = []
    changes = False

    for idx, line in enumerate(lines):
        raw = line  # keep original line ending
        stripped = raw.strip()

        if in_code_block:
            new_lines.append(raw)
            if stripped.startswith("```"):
                in_code_block = False
            continue

        if stripped.startswith("```"):
            in_code_block = True
            new_lines.append(raw)
            continue

        # Frontmatter range
        if idx <= frontmatter_end:
            new_lines.append(raw)
            continue

        # Empty lines
        if not stripped:
            new_lines.append(raw)
            continue

        # Headings
        if stripped.startswith("#"):
            new_lines.append(raw)
            continue

        # Lines with URLs
        if "http://" in raw or "https://" in raw:
            new_lines.append(raw)
            continue

        # Tables (contain pipe)
        if "|" in raw:
            new_lines.append(raw)
            continue

        # Reference link definitions
        if re.match(r"^\s*\[[^\]]+\]:\s*\S+", raw):
            new_lines.append(raw)
            continue

        # Already short enough
        content_len = len(raw.rstrip("\n").rstrip("\r"))
        if content_len <= width:
            new_lines.append(raw)
            continue

        wrapped = wrap_line(raw, width)
        if len(wrapped) == 1 and wrapped[0] == raw:
            new_lines.append(raw)
        else:
            new_lines.extend(wrapped)
            changes = True

    if changes:
        with open(filepath, "w", encoding="utf-8") as f:
            f.writelines(new_lines)
        return True
    return False


def main() -> None:
    """Main CLI entrypoint for wrapping Markdown files."""
    if len(sys.argv) < 2:
        print("Usage: wrap_markdown.py <file1.md> [file2.md ...]")
        sys.exit(1)

    wrapped = 0
    for fp in sys.argv[1:]:
        if wrap_file(fp):
            wrapped += 1

    print(f"Wrapped {wrapped} file(s).")


if __name__ == "__main__":
    main()
