---
shortDescription: Google Python Style Guide rules — 80 cols, 4 spaces, snake_case, type annotations, docstrings.
scope: coding-python
version: 0.1.0
lastUpdated: 2026-06-03
---

## Reference

[Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)

## Formatting

### Line Length

Maximum 80 characters. Exceptions: long import statements, URLs in comments,
long module-level constants without whitespace, pylint disable comments.

Use implicit line joining inside parentheses, brackets, braces. Never use
backslash for line continuation (except inside strings).

### Indentation

4 spaces per level. No tabs.

Align wrapped elements with opening delimiter, or use 4-space hanging indent.

### Semicolons

Do not use. One statement per line.

### Blank Lines

Two blank lines between top-level definitions (functions, classes). One blank
line between methods and between a class docstring and the first method.

### Whitespace

No whitespace inside parentheses, brackets, or braces. One space around binary
operators. No space before commas, colons, or semicolons. No space before open
paren in calls or indexing. No trailing whitespace.

### Shebang

`#!/usr/bin/env python3` for executables. Most `.py` files do not need one.

## Naming

| Type | Convention | Example |
|---|---|---|
| Functions, variables | `snake_case` | `get_user_by_id()` |
| Constants | `UPPER_CASE` | `MAX_RETRIES` |
| Classes | `CapWords` | `class UserProfile:` |
| Modules | `snake_case` | `user_profile.py` |
| Internal (private) | `_leading_underscore` | `_internal_helper()` |
| Override/reserved | `trailing_underscore_` | `class_` |

Names to avoid: single-char names (except trivial loops), leading/trailing
double underscores (reserved), offensive terms, type names in variable names.

## Imports

- `import x` for packages and modules.
- `from x import y` where `x` is the package prefix and `y` the module name.
- `from x import y as z` only to resolve conflicts or shorten long names.
- `import y as z` only for standard abbreviations (`import numpy as np`).
- No relative imports. Use full package path.
- Order: standard library, third-party, local — each group separated by blank
  line.

## Docstrings

Every module, public class, and public function MUST have a docstring.

- Modules: brief overview of contents.
- Classes: summary of purpose and usage.
- Functions: Args, Returns, Raises (if applicable). Types in signature or doc.
- Use `"""triple double quotes"""`.
- Summary line must fit 80 chars.
- Docstrings are **required** (Google rule). Inline comments explain **why**, not **what**.

## Type Annotations

Strongly encouraged. Use PEP 484 annotations on function signatures and
variable declarations. Prefer `list[X]`, `dict[K, V]`, `Optional[X]`,
`X | None` (Python 3.10+). Enable type checking via pytype or mypy at build
time.

## Exceptions

- Raise built-in exceptions when appropriate (`ValueError`, `TypeError`, etc.).
- Custom exceptions must inherit from `Exception`, name must end in `Error`.
- Never use catch-all `except:` (or `except Exception`). Re-raise or isolate.
- Minimize `try` body size. Use `finally` for cleanup.
- `assert` is for tests only, not for application logic.

## Comprehensions

Allowed for simple cases. Max one `for` clause and one `if` filter. Optimize
for readability, not conciseness.

## Lambdas

Okay for one-liners. Prefer `operator` module for common operations. Avoid
`map()` and `filter()` with lambdas — use comprehensions instead.

## Default Arguments

Never use mutable objects (`[]`, `{}`) as defaults. Use `None` and assign
inside the function.

## Properties

Use `@property` for trivial computed attributes. Do not use for simple get/set
that could be a public attribute.

## Power Features

Avoid custom metaclasses, bytecode access, `__del__`, on-the-fly compilation,
`getattr()` tricks. Use standard library classes like `abc.ABCMeta`,
`dataclasses`, `enum` instead.

## TODO Comments

`# TODO(user): description` — reference a bug or owner. Searchable.

## Main

```
def main() -> None:
    ...

if __name__ == '__main__':
    main()
```

## Rationale

These rules align all Python code with Google's internal standard, producing
consistent, type-safe, and self-documenting code that passes code review with
minimal style friction.
