---
shortDescription: Google HTML/CSS Style Guide rules and conventions.
scope: coding-html-css
version: 0.1.0
lastUpdated: 2026-10-22
---

## Reference

[Google HTML/CSS Style Guide](https://google.github.io/styleguide/htmlcssguide.html)

## General Principles

- Improve collaboration, code quality, and enabling supporting infrastructure
- Applies to raw working files: HTML, CSS, Sass, GSS
- Tools may obfuscate/minify/compile as long as general code quality maintained
- Be consistent — match local style when editing existing code

## General Style Rules

### Protocol

- Use HTTPS for embedded resources (images, media, stylesheets, scripts)
- HTTPS for `@import` in CSS
- Exception: when files not available over HTTPS

### Indentation

- 2 spaces per level
- No tabs, no mixed tabs and spaces

### Capitalization

- All code lowercase: HTML elements, attributes, attribute values (except text/CDATA), CSS selectors, properties, property values (except strings)

### Trailing Whitespace

- Remove trailing whitespace — unnecessary and complicates diffs

### Encoding

- UTF-8 without BOM
- Specify in HTML via `<meta charset="utf-8">`
- Do not specify encoding in stylesheets (assume UTF-8)

### Comments

- Explain code as needed: what it covers, purpose, why solution used
- Optional but encouraged for complex sections

### Action Items

- Mark with `TODO:` only (not `@@`, `FIXME`, etc.)
- Format: `TODO: action item`

## HTML Style Rules

### Document Type

- Use `<!doctype html>` — ensures no-quirks mode
- Without doctype: quirks mode; wrong doctype: limited-quirks mode

### HTML Validity

- Use valid HTML where possible
- Exception: otherwise unattainable performance goals
- Validate with W3C HTML validator

### Semantics

- Use elements for their purpose: headings for headings, `p` for paragraphs, `a` for anchors
- Important for accessibility, reuse, code efficiency
- Example: `<a href="...">` not `<div onclick="...">`

### Multimedia Fallback

- Alternative content for multimedia (images, video, canvas)
- Images: meaningful `alt` text (or `alt=""` for decorative)
- Video/audio: transcripts and captions

### Separation of Concerns

- Strictly separate structure (HTML), presentation (CSS), behavior (JS)
- Minimize interaction between the three
- Link as few stylesheets/scripts as possible
- Move presentational to stylesheets, behavioral to scripts

### Entity References

- Do not use entity references (`&mdash;`, `&rdquo;`, `&#x263a;`)
- UTF-8 encoding makes them unnecessary
- Exceptions: characters with special meaning in HTML (`<`, `&`) and control/invisible characters

### Optional Tags

- Omit optional tags (optional, for file size and scannability)
- HTML5 defines omittable tags
- Best to omit all optional tags consistently

### `type` Attributes

- Omit `type` for stylesheets (unless not CSS) and scripts (unless not JS, or `type="module"`)
- HTML5 implies `text/css` and `text/javascript` defaults
- JavaScript modules: must use `type="module"`

### `id` Attributes

- Avoid unnecessary `id` attributes
- Prefer `class` for styling, `data` attributes for scripting
- When required: include hyphen (e.g., `user-profile` not `userProfile`)
- Prevents collision with JavaScript identifier syntax

## HTML Formatting Rules

### General Formatting

- New line for every block, list, or table element
- Indent child elements of block, list, table elements
- Independent of CSS `display` property

### HTML Line-Wrapping

- No column limit, but wrap long lines if significantly improves readability
- Continuation lines indented to distinguish from child elements
- Consistent wrapping within project (enforced by automated tools)

### HTML Quotation Marks

- Double quotes (`""`) for attribute values
- Not single quotes

## CSS Style Rules

### CSS Validity

- Use valid CSS where possible
- Exception: CSS validator bugs or proprietary syntax
- Validate with W3C CSS validator

### Class Naming

- Meaningful or generic names reflecting element purpose
- Specific names preferred (most understandable, least likely to change)
- Generic names (`.aux`, `.alt`) as fallback for elements with no particular meaning
- Not presentational (`.button-green`, `.clear`) or cryptic (`.yee-1901`)

### Class Name Style

- As short as possible, as long as necessary
- Convey what class is about briefly

### Class Name Delimiters

- Hyphen (`-`) to separate words
- No concatenation, no underscores, no other characters

### Prefixes

- Application-specific prefix optional (e.g., `.adw-`, `.maia-`)
- Short unique identifiers followed by dash
- Helps prevent naming conflicts, aids maintenance

### Type Selectors

- Avoid qualifying class names with type selectors
- Unless necessary (e.g., helper classes)
- Performance: unnecessary ancestor selectors hurt performance

### ID Selectors

- Avoid ID selectors
- IDs must be unique across page — difficult to guarantee
- Prefer class selectors in all situations

### Shorthand Properties

- Use shorthand where possible (e.g., `font`, `padding`, `margin`, `border`)
- Even when only one value explicitly set
- Code efficiency and understandability

### 0 and Units

- Omit units after `0` values unless required
- Exception: `flex: 0px` (flex-basis requires unit)

### Leading 0s

- Always include leading `0` for values between -1 and 1
- Example: `font-size: 0.8em;`

### Hexadecimal Notation

- 3-character hex where possible (`#ebc` not `#eebbcc`)
- Shorter and more succinct

### Important Declarations

- Avoid `!important` — breaks natural cascade
- Use selector specificity to override instead

### Hacks

- Avoid user agent detection and CSS hacks
- Last resort only — try different approach first
- Detection/hacks hurt long-term maintainability

## CSS Formatting Rules

### Declaration Order

- Alphabetize declarations (optional but recommended for consistency)
- Ignore vendor prefixes for sorting
- Keep vendor prefixes sorted (`-moz-` before `-webkit-`)

### Block Content Indentation

- Indent all block content (rules within rules, declarations)
- Reflects hierarchy, improves understanding

### Declaration Stops

- Semicolon after every declaration
- Consistency and extensibility

### Property Name Stops

- Single space after property name's colon
- No space before colon

### Declaration Block Separation

- Single space between last selector and opening brace
- Opening brace on same line as last selector

### Selector and Declaration Separation

- New line for each selector and declaration

### Rule Separation

- Blank line (two line breaks) between rules

### CSS Quotation Marks

- Single quotes (`''`) for attribute selectors and property values
- No quotes in URI values (`url()`)
- Exception: `@charset` rule uses double quotes

## CSS Meta Rules

### Section Comments

- Group sections by section comments (optional)
- Separate sections with new lines
- Format: `/* Section Name */`

## Parting Words

> **Be consistent.**
> If editing code, look at surrounding code and match its style. The point of style guidelines is common vocabulary so people concentrate on what you're saying, not how you're saying it. Local style matters — if added code looks drastically different, it throws readers off.

## Rationale

These rules adapt the Google HTML/CSS Style Guide for this framework's review pipeline. The guide emphasizes semantic HTML, separation of concerns, consistent formatting, and maintainable CSS. Language-specific rules are loaded automatically by the review pipeline based on file extension (`.html`, `.css`, `.scss`, `.sass`, `.gss`).