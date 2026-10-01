/* ---------------------------------------------------------------------------
 * Vyne docs — client behaviour
 *   reading progress, mobile drawer, table of contents, copy buttons,
 *   back-to-top and the ⌘K command palette.
 * No external dependencies, no network requests (works from file://).
 * ------------------------------------------------------------------------- */
(function () {
  "use strict";

  var body = document.body;
  var ROOT = body.getAttribute("data-root") || "";
  var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* ---------------------------------------------------------------- progress */
  var progress = document.getElementById("progressBar");
  function updateProgress() {
    if (!progress) return;
    var h = document.documentElement;
    var max = h.scrollHeight - h.clientHeight;
    var pct = max > 0 ? (h.scrollTop / max) * 100 : 0;
    progress.style.width = pct + "%";
    if (backToTop) backToTop.classList.toggle("visible", h.scrollTop > 600);
  }

  /* ------------------------------------------------------------ back to top */
  var backToTop = document.getElementById("backToTop");
  if (backToTop) {
    backToTop.addEventListener("click", function () {
      window.scrollTo({ top: 0, behavior: reduceMotion ? "auto" : "smooth" });
    });
  }

  /* --------------------------------------------------------- mobile drawer */
  var sidebar = document.getElementById("sidebar");
  var overlay = document.getElementById("sidebarOverlay");
  var menuToggle = document.getElementById("menuToggle");
  var sidebarClose = document.getElementById("sidebarClose");

  function openDrawer() {
    if (!sidebar) return;
    sidebar.classList.add("open");
    if (overlay) overlay.hidden = false;
    body.classList.add("drawer-open");
    if (menuToggle) menuToggle.setAttribute("aria-expanded", "true");
  }
  function closeDrawer() {
    if (!sidebar) return;
    sidebar.classList.remove("open");
    if (overlay) overlay.hidden = true;
    body.classList.remove("drawer-open");
    if (menuToggle) menuToggle.setAttribute("aria-expanded", "false");
  }
  if (menuToggle) menuToggle.addEventListener("click", openDrawer);
  if (sidebarClose) sidebarClose.addEventListener("click", closeDrawer);
  if (overlay) overlay.addEventListener("click", closeDrawer);

  /* --------------------------------------------------- table of contents */
  var tocList = document.getElementById("tocList");
  var tocEl = document.getElementById("toc");
  var headings = [];
  var tocLinks = [];

  function buildToc() {
    if (!tocList) return;
    var scope = document.querySelector(".page");
    if (!scope) return;
    headings = Array.prototype.slice.call(scope.querySelectorAll("h2, h3"));
    tocList.innerHTML = "";
    tocLinks = [];
    if (!headings.length) {
      if (tocEl) tocEl.classList.add("toc-empty");
      return;
    }
    if (tocEl) tocEl.classList.remove("toc-empty");
    headings.forEach(function (h) {
      var id = h.id;
      if (!id) return;
      var li = document.createElement("li");
      var a = document.createElement("a");
      a.href = "#" + id;
      a.textContent = h.textContent.trim();
      if (h.tagName === "H3") a.classList.add("is-h3");
      a.addEventListener("click", function (e) {
        e.preventDefault();
        h.scrollIntoView({ behavior: reduceMotion ? "auto" : "smooth", block: "start" });
        history.replaceState(null, "", "#" + id);
        setActiveToc(id);
      });
      li.appendChild(a);
      tocList.appendChild(li);
      tocLinks.push(a);
    });
  }

  function setActiveToc(id) {
    tocLinks.forEach(function (a) {
      a.classList.toggle("active", a.getAttribute("href") === "#" + id);
    });
  }

  var ticking = false;
  function spy() {
    ticking = false;
    var current = headings.length ? headings[0].id : null;
    var offset = (document.querySelector(".topbar") || {}).offsetHeight || 70;
    for (var i = 0; i < headings.length; i++) {
      if (headings[i].getBoundingClientRect().top <= offset + 24) current = headings[i].id;
      else break;
    }
    if (current) setActiveToc(current);
  }

  /* -------------------------------------------------------- copy buttons */
  function copyText(text) {
    if (navigator.clipboard && window.isSecureContext) {
      return navigator.clipboard.writeText(text);
    }
    return new Promise(function (resolve) {
      var ta = document.createElement("textarea");
      ta.value = text;
      ta.style.position = "fixed";
      ta.style.opacity = "0";
      document.body.appendChild(ta);
      ta.select();
      try { document.execCommand("copy"); } catch (e) {}
      document.body.removeChild(ta);
      resolve();
    });
  }

  document.querySelectorAll(".copy-btn").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var block = btn.closest(".code-block");
      var bodyEl = block && block.querySelector(".code-body");
      if (!bodyEl) return;
      copyText(bodyEl.innerText).then(function () {
        var original = btn.innerHTML;
        btn.classList.add("copied");
        btn.innerHTML = '<i class="fas fa-check"></i> copied';
        setTimeout(function () {
          btn.classList.remove("copied");
          btn.innerHTML = original;
        }, 1600);
      });
    });
  });

  /* ------------------------------------------------------ command palette */
  var palette = document.getElementById("palette");
  var paletteInput = document.getElementById("paletteInput");
  var paletteResults = document.getElementById("paletteResults");
  var searchTrigger = document.getElementById("searchTrigger");
  var INDEX = window.VYNE_SEARCH || [];
  var results = [];
  var activeIndex = 0;

  function scoreEntry(entry, q) {
    var best = 0;
    if (entry.title.toLowerCase().indexOf(q) !== -1) best = Math.max(best, 90);
    if (entry.title.toLowerCase().startsWith(q)) best = Math.max(best, 120);
    for (var i = 0; i < entry.headings.length; i++) {
      var t = entry.headings[i].text.toLowerCase();
      if (t.startsWith(q)) best = Math.max(best, 80);
      else if (t.indexOf(q) !== -1) best = Math.max(best, 60);
    }
    var ti = entry.text.toLowerCase().indexOf(q);
    if (ti !== -1) best = Math.max(best, 30);
    return best;
  }

  function snippet(text, q) {
    var i = text.toLowerCase().indexOf(q);
    if (i === -1) return "";
    var start = Math.max(0, i - 40);
    return "…" + text.slice(start, i + q.length + 50).trim() + "…";
  }

  function runSearch(q) {
    q = q.trim().toLowerCase();
    results = [];
    if (!q) {
      INDEX.forEach(function (entry) {
        results.push({
          label: entry.title,
          sub: entry.group,
          href: ROOT + entry.path,
        });
      });
    } else {
      var scored = [];
      INDEX.forEach(function (entry) {
        var s = scoreEntry(entry, q);
        if (!s) return;
        var href = ROOT + entry.path;
        scored.push({ s: s, label: entry.title, sub: entry.group, href: href });
        for (var i = 0; i < entry.headings.length; i++) {
          var h = entry.headings[i];
          if (h.text.toLowerCase().indexOf(q) !== -1) {
            scored.push({
              s: s - 5,
              label: h.text,
              sub: entry.title,
              href: href + "#" + h.id,
            });
          }
        }
      });
      scored.sort(function (a, b) { return b.s - a.s; });
      results = scored.slice(0, 40).map(function (r) {
        return { label: r.label, sub: r.sub, href: r.href };
      });
    }
    activeIndex = 0;
    renderResults();
  }

  function renderResults() {
    if (!paletteResults) return;
    if (!results.length) {
      paletteResults.innerHTML =
        '<li class="palette-empty"><i class="fas fa-magnifying-glass"></i> No matches</li>';
      return;
    }
    var q = (paletteInput.value || "").trim().toLowerCase();
    paletteResults.innerHTML = results
      .map(function (r, i) {
        var snip = q ? snippet(r.label + " " + r.sub, q) : "";
        return (
          '<li><a class="palette-item' + (i === activeIndex ? " active" : "") +
          (i === activeIndex ? ' aria-selected="true"' : "") +
          '" href="' + r.href + '" data-index="' + i + '">' +
          '<i class="fas fa-angle-right"></i>' +
          '<span class="palette-text"><span class="palette-label">' + escapeHtml(r.label) + "</span>" +
          '<span class="palette-sub">' + escapeHtml(r.sub) + "</span>" +
          (snip ? '<span class="palette-snip">' + escapeHtml(snip) + "</span>" : "") +
          "</span></a></li>"
        );
      })
      .join("");
    var active = paletteResults.querySelector(".active");
    if (active && active.scrollIntoView) active.scrollIntoView({ block: "nearest" });
  }

  function escapeHtml(s) {
    return String(s)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  var lastFocused = null;
  function openPalette() {
    if (!palette) return;
    lastFocused = document.activeElement;
    palette.hidden = false;
    body.classList.add("palette-open");
    if (!paletteInput.value) runSearch("");
    setTimeout(function () { paletteInput.focus(); paletteInput.select(); }, 20);
  }
  function closePalette() {
    if (!palette) return;
    palette.hidden = true;
    body.classList.remove("palette-open");
    if (lastFocused && lastFocused.focus) lastFocused.focus();
  }

  function move(delta) {
    if (!results.length) return;
    activeIndex = (activeIndex + delta + results.length) % results.length;
    renderResults();
    var active = paletteResults.querySelector(".active");
    if (active) active.scrollIntoView({ block: "nearest" });
  }

  if (searchTrigger) searchTrigger.addEventListener("click", openPalette);
  if (palette) {
    palette.addEventListener("click", function (e) {
      if (e.target.hasAttribute("data-close")) closePalette();
    });
    if (paletteInput) {
      paletteInput.addEventListener("input", function () { runSearch(paletteInput.value); });
      paletteInput.addEventListener("keydown", function (e) {
        if (e.key === "ArrowDown") { e.preventDefault(); move(1); }
        else if (e.key === "ArrowUp") { e.preventDefault(); move(-1); }
        else if (e.key === "Enter") {
          e.preventDefault();
          if (results[activeIndex]) window.location.href = results[activeIndex].href;
        } else if (e.key === "Escape") { e.preventDefault(); closePalette(); }
      });
    }
    if (paletteResults) {
      paletteResults.addEventListener("click", function (e) {
        var item = e.target.closest(".palette-item");
        if (item) {
          e.preventDefault();
          window.location.href = item.getAttribute("href");
        }
      });
      paletteResults.addEventListener("mousemove", function (e) {
        var item = e.target.closest(".palette-item");
        if (!item) return;
        var idx = Number(item.getAttribute("data-index"));
        if (idx !== activeIndex) { activeIndex = idx; renderResults(); }
      });
    }
  }

  document.addEventListener("keydown", function (e) {
    if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "k") {
      e.preventDefault();
      palette && palette.hidden ? openPalette() : closePalette();
      return;
    }
    if (e.key === "Escape") {
      if (palette && !palette.hidden) closePalette();
      else if (sidebar && sidebar.classList.contains("open")) closeDrawer();
    }
    if (e.key === "/" && !/input|textarea/i.test((e.target.tagName || ""))) {
      if (palette && palette.hidden) { e.preventDefault(); openPalette(); }
    }
  });

  /* --------------------------------------------------------------- scroll */
  window.addEventListener("scroll", function () {
    if (!ticking) {
      ticking = true;
      window.requestAnimationFrame(function () {
        updateProgress();
        spy();
      });
    }
  }, { passive: true });

  window.addEventListener("resize", function () {
    if (window.innerWidth > 900) closeDrawer();
  });

  /* ---------------------------------------------------------------- init */
  buildToc();
  updateProgress();
  if (location.hash) {
    var target = document.getElementById(location.hash.slice(1));
    if (target) setTimeout(function () {
      target.scrollIntoView({ block: "start" });
    }, 40);
  }
})();
