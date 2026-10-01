// ---------------------------------------------------------------------------
// code-normalize
//
// The legacy index.html was run through a formatter that re-flowed the inline
// markup inside `.code-body`, inserting newlines between spans and wrapping
// attributes. Because the code body is rendered with `white-space: pre`, those
// formatter newlines showed up as broken, mid-expression line breaks.
//
// This module reconstructs readable code from that markup WITHOUT changing any
// visible character of the code other than whitespace:
//   * joins soft-wrapped lines back together,
//   * keeps real statement breaks (after ; { } and around comments),
//   * re-indents using brace depth,
//   * collapses wrapped comment text onto one line,
//   * leaves `shell` blocks on their original lines (only de-indented).
//
// It is intentionally tolerant of malformed input: anything it does not
// understand is passed through untouched.
// ---------------------------------------------------------------------------

const TAG_RE = /<[^>]+>/g;

function spanClasses(tag) {
  const m = tag.match(/class\s*=\s*"([^"]*)"/);
  return m ? m[1].split(/\s+/).filter(Boolean) : [];
}
function isClosing(tag) {
  return /^<\//.test(tag);
}
function isSpan(tag) {
  return /^<\/?span\b/i.test(tag);
}

// Split inner HTML into { t:"tag"|"ws"|"text", raw }.
function tokenize(html) {
  const tokens = [];
  let lastIndex = 0;
  let m;
  TAG_RE.lastIndex = 0;
  while ((m = TAG_RE.exec(html)) !== null) {
    if (m.index > lastIndex) pushText(tokens, html.slice(lastIndex, m.index));
    tokens.push({ t: "tag", raw: m[0] });
    lastIndex = m.index + m[0].length;
  }
  if (lastIndex < html.length) pushText(tokens, html.slice(lastIndex));
  return tokens;
}
function pushText(tokens, text) {
  for (const part of text.split(/(\s+)/)) {
    if (part === "") continue;
    tokens.push({ t: /^\s+$/.test(part) ? "ws" : "text", raw: part });
  }
}

// Track the open <span> class stack while walking tokens.
function makeStack() {
  const stack = [];
  return {
    update(tag) {
      if (!isSpan(tag)) return;
      if (isClosing(tag)) {
        if (stack.length) stack.pop();
      } else {
        stack.push(spanClasses(tag));
      }
    },
    has(cls) {
      return stack.some((c) => c.includes(cls));
    },
  };
}

