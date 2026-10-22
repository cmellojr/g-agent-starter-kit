# Feature Map

> Auto-maintained index of every user-facing feature and the code path that
> implements it. Updated alongside the code — not after the fact.

## Boot

Automatically initializes the framework session, pulls updates, configures CLI
agent bindings, and detects active languages.

**Flow:**

1. `AGENTS.md` — entrypoint file for AI agents to load the Maestro conductor
2. `personas/maestro.md` — orchestration persona that executes the boot
   sequence
3. `skills/boot/SKILL.md` — procedure for the framework update, memory load,
   and rules/language detection
4. `scripts/sync-framework.sh` — pulls the `.agents/` clone and reports the
   commit before and after
5. `skills/assets/maestro-boot-configure-cli.sh` — configures persona CLI
   bindings in `opencode.json`

---

## Dispatch

Assembles sub-agent prompts with required context (identity, rules, skills)
and routes them to the correct provider CLI or native API.

**Flow:**

1. `personas/maestro.md` — parses task, selects persona, and triggers subagent
   dispatch
2. `skills/dispatch/SKILL.md` — resolves model routing, filters rules/skills,
   and wraps the payload
3. `personas/` — directory of specialized personas that receive and execute the
   task

---

## Memory

Learns from user feedback and corrections, updates session logs, and retains
project-specific preferences and notes across runs.

**Flow:**

1. `personas/maestro.md` — intercepts feedback signals and distills lessons at
   checkpoints
2. `skills/agent-memory/SKILL.md` — reads and updates session logs and long-term
   memory
3. `.memory/long-term.md` — persistent file containing preferences, learned
   rules, and issues
4. `.memory/session/` — directory containing active or paused session log files

---

## Task Tracking

Tracks progress of complex multi-step tasks across session boundaries using
file-based to-do logs.

**Flow:**

1. `personas/maestro.md` — orchestrates the creation and resuming of to-do
   checklists
2. `skills/task-tracking/SKILL.md` — coordinates the checklist life cycle and
   status updates
3. `.memory/todo/` — directory containing active markdown check lists and
   chronological logs

---

## Review

Measures changed lines of code, scopes review passes, and evaluates plans and
implementations for design, quality, security, and docs.

**Flow:**

1. `personas/maestro.md` — routes plan or code output to the review pipeline
2. `skills/review-loop/SKILL.md` — measures changed LOC, splits large scopes,
   and determines review focus
3. `personas/reviewer.md` — runs the code and plan review passes
4. `skills/code-design-review/SKILL.md` — design pass evaluating simplicity and
   correctness
5. `skills/code-coherence-review/SKILL.md` — coherence pass evaluating imports,
   errors, and warnings
6. `skills/code-quality-review/SKILL.md` — quality pass loading
   language-specific rules for style
7. `skills/code-sec-review/SKILL.md` — security pass evaluating data trust
   boundaries and vulnerabilities
8. `skills/code-documentation-review/SKILL.md` — documentation pass checking
   docstrings and context updates
9. `skills/reviewer-self-review/SKILL.md` — reviewer self-review gate (SHIELD)
   evaluating review quality
10. `skills/reviewer-handoff/SKILL.md` — formats the verdict, coverage, and
    findings
    for the conductor

---

## Resiliency & Production Standards (SRE)

Integrates Google SRE practices for production stability into code quality rules.

**Flow:**

1. `rules/code/quality.md` — universal quality conventions extended with:
   - **Resilient Error Handling** (lines 95–115): truncated exponential backoff with jitter, per-request retry budget (3–6 attempts), per-client retry budget (≤10% retry ratio), retry attempt counters, "overloaded; don't retry" server responses
   - **Structured Logging** (lines 117–148): JSON-only log entries, required fields (timestamp, severity, message, service, trace_id, span_id), recommended fields (operation_id, user_id, labels, source_location), correct log level usage, secrets/PII prohibition
2. `rules/code/quality.md` frontmatter — version 0.4.0, updated 2026-10-21

---

## Frontend & Web Style Guides

Official Google-aligned style guides for TypeScript, HTML, and CSS.

**Flow:**

1. `rules/code/code-style-typescript.md` — Google TypeScript Style Guide:
   - Source file basics (encoding, structure, imports, exports)
   - Language features (variables, arrays, objects, classes, functions)
   - Type safety (strict mode, generics, null safety)
   - Naming, comments, formatting conventions
2. `rules/code/code-style-html-css.md` — Google HTML/CSS Style Guide:
   - General rules (protocol, indentation, capitalization, encoding)
   - HTML style (validity, semantics, multimedia, separation of concerns)
   - CSS style (validity, class naming, shorthand, formatting)
   - CSS formatting (declaration order, indentation, rules separation)
2. `rules/README.md` — updated rules index with new guides
3. `skills/boot/SKILL.md` — language detection for `.ts`, `.tsx`, `.html`, `.css`, `.scss`, `.sass`
4. `skills/dispatch/SKILL.md` — language detection for style guide loading
5. `docs/roadmap.md` — Phase 13 marked complete

---
