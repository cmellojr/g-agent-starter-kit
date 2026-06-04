---
shortDescription: Google Markdown Style Guide rules — 80 cols, ATX headings, fenced code blocks, reference links.
scope: coding-markdown
version: 0.1.0
lastUpdated: 2026-06-03
---

## Reference

[Google Markdown Style Guide](https://google.github.io/styleguide/docguide/style.html)

## General Principles

- Markdown is plain text first. Keep the source readable and portable.
- Balance three goals: readability, maintainability, simplicity.
- A small set of fresh docs is better than sprawling stale docs.

## Document Layout

```
# Document Title

Short introduction (1-3 sentences).

[TOC]

## Topic

Content.

## See also

* https://link-to-more-info
```

- One H1 per document (the title).
- `[TOC]` goes after the introduction but before the first H2.
- `## See also` section at the bottom for related links.

## Line Length

80 characters maximum for prose. Exceptions:
- **Links** (may exceed 80).
- **Tables** (may exceed 80).
- **Headings** (may exceed 80).
- **Code blocks** (any length allowed).

## Trailing Whitespace

No trailing whitespace on any line. Use a trailing backslash to break lines
(sparingly). Prefer paragraph breaks instead.

## Headings

- Use ATX-style headings (`#`, `##`, `###` — not underlined).
- Space after `#`: `## Heading`, not `##Heading`.
- Blank line before and after headings.
- Use unique, fully-descriptive heading names (even for sub-sections).
- Follow Google Developer Documentation Style Guide for capitalization.

## Lists

### Numbered Lists

Use lazy numbering for long/multi-level lists:
```
1.  Foo.
1.  Bar.
    1.  Foofoo.
1.  Baz.
```

Use explicit numbering for short, stable lists.

### Bullet Lists

```
*   Item with 4-space indent after the bullet.
    Wrapped text indented 4 spaces.
*   Next item.
```

### Nested Lists

Use 4-space indent for nested lists. Wrapped text indents 8 spaces at the
second level.

## Code

### Inline Code

Use backticks for short code, field names, file types, paths:
```
Run `really_cool_script.sh arg`.
Update your `README.md`.
```

### Code Blocks

Use fenced code blocks with language declaration:
```python
def foo():
    pass
```

Prefer fenced code blocks over indented code blocks (enables language-specific
syntax highlighting). Escape newlines in command snippets with `\`.

### Nesting in Lists

Indent the code block 4 additional spaces from the list item:
```
*   Bullet.

    ```c++
    int foo;
    ```
```

## Links

- Use explicit paths for links within Markdown: `[...](/path/to/page.md)`.
- Avoid relative paths with `../`.
- Use informative link text — never "here", "link", or bare URLs.
- Use **reference links** for long URLs, to reduce duplication, and in tables.
- Define reference links after their first use (before the next heading).
- Reference links used in multiple sections go at the bottom of the document.

```
See the [style guide][style] for details.

[style]: /styleguide/docguide/style.html
```

## Images

Use sparingly. Prefer simple screenshots. Always provide descriptive alt text.

## Tables

Use for tabular data that needs quick scanning. Avoid tables when a list
would suffice. Use reference links inside tables to keep cell content short.

```
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
```

## Strongly Prefer Markdown to HTML

Avoid HTML hacks. Standard Markdown meets almost all needs. Gitiles does not
render HTML.

## Rationale

Consistent Markdown formatting improves readability in source form, ensures
tool compatibility, and reduces review friction. These rules follow the Google
standard used across internal engineering documentation.
