# vrand

Random distributions for Vyne.

**Version:** 0.1.0
**Status:** unstable — public surface may change between releases
**Module name:** `vrand`
**Import path:** `use external "vrand/vrand.vy";`
**Requires:** `vmath` (scalar math, PCG32)

---

## Overview

`vrand` is a pure-Vyne random-variates library. It provides the
distributions that numeric, statistical, and machine-learning code
reach for first — Gaussian, exponential, gamma, beta, Poisson,
binomial, geometric, categorical — plus the sampling utilities
(shuffle, reservoir, sample-without-replacement) that pair with them.

Every function is a **pure function over `vmath`'s global PCG32
stream**. There is no per-distribution state, no per-call RNG object,
no caching. `vrand.seed(s)` and `vmath.seed(s)` are the same operation.
If you need two independent streams, seed between the phases that
should be decorrelated, or pull fresh seeds from `vcore.now_ns()`.

The library is deliberately small. It does not provide multivariate
distributions, mixture models, copulas, Markov chains, or any of the
other machinery that a statistics library would eventually need. Each
of those is its own project. What `vrand` provides is the layer
underneath: the individual univariate distributions that everything
else is built on, written to be read and extended rather than called
blindly.

---

## Quick start

```vyne
use external "vrand/vrand.vy";

ruleset { dynamic_casting };

vrand.seed(42);

# Direct sampling.
x :: Float64 = vrand.normal(0.0, 1.0);
y :: Float64 = vrand.exponential(2.5);
k :: Int64   = vrand.poisson(3.5);
b :: Bool    = vrand.bernoulli(0.7);
i :: Int64   = vrand.categorical([0.1, 0.2, 0.3, 0.4]);

# Bulk sampling into a typed array.
samples :: Array<Float64> = [];
through i :: 0..999 -> loop {
    samples.push(vrand.normal(0.0, 1.0));
};

# Sampling utilities.
cards :: Array = [1, 2, 3, 4, 5];
vrand.shuffle(cards);
picked :: Array = vrand.reservoir(cards, 3);
```

Nothing in this library mutates its input except the three `shuffle*`
functions.

---

## Importing

```vyne
use external "vrand/vrand.vy";
```

`vrand.vy` is a facade over four leaf modules:

| Module          | Contents                                                               |
| --------------- | ---------------------------------------------------------------------- |
| `Primitives.vy` | `seed`, `_u`, `_u_avoid_zero`, `_rand_int` — the RNG access layer      |
| `Continuous.vy` | Uniform, normal, exponential, lognormal, gamma, beta                   |
| `Discrete.vy`   | Bernoulli, binomial, geometric, Poisson, categorical, discrete uniform |
| `Sampling.vy`   | Shuffle, reservoir, sample-without-replacement                         |

You can import the leaf modules directly if you want a subset, but the
facade is the recommended entry point. **Do not reorder the `use`
statements in the facade** — `Primitives.vy` must be imported first so
its definitions are in the module registry before the others reference
them.

---

## Module layout

```
vrand/
├── vrand.vy          # facade: use + deploy
├── Primitives.vy     # seed, _u, _u_avoid_zero, _rand_int
├── Continuous.vy     # uniform, normal, exponential, lognormal, gamma, beta
├── Discrete.vy       # bernoulli, binomial, geometric, poisson, categorical
└── Sampling.vy       # shuffle, reservoir, sample_without_replacement
```

### Layering

`vrand` sits directly on top of `vmath` in a two-tier arrangement:

```
vrand/                      ← distribution transforms, sampling
───────────────────────────
vmath/                      ← PCG32 state, unit-uniform primitives
───────────────────────────
Int64 / Float64 arithmetic  ← everything else
```

The boundary between tiers is one function: `vmath.random_float(0.0,
1.0)`, which draws a `Float64` uniformly from `[0, 1)`. Every
distribution in this library is a deterministic transform of a
sequence of such draws. `vrand` never calls the RNG any other way.

---

## The RNG

`vmath` provides a PCG32 generator, seeded through `vmath.seed(s)`.
`vrand.seed(s)` forwards to it. The generator has one global state
shared by every caller in the process, including the interpreter and
any other library that draws from `vmath`.

**Implication:** there is no way to have two independent streams
within a single process. If your program has one phase that should be
reproducible (weight initialization) and another that should not
(dropout masking), seed before each phase with a different constant,
and accept that they advance the same stream.

