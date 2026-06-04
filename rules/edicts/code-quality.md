---
shortDescription: Universal code quality conventions for all languages.
scope: coding
version: 0.4.0
lastUpdated: 2026-06-03
---

## Language-Specific Style Guides

Each language has its own detailed style guide. Consult the relevant guide for
naming conventions, formatting, imports, docstring format, and testing patterns:

| Language | Guide |
|---|---|
| Python | `rules/edicts/code-style-python.md` |
| Go | `rules/edicts/code-style-go.md` |
| Shell | `rules/edicts/code-style-shell.md` |
| Rust | `rules/edicts/code-style-rust.md` |
| Markdown | `rules/edicts/code-style-markdown.md` |

This document covers **cross-language principles** only.

## Statement

### Docstrings and Comments

Public declarations — modules, classes, functions, methods — MUST have a
docstring. Docstrings describe the **what** (purpose, arguments, returns,
raises). Inline comments explain **why**, not **what**. If code requires an
inline comment to be understood, first consider making the code itself clearer.

For language-specific docstring formats, see the applicable style guide above.

### KISS

Choose the simplest solution that fully solves the problem. Complexity is a
liability. If a solution requires the reader to understand a design pattern,
an algorithm, or a non-obvious language feature, a simpler alternative likely
exists.

### DRY

Each piece of knowledge or behavior SHOULD have a single, unambiguous
representation. When two code paths do the same thing, they should share a
function, variable, or constant. Duplication is a bug waiting to happen.

### Single Responsibility Principle

Functions, modules, and files SHOULD have one reason to change. If a function
performs setup AND reporting, or parsing AND validation, it has two
responsibilities and SHOULD be split.

### Error Handling

Errors MUST always be logged. An error that passes without a log entry is a
silent failure. Handling depends on context — if the error is non-critical, it
may be logged and not propagated, but it must never be swallowed silently.

### Process-Killing Exceptions

Language constructs that terminate the process (`panic`, `os.Exit`, unhandled
`throw`, `process.exit`, etc.) used during runtime SHOULD be flagged. They are
acceptable during application startup or initialization. Once the application
is serving, process-killing constructs are frowned upon — failures SHOULD be
handled through the language's error propagation mechanism.

### Data Trust Boundary

Data from outside the code — user input, database results, API responses,
environment variables, file contents — SHOULD be treated as untrusted regardless
of origin. External data flowing directly into queries, templates, commands,
or domain operations without validation SHOULD be flagged. The recommended
pattern is to convert external data into a typed value object before use in
business logic.

### Schema Changes

Database schema modifications MUST be explicitly stated in any handoff or
commit summary.

## Rationale

These cross-language conventions produce code that reads linearly, names that
communicate intent, and tests that explain failures. Language-specific rules
in `rules/edicts/code-style-*.md` provide the detailed formatting and naming
conventions for each language.
