# G-Agent Starter Kit — Google Style Edition

> Describe what you need in plain language. Work directly in quick mode, or boot
the Maestro to break complex tasks into specialized sub-agent work. The Maestro
routes each task to specialized personas and checks it against the relevant
Google Style Guides.

[TOC]

G-Agent Starter Kit is a Natural Language AI Harness (NLAH) — multi-model, pure
Markdown, zero dependencies — pre-configured with Google Style Guides for
Python, Go, Shell, Rust, and Markdown. The smartest model orchestrates while
cheaper, faster ones handle the routine work — extending your premium coding
plan instead of burning it on everything.

It's model-agnostic: orchestrate on Claude, plan on Gemini or Kimi, review on
Qwen or DeepSeek — or any combination you choose. Code is reviewed against
[Google Engineering Practices][eng-practices] at every stage.

This is a **foundation**, not a finished product. It ships general-purpose
personas, common workflow skills, and opinionated rules aligned with [Google
Style Guides][styleguide] and [Google Engineering Practices][eng-practices].
Language-specific style rules live in `rules/code/code-style-*.md`. Anything
domain-specific or highly opinionated beyond this belongs in your own fork.
Clone it, extend it, make it yours — or build one for your entire company.

## How It Works

The **Maestro** is the conductor. It receives user requests, decomposes them,
and dispatches work to specialized personas:

- **Architect** — plans implementations, defines before/after states
- **Coder** — writes software following the plan
- **Reviewer** — checks work for design, coherence, quality (against Google
  Style Guides), security (OWASP), and documentation completeness
- **Contextualizer** — documents project structure for orientation

Each persona has an identity (who they are), a playbook (what they do), a
handoff format (what they deliver), and red lines (what they must not do).

Each persona also declares a `humor` style — which controls temperature and
thinking budget — plus a self-review rubric that scores its own work before
delivery. The `preferredModel` field routes work to the right provider
automatically. You can route every persona to the same model and skip
multi-provider routing entirely if you prefer.

The framework **learns as it works**. Corrections, preferences, and lessons
are captured to long-term memory and carried into every future session.
Interrupted work is tracked in session files so the next boot can resume where
the last one stopped.

## Setup

1. Clone into `.agents/` inside your software project:

   ```bash
   cd /path/to/your/project
   git clone https://github.com/cmellojr/g-agent-starter-kit.git .agents
   ```

The `.agents/` directory lives inside your project — it's not a plugin you
install once. Each project gets its own copy of the framework.

2. Symlink the entry file to the project root:

   ```bash
   ln -s .agents/AGENTS.md AGENTS.md
   ```

3. Start the AI agent interface (e.g., `claude`, `opencode`, or whatever CLI/TUI
   you use).

4. As the first message of every session, choose a mode:

   - **Full orchestration:** boot the Maestro to decompose, plan, dispatch, and
     review multi-step work:

     ```text
     Please comply with @.agents/ENTRYPOINT.md file.
     ```

   - **Quick work (default):** just type your request. The CLI auto-loads
     `AGENTS.md` — your style book is already in context. No boot phrase needed.

5. Describe what you want to build, fix, or change. In full orchestration mode,
   the Maestro breaks it down, dispatches to specialized personas (Architect
   plans, Coder implements, Reviewer validates), and delivers the result.

6. On first run in full orchestration mode, the Maestro automatically
   dispatches the Contextualizer to map the codebase before doing anything
   else.

7. (Optional) Customize — add personas, rules, skills, and providers to fit your
   project (see Customization below).

### OpenCode Configuration

The framework works with any AI CLI — Claude Code, Codex, opencode, or any tool
that can accept a prompt via `stdin`. No harness requires special configuration
to use the personas, rules, and skills. OpenCode is the first-class supported
target with native persona agent binding.

If you're running OpenCode and have [`yq`][yq-link] and [`jq`][jq-link]
installed, the boot sequence auto-detects it and writes `opencode.json` at the
project root with persona agent bindings.

**On the first run, `opencode.json` is created from scratch — restart the CLI
so the new agent bindings are picked up.**

Each persona gets a named agent with its model (read from frontmatter),
humor-based temperature and thinking budget, and permission profiles. The
script is idempotent — subsequent runs update existing bindings rather than
create duplicates.

If the tools aren't installed or you're using a different CLI, the script
exits silently and no configuration is needed.

## Structure

```text
personas/    Specialized AI roles (who does the work)
rules/       Constraints organized by authority level
  code/      code-style-python.md, code-style-go.md, code-style-shell.md, code-style-rust.md, code-style-markdown.md, plus debugging and quality guidance
skills/      Reusable procedures and protocols
docs/        roadmap.md — alignment plan and roadmap
```

## Rules Hierarchy

- **Commandments** — absolute, never bypassed
- **Code rules** — authoritative within scope, applicable to implementation and
  review
- **Other guidance** — supporting context and project-specific direction

