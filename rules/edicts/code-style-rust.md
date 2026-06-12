---
shortDescription: Rust Style Guide rules — rustfmt, 4 spaces, 100 cols, Result, ownership, traits.
scope: coding-rust
version: 0.1.0
lastUpdated: 2026-06-03
---

## Reference

- [Rust Style Guide](https://doc.rust-lang.org/style-guide/)
- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
- [Rust FAQ — naming](https://doc.rust-lang.org/nightly/style-guide/naming.html)

Google does not maintain a Rust style guide. These rules follow the official
Rust Style Guide.

## Formatting

- Use `rustfmt` with default settings. All code MUST conform to `rustfmt`.
- Indent 4 spaces. No tabs.
- Maximum line width: 100 characters.
- Block indent preferred over visual indent.
- Trailing commas required in multi-line comma-separated lists.
- Blank lines: zero or one between items. Use judiciously for grouping.
- No trailing whitespace.

## Naming

| Item | Convention | Example |
|---|---|---|
| Types, traits, enums | `UpperCamelCase` | `struct UserProfile` |
| Functions, methods, locals | `snake_case` | `fn get_user_by_id()` |
| Constants | `SCREAMING_SNAKE_CASE` | `const MAX_CONNECTIONS: u32` |
| Statics | `SCREAMING_SNAKE_CASE` | `static GLOBAL_CONFIG` |
| Type parameters | `UpperCamelCase`, short | `T`, `Error` |
| Lifetimes | single lowercase | `'a`, `'ctx` |
| Macros | `snake_case!` | `vec!`, `info!` |

Names should convey meaning. Avoid abbreviations unless conventional.

## Comments

- Prefer line comments (`//`) over block comments (`/* ... */`).
- Doc comments: `///` for public items, `//!` for module/crate docs.
- Place doc comments before attributes.
- Comments should be complete sentences: capital letter, period.
- Comment lines should not exceed 80 characters.
- Doc comments describe **what** and **why**, not implementation details.
- Inline comments explain **why**, not **what** (the code speaks for itself).

## Imports

- Group: `std`, external crates, `crate`, `self`/`super`. Blank line between
  groups.
- Sort within each group (version-sorting).
- Prefer `use crate::module::Type` over deep nesting.
- Avoid `use *` — be explicit.

## Error Handling

- Prefer `Result<T, E>` over panics. Reserve `unwrap()` / `expect()` for
  prototyping or infallible operations (with justification comment).
- Define custom error types for library code. Implement `std::error::Error`.
- Use `?` operator to propagate errors.
- Use `anyhow` for application-level error handling, `thiserror` for library
  error types (when these dependencies are already in the project).

## Ownership and Borrowing

- Prefer references (`&T`) over cloning. Clone only when necessary.
- Use `&mut T` when mutation is needed, keeping the borrow scope minimal.
- Prefer owned types in public APIs that consume values.
- Use `Cow<'_, T>` for arguments that may or may not need ownership.

## Traits

- Prefer small, focused traits (single responsibility).
- Provide blanket implementations where useful.
- Sealed traits (`pub trait: private::Sealed`) for internal extension points.
- Implement standard traits (`Debug`, `Clone`, `PartialEq`, `Default`, `Hash`)
  when semantically appropriate. Derive when possible.

## Types

- Prefer simple enums over boolean parameters for clarity.
- Use newtype pattern (`struct Meters(f64)`) for type safety with distinct
  units or concepts.
- Implement `From`/`TryFrom` for conversions rather than custom methods.
- Prefer `&str` to `&String`, `&[T]` to `&Vec<T>`.

## Testing

- Unit tests: `#[cfg(test)] mod tests` at bottom of file.
- Integration tests: `tests/` directory.
- Use descriptive test function names: `#[test] fn
  parse_valid_input_returns_ok()`.
- Prefer `assert_eq!`, `assert_ne!`, `matches!` over plain `assert!`.
- Use `should_panic` only for validation logic; prefer `Result`-returning tests.

## Prohibited

- `unsafe` blocks without a `// SAFETY:` comment explaining invariants.
- `panic!` in library code (use `Result`).
- `unwrap()` / `expect()` without justification.
- `transmute` unless absolutely necessary and documented.
- Interior mutability (`Cell`, `RefCell`, `Mutex`) without clear thread-safety
  documentation.

## API Guidelines Checklist

- The type implements standard traits (Debug, Clone, PartialEq) where
  meaningful.
- Conversions use `From`/`TryFrom`, not custom `fn to_*` / `fn from_*`.
- Function signatures are clear and avoid boolean parameters (use enums).
- Generic parameters have meaningful bounds.
- Public items have doc comments.

## Rationale

Rust code at Google follows the community Rust Style Guide. Consistency via
`rustfmt`, proper error handling, and the type system reduce bugs and make
refactoring safe.