A future version will expose a `Rand` struct that carries its own
state, once the runtime provides native bitwise operations (needed to
reimplement PCG32 in Vyne). See **Roadmap**.

---

## Reference semantics and the memory model

### Every function is a pure function over the RNG

No distribution carries state. `vrand.normal(mu, sigma)` reads from
the global stream, computes a value, and returns it. Two calls with
the same arguments produce different values because the stream
advances between them.

### Seeding is process-global

`vrand.seed(s)` and `vmath.seed(s)` both write to the same global.
Seeding from one place in the program affects every subsequent draw
from every other place. If you want a phase to be reproducible, seed
immediately before the phase and do not draw from the RNG between the
seed and the phase.

### What allocates

Only three functions allocate on the arena:

- `vrand.normal_pair` returns an `Array<Float64>` of length 2.
- `vrand.reservoir` returns an `Array` of length `k`.
- `vrand.sample_without_replacement` returns an `Array` of length `k`.

Every other function returns a scalar (`Float64`, `Int64`, `Bool`) or
mutates its array argument in place. The `shuffle*` functions use the
input array's own storage and allocate nothing.

Inside a training or sampling loop, wrap the body in a `vmem` region
to bound the memory used by the three allocating functions. The
scalar distributions need no checkpointing — they allocate nothing.

```vyne
module vmem;

through iter :: 0..N-1 -> loop {
    cp = vmem.checkpoint();
    xs :: Array<Float64> = [];
    through i :: 0..999 -> loop {
        xs.push(vrand.normal(0.0, 1.0));
    };
    vmem.rewind(cp);
};
```

---

## API reference

### Seeding

```vyne
vrand.seed(s :: Int64)
```

Seeds the global PCG32 stream. Same operation as `vmath.seed(s)`.
Returns null.

### Continuous distributions

```vyne
vrand.uniform(lo :: Float64, hi :: Float64) -> Float64
vrand.normal(mu :: Float64, sigma :: Float64) -> Float64
vrand.normal_pair(mu :: Float64, sigma :: Float64) -> Array<Float64>
vrand.exponential(rate :: Float64) -> Float64
vrand.lognormal(mu :: Float64, sigma :: Float64) -> Float64
vrand.gamma(shape :: Float64, scale :: Float64) -> Float64
vrand.beta(alpha :: Float64, beta_param :: Float64) -> Float64
```

| Function      | Mean          | Variance           | Notes                                                     |
| ------------- | ------------- | ------------------ | --------------------------------------------------------- |
| `uniform`     | `(lo+hi)/2`   | `(hi-lo)²/12`      | Returns `lo` when `hi <= lo`.                             |
| `normal`      | `mu`          | `sigma²`           | Box-Muller; discards second sample.                       |
| `normal_pair` | `mu`          | `sigma²`           | Returns both samples as a 2-element array.                |
| `exponential` | `1/rate`      | `1/rate²`          | Returns `0` for `rate <= 0`.                              |
| `lognormal`   | (see notes)   | (see notes)        | Parameters are those of the underlying normal.            |
| `gamma`       | `shape*scale` | `shape*scale²`     | Marsaglia-Tsang. Returns `0` for non-positive parameters. |
| `beta`        | `α/(α+β)`     | (see standard ref) | Ratio of two gammas.                                      |

Lognormal mean is `exp(mu + sigma²/2)`, variance is
`(exp(sigma²) - 1) * exp(2*mu + sigma²)`.

### Discrete distributions

```vyne
vrand.bernoulli(p :: Float64) -> Bool
vrand.binomial(n :: Int64, p :: Float64) -> Int64
vrand.geometric(p :: Float64) -> Int64
vrand.poisson(rate :: Float64) -> Int64
vrand.categorical(probs :: Array<Float64>) -> Int64
vrand.discrete_uniform(lo :: Int64, hi :: Int64) -> Int64
```

| Function           | Support         | Mean         | Notes                                              |
| ------------------ | --------------- | ------------ | -------------------------------------------------- |
| `bernoulli`        | `{false, true}` | `p` (as 0/1) | `p` clamped to `[0, 1]`.                           |
| `binomial`         | `0..n`          | `n*p`        | Sum of `n` Bernoullis; O(n).                       |
| `geometric`        | `1, 2, 3, ...`  | `1/p`        | Trials until first success, inclusive.             |
| `poisson`          | `0, 1, 2, ...`  | `rate`       | Knuth for `rate ≤ 30`; normal approximation above. |
| `categorical`      | `0..k-1`        | (from probs) | Linear scan; O(k).                                 |
| `discrete_uniform` | `[lo, hi]`      | `(lo+hi)/2`  | Inclusive on both ends.                            |

