# FAQ

Frequently asked questions about G-Agent Starter Kit.

## General

### Why this over other harnesses?

GSD, GStack, and similar tools lock you into dependencies, runtimes, and rigid workflows. G-Agent Starter Kit is **pure natural language** — every persona, rule, and skill is a Markdown file you can edit with zero installation or build step.

Most harnesses are built around dense, expensive models and burn thousands of tokens on guidance you'll never use. This kit is a **scalpel**: minimal by design, tuned for cheaper MoE models like DeepSeek, GLM, Kimi, and Qwen. You pay only for the context you need. When your project grows, you extend it — add a persona, tweak a rule, swap a provider — all in plain text.

### Full orchestration or quick mode — which do I use?

**Full orchestration** boots the Maestro — an orchestrator that decomposes your request, plans with the Architect, dispatches to the Coder, validates with the Reviewer, and maps the codebase with the Contextualizer. It carries memory across sessions, tracks work in to-do files, and manages a review pipeline. Use it for complex multi-step work where you want structured planning, adversarial review, or cross-session memory.

**Quick mode** is the default. Just type your request and the CLI works on it directly — your `AGENTS.md` style book is auto-loaded so the agent follows your coding conventions without any boot ceremony. Use it for everyday work: bug fixes, features, refactors, anything where you know what you want and just need it done.

The trade-off is speed vs. structure. Quick mode is faster and cheaper — one agent, no overhead. Full orchestration is more thorough — multiple specialized agents, review gates, and resumable state — but costs more tokens and requires a boot phrase each session.

### Why multi-model?

Coding plans are routinely quantized and rate-limited weeks after launch — the version you fell in love with gradually loses sharpness as the provider optimizes for throughput. A multi-model harness fights this in three ways:

1. **Resilience.** Spreading work across providers means you're less affected when any single plan degrades. If one provider tightens limits or loses quality, shift that persona's `preferredModel` to another entry in the Providers list.
2. **Token conservation.** The orchestrator (Maestro) only handles routing and decomposition. Token-heavy roles like Architect and Coder are delegated to other capable models, so your premium plan lasts longer.
3. **Fresh eyes.** Different models catch different things. A reviewer running on a separate provider will flag issues that the coder's model normalized.

### What do I need to run this?

A coding plan or API key for each provider you route to. We recommend coding plans — **Claude Code** (Anthropic), **Codex** (OpenAI), and **OpenCode Go** (DeepSeek, Qwen, Kimi, GLM, and more via the `opencode` CLI) offer flat-rate pricing with generous token allowances designed for agentic workflows. API keys work too, but plans are more cost-effective for sustained use. Each provider needs its CLI tool installed (e.g., `claude` for Claude Code, `codex` for Codex, `opencode` for DeepSeek or Qwen). If you only route to one provider, one plan is enough.

### How does the Maestro use multiple models from a single CLI?

The dispatch skill (`skills/dispatch/SKILL.md`) handles this automatically. When a persona's `preferredModel` matches the host runtime (e.g., you're running Claude Code and the persona wants `claude`), the Maestro dispatches natively using the host's built-in subagent mechanism (e.g., the Task tool). When the `preferredModel` points to a different provider (e.g., `qwen` or `deepseek`), the Maestro shells out to that provider's CLI tool (e.g., `opencode`) by piping the assembled prompt via `stdin`. The Providers list in `skills/dispatch/SKILL.md` maps each model family to its CLI.

### Can I use this with just one model?

Yes. Set every persona's `preferredModel` to your host runtime (e.g., `claude`) and the framework runs entirely within a single provider. You still benefit from the structured decomposition, review pipeline, and long-term memory — just without the multi-model routing.

### How should I assign models to personas?

Each persona declares a `preferredModel` in its frontmatter — this is what the Maestro uses to route work. Keep premium models as the orchestrator (Maestro makes routing decisions and manages context — short, high-leverage interactions worth the cost). For the rest, match the model to the persona's job using role-specific benchmarks:

