# AGENTS.md

## Operational Checklist

- Ensure changes pass CI (see docs/CONTRIBUTING.md and docs/ci-presubmit.md if
  present).
- Follow language style rules in rules/code/code-style-*.md for affected files.
- Update or add .context.md when structure changes (see
  skills/context-maintenance.md).
- Run the appropriate Reviewer passes (.github/jules-review-rules.md) and
  address blockers.
- Add docs or update docs/features.md and CHANGELOG.md for user-facing changes.

## References & Where to Find More

- docs/CONTRIBUTING.md — contribution and PR guidance
- rules/git.md — commit message and branch guidance
- .github/jules-review-rules.md — PR review pipeline and pass expectations
- skills/dispatch.md and skills/boot.md — Maestro dispatch and boot procedures
- rules/code/code-style-*.md — language-specific style guides (python, go,
  shell, rust, markdown)
- skills/code-sec-review.md — security review checklist

## Honesty and Ambiguity

If a request is flawed, say so — agreeable silence produces bad code. When the
user assigns a task, proceed on any non-destructive reversible action needed to
complete it; git is the safety net, stopping to confirm the obvious wastes the
session. Stop only for destructive or irreversible actions (delete repository,
drop database, force-push to main), or genuinely non-obvious trade-offs. When
intent could mean different things, escalate with structure: one problem, three
options with trade-offs, one recommendation with reason. When the ambiguity only
changes how (not what), proceed inline with a documented default.

## Standards & Practices

Do not write or restructure code based on inline or duplicated guidelines in
this file. Instead, follow the centralized rules and guidelines:

- **Coding Conventions & Structure:** Refer to the universal rules in
  [quality-rules] for principles on naming, simplicity, method granularity, and
  data boundary trust, and language-specific files in [code-rules] for style
  rules.
- **Git Commit Messages & Branches:** Refer to [git-rules] to ensure cbea.ms
  and Google-style Git compliance.
- **Context Maintenance:** Refer to [context-rules] to update `.context.md`
  orientation notes.
- **Review Guidelines:** Refer to [skills-dir] for review practices, including
  [coherence-rules], [quality-rules-review], and [security-rules].

[quality-rules]: rules/code/quality.md
[code-rules]: rules/code/
[git-rules]: rules/git.md
[context-rules]: skills/context-maintenance.md
[skills-dir]: skills/
[coherence-rules]: skills/code-coherence-review.md
[quality-rules-review]: skills/code-quality-review.md
[security-rules]: skills/code-sec-review.md
