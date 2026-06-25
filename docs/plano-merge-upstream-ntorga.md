# Merge Plan: upstream/ntorga → cmellojr fork

## Goal

Integrate upstream ntorga's 26 commits (v0.7.4–v0.8.5) into the cmellojr fork,
resolving all 10 merge conflicts while preserving fork-specific additions.

## Current State (Before)

The cmellojr fork contains additions not present in upstream:
- `.context.md` in multiple directories (root, docs/, personas/, rules/, skills/)
- `docs/features.md`, `docs/roadmap.md`
- New rules: `rules/edicts/api-design.md`, `code-style-go.md`,
  `code-style-markdown.md`, `code-style-python.md`, `code-style-rust.md`,
  `code-style-shell.md`
- Scripts: `skills/assets/check_markdown.py`, `wrap_markdown.py`
- CL Author Guidelines incorporated into `personas/coder.md`
- Enhanced Jules workflows in `.github/workflows/`
- Rebrand to "G-Agent Starter Kit" in README
- Markdown compliance changes across multiple files

The upstream ntorga introduced:
- Persona identities trimmed to 1 paragraph (v0.8.1)
- Coder: humor `pragmatic→robotic`, modelTier `tier-2→tier-1`
- Contextualizer: humor `introvert→robotic`
- Maestro: rewritten identity + Observations step in Playbook
- Reviewer: complete rewrite (from "three critics" to "safety net")
- Review-loop: complete rewrite (removed shapeshifter, task-driven focus)
- Reviewer-self-review: SHIELD rubric rewritten (S, H, E, L, D)
- Agent-memory: consolidated init + Observations section in schema
- Dispatch: Observations added to sub-agent notes
- Boot CLI script: robotic humor, git command blocking, dual-format thinking
- Boot CLI test: version fields and new test cases

## Target State (After)

After completion, the cmellojr fork will contain all upstream improvements
(updated personas, rewritten reviewer, Observations convention, enhanced CLI)
while fully preserving fork-specific additions (.context.md files, docs/,
style rules, compliance scripts, CL Author Guidelines, Jules workflows,
rebranding).

## Affected Areas

- **Personas** (`personas/`) — architect, coder, contextualizer, maestro, reviewer
- **Skills** (`skills/`) — agent-memory, dispatch, review-loop, reviewer-self-review
- **Assets** (`skills/assets/`) — maestro-boot-configure-cli.sh,
  maestro-boot-configure-cli_test.sh
- **Changelog** (`CHANGELOG.md`)
- **Overall integrity** — merge must compile with zero residual conflict markers

## Implementation Phases

### Phase 0: Backup and preparation (LOC: ~5)

**Files:** None (git branch)

- Create working branch: `git checkout -b merge-upstream-ntorga`
- **Acceptance criteria:** Branch created from `main`, no changes.
- **Dependencies:** None.

### Phase 1: Auto-merged files (LOC: ~60)

**Files:**
- `skills/assets/maestro-boot-configure-cli.sh` (auto-merged, needs review)
- `CHANGELOG.md` (auto-merged, needs review)

**Actions:**
- Verify auto-merge of CLI script is correct (robotic humor, git blocking,
  dual-format thinking — significant changes)
- Merge CHANGELOG entries: preserve both timelines (fork + upstream)
- **Acceptance criteria:** Both files reflect upstream + fork content.
- **Dependencies:** Phase 0.

### Phase 2: Base skills — no structural conflict (LOC: ~80)

**Files:**
- `skills/agent-memory.md`
- `skills/dispatch.md`

**Resolution strategy:**
- **agent-memory.md:** Accept upstream for consolidated directory init
  (`.memory/plan/`, `.memory/todo/`, `.memory/reviews/`) + Observations
  section in schema. Preserve fork content for existing procedures not
  overwritten by upstream (e.g., session memory details).
- **dispatch.md:** Accept upstream for the Observations block in notes.
  Preserve remaining fork content.

- **Acceptance criteria:** Both skills merged with upstream + fork content.
- **Dependencies:** Phase 1.

### Phase 3: Personas with simple identity conflicts (LOC: ~40)

**Files:**
- `personas/architect.md`
- `personas/contextualizer.md`

**Resolution strategy:**
- **architect.md:** Accept upstream's trimmed identity (1 paragraph). Keep
  upstream version/lastUpdated. Playbook is identical in both — no real
  conflict beyond identity.
