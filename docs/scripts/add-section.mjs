#!/usr/bin/env node
// ---------------------------------------------------------------------------
// add-section.mjs — turn a Markdown file into a fully styled documentation
// section, register it in the sidebar and rebuild the site.
//
//   node scripts/add-section.mjs --file docs/guide/threads.md \
//        --title "Threads" --group "Language Reference"
//
//   node scripts/add-section.mjs docs/guide/threads.md "Threads" "Reference"
//
// Flags: --file --title --group --icon --order --id --description
// ---------------------------------------------------------------------------

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { spawnSync } from "node:child_process";
import { parseFrontMatter, extractTitle, renderMarkdown } from "./lib/markdown.mjs";
import { slugify, escapeHtml } from "./lib/slug.mjs";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const CONTENT_DIR = path.join(ROOT, "content");
const NAV_FILE = path.join(ROOT, "nav.json");

function die(msg) {
  console.error(`\n✖ ${msg}\n`);
  process.exit(1);
}

// --- parse arguments --------------------------------------------------------
function parseArgs(argv) {
  const opts = {};
  const positional = [];
  const flags = new Set([
    "file", "title", "group", "icon", "order", "id", "description",
  ]);
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a.startsWith("--")) {
      const eq = a.indexOf("=");
      if (eq !== -1) {
        opts[a.slice(2, eq)] = a.slice(eq + 1);
      } else {
        const key = a.slice(2);
        if (flags.has(key)) {
          opts[key] = argv[++i];
        } else {
          opts[key] = true;
        }
      }
    } else {
      positional.push(a);
    }
  }
  if (!opts.file && positional[0]) opts.file = positional[0];
  if (!opts.title && positional[1]) opts.title = positional[1];
  if (!opts.group && positional[2]) opts.group = positional[2];
  return opts;
}

function defaultIcon(group) {
  const g = (group || "").toLowerCase();
  if (g.includes("library") || g.includes("stdlib")) return "fa-cube";
  if (g.includes("reference")) return "fa-key";
  if (g.includes("getting")) return "fa-rocket";
  if (g.includes("guide")) return "fa-book";
  return "fa-file-lines";
}

function titleFromId(id) {
  return id
    .split("-")
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(" ");
}

// --- main -------------------------------------------------------------------
const opts = parseArgs(process.argv.slice(2));

if (!opts.file) {
  die(
    "No Markdown file given.\n\n" +
      "Usage: node scripts/add-section.mjs --file docs/guide/threads.md \\\n" +
      '         --title "Threads" --group "Language Reference"',
  );
}

const mdPath = path.resolve(process.cwd(), opts.file);
if (!fs.existsSync(mdPath)) die(`Markdown file not found: ${opts.file}`);

const source = fs.readFileSync(mdPath, "utf8");
const { data: fm, body } = parseFrontMatter(source);
const { title: h1, body: withoutH1 } = extractTitle(body);

const id =
  opts.id || fm.id || slugify(path.basename(mdPath, path.extname(mdPath)));
if (!id) die("Could not derive an id. Pass --id.");

const title = opts.title || fm.title || h1 || titleFromId(id);
const group = opts.group || fm.group || "Docs";
const icon = opts.icon || fm.icon || defaultIcon(group);
const description = opts.description || fm.description || "";
const order = opts.order ? Number(opts.order) : fm.order ? Number(fm.order) : null;

const bodyHtml = renderMarkdown(withoutH1);
const header =
  `<div class="page-eyebrow">${escapeHtml(group)}</div>\n` +
  `<h1>${escapeHtml(title)}</h1>\n` +
  (description ? `<p class="lede">${escapeHtml(description)}</p>\n` : "");

fs.mkdirSync(CONTENT_DIR, { recursive: true });
fs.writeFileSync(path.join(CONTENT_DIR, `${id}.html`), header + bodyHtml + "\n");

// --- update nav.json --------------------------------------------------------
const nav = JSON.parse(fs.readFileSync(NAV_FILE, "utf8"));

// remove any existing entry with this id (upsert)
let previousGroup = null;
for (const g of nav.groups) {
  const before = g.items.length;
  g.items = g.items.filter((it) => it.id !== id);
  if (g.items.length !== before) previousGroup = g.title;
}

let target = nav.groups.find((g) => g.title === group);
if (!target) {
  target = { title: group, items: [] };
  nav.groups.push(target);
}

const entry = { id, title, icon };
if (order && order > 0) target.items.splice(Math.min(order - 1, target.items.length), 0, entry);
else target.items.push(entry);

fs.writeFileSync(NAV_FILE, JSON.stringify(nav, null, 2) + "\n");

// --- rebuild ----------------------------------------------------------------
const build = spawnSync(
  process.execPath,
  [path.join(__dirname, "build.mjs"), "--clean"],
  { cwd: ROOT, stdio: "inherit" },
);
if (build.status !== 0) die("Build failed after adding the section.");

const isIntro = id === "intro";
console.log(`\n✔ Section "${title}" added to group "${group}"`);
if (previousGroup && previousGroup !== group)
  console.log(`  (moved from "${previousGroup}")`);
console.log(`  content/${id}.html  →  ${isIntro ? "index.html" : `pages/${id}.html`}`);
