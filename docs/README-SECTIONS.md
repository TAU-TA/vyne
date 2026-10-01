# Vyne Docs — structure & the Markdown section generator

This site is a set of static HTML pages generated from small content files.
Adding a documentation page is a single command. The design, sidebar, table of
contents, search and pager are all applied automatically.

## Quick start

```bash
# add a new section from a Markdown file
npm run add -- --file docs/guide/threads.md --title "Threads" --group "Language Reference"

# rebuild everything (e.g. after editing nav.json)
npm run build

# preview locally (needs any static server; file:// also works)
npm run serve        # http://localhost:8000
```

Positional shorthand is also accepted:

```bash
node scripts/add-section.mjs docs/guide/threads.md "Threads" "Language Reference"
```

## What the `add` command does

1. Reads your Markdown file.
2. Converts it to the site's styled HTML.
3. Writes `content/<id>.html`.
4. Registers the section in `nav.json` (creating the group if needed).
5. Rebuilds **every** page so the sidebar, pager and search index include it.

It is safe to run repeatedly: running it again for the same file **updates** the
existing section instead of creating a duplicate.

## `add-section.mjs` options

| Flag | Positional | What it does |
| --- | --- | --- |
| `--file PATH` | 1st arg | **Required.** Path to the Markdown file. |
| `--title TEXT` | 2nd arg | Sidebar / page title. Falls back to front-matter, then the first `# heading`, then the filename. |
| `--group TEXT` | 3rd arg | Sidebar group. Falls back to front-matter, then `Docs`. |
| `--icon CLASS` | – | Font Awesome icon without the `fa-` prefix, e.g. `microchip`. Falls back to a group-based default. |
| `--order N` | – | 1-based position inside the group (defaults to append). |
| `--id SLUG` | – | URL/file id. Defaults to the slugified filename. |
| `--description TEXT` | – | Short lede shown under the title (also used for the meta description). |

### Front matter (optional)

Put this at the very top of your `.md` file; flags override it:

```markdown
---
title: Threads
group: Language Reference
icon: diagram-project
order: 3
description: Lightweight cooperative tasks built on top of regions.
---

# Threads

Your content…
```

## Supported Markdown

- Headings `#` … `####` — an H1 becomes the page title; H2/H3 feed the "On this
  page" table of contents and the search index.
- Paragraphs, **bold**, *italic* / _italic_, `inline code`.
- Links: `[text](https://example.com)` and internal links
  `[Memory & Regions](page:regions)` (jumps to another section by id).
- Ordered and unordered lists, including nested lists.
- GFM pipe tables.
- Fenced code blocks with highlighting:

  ````markdown
  ```vyne title="main.vy"
  module vcore;
  out("hello");
  ```

  ```shell
  vynec main.vy ./main
  ```
  ````

  `vyne` gets full syntax highlighting; `shell` / `bash` / `sh` / `console` get
  shell styling; any other language is shown as plain text. Every block gets a
  filename, language badge and copy button.

- Admonitions:

  ```markdown
  !!! note
  !!! tip "Optional custom title"
  !!! warning
  !!! danger
  ```

  The body is the following block indented by four spaces.

- Blockquotes (`>`) are rendered as note callouts.
- Horizontal rules (`---`).

## Project layout

```
index.html                 Introduction (generated)
pages/<id>.html            one generated page per section
content/<id>.html          the source fragment for each section
assets/styles.css          the entire design system
assets/app.js              progress bar, drawer, TOC, copy, ⌘K search
assets/search-index.js     generated search data
nav.json                   the sidebar/group/order manifest
scripts/build.mjs          rebuild all pages + search index
scripts/add-section.mjs    the Markdown -> section CLI
scripts/extract-legacy.mjs one-time importer (already used)
scripts/lib/                markdown, highlighter, layout, normalizer
docs/                      put your Markdown files here
```

## How to edit things

- **Sidebar order / icons / groups:** edit `nav.json`, then `npm run build`.
- **An existing page's text:** edit `content/<id>.html`, then `npm run build`.
- **A page you wrote:** edit your `.md`, then re-run `npm run add` (or `build`).
- **Look & feel:** edit `assets/styles.css` (`:root` holds the design tokens).

## Notes on the original content

The original single-file `index.html` was split losslessly: every section's
visible text and code are unchanged. The only adjustments were:

- code blocks that the old formatter had re-wrapped are re-flowed into readable
  lines (whitespace only — not a single code character changed), and
- every code block gained a copy button.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `⚙ Build failed` / `Missing content file` | `nav.json` lists an id with no `content/<id>.html`; run `add` for it or remove the entry. |
| Section not in the sidebar | Ensure it is listed in `nav.json`, then `npm run build`. |
| Changes to a `.md` don't appear | Re-run `npm run add` (the `build` alone won't re-read Markdown). |
| Want real URLs when opening files directly | Open `index.html` in a browser; internal links are relative and work from `file://`. |
