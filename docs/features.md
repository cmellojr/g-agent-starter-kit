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
3. `skills/boot.md` — procedure for Git pull, memory load, and rules/language
   detection
4. `skills/assets/maestro-boot-configure-cli.sh` — configures persona CLI
   bindings in `opencode.json`

---

## Dispatch

Assembles sub-agent prompts with required context (identity, rules, skills)
and routes them to the correct provider CLI or native API.

**Flow:**

1. `personas/maestro.md` — parses task, selects persona, and triggers subagent
   dispatch
2. `skills/dispatch.md` — resolves model routing, filters rules/skills, and
   wraps the payload
3. `personas/` — directory of specialized personas that receive and execute the
   task

---

## Memory

Learns from user feedback and corrections, updates session logs, and retains
project-specific preferences and notes across runs.

**Flow:**

1. `personas/maestro.md` — intercepts feedback signals and distills lessons at
   checkpoints
2. `skills/agent-memory.md` — reads and updates session logs and long-term
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
2. `skills/task-tracking.md` — coordinates the checklist life cycle and status
   updates
3. `.memory/todo/` — directory containing active markdown check lists and
   chronological logs

---

## Review

Measures changed lines of code, scopes review passes, and evaluates plans and
implementations for design, quality, security, and docs.

**Flow:**

1. `personas/maestro.md` — routes plan or code output to the review pipeline
2. `skills/review-loop.md` — measures changed LOC, splits large scopes, and
   determines review focus
3. `personas/reviewer.md` — runs the code and plan review passes
4. `skills/code-design-review.md` — design pass evaluating simplicity and
   correctness
5. `skills/code-coherence-review.md` — coherence pass evaluating imports,
   errors, and warnings
6. `skills/code-quality-review.md` — quality pass loading language-specific
   edicts for style rules
7. `skills/code-sec-review.md` — security pass evaluating data trust boundaries
   and vulnerabilities
8. `skills/code-documentation-review.md` — documentation pass checking
   docstrings and context updates
9. `skills/reviewer-self-review.md` — reviewer self-review gate (SHIELD)
   evaluating review quality
10. `skills/reviewer-handoff.md` — formats the verdict, coverage, and findings
    for the conductor

---
