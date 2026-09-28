# TODO — Standard Library

Draft. Companion to `todo.md` (Paper 1 pipeline), `todo_2.md` (feature axes),
and `todo_optimization.md` (codegen speed).

**Do not start any of this until Paper 1 is submitted.** Every library here
either depends on §6.2 (native array ABI), on Paper 2/3 features, or on the
paper's numbers being frozen. Touching the compiler or the runtime to add a
library invalidates §5.6, §5.7, §5.9, or all three.

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

## Priority order

Three tiers. Tier 1 ships first, each unlocks something the paper or the
next paper needs.

```

Tier 1 (do first): vfft, vfilter, voptim
Tier 2 (do next): vstat, vrand, vnum, vgeom
Tier 3 (later): vpath, vparse, vlin, vblas, vlapack
Tier 4 (defer): vtensor, vode, vsim, v3d
Never: vcrypto, vnet, vxml, vgui, vweb

```

---

## Tier 1 — The three that make the language defensible

Each of the three proves a different audience. Ship all three before
Paper 2. Each is one to two weeks.

---

### L1.1 — `vfft` — Fast Fourier Transform

**Why first.** It's the strongest single numeric demo. FFTW is a
well-known baseline; a Vyne FFT that runs within 2× of FFTW is a real
result. The memory profile is exactly the shape regions solve: three
scratch buffers with per-call lifetimes. And it's the library that
proves Vyne is for "real numeric code," not just matmuls.

**What lands.**

- `vfft.forward(re, im) -> (re, im)` — in-place complex FFT, radix-2
  Cooley-Tukey, precomputed twiddles.
- `vfft.inverse(re, im) -> (re, im)` — same, with conjugation and 1/N
  scaling.
- `vfft.rfft(x) -> (re, im)` — real-input FFT, N/2+1 output bins.
- `vfft.irfft(re, im) -> x` — inverse of the above.
- `vfft.next_pow2(n) -> Int64` — helper for padding.
- Bluestein's algorithm for non-power-of-2 lengths (v2, not v1).

**Signature shape.**

```vyne
use "vfft.vy";

region process {
    scratch re :: Float64[1024];
    scratch im :: Float64[1024];
    scratch tw :: Float64[512];        # twiddle factors, cos only

    # Fill re, zero im.
    ...
    vfft.forward(re, im, tw);
};
```

Note the caller owns the scratch. `vfft` never allocates internally.
That's the point: peak memory is the caller's declaration, provable at
compile time.

**Implementation plan.**

1. Bit-reversal permutation — in-place, needs one swap temp. Week 1, day 1.
2. Radix-2 butterfly loop — the inner loop is 5 lines. Week 1, day 2.
3. Twiddle factor precomputation — cos/sin table, `Float64[N/2]`. Week 1, day 3.
4. `rfft` / `irfft` wrappers via the standard symmetric-packing trick. Week 1, days 4–5.
5. Bit-exactness test: forward then inverse, assert `|x - x'| < 1e-14`. Week 2, day 1.
6. Benchmark against FFTW (`fftw3.h`, `-lfftw3`), report ratio. Week 2, day 2.
7. Write up as §5.10 (or a Paper 2 section). Week 2, days 3–5.

**Deliverable for the paper.** One paragraph: _"Vyne's FFT of length 1024
runs at 0.78× FFTW's speed, written in 40 lines of Vyne, with all three
scratch buffers region-scoped and the peak proven at 12 KB."_ That's the
numeric-language claim, demonstrated.

**Effort.** 1.5–2 weeks.

**Depends on.** Nothing. Can start the day Paper 1 ships.

---

### L1.2 — `vfilter` — IIR / FIR design and application

**Why second.** It's the direct continuation of the audio case study in
`regions.md` §6.9, and it's what `vaudio` most needs. It's the library
that proves Vyne is for real-time DSP, not just batch numeric work. The
per-sample update is a single multiply-accumulate; the per-block
application is a region per callback.

**What lands.**

- **Filter types.** `Butterworth`, `Chebyshev I`, `Chebyshev II`,
  `Linkwitz-Riley` — all second-order-section (SOS) forms.