- **contextualizer.md:** Accept upstream's trimmed identity + robotic humor.
  Keep playbook structure (identical in both).

- **Acceptance criteria:** Identities updated to upstream's concise versions.
- **Dependencies:** Phase 2 (agent-memory defines Observations, which
  contextualizer may reference).

### Phase 4: Coder — identity conflict + config changes (LOC: ~80)

**Files:**
- `personas/coder.md`

**Resolution strategy:**
- Accept upstream changes: humor `robotic`, modelTier `tier-1`
- Accept upstream's trimmed identity
- **PRESERVE** CL Author Guidelines added by fork in Playbook

**Specific conflict:** Upstream replaced the coder's identity. The fork added
CL Author Guidelines as a Playbook step. Solution: take upstream's identity
and merge the Playbook while keeping the fork's CL Author Guidelines steps.

- **Acceptance criteria:** Coder with upstream's concise identity, modelTier
  tier-1, humor robotic, and CL Author Guidelines preserved.
- **Dependencies:** Phase 3.

### Phase 5: Maestro — identity + Observations (LOC: ~100)

**Files:**
- `personas/maestro.md`

**Resolution strategy:**
- Accept upstream's rewritten identity (1 paragraph, more direct)
- Accept new **Observations** step in Playbook (step 7 bullet)
- Preserve fork's general Playbook structure — the real difference is a few
  phrasing changes and the Observations step

**Specific conflict:** Upstream rewrote the identity and added "Observations"
in the "Deliver" section. The fork kept the original identity and added
"Observations" in "Deliver" too, but in a different format. Solution: take
upstream's identity + upstream's Observations block.

- **Acceptance criteria:** Maestro with concise identity and Observations
  integrated.
- **Dependencies:** Phase 2 (agent-memory Observations schema).

### Phase 6: Review system — complete rewrite (LOC: ~250)

**Files:**
- `personas/reviewer.md`
- `skills/review-loop.md`
- `skills/reviewer-self-review.md`

**Resolution strategy:**
- **reviewer.md:** Accept full upstream version (safety net). The rewrite is
  significant: identity, playbook, red lines — everything changed. The fork
  had no substantial changes beyond metadata.
- **review-loop.md:** Accept full upstream version (task-driven focus, removed
  shapeshifter). The fork did not alter this file significantly.
- **reviewer-self-review.md:** Accept full upstream version (new SHIELD
  rubric: S→scan required passes, H→hold findings firm, E→edicts traced,
  L→lines traced, D→dependencies & external factors). The fork did not alter
  this file.

**Risk:** These are the deepest upstream changes. Resolution must be verified
with `git diff --check` to ensure no residual conflict markers.

- **Acceptance criteria:** Reviewer, review-loop, and self-review identical to
  upstream, with zero residual conflict markers.
- **Dependencies:** Phase 5 (maestro references review-loop).

### Phase 7: Test files (LOC: ~30)

**Files:**
- `skills/assets/maestro-boot-configure-cli_test.sh`

**Resolution strategy:**
- Accept upstream (version with robotic humor, new test cases for git
  blocking, reasoningEffort validation). Version/updated metadata is trivial.

- **Acceptance criteria:** Test file updated with upstream's new test cases.
- **Dependencies:** Phase 1 (CLI script is prerequisite for tests).

### Phase 8: Final merge and verification (LOC: ~10)

**Files:** None (git commands)

- Run `git merge --continue` or `git commit` to finalize the merge
- Run `git diff --check` to ensure zero conflict markers remain
- Verify clean tree: `git status`
- Run validation scripts if they exist
- **Acceptance criteria:** Merge commit created, zero residual conflicts,
  clean tree.
- **Dependencies:** Phases 1–7.

## Estimated Total LOC

| Phase | Description | Estimated LOC |
|-------|-------------|--------------|
| 0 | Backup and preparation | ~5 |
| 1 | Auto-merged files | ~60 |
| 2 | Base skills | ~80 |
| 3 | Simple persona conflicts | ~40 |
| 4 | Coder | ~80 |
| 5 | Maestro | ~100 |
| 6 | Review system | ~250 |
| 7 | Test files | ~30 |
| 8 | Final merge and verification | ~10 |
| **Total** | | **~655** |