const ENTITIES = {
  "&gt;": ">",
  "&lt;": "<",
  "&amp;": "&",
  "&quot;": '"',
  "&#39;": "'",
  "&nbsp;": " ",
};
// Decode the handful of entities used in code, so trailing `;` inside `&gt;`
// is not mistaken for a statement terminator.
function decodeEntities(raw) {
  return raw.replace(/&(gt|lt|amp|quot|nbsp|#39);/g, (s) => ENTITIES[s] || s);
}
function lastVisibleChar(raw) {
  const decoded = decodeEntities(raw);
  return decoded[decoded.length - 1] || "";
}

function lookahead(tokens, i) {
  for (let j = i; j < tokens.length; j++) {
    const tk = tokens[j];
    if (tk.t === "ws") continue;
    if (tk.t === "text") return { char: tk.raw[0] };
    if (tk.t === "tag") {
      if (isSpan(tk.raw) && !isClosing(tk.raw)) {
        if (spanClasses(tk.raw).includes("c-com"))
          return { char: "/", comment: true };
      }
      continue;
    }
  }
  return { char: "" };
}

function normalizeVyne(html) {
  const tokens = tokenize(html);

  // ---- pass 1: decisions for each whitespace run -------------------------
  const decisions = new Array(tokens.length).fill(null);
  const st = makeStack();
  let prevChar = "";
  for (let i = 0; i < tokens.length; i++) {
    const tk = tokens[i];
    if (tk.t === "tag") {
      st.update(tk.raw);
      continue;
    }
    if (tk.t === "text") {
      if (!st.has("c-com")) prevChar = lastVisibleChar(tk.raw);
      continue;
    }
    if (st.has("c-com")) {
      decisions[i] = " ";
      continue;
    }
    const run = tk.raw;
    const hasBlank = /\n[ \t\r]*\n/.test(run);
    const hasNl = run.includes("\n");
    const next = lookahead(tokens, i + 1);
    if (hasBlank) decisions[i] = "\n\n";
    else if (hasNl) {
      decisions[i] = /[;{}]/.test(prevChar) || next.comment ? "\n" : " ";
    } else decisions[i] = " ";
  }

  // ---- pass 2: emit HTML lines -------------------------------------------
  const lines = [];
  let cur = { html: [], vis: "", code: "" };
  const flush = () => {
    lines.push(cur);
    cur = { html: [], vis: "", code: "" };
  };
  const st2 = makeStack();
  let pending = null;

  const applyPending = () => {
    if (pending === null) return;
    if (pending === " ") {
      if (cur.vis !== "") {
        cur.html.push(" ");
        cur.vis += " ";
        cur.code += " ";
      }
    } else if (pending === "\n") {
      flush();
    } else if (pending === "\n\n") {
      flush();
      lines.push({ html: [], vis: "", code: "" });
    }
    pending = null;
  };

  for (let i = 0; i < tokens.length; i++) {
    const tk = tokens[i];
    if (tk.t === "ws") {
      const d = decisions[i];
      if (d === " ") {
        if (pending !== "\n" && pending !== "\n\n") pending = " ";
      } else if (d) {
        pending = d === "\n\n" ? "\n\n" : "\n";
      }
      continue;
    }
    if (tk.t === "tag") {
      const closing = isClosing(tk.raw);
      // A space before a closing tag is a soft-wrap artifact; drop it.
      if (closing && pending === " ") pending = null;
      applyPending();
      cur.html.push(tk.raw);
      const wasCom = st2.has("c-com");
      st2.update(tk.raw);
      if (closing && isSpan(tk.raw) && wasCom && !st2.has("c-com")) {
        pending = "\n"; // comment ends its logical line
      }
      continue;
    }
    applyPending();
    cur.html.push(tk.raw);
    cur.vis += tk.raw;
    if (!st2.has("c-str") && !st2.has("c-com")) cur.code += tk.raw;
  }
  flush();

  // ---- pass 3: trim blank edges ------------------------------------------
  while (lines.length && lines[0].vis.trim() === "") lines.shift();
  while (lines.length && lines[lines.length - 1].vis.trim() === "") lines.pop();

  // ---- pass 4: re-indent --------------------------------------------------
  let depth = 0;
  const out = [];
  for (const line of lines) {
    if (line.vis.trim() === "") {
      out.push("");
      continue;
    }
    const code = line.code;
    let indent = depth;
    if (code.trimStart().startsWith("}")) indent = Math.max(0, depth - 1);
    const opens = (code.match(/\{/g) || []).length;
    const closes = (code.match(/\}/g) || []).length;
    const body = line.html.join("").replace(/^\s+/, "").replace(/\s+$/, "");
    out.push("  ".repeat(indent) + body);
    depth = Math.max(0, depth + opens - closes);
  }
  return out.join("\n");
}

function dedentShell(html) {
  const text = tokenize(html)
    .map((t) => t.raw)
    .join("");
  return text
    .split("\n")
    .map((l) => l.replace(/^[ \t]+/, ""))
    .join("\n")
    .replace(/^\n+/, "")
    .replace(/\s+$/, "");
}

export function normalizeCodeBody(html, kind) {
  try {
    if (!html || typeof html !== "string") return html;
    if (!/\S/.test(html)) return html;
    return kind === "shell" ? dedentShell(html) : normalizeVyne(html);
  } catch {
    return html;
  }
}
