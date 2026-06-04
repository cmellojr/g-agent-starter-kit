# Rules

Rules are constraints — short, direct, and non-procedural. A rule that needs multiple pages to explain is likely a skill in disguise.

## Rule Hierarchy

- **Commandments** (`rules/commandments/`) — sacred, absolute, never bypassed.
- **Edicts** (`rules/edicts/`) — authoritative within their scope, shall not be bent.
- **Counsel** (`rules/counsel/`) — wise guidance, may be deviated from with justification.

## Available Rules

- **`commandments/git`** — Google-style commit messages, branch naming, commit style (coding)
- **`edicts/code-quality`** — Cross-language quality conventions: KISS, DRY, SRP, error handling, data trust boundary (coding)
- **`edicts/code-debugging`** — Root cause before fix, three-strike rule, anti-rationalization (coding)
- **`edicts/code-style-python`** — Google Python Style Guide: 80 cols, 4 spaces, snake_case, type annotations, docstrings (coding-python)
- **`edicts/code-style-go`** — Google Go Style Guide: gofmt, MixedCaps, least mechanism, clarity > concision (coding-go)
- **`edicts/code-style-shell`** — Google Shell Style Guide: Bash, 2 spaces, 80 cols, local, main(), ShellCheck (coding-shell)
- **`edicts/code-style-rust`** — Rust Style Guide: rustfmt, 4 spaces, 100 cols, Result, ownership, traits (coding-rust)
- **`edicts/code-style-markdown`** — Google Markdown Style Guide: 80 cols, ATX headings, fenced code blocks, reference links (coding-markdown)

## File Naming

Lowercase, hyphenated. Scoped rules are prefixed with the persona or domain they target: `coder-formatting.md`, not `formatting.md`. Universal rules carry no prefix.

## Schema (v0.1.0 // 2026-03-04)

### Frontmatter

- **`shortDescription`** (Required) — What the rule enforces in one sentence. Example: `Mandates .context.md updates on structural changes`
- **`scope`** (Required) — Task category this rule applies to. Example: `coding`
- **`version`** (Required) — Semantic version. Example: `0.1.0`
- **`lastUpdated`** (Required) — Last modification date. Example: `2026-02-05`

### Body

- **Statement** (Required) — The rule itself. Use RFC-style language: MUST, MUST NOT, SHOULD, SHALL, SHALL NOT. As short as the constraint allows.
- **Rationale** (Required) — Why this rule exists. One paragraph. Without rationale, rules feel arbitrary and get ignored.
