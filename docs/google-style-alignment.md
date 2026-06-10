# Google Style Alignment Plan

Plan to align the Agent Starter Kit's coding conventions, review practices, and tooling with [Google Style Guides](https://google.github.io/styleguide/) and [Google Engineering Practices](https://google.github.io/eng-practices/review/).

## Guiding Decisions

| Decision | Choice |
|---|---|
| Git workflow | Migrate from Conventional Commits to [How to Write a Git Commit Message](https://cbea.ms/git-commit/) (Google style) |
| Comments | Align with Google: docstrings required, inline comments explain **why** (not **what**) |
| Standard library | Prefer stdlib over external dependencies — reflected in Design review pass |
| Languages (now) | Python, Go, Shell, Rust, Markdown |
| Languages (roadmap) | TypeScript, JavaScript, Java, C++ |
| Testing on the Toilet | Roadmap |
| Rust style | Official [Rust Style Guide](https://doc.rust-lang.org/style-guide/) (Google does not maintain one) |
| Document language | English |

---

## Phase 1 — Language-Specific Style Rules

Create individual style guides in `rules/edicts/`:

| File | Reference | Key Topics |
|---|---|---|
| `rules/edicts/code-style-python.md` | [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html) | Line length 80, 4 spaces, `snake_case`, docstrings, `import x`, type annotations, exceptions, simple comprehensions |
| `rules/edicts/code-style-go.md` | [Google Go Style Guide](https://google.github.io/styleguide/go/guide) | `gofmt`, MixedCaps, no fixed line length, Least mechanism, clarity > concision |
| `rules/edicts/code-style-shell.md` | [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html) | Bash `#!/bin/bash`, 2 spaces, 80 cols, `local`, `main()`, `$(...)`, `[[...]]`, no `eval`, ShellCheck |
| `rules/edicts/code-style-rust.md` | [Rust Style Guide](https://doc.rust-lang.org/style-guide/) + [API Guidelines](https://rust-lang.github.io/api-guidelines/) | `rustfmt`, 4 spaces, 100 cols, naming conventions, `Result`, traits |
| `rules/edicts/code-style-markdown.md` | [Google Markdown Style Guide](https://google.github.io/styleguide/docguide/style.html) | 80 cols, ATX headings, fenced code blocks with language, `[TOC]`, reference links, no trailing whitespace |

**Effort:** 5 new files, 1 modified | **Priority:** critical

---

## Phase 2 — Update `rules/edicts/code-quality.md`

- **Keep:** KISS, DRY, SRP, Data Trust Boundary, Error Handling (must be logged), Process-killing exceptions
- **Remove:** sections now covered by language-specific guides (naming, imports, testing structure)
- **Add:** cross-references to each `code-style-*.md`
- **Add:** docstring requirement (aligned with Google)

**Effort:** 1 modified | **Priority:** high

---

## Phase 3 — Git (`rules/commandments/git.md`)

Migrate to Google style:
- Remove mandatory Conventional Commits prefixes
- Replace with [How to Write a Git Commit Message](https://cbea.ms/git-commit/) rules:
  - Subject line ≤ 50 characters, capitalized, no period, imperative mood
  - Body wrapped at 72 characters
  - Blank line between subject and body
- Downgrade branch naming from **commandment** to **counsel**

**Effort:** 1 modified | **Priority:** medium

---

## Phase 4 — Review Pipeline (Reviewer)

### 4.1 Update `personas/reviewer.md`

Revised playbook (6 passes):

1. Receive work (existing)
2. If plan → adversarial review (existing)
3. **Design pass** (NEW) — appropriateness, simplicity, maintainability, API design
4. Coherence pass (existing)
5. Quality pass (existing) — now evaluated against Google Style Guide
6. Security pass (existing)
7. **Documentation pass** (NEW) — `.context.md`, docstrings, README
8. Self-review SHIELD (existing)
9. Deliver (existing)

### 4.2 Create `skills/code-design-review.md` (NEW)

Checklist based on [Google Code Review — What to Look For](https://google.github.io/eng-practices/review/reviewer/):
- Is the code well-designed and appropriate for the system?
- Is the complexity justified?
- Would another developer easily understand it?
- Are abstractions necessary? (prefer stdlib over external deps)
- Could the code be simpler?

### 4.3 Create `skills/code-documentation-review.md` (NEW)

- `.context.md` and `docs/features.md` updated?
- Docstrings follow Google Style Guide for the language?
- README or relevant docs updated?

### 4.4 Update `skills/code-quality-review.md`

- Step 1: load **project rules + Google Style Guide** for the detected language
- Detect language by file extension to select the correct guide
- Naming violations: reference the specific guide (`snake_case` for Python, `MixedCaps` for Go)

### 4.5 Update `skills/reviewer-self-review.md` (SHIELD)

- Expand **S** (Scan All Passes Complete) to include **Design pass** and **Documentation pass**
- Both new passes must be mandatory like the existing ones

**Effort:** 2 new, 3 modified | **Priority:** high

---

## Phase 5 — Coder and Dispatch

### 5.1 Update `personas/coder.md`

- Step 4a: "Absorb local coding style **and consult the Google Style Guide for the language**"
- Reference new `rules/edicts/code-style-*` explicitly in the playbook

### 5.2 Update `skills/coder-self-review.md` (GRASP)

- **S (Style)** score 2 now requires: "follows Google Style Guide conventions for the language"
- **G (Guidelines)**: add docstring verification per applicable guide

### 5.3 Update `skills/dispatch.md`

- Step 6: detect language to include the correct Google Style Guide in `<rules>` block
- Example: task touches `.py` files → include `rules/edicts/code-style-python.md`

**Effort:** 3 modified | **Priority:** medium

---

## Phase 6 — Boot and Config

### 6.1 Update `skills/boot.md`

- Step 5: load rules index + **detect project languages**
- Suggest creating additional guides if uncovered languages are found

### 6.2 Update `rules/README.md`

- List all new `code-style-*` rules
- Add scopes: `coding-python`, `coding-go`, `coding-shell`, `coding-rust`, `coding-markdown`

**Effort:** 2 modified | **Priority:** medium

---

## Phase 7 — Contextualizer

### 7.1 Update `skills/context-maintenance.md`

- Add note: Constraints/Guidance sections may reference the applicable Google Style Guide

**Effort:** 1 modified | **Priority:** low

---

## Phase 8 — Adversarial Plan Review

### 8.1 Update `skills/reviewer-architect-adversarial.md`

- Step 6 (Standards checklist): verify plan against Google Style Guide for the language

**Effort:** 1 modified | **Priority:** low

---

## Roadmap (Future)

- **TypeScript/JavaScript Style Guides** — add when project needs them
- **Java/C++ Style Guides** — add when project needs them
- **Google Testing Best Practices** — [Testing on the Toilet](https://testing.googleblog.com/) series + structured testing guidance
- **Google Engineering Practices** — deeper integration with [How to Do a Code Review](https://google.github.io/eng-practices/review/reviewer/)

---

## Effort Summary

| Phase | New Files | Modified Files | Effort |
|---|---|---|---|
| 1 — Language style rules | 5 | 1 | critical |
| 2 — code-quality.md | 0 | 1 | high |
| 3 — Git | 0 | 1 | medium |
| 4 — Review pipeline | 2 | 3 | high |
| 5 — Coder/Dispatch | 0 | 3 | medium |
| 6 — Boot/Config | 0 | 2 | medium |
| 7 — Contextualizer | 0 | 1 | low |
| 8 — Plan review | 0 | 1 | low |
| **Total** | **7** | **13** | |

## Recommended Execution Order

```
Phase 1 ──► Phase 2 ──► Phase 4 ──► Phase 5 ──► Phase 3 ──► Phase 6 ──► Phase 7 ──► Phase 8
```

1. Language guides first (everything depends on them)
2. Update `code-quality.md` to reference them
3. Update reviewers to evaluate against them
4. Update coders and dispatch to use them
5. Git migration (independent)
6. Boot/config to auto-load them
7. Contextualizer and plan review (low-hanging fruit)
