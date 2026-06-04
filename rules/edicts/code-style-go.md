---
shortDescription: Google Go Style Guide rules — gofmt, MixedCaps, clarity > concision, least mechanism.
scope: coding-go
version: 0.1.0
lastUpdated: 2026-06-03
---

## Reference

[Google Go Style Guide](https://google.github.io/styleguide/go/guide)

## Core Principles (in order)

1. **Clarity** — The code's purpose and rationale must be clear to the reader.
2. **Simplicity** — Accomplish the goal in the simplest way possible.
3. **Concision** — High signal-to-noise ratio.
4. **Maintainability** — Easy to modify correctly by future programmers.
5. **Consistency** — Consistent with the broader Go codebase.

## Formatting

- All Go source files MUST conform to `gofmt` output. Non-negotiable.
- No fixed line length. If a line feels too long, refactor instead of splitting.
- Do not split lines before an indentation change or to fit a long string.

## Naming

- `MixedCaps` / `mixedCaps` (camelCase). Never `snake_case`.
- Exported names: `UpperCamelCase`. Unexported: `lowerCamelCase`.
- Constants: `MaxLength` (exported), `maxLength` (unexported). Never `MAX_LENGTH`.
- Local variables are considered unexported for capitalization.
- Name length should reflect scope — shorter for local, longer for exported.
- Names should not repeat package-level context.

## Comments

- Doc comments (`// Comment`) on all exported declarations.
- Comments explain **why**, not **what**. The code should already speak for itself.
- Use complete sentences with proper punctuation.

## Imports

- Grouped: standard library, third-party, local. Blank line between groups.
- Use meaningful import aliases only to resolve conflicts.
- Avoid blank imports (`import _`) unless required by a generated file or driver.

## Least Mechanism

Prefer the simplest tool for the job:
1. Core language constructs (slices, maps, loops, structs, channels).
2. Standard library (net/http, template, encoding/json).
3. Well-established Google-internal libraries.
4. External dependencies only as last resort.

## Error Handling

- Always check errors: `if err != nil { return ... }`.
- Use `fmt.Errorf` with `%w` to wrap errors for unwrapping.
- Prefer sentinel errors (`var ErrNotFound = errors.New("not found")`) over
  magic strings.
- Error strings should not be capitalized or end with punctuation (they are
  often chained).

## Testing

- Use standard `testing` package. `require` / `assert` from testify are NOT
  recommended.
- Table-driven tests are preferred for covering multiple cases.
- Test helper functions should return `error` and call `t.Fatal` only in the
  top-level test function.
- Use `t.Cleanup` for resource cleanup instead of manual `defer` in helpers.

## Code Organization

- Group types, then functions, then methods logically.
- Prefer small interfaces (1-2 methods). Accept interfaces, return concrete
  types.
- Avoid `init()` unless absolutely necessary. Prefer explicit initialization.

## Concurrency

- Use `go` + anonymous function or named function. Avoid goroutine leaks.
- Prefer channels for communication, sync primitives for coordination.
- Use `sync.WaitGroup` for waiting on goroutine completion.
- Pass `context.Context` as the first parameter in public APIs.

## Prohibited

- `panic` / `recover` outside of initialization or framework lifecycle.
- Global mutable state. Use dependency injection instead.
- `iota` with implicit values (always specify explicit values for clarity).
- `defer` inside loops (causes resource accumulation).

## Rationale

Following the Google Go Style Guide ensures Go code is idiomatic, readable,
and maintainable across the entire codebase. Consistency with `gofmt` and
standard library idioms reduces cognitive load during review and maintenance.
