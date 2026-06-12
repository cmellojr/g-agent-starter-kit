#!/usr/bin/env python3
"""Tests for check_markdown.py."""

import os
import subprocess
import tempfile
import unittest


class TestCheckMarkdown(unittest.TestCase):
    """Test case for check_markdown.py script execution and validation logic."""

    def setUp(self):
        self.script_path = os.path.join(
            os.path.dirname(__file__), "check_markdown.py"
        )

    def run_script(self, *args):
        """Helper to run the check_markdown.py script with arguments."""
        result = subprocess.run(
            ["python3", self.script_path] + list(args),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        return result.returncode, result.stdout, result.stderr

    def test_check_markdown_valid(self):
        """Happy path: a valid markdown file with proper wraps and headings."""
        content = (
            "# Document Title\n"
            "\n"
            "This is a paragraph under 80 characters. It is wrapped\n"
            "properly to fit guidelines.\n"
            "\n"
            "## Heading 2\n"
            "\n"
            "Another line of text.\n"
            "\n"
            "```python\n"
            "# Code block is allowed to be longer than 80 characters if needed\n"
            "print('hello')\n"
            "```\n"
        )
        with tempfile.NamedTemporaryFile(suffix=".md", mode="w", delete=False) as f:
            f.write(content)
            temp_name = f.name

        try:
            exit_code, stdout, stderr = self.run_script(temp_name)
            self.assertEqual(exit_code, 0, f"Expected 0, got {exit_code}.\nStdout: {stdout}\nStderr: {stderr}")
        finally:
            os.remove(temp_name)

    def test_check_markdown_long_line(self):
        """Error case: a markdown file with a 90-character prose line."""
        content = (
            "# Title\n"
            "\n"
            "This is a very long line that exceeds the eighty character limit "
            "imposed by the google markdown guide.\n"
        )
        with tempfile.NamedTemporaryFile(suffix=".md", mode="w", delete=False) as f:
            f.write(content)
            temp_name = f.name

        try:
            exit_code, stdout, stderr = self.run_script(temp_name)
            self.assertEqual(exit_code, 1, f"Expected 1, got {exit_code}")
            self.assertIn("exceeds 80 characters", stdout + stderr)
        finally:
            os.remove(temp_name)

    def test_check_markdown_missing_file(self):
        """Adversarial case: non-existent path, exit 1 with clean error message."""
        exit_code, stdout, stderr = self.run_script("non_existent_file_12345.md")
        self.assertEqual(exit_code, 1)
        self.assertTrue(len(stdout + stderr) > 0)

    def test_check_markdown_unclosed_code_block(self):
        """Error case: a markdown file with an unclosed fenced code block."""
        content = (
            "# Title\n"
            "\n"
            "```python\n"
            "print('unclosed block')\n"
        )
        with tempfile.NamedTemporaryFile(suffix=".md", mode="w", delete=False) as f:
            f.write(content)
            temp_name = f.name

        try:
            exit_code, stdout, stderr = self.run_script(temp_name)
            self.assertEqual(exit_code, 1, f"Expected 1, got {exit_code}")
            self.assertIn("Unclosed fenced code block", stdout + stderr)
        finally:
            os.remove(temp_name)

    def test_phase1_files(self):
        """Verify that all target Phase 1 files pass style validation."""
        root_dir = os.path.dirname(os.path.dirname(os.path.dirname(self.script_path)))
        target_files = [
            ".context.md",
            "README.md",
            "AGENTS.md",
            "CHANGELOG.md",
            "docs/.context.md",
            "docs/CONTRIBUTING.md",
            "docs/features.md",
            "docs/google-engineering-practices-roadmap.md",
            "docs/google-style-alignment.md",
        ]
        for tf in target_files:
            full_path = os.path.join(root_dir, tf)
            exit_code, stdout, stderr = self.run_script(full_path)
            self.assertEqual(
                exit_code,
                0,
                f"File {tf} failed check_markdown.py validation.\nStdout: {stdout}\nStderr: {stderr}"
            )


if __name__ == "__main__":
    unittest.main()
