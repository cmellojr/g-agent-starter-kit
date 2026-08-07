---
shortDescription: Reviews documentation — .context.md, docstrings, README, features.md.
usedBy: [reviewer]
version: 0.1.0
lastUpdated: 2026-06-03
---

## Purpose

Documentation that drifts from the code is worse than no documentation — it
misleads. This skill verifies that structural changes are reflected in
`.context.md` files, that public declarations have docstrings following the
applicable Google Style Guide, and that README and features.md are current.

## Procedure

1. **Detect language and load style guide.** Identify the primary language of
   the changed files by extension. Load the corresponding
   `rules/code/code-style-*.md` to determine the required docstring format.

2. **Check `.context.md` updates.** For each directory touched by the change:
   - Does a `.context.md` exist in that directory?
   - If yes: does the `.context.md` Summary section list the changed files?
   - If no: was the change structural (added/removed files, changed directory
     purpose)? If structural, a `.context.md` is needed — file a Warning.
   - Verify the `<context>` tag's `updated` date reflects the current change.

3. **Check docstrings.** For each new or modified public declaration:
   - Does it have a docstring? (Missing docstring on a public declaration is a
     Blocker per Google style.)
   - Does the docstring follow the format required by the language's style
     guide?
   - Does the docstring describe **what** and **why**, not trivially restate
     the code?

4. **Check README.** If the change affects the project's public interface,
   installation steps, configuration, or usage:
   - Does the README need updating? If yes and it was not updated, file a
     Warning.

5. **Check docs/features.md.** If the change adds, removes, or renames a
   user-facing feature:
   - Is the feature reflected in `docs/features.md`? If not, file a Warning.

6. **Classify findings.**
   - **Blocker** — Missing docstring on a public declaration (violates Google
     Style Guide). Structural change with no `.context.md` at all.
   - **Warning** — `.context.md` exists but is outdated. Docstring exists but
     does not fully follow format. README or features.md needs updating.
   - **Note** — Cosmetic documentation suggestions.

## Guardrails

- Never require docstrings on private/internal declarations unless the language
  style guide requires them.
- Never file a Blocker for missing README updates — only Warnings.
- Generated files and vendored directories are exempt from documentation review.
