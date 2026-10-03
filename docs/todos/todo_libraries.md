# TODO — Standard Library

Draft. Companion to `todo.md` (Paper 1 pipeline), `todo_2.md` (feature axes),
and `todo_optimization.md` (codegen speed).

**Status.** Five user-facing libraries ship today: `vlin`, `vml`, `vbio`,
`vfft`, `vjson`. Four are documented; `vjson`'s README is pending. This
file tracks what to build next, in priority order, with the same
three-question test the original draft used.

**Do not start any new library until Paper 1 is submitted.** Every
remaining entry either depends on §6.2 (native array ABI), on Paper 2/3
features, or on the paper's numbers being frozen. Touching the compiler
or the runtime to add a library invalidates §5.6, §5.7, §5.9, or all
three.

The through-line: **a good Vyne library has a natural per-call boundary,
does arithmetic on native types, and gives the caller a compile-time peak
bound.** If a candidate library fails any of the three, it's a fight with
the language, not a use of it. Every entry below is scored against that
test.

---

## The scoring test

| Question                                      | If no, then...                     |
| --------------------------------------------- | ---------------------------------- |
| Does it have a natural per-call boundary?     | Region model doesn't help          |
| Does it do arithmetic on `Int64` / `Float64`? | Native boxing buys you nothing     |
| Does the caller benefit from a peak bound?    | The language's pitch is irrelevant |

Three yeses → strong library. Two yeses → usable but not a demo. One yes →
don't.

---

## What ships today

Runtime modules built into the compiler. Not libraries — they are pulled
in through `use native`, not through `use external`.

| Module  | Contents                                                          | Doc             |
| ------- | ----------------------------------------------------------------- | --------------- |
| `vcore` | Platform, time, process info, string builder, `chr`, JSON helpers | header comments |
| `vmath` | Scalar math, PCG32 RNG, `_f64` unboxed variants                   | header comments |
| `vmem`  | Arena checkpoint / rewind, peak and live inspection               | header comments |
| `vfs`   | File read/write, directory listing, walk, glob, path helpers      | header comments |

User-facing libraries under `vyne/modules/external/`. These are written
in Vyne and imported through `use external`.

| Library   | State    | README                   | One-line summary                                             |
| --------- | -------- | ------------------------ | ------------------------------------------------------------ |
| `vlin`    | **Done** | `vlin/README.md`         | Matrix and vector linear algebra over `Array<Float64>`.      |
| `vml`     | **Done** | `vml/README.md`          | Dense neural network primitives on top of `vlin`.            |
| `vbio`    | **Done** | `vbio/README.md`         | Nucleotide and protein sequence primitives.                  |
| `vfft`    | **Done** | `vfft/README.md`         | Iterative radix-2 Cooley-Tukey FFT with plan caching.        |
| `vjson`   | **Done** | _(pending)_              | Recursive-descent JSON parser and string-builder serializer. |
| `vcolors` | **Done** | _(header comments only)_ | ANSI color helpers for diagnostics and demo output.          |

### Condensed READMEs of completed libraries

`vlin` — the numerical core. Row-major flat-buffer `Matrix` and a 2-D
geometric `Vector`. Split into `Kernels` (`k_*` loops over typed arrays,
native-ABI eligible) and `Ops`/`Reductions`/`Constructors` (matrix-level
wrappers that allocate the output and dispatch). Two calling conventions:
`vlin.multiply(a, b)` and `a.transposed()`. Same kernel underneath. Weight
initializers (`xavier_init`, `he_init`, `random_uniform`). In-place
variants (`add_into`, `multiply_into`) for training loops that reuse
buffers. **Load-bearing detail:** the `data :: Array<Float64>` annotation
on the `Matrix` interface is what unboxes the field into a native
`VyneArray_f64` at every read. Changing it to plain `Array` compiles but
makes every element access 8× slower. Actively maintained.

