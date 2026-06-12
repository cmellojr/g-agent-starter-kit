---
shortDescription: Reviews code and plans against the project's coding rules.
usedBy: [reviewer]
version: 0.1.0
lastUpdated: 2026-06-03
---

## Purpose

A code review without a checklist drifts toward gut feeling — catching whatever
the reviewer happens to notice while missing what they don't. This skill turns
the project's coding rules into a repeatable review procedure. It tells the
reviewer exactly what to inspect and in what order.

## Procedure

1. **Detect the language and load the Google Style Guide.** Identify the
   primary language of the changed files by extension:
   - `.py` → `rules/edicts/code-style-python.md`
   - `.go` → `rules/edicts/code-style-go.md`
   - `.sh` → `rules/edicts/code-style-shell.md`
   - `.rs` → `rules/edicts/code-style-rust.md`
   - `.md` → `rules/edicts/code-style-markdown.md`
   - Other/unclear → no language-specific guide, use only the general rules.
   Load the matching style guide alongside the general rules.

2. **Collect the applicable rules.** Load all files from `rules/edicts/` and
     `rules/counsel/` whose names start with `code-`. Also load any applicable
     `rules/commandments/`. Include the language-specific guide loaded in step
     1.
     Separate them into three tiers:
   - **Commandments** — violations are always blockers. No exceptions.
   - **Edicts** — violations require justification visible in the code (a
     comment, a design note, or a `.context.md` entry). If the justification is
     clear, it is a warning. If absent or unclear, it is a blocker.
   - **Counsel** — deviations are warnings. The code can ship, but the author
     should justify.

3. **Walk the work against every rule.** Check each statement in each loaded
     rule file against the changed code or plan. Do not skip rules, do not
     paraphrase
     — the rules are the source of truth. Look for:
   - Naming violations — evaluated against the **language-specific style guide**
     (e.g., `snake_case` for Python, `MixedCaps` for Go,
     `lower_case_with_underscores` for Shell).
   - Readability violations — clever patterns, dense one-liners, code that needs
     comments to be understood.
   - Testing violations — missing tests for complex logic, hardcoded secrets in
     tests. Evaluated against language-specific testing conventions.
   - Over-engineering — abstractions nobody asked for, unnecessary complexity,
     premature generalization.
   - Lint/type suppression markers — `@ts-ignore`, `type: ignore`, `noqa`,
     `eslint-disable`, `nolint`, `#nosec`, `NOLINT`, or equivalent. Each
     suppression bypasses the project's quality tooling. If a new suppression
     was
     added without an adjacent comment justifying it, it is a blocker.

4. **Classify findings.** For each issue found, assign a severity:
   - **Blocker** — commandment violation, unjustified edict violation. Must be
     fixed.
   - **Warning** — justified edict deviation, counsel deviation, minor
     inconsistency. Should be addressed.
   - **Note** — style suggestion beyond what rules mandate. No action required.

## Guardrails

- Never flag a counsel deviation as a blocker. Counsel is guidance, not law — it
  earns a warning, not a veto.
- Never invent rules. If an issue does not trace back to a loaded `code-` rule,
  it is a Note at most, not a Warning or Blocker.
- Do not invent violations. If a pattern match is ambiguous, skip it rather than
  rationalizing it into a finding.
