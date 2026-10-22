# Roadmap: Google Engineering Practices Integration

This document outlines the consolidation of style guides, engineering practices,
and development standards to align the **G-Agent Starter Kit** with Google
software engineering standards.

[TOC]

## Status Overview

| Phase | Item | Status |
|---|---|---|
| **Phase 1** | Language-Specific Style Rules (Py, Go, Sh, Rs, Md) | **Done** |
| **Phase 2** | Universal Code Quality Principles | **Done** |
| **Phase 3** | Google-Style Git Workflow | **Done** |
| **Phase 4** | Enhanced Review Pipeline (Design & Doc passes) | **Done** |
| **Phase 5** | Coder & Dispatch Alignment | **Done** |
| **Phase 6** | Boot & Configuration (Language Detection) | **Done** |
| **Phase 7** | Context Maintenance Alignment | **Done** |
| **Phase 8** | Adversarial Plan Review Alignment | **Done** |
| **Phase 9** | CL Author Guidelines (Small CLs) | **Done** |
| **Phase 10** | API Design Standards | **Done** |
| **Phase 11** | Software Testing Principles (Testing on the Toilet) | **Done** |
| **Phase 12** | Resiliency and Production Standards (SRE) | **Done** |
| **Phase 13** | Frontend & Web Style Guides (TS, HTML/CSS) | **Done** |
| **Phase 14** | Code Reviewer's Guide Integration | **Pending** |
| **Phase 15** | Framework Distribution (clone-based `.agents`) | **Done** |

---

## Completed Phases

### Phase 1 — Language-Specific Style Rules

- Created individual style guides in `rules/code/` for Python, Go, Shell,
  Rust, and Markdown.
- Aligned with official Google Style Guides (or Rust community standards).

### Phase 2 — Universal Code Quality

- Updated `rules/code/quality.md` to focus on cross-language principles
  (KISS, DRY, SRP).
- Added mandatory docstring requirements and data trust boundary rules.

### Phase 3 — Git Workflow

