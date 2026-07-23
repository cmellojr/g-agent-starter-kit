---
shortDescription: Git workflow rules — Google style commit messages.
scope: coding
version: 0.2.0
lastUpdated: 2026-06-03
---

## Statement

Commit messages MUST follow the structure prescribed by
[How to Write a Git Commit Message](https://cbea.ms/git-commit/):

1. **Subject line:** ≤ 50 characters, capitalized, no trailing period,
   imperative mood ("Add feature" not "Added feature").
2. **Blank line** between subject and body.
3. **Body:** wrapped at 72 characters, explains **what** and **why**,
   not **how**.

Branch naming SHOULD follow a descriptive pattern (`fix-login-timeout`,
`add-user-preferences`). Prefix-based branching (`feat-*`, `fix-*`) is
permitted but not required.

## Rationale

Well-crafted commit messages make git history readable, searchable, and useful
for code review, bisecting, and release notes. The Google style (cbea.ms) is
the standard at Google and produces consistent, informative histories.