### Sampling utilities

```vyne
vrand.shuffle(arr :: Array)
vrand.shuffle_f64(arr :: Array<Float64>)
vrand.shuffle_i64(arr :: Array<Int64>)
vrand.reservoir(stream :: Array, k :: Int64) -> Array
vrand.sample_without_replacement(arr :: Array, k :: Int64) -> Array
```

`shuffle*` mutate their argument in place. `reservoir` and
`sample_without_replacement` allocate a new array of length `k` and
leave their input untouched.

`shuffle` works on any element type because it swaps whole
`VyneValue`s. `shuffle_f64` and `shuffle_i64` take typed arrays and
use the native element path, so the swaps are direct `double` or
`int64_t` loads with no boxing.

---

## Worked example

Estimate the mean of each distribution empirically and confirm that
the sampler is unbiased.

```vyne
use external "vrand/vrand.vy";
use native vmath;

ruleset { dynamic_casting };

vrand.seed(42);

N :: Int64 = 10000;

# ---- Normal(5, 2) ----
xs :: Array<Float64> = [];
through i :: 0..N-1 -> loop { xs.push(vrand.normal(5.0, 2.0)); };

sum :: Float64 = 0.0;
through i :: 0..N-1 -> loop { sum = sum + xs[i]; };
mean :: Float64 = sum / float64(N);
out("Normal(5, 2) empirical mean  = " + string(mean));
out("              expected        = 5.0");
out("");

# ---- Exponential(2) ----
ys :: Array<Float64> = [];
through i :: 0..N-1 -> loop { ys.push(vrand.exponential(2.0)); };

sum = 0.0;
through i :: 0..N-1 -> loop { sum = sum + ys[i]; };
out("Exp(2) empirical mean        = " + string(sum / float64(N)));
out("       expected              = 0.5");
out("");

# ---- Poisson(3.5) ----
total :: Int64 = 0;
through i :: 0..N-1 -> loop { total = total + vrand.poisson(3.5); };
out("Poisson(3.5) empirical mean  = " + string(float64(total) / float64(N)));
out("             expected        = 3.5");
```

The same program also works with any distribution in the table.
Compare the "empirical" and "expected" columns to check that a new
distribution is correct.

---

## Limitations

### Power-of-two restrictions do not apply

`vrand` does not have any power-of-two restrictions. Every function
works for arbitrary parameter values. `normal`, `exponential`,
`gamma`, `beta` all accept real-valued parameters.

### Single global RNG stream

Documented above under **The RNG**. Two independent streams require a
runtime change (native bitwise ops and a state-carrying RNG type) that
is not present in 0.1.0.

### `binomial` is O(n)

The sum-of-Bernoullis implementation is fine for `n` up to a few
hundred. For `n` in the thousands, use `normal(n*p, sqrt(n*p*(1-p)))`
directly and round. The library does not switch automatically because
the normal approximation has a subtle tail behaviour that the caller
should opt into rather than receive silently.

### `poisson` uses a coarse normal approximation above `rate = 30`

Same caveat as `binomial`. The Knuth algorithm is used below the
threshold and produces exact Poisson variates. Above it, the sampler
uses the normal approximation with a continuity correction. If you
need exact Poisson variates for large `rate`, use the PTRS or
transformed-rejection algorithm from your own code; those are ten
lines each and outside the scope of a first-pass library.

### `categorical` is O(k) per draw

Linear scan over the probability vector. For `k` in the hundreds and
draws in the millions, build an alias table. Not built in because the
common case — a handful of categories — does not justify the extra
surface.

### No multivariate distributions

No bivariate normal, no Dirichlet, no multinomial, no Wishart. Each
requires shape tracking and a per-distribution state; none of them
belongs in a first-pass univariate library.

### No distribution objects

There is no `Normal(mu, sigma)` object. Every call passes parameters
explicitly. This is a deliberate choice: it keeps the surface flat,
avoids a `Types` group with one-member interfaces, and matches the
style of every other library in the ecosystem.

### The underlying RNG is PCG32

Adequate for Monte Carlo, weight initialization, and simulation. Not
adequate for cryptographic use. Do not use `vrand.seed` to derive
keys or tokens.

---

## Design notes

### Why `vrand` is stateless