- **Filter responses.** `lowpass`, `highpass`, `bandpass`, `bandstop`,
  `allpass`, `peaking`, `lowshelf`, `highshelf`.
- **Coefficient design.** RBJ Audio EQ Cookbook formulas — the standard
  reference everyone uses. `vfilter.design_peaking(fs, f0, Q, gain_db) -> Biquad`.
- **Direct application.** `vfilter.apply(biquad, state, input, output)`
  — Direct Form II Transposed, one multiply-add per sample.
- **Cascade application.** `vfilter.apply_cascade(sos_array, states, in, out)`
  — for N-th-order filters implemented as cascaded biquads.
- **Filter analysis.** `vfilter.response_at(biquad, freq, fs) -> Float64`
  — magnitude response in dB. `vfilter.group_delay(biquad, freq, fs)`.

**Signature shape.**

```vyne
region session {
    # Persistent state — one per filter per channel.
    scratch lp_state  :: Float64[2, 4];   # 2 channels, 4 biquad coeffs
    scratch hp_state  :: Float64[2, 4];

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

The `session` region declares the persistent filter state; the `callback`
region declares the per-block scratch. The compiler proves the callback
path never allocates, which is the real-time guarantee that `vaudio`
promises and cannot currently verify.

**Implementation plan.**

1. Biquad coefficient struct + RBJ lowpass/highpass/bandpass (week 1, days 1–2).
2. Direct Form II Transposed apply — 6 lines per sample (week 1, day 3).
3. Cascade apply — outer loop over biquads, inner over samples (week 1, day 4).
4. Shelving and peaking filters (week 1, day 5).
5. Butterworth / Chebyshev design — bilinear transform, pole placement (week 2, days 1–3).
6. Magnitude and phase response (week 2, day 4).
7. Test against `vaudio`'s existing C++ implementation — same input,
   same output, same coefficients (week 2, day 5).

**Deliverable for the paper.** A section showing a 4-band EQ written
in Vyne, provably allocation-free in the audio callback, with coefficients
matching the C++ `vaudio` reference to within float64 rounding.

**Effort.** 2 weeks.

**Depends on.** Nothing strictly, but the demo lands harder once §6.9
(the hoisting-gaps section) is written — the audio callback is exactly
the "region is not a stylistic choice" case.

---

### L1.3 — `voptim` — Optimizers for training loops

**Why third.** It's the smallest of the three and it directly improves
§5.6's classifier numbers. Every ML training loop needs it, and Adam is
twenty lines. Ship it and the classifier gets measurably faster, which
gives §5.6 a real "before/after" story.

**What lands.**

- `voptim.sgd(W, grad, lr)` — already in `vlinalg`; alias it here.
- `voptim.sgd_momentum(W, grad, velocity, lr, momentum)`.
- `voptim.rmsprop(W, grad, square_avg, lr, decay, eps)`.
- `voptim.adam(W, grad, m, v, lr, b1, b2, eps, t)`.
- `voptim.adamw(W, grad, m, v, lr, b1, b2, eps, t, wd)` — Adam with
  weight decay, the modern default.
- `voptim.schedule_step(lr0, gamma, step_every)` — step decay.
- `voptim.schedule_cosine(lr0, lr_min, T_max, t)` — cosine annealing.

Each optimizer takes the parameter matrix and its gradient, plus its
persistent state (momentum buffer, moments), and mutates in place. The
persistent state is region-scoped at session level; the per-step update
allocates nothing.

**Signature shape.**

```vyne
region training {
    # Persistent optimizer state, one buffer per parameter matrix.
    scratch W1_m :: Float64[64, 16];
    scratch W1_v :: Float64[64, 16];
    scratch W2_m :: Float64[16, 12];
    scratch W2_v :: Float64[16, 12];

    through epoch :: 1..EPOCHS -> loop {
        region step {
            # ... forward, backward, produce gradients dW1, dW2 ...
            voptim.adam(W1, dW1, W1_m, W1_v, lr, 0.9, 0.999, 1e-8, epoch);
            voptim.adam(W2, dW2, W2_m, W2_v, lr, 0.9, 0.999, 1e-8, epoch);
        };
    };
};
```

**Implementation plan.**

1. Port `sgd_update_inplace` from `vlinalg/Ops.vy` to `voptim` (day 1).
2. SGD with momentum — one extra buffer, one FMA (day 1).
3. RMSProp — one square-average buffer (day 2).
4. Adam — two buffers, bias correction with `t` (day 2).
5. AdamW — Adam plus decoupled weight decay (day 2).
6. LR schedules — two functions, trivial (day 3).
7. Wire into `ml_seq.vy` as a config option, re-measure §5.6 (days 4–5).

**Deliverable for the paper.** Updated §5.6 numbers showing Adam training
the classifier to the same accuracy in fewer epochs than the current SGD.
The speedup isn't from the optimizer itself (Adam is _more_ work per step)
but from the training loop converging faster, which is the actual claim.

**Effort.** 1 week.

**Depends on.** Nothing, but the ML story is stronger once §6.2 lands,
because then `W` and `grad` become raw pointers and the optimizer is a
tight C loop instead of a boxed dispatch.

---

## Tier 2 — Real, but not demo-critical

Each is useful; none of them is a paper. Ship them as they come up.

---

### L2.1 — `vstat` — Statistics

**What.**

- Central tendency: mean, median, mode, weighted mean.
- Spread: variance, stddev, MAD, IQR, range.
- Correlation: Pearson, Spearman, covariance, autocorrelation.
- Regression: linear least squares, multiple linear, ridge.
- Distributions: histogram, quantiles, CDF, PDF estimation.
- Streaming: Welford accumulator, online mean/var.

**Effort.** 1 week.

**Paper.** No. Section in a "batteries" §7 if you ever write a language
overview paper.

---

### L2.2 — `vrand` — Random distributions

**Current state.** `vmath.random(lo, hi)` and `vmath.random_float(lo, hi)`
exist. Missing all the useful distributions.

**What.**

- Gaussian — Box-Muller (v1) and Ziggurat (v2 for speed).
- Exponential, Poisson, Binomial, Gamma, Beta.
- Categorical sampling from a probability vector.
- Fisher-Yates shuffle.
- Reservoir sampling.
- Seedable, deterministic.

**Effort.** 3–4 days.

**Note.** The PCG32 you ported to `vmath.h` is a fine base RNG. This
library wraps it with distribution-specific transforms.

---

### L2.3 — `vnum` — Numerical methods

**What.**

- Root finding: bisection, Newton-Raphson, secant, Brent.
- Integration: trapezoidal, Simpson, Gauss-Legendre, adaptive.
- ODE: Euler, midpoint, RK4, adaptive RK45.
- Interpolation: linear, polynomial, cubic spline.
- Curve fitting: least squares, polynomial fit.

**Effort.** 1.5 weeks.

**Depends on.** Nothing for v1. Function-pointer-style callbacks for the
root finders and integrators require either monomorphization or a small
dispatcher. Monomorphization is the right answer (you already have it),
but it means each root-finder is instantiated per function.

---

### L2.4 — `vgeom` — Computational geometry

**What.**

- Vector 2D/3D ops (add, sub, dot, cross, normalize).
- Line and segment intersection.
- Point-in-polygon (ray casting, winding number).
- Convex hull (Graham scan, Andrew monotone chain).
- AABB, circle, sphere intersection tests.
- Spatial hashing, quadtrees, octrees.

**Effort.** 1 week for the core; a month for the spatial structures.

**Pairs with.** `vglib` and the graphics examples already in the tree.

---

## Tier 3 — Needs §6.2 or is a longer project

None of these are worth starting until the native array ABI lands. They
exist to bind external C libraries, and until §6.2 makes pointers free,
every call copies.

---

### L3.1 — `vblas` — OpenBLAS / MKL bindings

**Prerequisite.** §6.2 (native array ABI).

**What.** Thin wrappers over the four BLAS workhorses: `dgemm`, `daxpy`,
`dscal`, `dgemv`. Plus level-2 (`dger`) and the symmetric variants
(`dsyrk`).

**Signature.**

```vyne
vblas.dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans,
            M, N, K,
            1.0, A, lda, B, ldb,
            0.0, C, ldc);
