---
shortDescription: Google TypeScript Style Guide rules and conventions.
scope: coding-typescript
version: 0.1.0
lastUpdated: 2026-10-22
---

## Reference

[Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)

## General Principles

- Follow the Google JavaScript Style Guide as the base
- TypeScript-specific additions for type safety and maintainability
- Use `import type` and `export type` for type-only imports/exports
- Prefer named exports over default exports
- Use `const`/`let`, never `var`

## Source File Basics

### File Encoding

- UTF-8 encoding
- Only ASCII horizontal space (0x20) as whitespace character
- Use special escape sequences (`\'`, `\"`, `\\`, `\b`, `\f`, `\n`, `\r`, `\t`, `\v`)
- Use actual Unicode characters for non-ASCII printable characters

### File Structure

Files consist of, in order:
1. Copyright/license information (if present) — in JSDoc
2. `@fileoverview` JSDoc (if present)
3. Imports
4. File implementation

Exactly one blank line separates each section.

### Imports

**Import types:**
- Namespace import: `import * as foo from '...';`
- Named import: `import {SomeThing} from '...';`
- Default import: only for external code requiring them
- Side-effect import: `import '...';` for side-effect-only libraries

**Import paths:**
- Use relative imports (`./foo`) for files within the same project
- Use absolute paths for cross-project imports
- Limit parent steps (`../../../`) — they make structure hard to understand

**Namespace vs named imports:**
- Prefer named imports for frequently used symbols with clear names
- Prefer namespace imports for large APIs with many symbols or common names (`Model`, `Controller`)
- Alias named imports with `as` when needed for clarity

**Renaming imports:**
- Use namespace import or rename exports to fix collisions
- May rename imports (`import {SomeThing as OtherThing}`) to avoid collisions or improve clarity

### Exports

- Use **named exports** in all code — no default exports
- `export type` for re-exporting types
- Minimize exported API surface
- No mutable exports (`export let` not allowed) — use getter functions instead
- For conditional exports, do the check first, then export the final value

### Container Classes

- Do not create container classes with static methods for namespacing
- Export individual constants and functions instead

### Import/Export Type

- Use `import type {...}` when imported symbol used only as type
- Use `export type` when re-exporting a type
- Use ES6 module syntax — no `require()`, no `namespace`, no `<reference>`

## Language Features

### Local Variable Declarations

- Use `const` by default, `let` if reassignment needed, never `var`
- One variable per declaration
- Variables must not be used before declaration

### Array Literals

- Do not use `Array` constructor — use bracket notation `[]`
- Do not define non-numeric properties on arrays — use `Map` or `Object`
- Spread syntax `[...foo]` allowed for shallow-copying/concatenating
- Array destructuring allowed — specify `[]` as default for optional destructured params

### Object Literals

- Do not use `Object` constructor — use `{}`
- Do not use unfiltered `for...in` — use `for...of Object.keys()` or filter with `hasOwnProperty`
- Spread syntax `{...bar}` allowed for shallow copy
- Computed property names allowed for symbols only
- Object destructuring: single level, unquoted shorthand, default values on left side

### Classes

**Declarations:**
- No semicolon after class declaration braces
- Class expressions must have semicolon

**Methods:**
- No semicolon after method declarations
- Single blank line between methods

**Static methods:**
- Prefer module-local functions over private static methods
- Do not rely on dynamic dispatch of static methods
- Must not use `this` in static context

**Constructors:**
- Must use parentheses: `new Foo()`
- Omit empty constructors or ones only delegating to parent
- Parameter properties: `constructor(private readonly bar: Bar)`
- Initialize fields at declaration when possible

**Class members:**
- No `#private` fields — use TypeScript `private`/`protected`
- Use `readonly` for never-reassigned properties
- Prefer parameter properties over manual initialization
- Initialize fields at declaration
- Properties used outside class scope must not be `private` (use `protected`/`public`)
- Getters must be pure functions (no side effects)
- No pass-through accessors — make property public or `readonly` instead
- Computed properties only for symbols

**Visibility:**
- Restrict visibility as much as possible
- Convert private methods to non-exported functions when possible
- TypeScript symbols are public by default — never use `public` modifier except for non-readonly public parameter properties

**Disallowed:**
- No direct `prototype` manipulation
- No mixins or modifying builtin prototypes

### Functions

