// ---------------------------------------------------------------------------
// extract-legacy.mjs  (run once)
//
// Splits the original single-file index.html into:
//   * content/<id>.html  - the inner HTML of every <article class="page">
//   * nav.json           - the sidebar navigation manifest
//
// Existing information is preserved. The only changes made are:
//   * code blocks are re-flowed into readable lines (whitespace only),
//   * the one inline-styled <pre> becomes a standard code block,
//   * in-content [data-page] links are left intact (the build rewrites them).
// ---------------------------------------------------------------------------

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import crypto from "node:crypto";
import { normalizeCodeBody } from "./lib/code-normalize.mjs";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const SRC = path.join(ROOT, "index.html");
const CONTENT_DIR = path.join(ROOT, "content");

const html = fs.readFileSync(SRC, "utf8");

// ---------------------------------------------------------------------------
// 1. Navigation
// ---------------------------------------------------------------------------
function parseNav(source) {
  const aside = source.slice(
    source.indexOf('<aside class="sidebar'),
    source.indexOf("</aside>"),
  );
  const groups = [];
  const groupRe =
    /<div class="nav-group">\s*<div class="nav-group-title">([\s\S]*?)<\/div>\s*<ul class="nav-list">([\s\S]*?)<\/ul>/g;
  let gm;
  while ((gm = groupRe.exec(aside)) !== null) {
    const title = gm[1].trim();
    const listHtml = gm[2];
    const items = [];
    const itemRe =
      /<a class="nav-link[^"]*"[^>]*?data-page="([^"]+)"[^>]*>([\s\S]*?)<\/a\s*>/g;
    let im;
    while ((im = itemRe.exec(listHtml)) !== null) {
      const id = im[1];
      const inner = im[2];
      const iconMatch = inner.match(/class="fas ([a-z0-9-]+)"/);
      const icon = iconMatch ? iconMatch[1] : "fa-file-lines";
      const titleText = inner
        .replace(/<i[^>]*><\/i>/, "")
        .replace(/<[^>]*>/g, "")
        .replace(/&amp;/g, "&")
        .replace(/&lt;/g, "<")
        .replace(/&gt;/g, ">")
        .replace(/&quot;/g, '"')
        .replace(/&#39;/g, "'")
        .replace(/&nbsp;/g, " ")
        .replace(/\s+/g, " ")
        .trim();
      items.push({ id, title: titleText, icon });
    }
    groups.push({ title, items });
  }
  return { groups };
}

// ---------------------------------------------------------------------------
// 2. Code-block normalization helpers
// ---------------------------------------------------------------------------
function normalizeAllCodeBlocks(inner) {
  const blockRe =
    /<div class="code-block">([\s\S]*?)<\/div>\s*<\/div>/g;
  return inner.replace(blockRe, (full) => {
    const bodyMatch = full.match(
      /<div class="code-body">([\s\S]*?)<\/div>/,
    );
    if (!bodyMatch) return full;
    const fnMatch = full.match(/code-filename"[^>]*>(?:<i[^>]*><\/i>)?&nbsp;?([^<]*)/);
    const filename = fnMatch ? fnMatch[1].trim() : "";
    const kind = /shell/i.test(filename) ? "shell" : "vyne";
    const normalized = normalizeCodeBody(bodyMatch[1], kind);
    return full.replace(bodyMatch[0], `<div class="code-body">${normalized}</div>`);
  });
}

function convertInlinePre(inner) {
  // The single inline-styled <pre> holding the `through` syntax.
  const preRe = /<pre\b[^>]*>([\s\S]*?)<\/pre>/g;
  return inner.replace(preRe, (full, body) => {
    const text = body.replace(/<[^>]*>/g, "").replace(/\s+/g, " ").trim();
    const highlighted = text
      .replace(/^through\b/, '<span class="c-kw">through</span>')
      .replace(/\b(name|iterable|mode|body)\b/g, '<span class="c-fn">$1</span>')
      .replace(/(::|->|[{}])/g, '<span class="c-op">$1</span>');
    return (
      '<div class="code-block"><div class="code-header">' +
      '<span class="code-filename"><i class="fas fa-terminal"></i>&nbsp;syntax</span>' +
      '<span class="code-lang">vyne</span>' +
      '<button class="copy-btn"><i class="far fa-copy"></i> copy</button>' +
      "</div>" +
      `<div class="code-body">${highlighted}</div></div>`
    );
  });
}

// ---------------------------------------------------------------------------
// 3. Extract every article
// ---------------------------------------------------------------------------
const articleRe =
  /<article class="page[^"]*" id="page-([a-z0-9-]+)">([\s\S]*?)<\/article>/g;
const articles = [];
let am;
while ((am = articleRe.exec(html)) !== null) {
  articles.push({ id: am[1], inner: am[2] });
}

if (articles.length === 0) {
  console.error("No articles found - aborting.");
  process.exit(1);
}

fs.mkdirSync(CONTENT_DIR, { recursive: true });
const report = [];
for (const art of articles) {
  let inner = art.inner;
  const before = inner;
  inner = normalizeAllCodeBlocks(inner);
  inner = convertInlinePre(inner);
  // Trim only the outer wrapper whitespace, never inner content.
  inner = inner.replace(/^\s*\n/, "").replace(/\s+$/, "");
  const file = path.join(CONTENT_DIR, `${art.id}.html`);
  fs.writeFileSync(file, inner + "\n");
  report.push({
    id: art.id,
    bytes: Buffer.byteLength(inner),
    changed: before !== inner,
    hash: crypto.createHash("sha1").update(inner).digest("hex").slice(0, 8),
  });
}

const nav = parseNav(html);
fs.writeFileSync(
  path.join(ROOT, "nav.json"),
  JSON.stringify(nav, null, 2) + "\n",
);

console.log(`Extracted ${articles.length} articles -> content/`);
console.log(`Nav groups: ${nav.groups.length}, items: ${nav.groups.reduce((n, g) => n + g.items.length, 0)}`);
console.table(report);