```

**Driver.** `-lopenblas` (Linux) or `-lcblas` (Windows via vcpkg) behind
a `--blas` flag. Same shape as `--native`.

**Effort.** 1 day, once §6.2 exists.

---

### L3.2 — `vlapack` — LAPACK bindings

**Prerequisite.** §6.2, plus a way to express "LAPACK wants a workspace
buffer and returns its required size."

**What.**

- LU decomposition (`dgetrf`) + solve (`dgetrs`).
- QR decomposition (`dgeqrf`) + apply (`dormqr`).
- Cholesky (`dpotrf`).
- SVD (`dgesvd`).
- Eigenvalues (`dgeev`, `dsyev`).
- Linear least squares (`dgels`).

**Interesting note.** LAPACK's workspace-query convention —
call once with `lwork = -1` to get the required size, then call again
with the sized buffer — is a natural fit for the region model. The
Vyne wrapper can precompute the workspace as scratch and pass it in.
This is the case where your memory model is _closer to LAPACK's contract_
than a `malloc`-based wrapper would be.

**Effort.** 3–4 days, after §6.2.

---

### L3.3 — `vlin` — Vyne's own linear algebra

**Why separate from `vblas`/`vlapack`.** Because "you don't need LAPACK
for a 64×64 matrix" is a real argument. A pure-Vyne LU with partial
pivoting is 40 lines and matches LAPACK on small matrices while
integrating seamlessly with the region model.

**What.**

- LU with partial pivoting.
- Cholesky.
- QR via Householder reflections.
- Small SVD (Jacobi).
- Linear solve (via any of the above).
- Inverse, determinant, condition number estimate.

**Effort.** 1.5 weeks.

---

### L3.4 — `vpath` — Pathfinding

**What.**

- Grid-based: A*, Dijkstra, BFS, DFS, IDA*.
- Heuristics: Manhattan, Chebyshev, Euclidean, octile.
- Flow field generation.
- Navigation mesh basics.

**Effort.** 1 week.

**Pairs with.** `vglib`, the maze and nextbot examples.

---

### L3.5 — `vparse` — Parsers

**What.**

- JSON parser and serializer.
- TOML, INI, CSV.
- A hand-written recursive-descent parser for a small expression language.

**Why it's interesting.** This is the "Vyne can do tree-shaped work"
demo. It's the closest thing on the list to writing a compiler in Vyne.
If a JSON parser is 200 lines and works, the language has credible
non-numeric reach.

**Effort.** 1 week for JSON, 2 days each for the simpler formats.

---

## Tier 4 — Defer until Papers 2 and 3

Nothing in this tier is doable with today's feature set. They exist so
you don't accidentally start one.

---

### L4.1 — `vtensor` — Autodiff tensors

The diffDSP project. Needs:

- Linear types (Paper 2) for in-place ops.
- Shape types (Paper 3) for static dimension checking.
- Region-aware autodiff (a Paper 2/3 feature — see the earlier
  discussion of checkpointed forward passes).

This is the project that _pays_ for the entire language. It's Paper 4
at the earliest.

---

### L4.2 — `vode` / `vpde` — Differential equation solvers

Needs shape types for state-vector dimensionality. Region-scoped per-step
scratch is the natural fit but the current feature set can't express
"state vector of dimension N" as a type.

---

### L4.3 — `vsim` — 3D physics at scale

Needs shape types and linear types. The integration step is naturally
in-place. Rigid body dynamics, constraint solvers, collision response.
Paper 3 or 4.

---

### L4.4 — `v3d` — 3D math types

Quaternions, 3×3 and 4×4 matrices, transformations. Needs shape types
to distinguish `Vec3` from `Vec4` from `Mat4` — otherwise it's
`vgeom` with worse ergonomics.

---

## Never

The languages that try to do everything do none of them well.

**`vcrypto`.** Writing your own cryptography is a known footgun. Bind
libsodium via §6.2 or don't ship it. Do not implement AES or SHA in Vyne.

**`vnet`.** Sockets require syscalls and platform-specific headers. If
you want network access, bind the C socket API via §6.2 and keep the
wrapper thin.

**`vxml`.** No.

**`vgui` / `vweb`.** GUI and web programming are state-and-callback
languages, not arithmetic. `vglib` and `vserv` are the right scope;
don't go further.

---

## Directory layout

Library modules live under `vyne/modules/external/` today (where
`vlinalg`, `vbio`, `vcolors` are). Keep that structure. Each library
gets a directory with:

```
vyne/modules/external/vfft/
├── vfft.vy              # facade, `use` all sub-modules
├── Types.vy             # any structs/interfaces
├── Forward.vy           # forward transform
├── Inverse.vy           # inverse transform
├── Twiddles.vy          # coefficient precomputation
├── README.md            # one-page usage doc
└── tests/
    └── fft_test.vy      # round-trip bit-exactness test
