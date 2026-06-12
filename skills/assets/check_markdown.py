#!/usr/bin/env python3
"""Validation utility for Google Markdown Style Guide compliance.

Checks:
1. Lines exceeding 80 characters for prose (with exemptions for links, headings,
   tables, code blocks, and frontmatter).
2. Correct ATX heading spacing (space after '#', blank lines before and after).
3. Code block language annotations (fenced code blocks must have a language).
4. No trailing whitespace.
"""

import sys
import os
import re
from typing import List, Tuple


def check_file(filepath: str) -> List[str]:
    """Checks a markdown file for style guide compliance.

    Args:
        filepath: Path to the markdown file.

    Returns:
        A list of string messages describing violations.
    """
    violations = []
    if not os.path.exists(filepath):
        return [f"File not found: {filepath}"]

    try:
        with open(filepath, "r", encoding="utf-8") as f:
            lines = f.readlines()
    except Exception as e:
        return [f"Failed to read file {filepath}: {e}"]

    in_code_block = False
    code_block_indent = -1
    in_frontmatter = False
    frontmatter_count = 0

    # First line check for YAML frontmatter
    if lines and lines[0].strip() == "---":
        in_frontmatter = True
        frontmatter_count = 1

    for idx, line in enumerate(lines):
        line_num = idx + 1
        raw_line = line
        # Strip newline characters at the end of the line
        line_content = line.rstrip("\r\n")

        # Track frontmatter
        if line_num > 1 and line_content.strip() == "---":
            if in_frontmatter:
                in_frontmatter = False
                frontmatter_count += 1
                continue
            elif frontmatter_count == 0:
                # If frontmatter wasn't open but we saw --- at line start,
                # check if it starts a frontmatter. Google Markdown guide allows
                # it only at start of file, but let's be safe.
                pass

        # Trailing whitespace check
        if line_content.endswith(" ") or line_content.endswith("\t"):
            violations.append(
                f"{line_num}: Trailing whitespace detected."
            )

        # Code block tracking and check
        stripped = line_content.strip()
        if stripped.startswith("```"):
            if not in_code_block:
                in_code_block = True
                code_block_indent = len(line_content) - len(stripped)
                # Check for language declaration
                lang = stripped[3:].strip()
                if not lang:
                    violations.append(
                        f"{line_num}: Fenced code block missing language declaration."
                    )
            else:
                line_indent = len(line_content) - len(stripped)
                if line_indent <= code_block_indent:
                    in_code_block = False
                    code_block_indent = -1
            continue

        if in_code_block:
            continue

        # ATX Heading Spacing
        if stripped.startswith("#"):
            # Spacing after '#': must be '^#+ '
            match = re.match(r"^(#+)(.*)$", stripped)
            if match:
                hashes = match.group(1)
                after = match.group(2)
                if not after.startswith(" "):
                    violations.append(
                        f"{line_num}: Heading starting with '{hashes}' must have a space after hashes."
                    )

            # Blank line before heading
            if idx > 0:
                prev_line = lines[idx - 1].rstrip("\r\n").strip()
                # Exception: if the previous line is another heading, or if it is empty.
                # Actually, standard style says "blank line before and after".
                # If there's another heading immediately preceding, it's also a violation
                # because there should be a blank line between headings.
                if prev_line != "":
                    violations.append(
                        f"{line_num}: Missing blank line before heading."
                    )

            # Blank line after heading
            if idx < len(lines) - 1:
                next_line = lines[idx + 1].rstrip("\r\n").strip()
                if next_line != "":
                    violations.append(
                        f"{line_num}: Missing blank line after heading."
                    )

            # Headings are allowed to exceed 80 chars
            continue

        # Frontmatter lines are exempt from length check
        if in_frontmatter:
            continue

        # Prose Line Length Check (80 characters limit)
        if len(line_content) > 80:
            # Check for exemptions
            is_exempt = False
            # 1. Links (contains http:// or https://)
            if "http://" in line_content or "https://" in line_content:
                is_exempt = True
            # 2. Reference link definitions: e.g. [name]: url
            elif re.match(r"^\s*\[[^\]]+\]:\s*\S+", line_content):
                is_exempt = True
            # 3. Tables (contains '|')
            elif "|" in line_content:
                is_exempt = True

            if not is_exempt:
                violations.append(
                    f"{line_num}: Line length {len(line_content)} exceeds 80 characters."
                )

    if in_code_block:
        violations.append("EOF: Unclosed fenced code block detected.")

    return violations


def main() -> None:
    """Main entrypoint for the CLI script."""
    if len(sys.argv) < 2:
        print("Usage: check_markdown.py <file1.md> [file2.md ...]")
        sys.exit(1)

    total_violations = 0
    for filepath in sys.argv[1:]:
        violations = check_file(filepath)
        if violations:
            total_violations += len(violations)
            print(f"Violations in {filepath}:")
            for v in violations:
                print(f"  {v}")

    if total_violations > 0:
        print(f"\nTotal violations: {total_violations}")
        sys.exit(1)
    else:
        print("All checked files are compliant.")
        sys.exit(0)


if __name__ == "__main__":
    main()
