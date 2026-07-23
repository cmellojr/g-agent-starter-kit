---
shortDescription: Google Shell Style Guide rules — Bash, 2 spaces, 80 cols, local, main(), ShellCheck.
scope: coding-shell
version: 0.1.0
lastUpdated: 2026-06-03
---

## Reference

[Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

## Shell and Interpreter

- Executables MUST use `#!/bin/bash` + minimal flags.
- Set shell options with `set` so `bash script_name` works the same.
- Shell is for **small utilities and simple wrappers only**.
- If a script exceeds ~100 lines or uses complex control flow, rewrite in a
  structured language (Python, Go).
- SUID/SGID is forbidden on shell scripts.

## File Extensions

- Executables: `.sh` extension or no extension.
- Libraries: `.sh` extension, not executable.

## Formatting

- Indent 2 spaces. No tabs.
- Maximum line length: 80 characters.
- For long strings, use heredocs or embedded newlines. Avoid literal strings
  exceeding 80 chars.

### Pipelines

Split one pipe per line if the pipeline does not fit on one line. Place the
pipe on the newline with 2-space indent:

```bash
command1 \
  | command2 \
  | command3
```

### Control Flow

`; then` and `; do` on same line as `if`/`for`/`while`. `else` on its own
line. `fi` / `done` flush with the opening statement.

### Case

Indent patterns 2 spaces from `case`/`esac`. Actions indent another 2 spaces.
`;;` on its own line for multi-line actions. Avoid `;&` and `;;&`.

## Quoting

- Always quote strings with variables, command substitutions, spaces, or shell
  meta characters: `"${var}"`.
- Use `"$@"` (not `$*`) unless you specifically need concatenated args.
- Prefer `"${var}"` over `$var` (braces + quotes).
- Single-char specials (`$1`, `$?`) can omit braces.

## Features and Bugs

### Command Substitution

Use `$(command)` not backticks.

### Tests

Prefer `[[ ... ]]` over `[ ... ]` or `test`. Use `(( ... ))` for arithmetic.
Use `-z` / `-n` for string emptiness checks.

### eval

**Never use `eval`.** It obscures variable assignment and creates security
risks.

### Arrays

Use Bash arrays for lists of elements to avoid quoting issues:
```bash
declare -a FLAGS=(--foo --bar='baz')
mybinary "${FLAGS[@]}"
```

### Pipes to while

Avoid — pipes create a subshell. Use process substitution instead:
```bash
while read -r line; do ... done < <(command)
```

### Arithmetic

Use `(( ... ))` or `$(( ... ))`. Never use `let`, `$[...]`, or `expr`.

### Aliases

Avoid in scripts. Use functions instead.

## Naming

- **Functions:** `lower_case_with_underscores`. Parentheses required after name.
  `function` keyword optional but must be consistent.
- **Variables:** `lower_case_with_underscores`.
- **Constants / environment:** `UPPER_CASE` with underscores. Declare at top
  of file. Use `readonly`.
- **Source filenames:** lowercase, underscores allowed, no hyphens.

## Locals

Declare function-scoped variables with `local`. Declaration and assignment must
be separate when using command substitution (so `$?` captures the command, not
`local`).

## Function Location

Put all functions together just below constants. Only `set`, `includes`, and
constants precede them.

## main

A `main()` function is **required** for scripts with at least one other
function. It MUST be the last function. The last non-comment line must call it:

```bash
main "$@"
```

## Comments

- File header: brief overview of contents at top of file.
- Function comments: Description, Globals, Arguments, Outputs, Returns — for
  all non-trivial functions and all library functions.
- Implementation comments: explain tricky, non-obvious parts.
- TODO: `# TODO(owner): description`

## Error Handling

- All error messages go to STDERR. Use a helper function:
  ```bash
  err() { echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2; }
  ```
- Always check return values with `if ! command; then ...` or `$?`.
- Prefer built-in commands over external processes (`sed`, `expr`, `grep`).

## ShellCheck

All shell scripts MUST pass ShellCheck analysis.

## Rationale

Shell scripts at Google are utility-grade: short, focused, and
defensive. These rules prevent the most common shell pitfalls
(unquoted variables, missing error checks, subshell leaks) and
keep scripts maintainable.