- Migrated `rules/commandments/git.md` to follow [cbea.ms](https://cbea.ms/git-commit/) (Google style).
- Standardized subject lines (50 chars) and body wrapping (72 chars).

### Phase 4 — Review Pipeline

- Updated `personas/reviewer.md` with new **Design** and **Documentation**
  passes.
- Created `skills/code-design-review/SKILL.md` and
  `skills/code-documentation-review/SKILL.md`.
- Updated SHIELD rubric (`skills/reviewer-self-review/SKILL.md`) to include new
  passes.

### Phase 5 — Coder and Dispatch

- Updated `personas/coder.md` to require consulting Google Style Guides.
- Updated GRASP rubric (`skills/coder-self-review/SKILL.md`) for style scores.
- Updated `skills/dispatch/SKILL.md` with automatic language detection for rules
  loading.

### Phase 6 — Boot and Config

- Updated `skills/boot/SKILL.md` to detect project languages during startup.
- Updated `rules/README.md` with the new rules index.

### Phase 7 — Context Maintenance

- Updated `skills/context-maintenance/SKILL.md` to reference Google Style
  Guides in
  `.context.md` files.

### Phase 8 — Adversarial Plan Review

- Updated `skills/reviewer-architect-adversarial/SKILL.md` to verify plans
  against
  language-specific style guides.

### Phase 9 — CL Author Guidelines

- Updated `personas/coder.md` playbook with "Small CLs" principles.
- Updated `skills/coder-self-review/SKILL.md` to enforce technical reasoning in
  commit messages and PR descriptions.

### Phase 10 — API Design Standards

- Created `rules/code/api-design.md` for resource naming and standard methods.
- Updated `personas/architect.md` to consult the API design rules.

### Phase 11 — Software Testing Principles

- Created `rules/code/testing-practices.md` with cross-language testing
  principles
  derived from Google's Testing on the Toilet.
- Covers hermetic tests, behavior verification, and input-value strategy.
- Updated `rules/.context.md`, `rules/code/.context.md`, and `rules/README.md`
  to reference the new rule.

---

## Future Implementation Plan

### Phase 12 — Resiliency and Production Standards (SRE)

*   **Goal**: Integrate production stability into code quality.
*   **Actions**:
    *   Update `rules/code/quality.md` with resilient error handling
      (backoff/jitter) and structured logging.
*   **Completed**: 2026-10-21
*   **Changes**:
    *   `rules/code/quality.md` v0.4.0 — added **Resilient Error Handling** (truncated exponential backoff with jitter, per-request retry budget 3-6, per-client retry budget ≤10%, retry attempt counters, "overloaded; don't retry" server responses, safe-to-retry codes only)
    *   `rules/code/quality.md` v0.4.0 — added **Structured Logging** (JSON-only, required fields: timestamp RFC3339, severity, message, service, trace_id, span_id; recommended: operation_id, user_id/request_id, labels, source_location; correct log levels DEBUG/INFO/WARNING/ERROR/CRITICAL; secrets/PII prohibition)
    *   `docs/FEATURE-MAP.md` — added "Resiliency & Production Standards (SRE)" feature entry
*   **Reference**: [Google SRE Books](https://sre.google/books/), [Cloud Logging](https://cloud.google.com/logging/docs/structured-logging), [Cloud IAM Retry Strategy](https://cloud.google.com/iam/docs/retry-strategy)

### Phase 13 — Frontend & Web Style Guides

*   **Goal**: Official Google-aligned guides for TypeScript, HTML, and CSS.
*   **Completed**: 2026-10-22
*   **Actions**:
    *   Created `rules/code/code-style-typescript.md` — Google TypeScript Style Guide
    *   Created `rules/code/code-style-html-css.md` — Google HTML/CSS Style Guide
    *   Updated `rules/README.md` — added new guides to rules index
    *   Updated `.agents/rules/code/.context.md` — added new guides to summary
    *   Updated `.agents/skills/boot/SKILL.md` — added `.ts`, `.tsx`, `.html`, `.css`, `.scss`, `.sass` to language detection
    *   Updated `.agents/skills/dispatch/SKILL.md` — added language detection for new extensions
    *   Updated `docs/FEATURE-MAP.md` — added feature entry
    *   Updated `docs/roadmap.md` — marked phase complete
*   **Reference**: [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html), [Google HTML/CSS Style Guide](https://google.github.io/styleguide/htmlcssguide.html)

### Phase 14 — Code Reviewer's Guide Integration

*   **Goal**: Align AI reviewer behavior, comments, and tone with Google's
    code reviewer standards.
*   **Actions**:
    *   Incorporate the standard of code review (helpfulness, focus on
        improving code quality over personal preference, distinguishing blocking
        vs. optional comments) into the reviewer persona playbook and review
        rules.
    *   Standardize the review comments structure to focus on the "why" and
        "how to fix" rather than just highlighting issues.
    *   Define guidance for the AI reviewer on handling user pushback and
        managing review cycles constructively.
*   **Reference**: [Google Code Reviewer's Guide](https://google.github.io/eng-practices/review/reviewer/).

### Phase 15 — Framework Distribution

*   **Goal**: Run the published framework from a git clone instead of a file
    mirror.
*   **Actions**:
    *   Replace the `.agents/` symlink mirror with a clone that tracks
        `origin/main`.
    *   Refresh the clone at session start with
        `.agents/scripts/sync-framework.sh`.
    *   Keep `--track <ref>` as an opt-in for testing non-stable refs.

## See also

*   [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
*   [Google Go Style Guide](https://google.github.io/styleguide/go/guide)
*   [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
*   [Google Markdown Style Guide](https://google.github.io/styleguide/docguide/style.html)
*   [Google Engineering Practices](https://google.github.io/eng-practices/)