- Prefer function declarations for named functions
- Arrow functions for callbacks and when explicit type annotation needed
- No function expressions — use arrow functions instead
- Arrow function bodies: concise when return used, block body when return unused (or use `void`)
- Never rebind `this` — use arrow functions or explicit parameters
- Prefer passing arrow functions as callbacks (explicit parameter forwarding)
- Classes should not contain arrow function properties (use anonymous functions at call site)
- Event handlers: arrow functions when no uninstall needed; arrow function properties when uninstall required
- Optional parameters: default initializers must have no side effects
- Use rest parameters instead of `arguments`
- Use spread syntax instead of `Function.prototype.apply`
- No blank lines at start/end of function body

### `this`

- Only in class constructors/methods, functions with explicit `this` type, or arrow functions in scope where `this` is valid
- Never use `this` for global object, `eval` context, event target, or unnecessary `call()`/`apply()`

### Interfaces

- Use interfaces for object type definitions
- Prefer `type` for unions, intersections, and other non-object types

### Primitive Literals

**Strings:**
- Single quotes `'` for ordinary strings
- Template literals `` ` `` for multi-line or complex concatenation
- No line continuations (backslash at end of line)

**Numbers:**
- Decimal, hex (`0x`), octal (`0o`), binary (`0b`) with lowercase prefixes
- No leading zero unless followed by `x`, `o`, or `b`

### Type Coercion

- Use `String()`, `Boolean()`, template literals, or `!!` for coercion
- **Never** convert enums to booleans with `Boolean()` or `!!` — compare explicitly
- Use `Number()` for parsing — check `NaN` explicitly
- No unary plus (`+`) for string-to-number
- No `parseInt`/`parseFloat` except for non-base-10 (validate input first)
- Use `Number()` + `Math.floor`/`Math.trunc` for integers

### Implicit Coercion

- No explicit boolean coercion in implicit boolean contexts (`if (!!foo)` → `if (foo)`)
- Enums: never implicitly coerce — compare explicitly

## Naming

### General

- Use `lowerCamelCase` for variables, parameters, functions, methods, properties
- Use `UpperCamelCase` for classes, interfaces, type aliases, enums
- Use `UPPER_SNAKE_CASE` for constants (module-level `const`/`readonly`)
- No single-letter names (except loop indices in tight scopes)
- No trailing/leading underscores for private — use visibility modifiers

### Test Names

- `describe`/`it` blocks: descriptive strings explaining behavior
- Test file: `<name>_test.ts` or `<name>.spec.ts`

## Comments

### JSDoc

- Top-level: `@fileoverview` for file description
- Exported symbols: JSDoc with description, `@param`, `@returns`, `@throws`
- Parameter properties: `@param` tag in constructor JSDoc
- Private/internal: JSDoc optional but encouraged

### Implementation Comments

- Explain **why**, not **what**
- Use `TODO:` for action items (not `@@` or `FIXME`)
- No commented-out code

## Formatting

### Indentation

- 2 spaces per level
- No tabs

### Line Length

- 100 characters maximum for TypeScript code
- Exceptions: long strings, import lines, comments with URLs

### Semicolons

- Always use semicolons

### Braces

- Braces on same line as statement (`if (condition) {`)
- Braces for all control structures, even single-line bodies
- `else` on same line as closing brace

### Trailing Commas

- Use trailing commas in multi-line objects, arrays, imports, exports, type parameters

### Type Annotations

- Annotate function parameters and return types for exported functions
- Local variables: type inference preferred, annotate when clarity improves

## Type Safety

### Strict Mode

- Code must compile with `strict: true` in `tsconfig.json`
- No `any` — use `unknown` when type truly unknown
- No `@ts-ignore` or `@ts-expect-error` without justification comment
- No non-null assertions (`!`) without justification

### Generics

- Use descriptive type parameter names (`T`, `TRequest`, `TResponse`)
- Constrain generics when possible

### Null Safety

- Prefer `undefined` over `null` for missing values
- Use `?` optional syntax for optional properties/parameters
- Handle `null`/`undefined` explicitly — no silent failures

## Testing

- Test files: `<name>_test.ts` or `<name>.spec.ts`
- Use `describe`/`it` from testing framework
- Follow testing-practices.md for hermetic, behavior-verifying tests
- Test type-only code with `import type` and type assertions

## Rationale

These rules adapt the Google TypeScript Style Guide for this framework's review pipeline. The guide emphasizes type safety, explicit contracts, and consistency across the codebase. Language-specific rules are loaded automatically by the review pipeline based on file extension.