The `rules/code/` directory includes the language-specific Google Style Guides
and related code-quality guidance (`code-style-python.md`, `code-style-go.md`,
`code-style-shell.md`, `code-style-rust.md`, `code-style-markdown.md`,
`debugging.md`, `quality.md`). These are the authoritative reference for coding
conventions — code is evaluated against them during the Quality review pass.

## Skills

Skills codify procedures that personas reference. They answer "how to do X" so
personas can focus on "what to do."

- **agent-decision** — persona decision-making framework with self-review
  rubrics
- **agent-memory** — long-term and session memory across sessions
- **architect-self-review** — DRAFT self-review rubric — plan quality gate
- **boot** — session startup sequence (full boot for complex features)
- **code-coherence-review** — logic coherence, correctness, and structural
  integrity checks
- **code-quality-review** — rules-walk procedure for coding standards compliance
- **code-sec-review** — OWASP-aligned security code review checklist
- **coder-self-review** — GRASP self-review rubric — implementation quality
  gate
- **context-maintenance** — schema and rules for `.context.md` files
- **contextualizer-self-review** — TRACE self-review rubric — context
  generation quality gate
- **dispatch** — how the Maestro assembles and sends work to personas
- **loop-recovery** — structured recovery and escalation for retry loops
- **review-loop** — LOC-based review tier selection with shapeshifter dispatch
- **reviewer-architect-adversarial** — adversarial plan validation and
  assumption attack
- **reviewer-handoff** — structured review summary format with verdict logic
- **reviewer-self-review** — SHIELD self-review rubric — unified reviewer
  quality gate
- **task-tracking** — file-based to-do for multi-step work

## Customization

- **Dispatch** — edit `skills/dispatch.md` to match your CLI agents and
  provider routing. The Providers list and CLI Dispatch section are
  pre-configured for Claude Code, Codex, Cursor, DeepSeek, Gemini, and Qwen.
  Each persona defaults to `host`, which uses whatever model your CLI provides,
  so you can start without extra configuration. Add entries for any other
  provider/model you use.
- Add new personas to `personas/` following the schema in `personas/README.md`
- Add rules to `rules/`
- Add skills to `skills/` following the schema in `skills/README.md`
- Modify existing files to match your project's needs
- **AGENTS.md** — edit to add your project's coding conventions,
  language-specific rules, or personal preferences. This file loads
  automatically in quick mode, so anything you add here shapes every session
  without booting the Maestro.

Each directory has a README with the full schema definition.

- **Google Style Guides** — edit `rules/code/code-style-*.md` to tune
  conventions per language. The review pipeline loads these automatically
  based on file extension (see `docs/roadmap.md` for the full roadmap).

## FAQ

### Why this over other harnesses?

GSD, GStack, and Gas Town are software — they lock you into dependencies,
runtimes, and rigid workflows. G-Agent Starter Kit is **pure natural
language**\*.
Every persona, rule, and skill is a Markdown file you can edit with zero
installation or build step.

Most harnesses are built around dense, expensive models and burn thousands of
tokens on guidance you'll never use. This kit is a **scalpel**: minimal by
design, tuned for cheaper MoE models like DeepSeek, GLM, Kimi, and Qwen. You pay
only for the context you need. When your project grows, you extend it — add a
persona, tweak a rule, swap a provider — all in plain text. Other tools produce
code once and walk away. This framework learns, remembers, and adapts across
every session.

*\* Almost — one optional shell script for OpenCode auto-configuration and a
YAML provider list in `skills/dispatch.md`. No runtimes, no dependencies, no
build steps.*

### Full orchestration or quick mode — which do I use?

**Full orchestration** boots the Maestro — an orchestrator that decomposes your
request, plans with the Architect, dispatches to the Coder, validates with the
Reviewer, and maps the codebase with the Contextualizer. It carries memory
across sessions, tracks work in to-do files, and manages a review pipeline. Use
it for complex multi-step work where you want structured planning, adversarial
review, or cross-session memory.

**Quick mode** is the default. Just type your request and the CLI works on it
directly — your `AGENTS.md` style book is auto-loaded so the agent follows your
coding conventions without any boot ceremony. Use it for everyday work: bug
fixes, features, refactors, anything where you know what you want and just need
it done.

The trade-off is speed vs. structure. Quick mode is faster and cheaper — one
agent, no overhead. Full orchestration is more thorough — multiple specialized
agents, review gates, and resumable state — but costs more tokens and requires a
boot phrase each session.

### Why multi-model?

Coding plans are routinely quantized and rate-limited weeks after launch — the
version you fell in love with gradually loses sharpness as the provider
optimizes for throughput. A multi-model harness fights this in three ways:

1. **Resilience.** Spreading work across providers means you're less affected
   when any single plan degrades. If one provider tightens limits or loses
   quality, shift that persona's `preferredModel` to another entry in the
   Providers list.
2. **Token conservation.** The orchestrator (Maestro) only handles routing and
   decomposition. Token-heavy roles like Architect and Coder are delegated to
   other capable models, so your premium plan lasts longer.