Every distribution is a pure function over the global stream. This is
the same pattern `vjson`'s parser uses — a `Parser` value passed
explicitly through every helper — with one twist: the RNG state is
global rather than explicit, because `vmath` cannot expose it as an
opaque handle. If `vmath` ever gains a state-carrying type, `vrand`
will grow optional `state` parameters on each distribution and keep
the current form as sugar for the default stream.

The stateless design has one clear benefit: the source reads top to
bottom with no hidden state to track. A call to `vrand.normal(0, 1)`
has no side effects beyond advancing the global stream.

### Why Box-Muller and not Ziggurat

Box-Muller requires one `log`, one `sqrt`, and one `cos`/`sin` per
sample. Ziggurat requires a precomputed table and a rejection loop,
and is roughly 2× faster in C. Neither the table nor the loop is
currently easy to express in Vyne — the table is an
`Array<Float64>` that would need to be built at program start, and the
rejection loop is fine but the extra state does not pay for itself at
the sample counts `vrand` targets.

If you are generating billions of normal variates, replace
`vrand.normal` with a Ziggurat in user code. The correctness test —
`forward -> sample -> histogram -> check` — is the same.

### Why `gamma` and `beta` are grouped with continuous

They are not natural companions of `normal` in any mathematical sense,
but they are all called with `Float64` parameters, they all return
`Float64`, and they all share the same helper (`normal` for the
envelope, `_u_avoid_zero` for the clamps). Keeping them in
`Continuous.vy` puts the arithmetic in one file.

### Why no distribution objects

An object-shaped API — `n = vrand.Normal(0, 1); x = n.sample();` —
would be idiomatic in Python and expected in a stats library. In Vyne
0.1.0 it would require an interface with a state field, a per-instance
storage allocation, and a method dispatch through `vyne_struct_call`
on every draw. That is three times the cost per sample for zero
functional benefit.

The library gives you distribution _functions_. If you want object
shape, wrap them in your own interface.

### Why the codegen uses `-> Float64` even for functions that return `VyneValue`

`vrand` declares `-> Float64` on every continuous distribution. This
is a type annotation for the compiler, not a C ABI constraint. The
generated C function still returns `VyneValue`; the annotation only
tells the emitter what the returned value's type is, so that a
subsequent operation on the result can take the fast path.

### Why `_u()` is a function even though it is one line

The helper exists so the transform from `vmath.random_float(0, 1)` to
`Float64` is written once. Without it, every distribution would write
`float64(vmath.random_float(0.0, 1.0))` inline, and any change to the
underlying primitive would touch every call site. The extra function
call is a few nanoseconds; the maintainability is worth it.

---

## Roadmap

### `Rand` state type

A `Rand` interface carrying its own PCG32 state, with `rand.seed(s)`
and per-distribution methods that draw from that state rather than
the global stream. Blocked on a runtime change: the state needs to be
stored as an opaque handle or as two `Int64`s with bitwise primitives
available in the language. Once the runtime exposes either, this
becomes a two-file addition.

### Additional distributions

Gamma variants (inverse-gamma, chi-squared), Dirichlet, multinomial,
Student-t, Fisher-F, Weibull, Pareto, von Mises. Each is a small
addition once a caller needs it. Not built speculatively.

### Bulk sample API

`vrand.sample_into(distribution_id, params, output_array)` for
generating large batches without the per-call boxing overhead of
returning a `VyneValue`. Would require a `Switch` or dispatch table in
Vyne, which does not currently exist. Blocked on a language feature.

### Alias table for `categorical`

For `k > 64` and hot calls. Standard Vose's algorithm, ~30 lines.
Deferred until a caller needs it.

### Ziggurat for `normal`

For callers generating millions of normals per second. Requires a
precomputed table built at first use. Deferred.

### `vrand.binomial` normal approximation switch

Automatically switch to the normal approximation above `n*p > 30`.
Currently the caller decides. Adding the threshold would require a
heuristic that is not obvious, and the current explicit design is
documented.

---

## Version history

**0.1.0** — initial release. `Primitives` (`seed`, `_u`,
`_u_avoid_zero`, `_rand_int`), `Continuous` (uniform, normal,
normal_pair, exponential, lognormal, gamma, beta), `Discrete`
(bernoulli, binomial, geometric, poisson, categorical,
discrete_uniform), `Sampling` (shuffle, shuffle_f64, shuffle_i64,
reservoir, sample_without_replacement). Single global RNG stream.
No state-carrying RNG type.