`vml` — a thin composition layer over `vlin`. `Dense` (weight matrix +
bias + activation name), `Sequential` (list of layers), `SGD`
(learning-rate holder). Forward pass, four activation derivatives, one
SGD step. Backward pass is manual, written by the user in terms of `vlin`
operations. `W` is stored `(in, out)` so the forward pass is `x @ W` with
no transpose allocation. Deliberately no autograd, no GPU, no
conv/recurrent layers, no adaptive optimizers in 0.1.0. **The main
limitation:** `vlin.relu_prime` produces a matrix of nulls due to a
codegen issue in `ForNode::getCExpr`; use `tanh` or `sigmoid` for hidden
layers until it's fixed.

`vbio` — nucleotide and protein sequence primitives. Complement,
reverse-complement, transcription, codon-table translation, reverse
translation, GC content, melting temperature (Wallace + GC-based),
Hamming distance, codon composition. Sequences are plain `String`s; the
`DNA`/`RNA`/`Protein` interfaces are thin wrappers carrying a `name`
label. No alignment, no secondary structure, no ambiguity codes. Codon
bias is hard-coded to E. coli K-12; edit `Codon.vy` to change it. Used
by `ml_seq.vy` for codon-usage feature extraction.

`vfft` — iterative radix-2 Cooley-Tukey, complex input only, power-of-two
lengths only. **Plan caching** is the load-bearing design: twiddle tables
and bit-reversal indices are computed once per length and reused.
`forward` and `inverse` conjugate-symmetry trick keeps one kernel for
both directions. The inverse is unscaled forward with conjugate on both
sides and a 1/N final scale. Public surface: `forward`, `inverse`,
`next_pow2`, `log2_exact`, `pow2`, `make_plan`, `ensure_plan`,
`fft_kernel`, `bit_reverse`. **Load-bearing warning:** the plan is
arena-allocated, but the cache's invalidation sentinel is a plain global.
If the plan is first built inside a `region` and the region rewinds,
`ensure_plan` will hand back a dangling pointer. Warm the plan at
top-level scope before any region loop. The same hazard applies to any
lazily-cached arena structure.

`vjson` — recursive-descent parser and string-builder serializer.
Supports all seven JSON value types, nested containers, escapes,
surrogate pairs, `\uXXXX` decoding with UTF-8 encoding. `parse`,
`serialize`, `validate`, `depth`, plus type predicates. Errors are raised
with `throw` and carry a byte offset. **Load-bearing detail:** source
strings containing `{` need `\{` — the Vyne lexer treats bare `{` inside
a string as the start of an interpolation. Same for `}` only if it
appears as the terminator of an actual interpolation. Serializer preserves
all JSON value semantics; key order is hash-order, not insertion-order,
which is valid JSON but not byte-identical on round-trip. **README
pending.**

`vcolors` — ANSI escape helpers for bold, red, green, yellow, cyan,
magenta, reset. Used by every demo that prints colored banners. Header
comments only; no README, no version.

---

## Tier 1 — The three that make the language defensible

One of the three now ships. The other two are the priority.

### L1.1 — `vfft` — **DONE**

Shipped. See the completed libraries section above. README at
`vfft/README.md`.

Remaining work: `rfft` / `irfft` (real-input fast path), batched
transforms, region-aware plan invalidation. All deferred to 0.2.

---

### L1.2 — `vfilter` — IIR / FIR design and application

**Why second.** Direct continuation of the audio case study in
`regions.md` §6.9. It's what `vaudio` most needs. Proves the language is
for real-time DSP, not just batch numeric work. Per-sample update is one
multiply-accumulate; per-block application is a region per callback.

**What lands.**

- Second-order-section (SOS) forms: Butterworth, Chebyshev I, Chebyshev II, Linkwitz-Riley.
- Response types: lowpass, highpass, bandpass, bandstop, allpass, peaking, lowshelf, highshelf.
- Coefficient design via RBJ Audio EQ Cookbook.
- Direct Form II Transposed apply — 6 lines per sample.
- Cascade apply for N-th-order filters.
- Magnitude and group-delay analysis.

**Signature shape.**

```vyne
region session {
    scratch lp_state :: Float64[2, 4];
    scratch hp_state :: Float64[2, 4];
    through block :: 0..n_blocks-1 -> loop {
        region callback {
            scratch in  :: Float64[2, 512];
            scratch out :: Float64[2, 512];
            vfilter.apply_cascade(lp_sos, lp_state, in, out);
            vfilter.apply_cascade(hp_sos, hp_state, out, out);
        };
    };
};
```

