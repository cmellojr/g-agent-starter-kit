# Rules

Rules are constraints — short, direct, and non-procedural. A rule that needs
multiple pages to explain is likely a skill in disguise.

## Rule Hierarchy

- **Commandments** (`rules/commandments/`) — sacred, absolute, never bypassed.
- **Code rules** (`rules/code/`) — authoritative within their scope, shall not
  be bent.
- **Project guidance** — supporting direction for repository-specific behavior.

## Available Rules

- **`git`** (`rules/git.md`) — Git commit message structure and branch policy.
- **`code/api-design`** (`rules/code/api-design.md`) — Google REST API design
  standards and resource naming rules.
- **`code/debugging`** (`rules/code/debugging.md`) — Systematic debugging
  methodology, three-strike rule, and anti-rationalization rules.
- **`code/quality`** (`rules/code/quality.md`) — Universal code quality,
  naming, error handling, and testing principles.
- **`code/code-style-*`** (`rules/code/code-style-*.md`) — Language-specific
  style guides (Go, Markdown, Python, Rust, Shell).

## File Naming

Lowercase, hyphenated. Scoped rules are prefixed with the persona or domain they
target: `coder-formatting.md`, not `formatting.md`. Universal rules carry no
prefix.

## Schema (v0.2.0 // 2026-07-09)

### Frontmatter

- **`shortDescription`** (Required) — What the rule enforces in one sentence.
  Example: `Mandates .context.md updates on structural changes`
- **`scope`** (Required) — Task category this rule applies to. Example: `coding`
- **`version`** (Required) — Semantic version. Example: `0.1.0`
- **`lastUpdated`** (Required) — Last modification date. Example: `2026-02-05`

### Body

- **Statement** (Required) — The rule itself. Use RFC-style language: MUST, MUST
  NOT, SHOULD, SHALL, SHALL NOT. As short as the constraint allows.
- **Rationale** (Required) — Why this rule exists. One paragraph. Without
  rationale, rules feel arbitrary and get ignored.
