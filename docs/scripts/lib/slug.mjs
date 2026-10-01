// Slug + id helpers shared by the generator and the markdown converter.

export function slugify(input) {
  return String(input)
    .toLowerCase()
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/&[a-z]+;/g, " ")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");
}

// Returns a slug that is unique within `used` (a Set). Mutates the set.
export function uniqueSlug(input, used) {
  const base = slugify(input) || "section";
  let candidate = base;
  let n = 2;
  while (used.has(candidate)) {
    candidate = `${base}-${n++}`;
  }
  used.add(candidate);
  return candidate;
}

// Strip HTML tags and decode the handful of entities used in the docs.
export function stripHtml(html) {
  return String(html)
    .replace(/<[^>]*>/g, " ")
    .replace(/&nbsp;/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/\s+/g, " ")
    .trim();
}

export function escapeHtml(text) {
  return String(text)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

export function escapeAttr(text) {
  return escapeHtml(text).replace(/'/g, "&#39;");
}