```

Same shape as `vlinalg`'s existing split. The `use "vfft.vy"` at the
top of a caller file pulls in the whole surface; the linker handles
topological ordering (already works for `vlinalg`).

---

## Implementation order, concretely

```
After Paper 1 submits
    ↓
[Optional] Tier 0 + Tier 1 optimizations (todo_optimization.md, 1.5 days)
    ↓
L1.3 voptim        (1 week)   ← improves §5.6, easiest win
    ↓
L1.1 vfft          (1.5 weeks) ← strongest single numeric demo
    ↓
L1.2 vfilter       (2 weeks)  ← audio case study + vaudio port
    ↓
Then Edit 1 (field annotation) + §6.2 native ABI
    ↓
L3.1 vblas         (1 day)
    ↓
L2.* and L3.* in whatever order the next project needs
```

The reason `voptim` goes first despite being the smallest: it directly
improves §5.6's classifier numbers, and §5.6 is the paper's second-most-
important measurement. A week of work for a real improvement in the
paper is a good trade. `vfft` and `vfilter` are the two "new demo"
libraries, and they can be built in parallel or sequentially depending
on which audience you want to reach first.

---

## What each library contributes to the story

| Library   | Audience             | Claim                                               |
| --------- | -------------------- | --------------------------------------------------- |
| `vfft`    | Numeric / scientific | "Real numeric code, no deps, competitive speed"     |
| `vfilter` | Real-time DSP        | "Allocation-free audio callbacks, provably"         |
| `voptim`  | ML                   | "Training loops get faster and the numbers improve" |
| `vstat`   | Data / analytics     | "The language has the boring stuff you need"        |
| `vrand`   | Everything           | "We have distributions, not just a PRNG"            |
| `vnum`    | Scientific           | "ODE and root-finding belong here"                  |
| `vgeom`   | Games / graphics     | "Pairs with vglib"                                  |
| `vblas`   | ML / numeric         | "Calls BLAS with pointers into the arena"           |
| `vlin`    | Numeric              | "You don't need LAPACK for 64×64"                   |
| `vpath`   | Games                | "A\* in a language with bounded memory"             |
| `vparse`  | Tooling              | "Recursive descent without a GC"                    |
| `vtensor` | ML                   | "Autodiff as a first-class primitive"               |

Three rows in that table are paper-worthy. The rest are "the ecosystem
is real." Both matter — a language with three great libraries and
nothing else looks like a demo, not a language.

---

## Don't do this

- **Don't start any of these before Paper 1 ships.** The compiler is
  frozen; a new library is a compiler edit.
- **Don't ship `vblas` before §6.2.** Every call copies otherwise.
- **Don't build `vtensor` before Papers 2 and 3.** It's the wrong tool
  for the current feature set.
- **Don't try to match FFTW's last 30%.** 0.7–0.9× FFTW is the honest
  number and a good one. Matching FFTW exactly means porting their
  codelet generation, which is a research project, not a library.
- **Don't add every distribution to `vrand`.** Gaussian, exponential,
  and categorical cover 90% of uses. Add more when a real caller needs
  them.
- **Don't write two libraries at once.** Each one teaches you something
  about the language. Serialize.

---

## What "done" looks like for this file

When you can compile `examples/benchmark/` and get:

- A matmul at native-C speed (Paper 1)
- An FFT at 0.8× FFTW (vfft)
- A 4-band EQ with an allocation-free callback (vfilter)
- A classifier trained with Adam in fewer epochs (voptim)
- All of the above with provable peak scratch bounds

...the language has both a numeric story and a memory-model story, and
both are backed by measurements a reviewer can read. That's the point of
the library work — it's what turns the compiler's guarantees from
_interesting_ into _useful_.

---