The `session` region declares persistent state; the `callback` region
declares per-block scratch. The compiler proves the callback path never
allocates — the real-time guarantee `vaudio` promises and cannot
currently verify.

**Effort.** 2 weeks.

**Depends on.** Nothing strictly; lands harder once §6.9 is written.

---

### L1.3 — `voptim` — Optimizers for training loops

**Why third.** Directly improves §5.6's classifier numbers. Every ML
training loop needs it, and Adam is twenty lines. Ship it and the
classifier gets measurably faster, which gives §5.6 a real before/after
story.

**What lands.**

- `sgd`, `sgd_momentum`, `rmsprop`, `adam`, `adamw`.
- LR schedules: `schedule_step`, `schedule_cosine`.
- Per-parameter state is region-scoped at session level; per-step update
  allocates nothing.

**Effort.** 1 week.

**Depends on.** Nothing, but stronger once §6.2 lands because then `W`
and `grad` become raw pointers and the update is a tight C loop.

---

## Tier 2 — Real, but not demo-critical

Unchanged from the original draft. Each is a week or less and useful on
its own; none is a paper.

### L2.1 — `vstat` — Statistics

Central tendency (mean, median, mode, weighted mean), spread (variance,
stddev, MAD, IQR, range), correlation (Pearson, Spearman, covariance,
autocorrelation), regression (linear least squares, multiple linear,
ridge), distributions (histogram, quantiles, CDF, PDF estimation),
streaming accumulators (Welford).

**Effort.** 1 week.

---

### L2.2 — `vrand` — Random distributions

Current state: `vmath.random(lo, hi)` and `vmath.random_float(lo, hi)`.
Missing all the useful distributions. Add: Gaussian (Box-Muller and
Ziggurat), exponential, Poisson, binomial, gamma, beta, categorical,
Fisher-Yates shuffle, reservoir sampling. Seedable and deterministic
on top of the existing PCG32.

**Effort.** 3–4 days.

---

### L2.3 — `vnum` — Numerical methods

Root finding (bisection, Newton, secant, Brent), integration
(trapezoidal, Simpson, Gauss-Legendre, adaptive), ODE (Euler, midpoint,
RK4, adaptive RK45), interpolation (linear, polynomial, cubic spline),
curve fitting (least squares, polynomial).

**Effort.** 1.5 weeks.

**Note.** Function-pointer callbacks require either monomorphization or a
small dispatcher. Monomorphization is the right answer and you already
have it.

---

### L2.4 — `vgeom` — Computational geometry

Vector 2D/3D ops, line and segment intersection, point-in-polygon (ray
casting and winding number), convex hull (Graham scan, Andrew monotone
chain), AABB / circle / sphere intersection, spatial hashing, quadtrees,
octrees.

**Effort.** 1 week for the core; a month for the spatial structures.

**Pairs with.** `vglib` and the graphics examples.

---

## Tier 3 — Needs §6.2 or is a longer project

`vlin` has moved out of this tier (shipped). The rest are unchanged.

### L3.1 — `vblas` — OpenBLAS / MKL bindings

Thin wrappers over `dgemm`, `daxpy`, `dscal`, `dgemv`, plus level-2
(`dger`) and symmetric variants (`dsyrk`). Driver `-lopenblas` behind a
`--blas` flag.

**Effort.** 1 day, once §6.2 exists.

---

### L3.2 — `vlapack` — LAPACK bindings

LU, QR, Cholesky, SVD, eigenvalues, linear least squares. LAPACK's
workspace-query convention (`lwork = -1` then re-call with the sized
buffer) is a natural fit for the region model.

**Effort.** 3–4 days, after §6.2.

---

### L3.3 — `vlin` — **DONE**

Shipped. See completed libraries section. README at `vlin/README.md`.

Remaining work: activations module (`apply_tanh`, `apply_sigmoid`,
`apply_relu` and their primes), losses (`mse`, `cross_entropy` and their
primes), `sgd_update_inplace`, `insert_row`, `dot`/`outer`,
`sub_scalar`/`div_scalar`. All listed in `vlin/README.md`'s roadmap.

