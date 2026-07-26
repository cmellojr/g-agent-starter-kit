# Review and Verification Plan for Upstream Sync

This document outlines the findings from the review of the recent merge
(`upstream/ntorga` into `main`) and proposes steps to verify and fix the
identified compatibility issues, particularly on Windows environments.

[TOC]

## Findings

The review identified three main issues that prevent the test suite and
configuration scripts from running successfully:

### 1. Windows Line Endings (CRLF)

- **Problem**: Git's `core.autocrlf = true` is active on the host system.
- **Impact**: Shell scripts (`.sh` files) like `maestro-boot-configure-cli.sh`
  and its test script are checked out with CRLF line endings, which breaks
  execution in `bash` (e.g. `\r: command not found`).
- **Remediation**: Add a `.gitattributes` file to force LF line endings for
  all shell scripts (`*.sh`) and Python scripts (`*.py`).

### 2. Hardcoded Python Interpreter in Subprocesses

- **Problem**: `check_markdown_test.py` hardcodes the command `python3` when
  spawning subprocesses to run the check script.
- **Impact**: The test suite fails on standard Windows environments where
  the default Python executable name is `python` (resulting in exit code 9009
  representing "command not found").
- **Remediation**: Update `check_markdown_test.py` to use `sys.executable` so
  it automatically uses the running Python interpreter path.

### 3. Markdown Style Violations in Phase 1 Target Files

- **Problem**: `AGENTS.md`, `README.md`, and `docs/CONTRIBUTING.md` contain
  prose lines exceeding 80 characters.
- **Impact**: The `test_phase1_files` unit test fails because it expects all
  Phase 1 files to yield 0 style violations from `check_markdown.py`.
- **Remediation**: Either format these files to respect the 80-character prose
  limit or adjust the test/exemptions list to accommodate copy-pasted blocks.

## Proposed Plan

To safely apply the fixes after user approval, the following steps are proposed
for execution.

### Phase 1: Git and Line Endings

- **Action**: Create a `.gitattributes` file at the repository root.
- **Content**:
  ```text
  *.sh text eol=lf
  *.py text eol=lf
  ```
- **Post-Action**: Run `git add --renormalize .` to apply LF endings to all
  existing shell and Python scripts in the index.

### Phase 2: Python Portability Fix

- **Action**: Modify `check_markdown_test.py` to import `sys` and replace the
  subprocess command `python3` with `sys.executable`.

### Phase 3: Style Guide Compliance & Verification

- **Action**:
  - Re-run `python .agents/skills/assets/check_markdown_test.py` to verify.
  - Review remaining violations in `README.md`, `AGENTS.md`, and others to
    ensure they conform or are appropriately exempted.

## See also

* [Google Markdown Style Guide](https://google.github.io/styleguide/docguide/style.html)
