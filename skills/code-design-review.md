---
shortDescription: Reviews code and plans for design quality — appropriateness, simplicity, maintainability.
usedBy: [reviewer]
version: 0.1.0
lastUpdated: 2026-06-03
---

## Purpose

Design review catches structural problems before they become code problems. This
skill implements the principles from
[Google Code Review — What to Look For](https://google.github.io/eng-practices/review/reviewer/),
focusing on whether the code is well-designed, appropriately complex, and
maintainable over time.

## Procedure

1. **Load the applicable Google Style Guide.** Detect the language of the
   changed files (by extension) and load the corresponding
   `rules/edicts/code-style-*.md` to understand the language's design
   philosophy.

2. **Evaluate design appropriateness.**
   - Does the code solve the right problem? Check against the acceptance
     criteria in the task brief or plan.
   - Is the design a natural fit for the system, or does it fight existing
     architecture?
   - Are the abstractions necessary? Prefer the simplest tool: language
     built-in → standard library → well-established library → custom
     abstraction.

3. **Evaluate simplicity.**
   - Could the code be simpler without losing correctness or performance?
   - Would another developer easily understand this code?
   - Are there unnecessary layers of indirection (extra interfaces, factories,
     adapters that add no value)?
   - Does the code use the **least mechanism** possible (per Google Go / general
     principle)?

4. **Evaluate maintainability.**
   - Is the code easy to modify correctly without deep knowledge?
   - Are APIs designed to grow gracefully (backward-compatible defaults,
     extensible parameters)?
   - Are dependencies minimized and explicit?
   - Does the code avoid hidden coupling (global state, implicit ordering
     requirements, magic strings)?

5. **Evaluate consistency.**
   - Does the code follow patterns already established in the codebase?
   - Are there multiple ways to do the same thing within the diff? If so,
     standardize.
   - Does the code align with the principles in the applicable Google Style
     Guide (clarity, simplicity, concision for Go; readability and type safety
     for Python; etc.)?

6. **Classify findings.**
   - **Blocker** — Design is fundamentally inappropriate for the problem.
     Unnecessary complexity that creates maintainability debt. Violates loaded
     style guide principles without justification.
   - **Warning** — Design could be simpler or more consistent. Minor
     architectural concerns that should be addressed but do not block the
     change.
   - **Note** — Design observations beyond the scope of the current change.
     Suggestions for future improvement.

## Guardrails

- Never flag simplicity as a blocker. Over-engineering is suboptimal, not
  broken.
- Never require perfection. "Good enough to ship and improve" is an acceptable
  outcome.
- If the code is a direct implementation of a reviewed plan, defer to the
  plan's design decisions unless new information emerged during implementation.