3. **Fresh eyes.** Different models catch different things. A reviewer running
   on a separate provider will flag issues that the coder's model normalized.

### What do I need to run this?

A coding plan or API key for each provider you route to. We recommend coding
plans — **Claude Code** (Anthropic), **Codex** (OpenAI), and **OpenCode Go**
(DeepSeek, Qwen, Kimi, GLM, and more via the `opencode` CLI) offer
flat-rate pricing with generous token allowances designed for agentic
workflows. API keys work too, but plans are more cost-effective for sustained
use. Each provider needs its CLI tool installed (e.g., `claude` for Claude
Code, `codex` for Codex, `opencode` for DeepSeek or Qwen). If you only route
to one provider, one plan is enough.

### How does the Maestro use multiple models from a single CLI?

The dispatch skill (`skills/dispatch.md`) handles this automatically. When a
persona's `preferredModel` matches the host runtime (e.g., you're running
Claude Code and the persona wants `claude`), the Maestro dispatches natively
using the host's built-in subagent mechanism (e.g., the Task tool). When the
`preferredModel` points to a different provider (e.g., `qwen` or `deepseek`),
the Maestro shells out to that provider's CLI tool (e.g., `opencode`) by
piping the assembled prompt via `stdin`. The Providers list in
`skills/dispatch.md` maps each model family to its CLI — see that file for
details.

### Can I use this with just one model?

Yes. Set every persona's `preferredModel` to your host runtime (e.g., `claude`)
and the framework runs entirely within a single provider. You still benefit
from the structured decomposition, review pipeline, and long-term memory —
just without the multi-model routing.

### How should I assign models to personas?

Each persona declares a `preferredModel` in its frontmatter — this is what the
Maestro uses to route work. Keep premium models as the orchestrator (Maestro
makes routing decisions and manages context — short, high-leverage interactions
worth the cost). For the rest, match the model to the persona's job using
role-specific benchmarks:

- **Coder** — [LiveCodeBench][livecodebench] (real-world coding tasks)
- **Architect** — [Artificial Analysis Long Context Reasoning][aa-reasoning]
  (multi-step reasoning across large contexts)
- **Reviewer** — [IFBench][ifbench] (instruction following and constraint
  verification)

These benchmarks are examples — new ones emerge frequently. Pick whatever
benchmark best measures the capability each role needs, then set
`preferredModel` accordingly in the persona's frontmatter.

### Does the framework auto-update?

Yes. On every session start, the boot sequence runs `git -C .agents pull`. If
the pull brings changes, the Maestro reads the changelog, purges any long-term
memory entries that the update made obsolete, and reboots with the new
instructions.

### What does "model-agnostic" mean? Which models are supported?

Any model with a CLI tool that can accept a prompt via `stdin` works. As a
quality floor, we recommend models scoring 1300+ ELO on [GDPval-AA][gdpval-aa] —
a benchmark for general-purpose reasoning. Below that threshold, personas
may struggle with multi-step tasks.

### What thinking token budget should I use for MoE models?

If you use Mixture-of-Experts models (Kimi, Qwen, DeepSeek, or similar), cap
thinking tokens at **16,000** in your CLI's configuration. Research across 121+
code review dispatches found that MoE models regress past this threshold —
higher budgets cause models to qualify findings, soften severity, and
rationalize away bugs they previously found. Dense models (Claude, Seed) do not
exhibit this regression and can use higher budgets safely. See [Overfed,
Overthought, Overasked][overfed-overthought] for the full research.

If you're running OpenCode, the boot sequence already sets per-persona thinking
budgets based on humor profiles — no manual configuration needed.

### What Google Style Guides are included?

This edition ships Google-aligned style guides for **Python**, **Go**,
**Shell**, **Rust**, and **Markdown**. Each guide is a standalone
`rules/code/code-style-*.md` file — edit them freely to match your team's
preferences. The review pipeline detects the language of changed files and
loads the corresponding guide automatically. See `docs/roadmap.md` for the
full alignment plan and roadmap.

## See also

- [Google Style Guides](https://google.github.io/styleguide/)
- [Google Engineering Practices](https://google.github.io/eng-practices/)
- [Google API Design Guide](https://cloud.google.com/apis/design)
- [Google Markdown Style Guide](https://google.github.io/styleguide/docguide/style.html)

[styleguide]: https://google.github.io/styleguide/
[eng-practices]: https://google.github.io/eng-practices/
[yq-link]: https://github.com/mikefarah/yq
[jq-link]: https://github.com/jqlang/jq
[livecodebench]: https://livecodebench.github.io/
[aa-reasoning]: https://artificialanalysis.ai/benchmarks/long-context-reasoning
[ifbench]: https://huggingface.co/spaces/lmsys/IFBench
[gdpval-aa]: https://artificialanalysis.ai/benchmarks/gdp-val
[overfed-overthought]: https://arxiv.org/abs/2502.02539