- **Coder** — [LiveCodeBench](https://livecodebench.github.io/) (real-world coding tasks)
- **Architect** — [Artificial Analysis Long Context Reasoning](https://artificialanalysis.ai/benchmarks/long-context-reasoning) (multi-step reasoning across large contexts)
- **Reviewer** — [IFBench](https://huggingface.co/spaces/lmsys/IFBench) (instruction following and constraint verification)

These benchmarks are examples — new ones emerge frequently. Pick whatever benchmark best measures the capability each role needs, then set `preferredModel` accordingly in the persona's frontmatter.

### Does the framework auto-update?

Yes. On every session start, the boot sequence runs `.agents/scripts/sync-framework.sh`. The script pulls the `.agents/` clone on its current branch, which tracks `main` by default. It prints the short commit hash before and after the update. If the pull fails, the Maestro announces that the framework was not updated and continues on the existing clone.

To test a ref that is not stable, run `.agents/scripts/sync-framework.sh --track <ref>`. The clone is force-reset, and uncommitted work in it is discarded. The clone returns to `main` with `--track main`.

### What does "model-agnostic" mean? Which models are supported?

Any model with a CLI tool that can accept a prompt via `stdin` works. As a quality floor, we recommend models scoring 1300+ ELO on [GDPval-AA](https://artificialanalysis.ai/benchmarks/gdp-val) — a benchmark for general-purpose reasoning. Below that threshold, personas may struggle with multi-step tasks.

### What thinking token budget should I use for MoE models?

If you use Mixture-of-Experts models (Kimi, Qwen, DeepSeek, or similar), cap thinking tokens at **16,000** in your CLI's configuration. Research across 121+ code review dispatches found that MoE models regress past this threshold — higher budgets cause models to qualify findings, soften severity, and rationalize away bugs they previously found. Dense models (Claude, Seed) do not exhibit this regression and can use higher budgets safely. See [Overfed, Overthought, Overasked](https://arxiv.org/abs/2502.02539) for the full research.

If you're running OpenCode, the boot sequence already sets per-persona thinking budgets based on humor profiles — no manual configuration needed.

### What Google Style Guides are included?

This edition ships Google-aligned style guides for **Python**, **Go**, **Shell**, **Rust**, and **Markdown**. Each guide is a standalone `rules/code/code-style-*.md` file — edit them freely to match your team's preferences. The review pipeline detects the language of changed files and loads the corresponding guide automatically. See `docs/roadmap.md` for the full alignment plan and roadmap.

## Technical

### How does memory work?

Two layers:
- **Long-term** (`.memory/long-term.md`) — preferences, learned rules, discovered issues, observations, project notes. Persists across sessions.
- **Session** (`.memory/session/<slug>.md`) — current task, active todo, interaction log. Resumable if interrupted.

The Maestro distills session → long-term at session end (corrections, struggles, decisions, preferences, pruning).

### What are `.context.md` files?

Per-directory indexes that answer "what lives here" — purpose, file summary, constraints, guidance. Created/maintained by the Contextualizer via `skills/context-maintenance/SKILL.md`. Updated in the same commit as structural changes. Gitignored by default in this repo (local-only), but the skill expects them committed in team settings.

### What is `FEATURE-MAP.md`?

Single project-level index mapping every user-facing feature to its code path (entry point → flow → output). Updated by Contextualizer alongside `.context.md` files. See `docs/FEATURE-MAP.md`.

### How does the review pipeline work?

Two modes:
- **Per-epic** (default): single reviewer runs all 5 passes on each epic's changes
- **Full branch**: three reviewers run all passes on accumulated changes after all epics land

Five passes: **Design** (simplicity, correctness), **Coherence** (logic, correctness, structure), **Quality** (style guides, naming, conventions), **Security** (OWASP 2025, attack surface, data flow), **Documentation** (docstrings, `.context.md`, `FEATURE-MAP.md`).

Each pass produces a structured handoff with verdict (pass/partial/fail), findings, and coverage score. Reviewer self-reviews via SHIELD rubric.

### How do I add a new skill?

1. Create `skills/<name>/SKILL.md` following the schema in `skills/README.md`
2. Add frontmatter: `name`, `description`, `usedBy`, `version`, `lastUpdated`
3. Reference it in a persona's dispatch (Maestro auto-discovers via `skills/README.md`)

### How do I add a new persona?

1. Create `personas/<name>.md` following the schema in `personas/README.md`
2. Include frontmatter: `name`, `description`, `preferredModel`, `modelTier`, `humor`, `version`, `lastUpdated`
3. Define: Identity, Playbook, Handoff, Red Lines, Yield conditions
4. Add self-review rubric reference if applicable

The Maestro discovers it automatically via `personas/README.md`.

## Google Practices

### Which Google Engineering Practices are implemented?

| Practice | Location |
|---|---|
| Style Guides (Py, Go, Sh, Rs, Md) | `rules/code/code-style-*.md` |
| Code Review (adversarial, multi-pass) | `skills/reviewer-architect-adversarial/`, `skills/review-loop/` |
| Testing on the Toilet | `rules/code/testing-practices.md` |
| SRE / Resiliency (backoff/jitter, structured logging) | `rules/code/quality.md` §Resilient Error Handling, §Structured Logging |
| API Design Guide | `rules/code/api-design.md` |
| CL Author Guidelines (small CLs, why not what) | `rules/git.md`, `personas/coder.md` |
| Documentation standards | `skills/context-maintenance/`, `skills/code-documentation-review/` |

### Is this an official Google project?

**No.** This is a community project that *adopts and operationalizes* Google's published engineering standards. The Google badges indicate alignment with their public guides, not endorsement.