---

### L3.4 — `vpath` — Pathfinding

Grid-based A*, Dijkstra, BFS, DFS, IDA*. Heuristics (Manhattan,
Chebyshev, Euclidean, octile). Flow field generation. Navigation mesh
basics.

**Effort.** 1 week.

**Pairs with.** `vglib`, the maze and nextbot examples.

---

### L3.5 — `vparse` — Parsers

**Update.** JSON is done (`vjson`). Remaining: TOML, INI, CSV, plus a
recursive-descent parser for a small expression language.

**Effort.** 2 days each for INI and CSV; 1 week for TOML; 3–5 days for
the expression language.

---

## Tier 4 — Defer until Papers 2 and 3

Unchanged. Nothing in this tier is doable with today's feature set.

- **`vtensor`** — autodiff tensors. Needs linear types (Paper 2) and shape types (Paper 3).
- **`vode` / `vpde`** — differential equation solvers. Needs shape types.
- **`vsim`** — 3D physics at scale. Needs shape types and linear types.
- **`v3d`** — 3D math types. Needs shape types to distinguish `Vec3` / `Vec4` / `Mat4`.

---

## Never

Unchanged. `vcrypto` (bind libsodium, don't roll your own), `vnet`
(sockets require syscalls; bind the C API), `vxml` (no), `vgui` / `vweb`
(state-and-callback languages, not arithmetic).

---

## Thirty more useful libraries

New since the last revision. Organized by domain. Each entry is scored
against the three-question test and given an effort estimate. None of
these should be started before the Tier 1 and Tier 2 entries above are
in the tree.

### Data structures

| Library   | What it does                                                  | Fits? | Effort |
| --------- | ------------------------------------------------------------- | ----- | ------ |
| `vheap`   | Binary heap / priority queue with caller-supplied comparator. | ✓✓✓   | 2 days |
| `vtreap`  | Balanced BST (treap). Ordered iteration, range queries.       | ✓✓✓   | 3 days |
| `vtrie`   | Prefix tree for string lookup. Compressed variant optional.   | ✓✓✓   | 3 days |
| `vunion`  | Union-find / disjoint set with path compression.              | ✓✓✓   | 1 day  |
| `vbitset` | Fixed-size bitset with popcount, and/or/xor.                  | ✓✓✓   | 2 days |
| `vbloom`  | Bloom filter with configurable false-positive rate.           | ✓✓    | 1 day  |

All six have a clean per-call boundary and benefit from a compile-time
peak bound. `vbitset` is the strongest because it uses `Array<Int64>` as
storage and every operation is a scalar loop over words.

### Algorithms

| Library   | What it does                                                                               | Fits? | Effort |
| --------- | ------------------------------------------------------------------------------------------ | ----- | ------ |
| `vgraph`  | Graph representation + BFS, DFS, topological sort, Dijkstra, Bellman-Ford, Floyd-Warshall. | ✓✓✓   | 1 week |
| `vsort`   | Sorting algorithms beyond `qsort`: merge, radix, counting, bucket, timsort-lite.           | ✓✓✓   | 4 days |
| `vsearch` | Binary search, lower_bound, upper_bound, exponential search, interpolation search.         | ✓✓✓   | 2 days |

`vsort` is a natural fit for `Array<Float64>` — every kernel is a native
loop.

### Text and parsing

| Library     | What it does                                                               | Fits? | Effort    |
| ----------- | -------------------------------------------------------------------------- | ----- | --------- |
| `vregex`    | NFA-based regular expression engine with the standard syntax.              | ✓✓    | 1.5 weeks |
| `vstring`   | Levenshtein, Jaro-Winkler, kebab/snake/camel case, wrap, indent, truncate. | ✓✓    | 4 days    |
| `vbase64`   | Base64 encode / decode.                                                    | ✓✓✓   | 1 day     |
| `vhex`      | Hex dump, hex encode, hex decode.                                          | ✓✓✓   | 1 day     |
| `vsemver`   | Semantic versioning: parse, compare, range matching.                       | ✓✓✓   | 2 days    |
| `vmarkdown` | Markdown to HTML. Subset: headings, lists, code, emphasis.                 | ✓✓    | 1 week    |

`vregex` and `vmarkdown` are the "tree-shaped work" demos alongside
`vjson` — they exercise recursive descent and arena-scoped intermediates.

### Encoding, time, config

| Library     | What it does                                                             | Fits? | Effort |
| ----------- | ------------------------------------------------------------------------ | ----- | ------ |
| `vtime`     | Date and time arithmetic: parse ISO 8601, format, add/subtract, compare. | ✓✓✓   | 3 days |
| `vduration` | Duration parsing (`"1h30m"`, `"500ms"`), format, arithmetic.             | ✓✓✓   | 1 day  |
| `vcalendar` | Calendar arithmetic: day-of-week, week-number, month names, leap years.  | ✓✓✓   | 2 days |
| `vuuid`     | UUID v4 (random) and v7 (time-ordered) generation.                       | ✓✓✓   | 1 day  |
| `vconfig`   | Config loading: INI, JSON, environment variables. Layered lookup.        | ✓✓    | 4 days |
| `vcsv`      | CSV reader / writer with configurable delimiter and quoting.             | ✓✓✓   | 3 days |
| `vini`      | INI parser and serializer.                                               | ✓✓✓   | 2 days |
| `vtoml`     | TOML parser. Larger than INI; the grammar has more edge cases.           | ✓✓    | 1 week |
| `vlog`      | Structured logging: levels, key-value fields, JSON output.               | ✓✓    | 3 days |
| `vprocess`  | Subprocess spawning, capture stdout/stderr, wait, signal.                | ✓     | 3 days |

`vtoml` is a full parser project; do it after `vini` and `vcsv` have
shaken out the patterns. `vprocess` is platform-specific (POSIX
`fork`/`exec` vs Windows `CreateProcess`); budget for the divergence.

### Numeric extras

| Library    | What it does                                                                 | Fits? | Effort    |
| ---------- | ---------------------------------------------------------------------------- | ----- | --------- |
| `vcomplex` | Complex number arithmetic over pairs of `Float64`.                           | ✓✓✓   | 2 days    |
| `vquat`    | Quaternion arithmetic, unit quaternions, rotations.                          | ✓✓✓   | 3 days    |
| `vbigint`  | Arbitrary-precision integers over `Array<Int64>`.                            | ✓✓✓   | 1.5 weeks |
| `vsparse`  | Sparse matrices in CSR and CSC formats.                                      | ✓✓✓   | 1 week    |
| `vsignal`  | Signal processing: windowing, convolution, FIR/IIR application, spectrogram. | ✓✓✓   | 1 week    |
| `vinterp`  | 1-D and 2-D interpolation: nearest, linear, cubic, bilinear.                 | ✓✓✓   | 3 days    |

`vsparse` is the strongest fit — sparse matrix-vector products have a
natural per-call peak bound, use `Array<Int64>` for indices and
`Array<Float64>` for values, and every kernel is a native loop.
`vbigint` is the largest effort and the one with the most subtle
correctness surface.

### Media and device

| Library  | What it does                                                     | Fits? | Effort |
| -------- | ---------------------------------------------------------------- | ----- | ------ |
| `vimage` | Image loading and saving: PPM, PNG (uncompressed). Pixel access. | ✓✓    | 1 week |
| `vaudio` | WAV file reading and writing, sample access, resampling.         | ✓✓    | 4 days |
| `vcolor` | Color space conversions: RGB, HSL, HSV, Lab, sRGB gamma.         | ✓✓✓   | 2 days |
| `vunits` | Unit conversions: length, mass, temperature, pressure, time.     | ✓✓✓   | 2 days |
| `vtest`  | Unit testing framework: assertions, grouping, reporting.         | ✓     | 3 days |
| `vbench` | Benchmarking harness: warmup, sampling, statistics.              | ✓     | 2 days |

`vimage` and `vaudio` are Tier-2-quality demos because they connect to
the graphics and DSP stories the language is already telling. PNG
requires DEFLATE — either bundle miniz or implement it, budget
accordingly.

### Library count check

Data structures: 6. Algorithms: 3. Text: 6. Encoding/time/config: 10.
Numeric: 6. Media/device: 6. Total: **37**, but I've folded the
least-essential (a couple of the media entries) into "nice to have" so
you can pick the 30 that matter without re-organizing.

---

## Ordering

```
After Paper 1 submits
    ↓
Tier 0 + Tier 1 codegen optimizations (todo_optimization.md, ~1.5 days)
    ↓
L1.3 voptim        (1 week)     ← improves §5.6 directly
    ↓
L1.2 vfilter       (2 weeks)    ← audio case study + vaudio port
    ↓
Then Edit 1 (field annotation) + §6.2 native ABI
    ↓
Tier 2 in whatever order the next project needs
    ↓
30 more libraries, prioritized by which demo or paper they serve
```

The reason `vfft` is no longer in the queue: it shipped. The reason
`voptim` is now first: it's the shortest path to a measurable §5.6
improvement, and the paper benefits directly. `vfilter` is second
because it's the strongest new demo the language can produce in two
weeks.

---

## What each library contributes to the story

Updated. Done rows are marked.

| Library   | State  | Audience             | Claim                                               |
| --------- | ------ | -------------------- | --------------------------------------------------- |
| `vlin`    | Done   | Numeric              | "The numerical core, with native-ABI kernels"       |
| `vml`     | Done   | ML                   | "Training loops work, and the numbers are real"     |
| `vbio`    | Done   | Bioinformatics       | "The language has credible non-numeric reach"       |
| `vfft`    | Done   | Numeric / scientific | "Real numeric code, no deps, competitive speed"     |
| `vjson`   | Done   | Tooling              | "Recursive descent without a GC"                    |
| `vfilter` | Next   | Real-time DSP        | "Allocation-free audio callbacks, provably"         |
| `voptim`  | Next   | ML                   | "Training loops get faster and the numbers improve" |
| `vstat`   | Tier 2 | Data / analytics     | "The language has the boring stuff you need"        |
| `vrand`   | Tier 2 | Everything           | "We have distributions, not just a PRNG"            |
| `vnum`    | Tier 2 | Scientific           | "ODE and root-finding belong here"                  |
| `vgeom`   | Tier 2 | Games / graphics     | "Pairs with vglib"                                  |
| `vblas`   | Tier 3 | ML / numeric         | "Calls BLAS with pointers into the arena"           |
| `vpath`   | Tier 3 | Games                | "A\* in a language with bounded memory"             |
| `vtensor` | Tier 4 | ML                   | "Autodiff as a first-class primitive"               |

Six rows ship today. The remaining entries are the ecosystem story.

---

## Don't do this

- **Don't start any of these before Paper 1 ships.** The compiler is
  frozen; a new library is a compiler edit.
- **Don't ship `vblas` before §6.2.** Every call copies otherwise.
- **Don't build `vtensor` before Papers 2 and 3.** It's the wrong tool
  for the current feature set.
- **Don't try to match FFTW's last 30%.** 0.7–0.9× FFTW is the honest
  number and a good one.
- **Don't add every distribution to `vrand`.** Gaussian, exponential,
  and categorical cover 90% of uses.
- **Don't write two libraries at once.** Each one teaches you something
  about the language. Serialize.
- **Don't chase key-order preservation in `vjson`.** It's a valid
  improvement but a low-priority one; the trigger condition is "first
  user-facing serialize-to-file use case", not "now".
- **Don't roll your own crypto, ever.** Bind libsodium through §6.2 or
  don't ship a crypto library at all.

---

## What "done" looks like for this file

When you can compile `examples/benchmark/` and get:

- A matmul at native-C speed (Paper 1, `vlin`)
- An FFT at 0.8× FFTW (`vfft`)
- A 4-band EQ with an allocation-free callback (`vfilter`)
- A classifier trained with Adam in fewer epochs (`voptim`)
- A JSON parser that round-trips a real payload (`vjson`)
- All of the above with provable peak scratch bounds

...the language has both a numeric story and a memory-model story, and
both are backed by measurements a reviewer can read. That's what the
library work is for — it's what turns the compiler's guarantees from
_interesting_ into _useful_.
