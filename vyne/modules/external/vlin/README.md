# vlin

Matrix and vector linear algebra for Vyne.

**Version:** 0.1.0
**Status:** unstable — public surface may change between releases
**Module name:** `vlin`
**Import path:** `use lib "vlin/vlin.vy";`
**Requires:** `vmath` (scalar math), `vcolors` (diagnostic output)

> **On the name.** Earlier drafts of this document referred to the library
> as `vlinalg`. The source has always used `vlin` — in the `module vlin;`
> declaration, in the mangled names, and in the `use lib` path. This manual
> uses `vlin` exclusively. If you have call sites that write
> `vlinalg.foo(...)`, they will not resolve.

---

## Contents

1. [Overview](#overview)
2. [Quick start](#quick-start)
3. [Importing](#importing)
4. [Module layout](#module-layout)
5. [The `Matrix` type](#the-matrix-type)
6. [The `Vector` type](#the-vector-type)
7. [Reference semantics and the memory model](#reference-semantics-and-the-memory-model)
8. [API reference](#api-reference)
9. [Worked example](#worked-example)
10. [Limitations](#limitations)
11. [Design notes](#design-notes)
12. [Roadmap](#roadmap)
13. [Version history](#version-history)

---

## Overview

`vlin` is a pure-Vyne linear algebra library. It provides a small,
predictable set of matrix and vector operations sufficient to build and
prototype dense neural networks, solve small systems of linear
equations, and drive numerical examples directly from Vyne source.

The library deliberately omits the features that make NumPy and BLAS
fast — broadcasting, strided views, SIMD kernels, integer matrices. It
does one thing well: it represents a matrix as a flat
`Array<Float64>` and provides the primitive operations over that
representation that machine-learning workloads actually call.

That flat representation is the same one the Vyne C backend unboxes to
native C when the element type is statically known. A well-typed `vlin`
program compiles to code where `A.data[i]` is a direct `double` load
rather than a boxed `vyne_index_get` dispatch, so the C compiler can
optimize the inner loops.

The library is intentionally small. Everything it exposes is meant to
be read, not just called. The source files are the specification.

---

## Quick start

```vyne
use lib "vlin/vlin.vy";

module vlin;
module vmath;

# 2x2 matrix from a flat buffer (row-major).
a :: vlin.Types.Matrix = vlin.from_flat(2, 2, [1.0, 2.0, 3.0, 4.0]);
b :: vlin.Types.Matrix = vlin.from_flat(2, 2, [5.0, 6.0, 7.0, 8.0]);

# Matrix product: [[1,2],[3,4]] @ [[5,6],[7,8]] == [[19,22],[43,50]]
c :: vlin.Types.Matrix = vlin.multiply(a, b);

out("c[0,0] = " + string(c.get(0, 0)));   # 19.0
out("c[0,1] = " + string(c.get(0, 1)));   # 22.0
out("c[1,0] = " + string(c.get(1, 0)));   # 43.0
out("c[1,1] = " + string(c.get(1, 1)));   # 50.0

# Method form is available for most operations.
d :: vlin.Types.Matrix = vlin.add(a, b);
out("d.sum() = " + string(d.sum()));      # 36.0

e :: vlin.Types.Matrix = vlin.transpose(a);
out("e[0,1] = " + string(e.get(0, 1)));   # 3.0
out("e[1,0] = " + string(e.get(1, 0)));   # 2.0
```

Two calling conventions coexist and are equivalent:

- **Function form** — `vlin.multiply(a, b)` — reads as "apply the
  multiply operation to `a` and `b`".
- **Method form** — `a.transposed()`, `a.sum()` — reads as "ask the
  matrix to do X".

For operations that exist in both forms, use whichever reads better at
the call site. They dispatch to identical kernels.

---

## Importing

```vyne
use lib "vlin/vlin.vy";

module vlin;
module vmath;
```

`vlin.vy` is a facade. It pulls in the leaf modules:

| Module            | Contents                                                        |
| ----------------- | --------------------------------------------------------------- |
| `Types.vy`        | `Matrix` and `Vector` interfaces, group `Types :: vlin`         |
| `Kernels.vy`      | Hot loops over `Array<Float64>`; the native-ABI surface         |
| `Constructors.vy` | Factories and random initializers                               |
| `Ops.vy`          | Matrix arithmetic, matrix products, stacking, in-place variants |
| `Reductions.vy`   | Scalar reductions: sum, mean, min, max, trace, norm             |

You may import individual leaf modules if you want to avoid pulling in
the full surface, but the facade is the recommended entry point.

---

## Module layout

```
vlin/
├── vlin.vy            # facade: use + deploy
├── Types.vy           # Matrix, Vector interfaces
├── Kernels.vy         # k_* functions over Array<Float64>
├── Constructors.vy    # zeros, ones, identity, random initializers
├── Ops.vy             # add, subtract, multiply, transpose, stacking
└── Reductions.vy      # sum, mean, trace, norm_fro, argmax, argmin
```

### Two-layer design

Every user-visible operation is a two-layer composition:

1. **Kernels** (`k_*.vy`): loops over raw `Array<Float64>`. Every
   function takes typed-array parameters and returns either `Int64`
   (a status code, always 0) or `Float64`. This shape makes the call
   site eligible for the native array ABI — the emitter passes `.data`
   directly and the body compiles to a bare C loop over `double*`.

2. **Ops / Reductions / Constructors**: matrix-level wrappers that
   validate shapes, allocate the output buffer, and dispatch to the
   corresponding kernel.

Splitting the two layers this way is what lets `vlin` pay for shape
checks exactly once, at the boundary, and then run unguarded loops in
the hot path.

---

## The `Matrix` type

```vyne
interface Matrix {
    row  :: Int64,
    col  :: Int64,
    data :: Array<Float64>,

    # ... methods ...
}
```

A `Matrix` is a triple: two `Int64` dimensions and a flat
`Array<Float64>`. There is no stride field, no offset, no view
mechanism. Row-major layout is the only layout.

### Storage layout

Element `(r, c)` lives at index `r * col + c` in the flat `data`
buffer.

```
A = [[a00, a01, a02],
     [a10, a11, a12]]     (2 rows, 3 cols)

A.data = [a00, a01, a02, a10, a11, a12]
             0    1    2    3    4    5
```

This is the layout C uses for nested arrays, the layout BLAS uses for
row-major matrices, and the layout most ML frameworks use internally.
It matters if you plan to interoperate with `vlin` from native code,
because the flat `data` buffer is the interop surface.

### The `Array<Float64>` annotation is load-bearing

The `data` field is annotated `Array<Float64>`, not `Array`. The
annotation is read by the Vyne C backend: when a struct field is
annotated with a typed-array type, the backend unboxes that field into
a native `VyneArray_f64` on every read, so `A.data[i]` compiles to a
direct `double` load rather than a boxed `vyne_index_get` dispatch.

Changing the annotation to plain `Array` still type-checks in Vyne
source, but makes every element access in the library roughly 8×
slower. Do not change it.

---

## The `Vector` type

```vyne
interface Vector {
    x :: Int64,
    y :: Int64,

    magnitude() -> Float64 { ... }
    slope()     -> Float64 { ... }
    dot(other)  -> Int64   { ... }
    cross_product(other) -> Int64 { ... }
}
```

`Vector` is a **2-D geometric vector** — two `Int64` components, not
an n-dimensional container. It exists for geometry problems and is not
used by the matrix code paths. Neural-network code represents vectors
as `Matrix` instances with one dimension equal to 1.

If you need a general n-dimensional vector, use `Matrix` with shape
`(N, 1)` or `(1, N)`.

---

## Reference semantics and the memory model

### Arrays and matrices are passed by reference

Vyne arrays are passed by reference, not by value. A `Matrix` parameter
aliases the caller's `data` buffer:

```vyne
fn mutate(m :: vlin.Types.Matrix) {
    m.data[0] = 999.0;
}

A :: vlin.Types.Matrix = vlin.zeros(2, 2);
mutate(A);
out(A.data[0]);   # 999.0
```

Same semantics as Python lists, JavaScript arrays, and Lua tables.

If you want a defensive copy, call `m.copy()` at the top of the
function. That is the only way to obtain value semantics in Vyne.

### Every operation allocates, except `m.flatten()` and in-place variants

Each function in `Ops.vy` and `Reductions.vy` that returns a `Matrix`
allocates a fresh backing buffer from the arena. Two exceptions exist:

- `m.flatten()` returns the internal `data` buffer itself, **not a
  copy**. Mutating it mutates the matrix.
- The `*_into` functions (`add_into`, `multiply_into`,
  `add_bias_into`) write into a caller-provided destination instead of
  allocating a new result.

### Arena lifetime and `vmem`

Under the default memory model, arena allocations live until process
exit. A training loop that allocates a fresh matrix per iteration grows
memory monotonically unless you checkpoint with `vmem`:

```vyne
module vmem;

through epoch :: 1..N -> loop {
    cp = vmem.checkpoint();

    # Every vlin operation in here allocates.
    # All of it is dropped at the rewind.
    #
    # (only safe if you don't return anything out of the region — see
    #  the runtime docs on region escapes for the details)

    vmem.rewind(cp);
};
```

For a `64 → 16 → 12 → 1` MLP at batch size 240, that is roughly 1.5 MB
of intermediates per forward-plus-backward pass. Across 500 epochs,
750 MB without a checkpoint; a few hundred kB with one.

---

## API reference

### Constructors

```vyne
vlin.zeros(rows :: Int64, cols :: Int64) -> Matrix
vlin.ones(rows :: Int64, cols :: Int64) -> Matrix
vlin.full(rows :: Int64, cols :: Int64, value :: Float64) -> Matrix
vlin.identity(n :: Int64) -> Matrix
```

Fill matrices. `identity` produces an `n × n` diagonal matrix of ones
with zeros elsewhere.

```vyne
vlin.from_array(data :: Array) -> Matrix
```

Build a matrix from a nested array. `data[r][c]` becomes element
`(r, c)`. Column count is inferred from `data[0]`. The function does
not validate that inner arrays have consistent lengths.

```vyne
vlin.from_flat(rows :: Int64, cols :: Int64, data :: Array) -> Matrix
```

Build a matrix from a flat array. `data[r * cols + c]` becomes element
`(r, c)`. Same absence of length validation.

```vyne
vlin.random_uniform(rows, cols, lo :: Float64, hi :: Float64) -> Matrix
vlin.xavier_init(rows :: Int64, cols :: Int64) -> Matrix
vlin.he_init(rows :: Int64, cols :: Int64) -> Matrix
vlin.random_init(rows :: Int64, cols :: Int64) -> Matrix
```

Weight initializers.

- `random_uniform` draws every element uniformly from `[lo, hi)`.
- `xavier_init` draws uniformly from `[-L, L]` with
  `L = sqrt(6 / (rows + cols))` (Glorot uniform, appropriate for
  `tanh` / `sigmoid`).
- `he_init` draws uniformly from `[-L, L]` with `L = sqrt(6 / cols)`
  (He uniform, appropriate for ReLU networks when the matrix is
  applied as `Y = X · W`).
- `random_init` draws uniformly from `[-0.5, 0.5)`. Provided for
  symmetry; rarely what you want.

All initializers call `vmath.random_float`. See **Limitations** for
the RNG's quality.

#### Low-level typed-array allocators

These are part of the public surface because they are the ABI boundary
between kernel and wrapper. Most users should not call them directly.

```vyne
vlin.zeros_f64(n :: Int64)              -> Array<Float64>
vlin.ones_f64(n :: Int64)               -> Array<Float64>
vlin.fill_f64(n :: Int64, v :: Float64) -> Array<Float64>
vlin.clone_f64(a :: Array<Float64>, n :: Int64) -> Array<Float64>
```

### Element-wise ops

```vyne
vlin.add(a :: Matrix, b :: Matrix)      -> Matrix
vlin.subtract(a :: Matrix, b :: Matrix) -> Matrix
vlin.hadamard(a :: Matrix, b :: Matrix) -> Matrix
```

All three require `a.row == b.row` and `a.col == b.col`. On mismatch
they print a red diagnostic via `vcolors` and return a `0 × 0` matrix.
They do not raise.

- `add` computes `a[i] + b[i]`.
- `subtract` computes `a[i] - b[i]`.
- `hadamard` computes `a[i] * b[i]` (Schur product).

### Matrix products

```vyne
vlin.multiply(a :: Matrix, b :: Matrix)           -> Matrix
vlin.multiply_trans_b(a :: Matrix, b :: Matrix)   -> Matrix
vlin.transpose(m :: Matrix)                       -> Matrix
```

`multiply` is the ordinary matrix product. Requires `a.col == b.row`,
returns shape `(a.row, b.col)`. On mismatch, red diagnostic and `0 × 0`.

`multiply_trans_b` computes `a @ b.T`. Requires `a.col == b.col` and
returns shape `(a.row, b.row)`. Both inner reads are contiguous in
the reduction dimension, which is the form you want for the backward
pass of a dense layer.

`transpose` delegates to `Matrix.transposed()`. Same semantics, same
allocation profile.

The implementation is a straightforward triple loop with no blocking,
no cache-aware traversal, and no SIMD. For matrices larger than a few
hundred elements per side, the constant factor is significantly worse
than a tuned BLAS. Acceptable for the library's target use cases (small
dense networks, small linear systems); not for large-scale numerical
work.

### Scalar ops

```vyne
vlin.add_scalar(m :: Matrix, s :: Float64)      -> Matrix
vlin.multiply_scalar(m :: Matrix, s :: Float64) -> Matrix
vlin.clip(m :: Matrix, lo :: Float64, hi :: Float64) -> Matrix
```

`add_scalar` and `multiply_scalar` apply an affine transformation
element-wise. `clip` applies `vmath.clamp(x, lo, hi)` — which silently
swaps the bounds if `lo > hi`.

### Bias, stacking

```vyne
vlin.add_bias(m :: Matrix, b :: Array<Float64>) -> Matrix
vlin.vstack(a :: Matrix, b :: Matrix) -> Matrix
vlin.hstack(a :: Matrix, b :: Matrix) -> Matrix
```

`add_bias` takes a plain `Array<Float64>`, not a `Matrix`. The bias
vector broadcasts row-wise: `out[r][c] = m[r][c] + b[c]`. `b` must
have length `m.col`.

`vstack` requires matching column counts and produces a matrix with
`a.row + b.row` rows. `hstack` requires matching row counts and
produces a matrix with `a.col + b.col` columns. Both return `0 × 0`
on mismatch with a red diagnostic.

### In-place variants

```vyne
vlin.add_into(output :: Matrix, a :: Matrix, b :: Matrix)      -> Int64
vlin.multiply_into(output :: Matrix, a :: Matrix, b :: Matrix) -> Int64
vlin.add_bias_into(m :: Matrix, b :: Array<Float64>)           -> Int64
```

Write into a caller-provided `output` matrix instead of allocating a
fresh result. Return `0` on success, `-1` on shape mismatch (also
printing a red diagnostic).

These exist because the arena is not free. In a training loop, the
functional form of `add` allocates a new backing buffer per call. The
in-place variant lets you reuse one buffer across iterations.

**These functions mutate their destination.** If `output` aliases any
of the inputs (e.g. `add_into(a, a, b)`), behavior is undefined — the
kernel writes one element at a time and reads both inputs at each
step.

### Reductions

```vyne
vlin.sum(m :: Matrix)     -> Float64
vlin.mean(m :: Matrix)    -> Float64
vlin.minimum(m :: Matrix) -> Float64
vlin.maximum(m :: Matrix) -> Float64
vlin.norm_fro(m :: Matrix) -> Float64
vlin.trace(m :: Matrix)   -> Float64
vlin.argmax(m :: Matrix)  -> Int64
vlin.argmin(m :: Matrix)  -> Int64
```

- `sum` — sum of all elements.
- `mean` — `sum / (row * col)`. Returns 0 for an empty matrix.
- `minimum`, `maximum` — scalar extremum over all elements. Return 0
  for an empty matrix.
- `norm_fro` — Frobenius norm, `sqrt(sum of squares)`. Never negative.
- `trace` — sum of the main diagonal. For a non-square matrix, the
  diagonal length is `min(row, col)`.
- `argmax`, `argmin` — flat index of the extremum. Return 0 for an
  empty matrix.

### Matrix methods

The `Matrix` interface exposes the following methods. All are called
`m.method(args)`.

#### Shape and structure

| Method          | Returns          | Notes                                 |
| --------------- | ---------------- | ------------------------------------- |
| `m.shape()`     | `Array`          | `[row, col]`                          |
| `m.size()`      | `Int64`          | `row * col`                           |
| `m.is_square()` | `Bool`           | `row == col`                          |
| `m.is_vector()` | `Bool`           | `row == 1` or `col == 1`              |
| `m.get(r, c)`   | `Float64`        | Element at `(r, c)`. No bounds check. |
| `m.copy()`      | `Matrix`         | Deep copy of the data buffer          |
| `m.flatten()`   | `Array<Float64>` | Returns `m.data` (shared, not copied) |
| `m.row_at(r)`   | `Array<Float64>` | Row `r` as a fresh flat array         |
| `m.col_at(c)`   | `Array<Float64>` | Column `c` as a fresh flat array      |

#### Reductions (delegating to `vlin.*`)

| Method         | Returns   |
| -------------- | --------- |
| `m.sum()`      | `Float64` |
| `m.mean()`     | `Float64` |
| `m.minimum()`  | `Float64` |
| `m.maximum()`  | `Float64` |
| `m.trace()`    | `Float64` |
| `m.norm_fro()` | `Float64` |
| `m.argmax()`   | `Int64`   |
| `m.argmin()`   | `Int64`   |

#### Element-wise (returns fresh `Matrix`)

| Method            | Returns  | Notes                |
| ----------------- | -------- | -------------------- |
| `m.negate()`      | `Matrix` | Element-wise `-x`    |
| `m.add_scalar(s)` | `Matrix` | Element-wise `x + s` |
| `m.mul_scalar(s)` | `Matrix` | Element-wise `x * s` |

#### Shape manipulation

| Method                  | Returns  | Notes                                                                          |
| ----------------------- | -------- | ------------------------------------------------------------------------------ |
| `m.reshape(rows, cols)` | `Matrix` | Requires `rows*cols == row*col`; else prints diagnostic and returns `m.copy()` |
| `m.transposed()`        | `Matrix` | Returns a fresh `(col, row)` matrix                                            |

### Vector methods

| Method                   | Returns   | Notes                             |
| ------------------------ | --------- | --------------------------------- |
| `v.magnitude()`          | `Float64` | Euclidean length: `sqrt(x² + y²)` |
| `v.slope()`              | `Float64` | `y / x`; undefined for `x == 0`   |
| `v.dot(other)`           | `Int64`   | `x · o.x + y · o.y`               |
| `v.cross_product(other)` | `Int64`   | `x · o.y − y · o.x`               |

### Internal kernels

These are the `k_*` functions in `Kernels.vy`. They are public in the
sense that the parser will resolve `vlin.k_add(...)`, but they are not
part of the stable interface — the parameter order, return type, and
even the function list may change between versions. Use them only if
you are building a new wrapper layer and want to reuse an existing
loop.

```vyne
# Element-wise binary (output, a, b, n) -> Int64 (0)
vlin.k_add / k_sub / k_mul / k_div

# Scalar and unary
vlin.k_scale(output, a, s, n) -> Int64
vlin.k_add_scalar(output, a, s, n) -> Int64
vlin.k_fill(output, v, n) -> Int64
vlin.k_copy(output, a, n) -> Int64
vlin.k_neg(output, a, n) -> Int64

# Reductions (no output buffer)
vlin.k_sum(a, n)     -> Float64
vlin.k_dot(a, b, n)  -> Float64
vlin.k_norm_sq(a, n) -> Float64
vlin.k_max(a, n)     -> Float64
vlin.k_min(a, n)     -> Float64

# Matrix products
vlin.k_matmul(output, a, b, M, K, N)         -> Int64
vlin.k_matmul_trans_b(output, a, b, M, K, N) -> Int64

# Transpose
vlin.k_transpose(output, a, R, C) -> Int64
```

---

## Worked example

A minimal forward pass through a 2-layer MLP, using only the current
surface.

```vyne
use lib "vlin/vlin.vy";

module vlin;
module vmath;

vmath.seed(42);

# Layer 1: 4 inputs -> 3 hidden units.
W1 :: vlin.Types.Matrix = vlin.xavier_init(3, 4);
b1 :: vlin.Types.Matrix = vlin.zeros(1, 3);

# Layer 2: 3 hidden -> 1 output.
W2 :: vlin.Types.Matrix = vlin.xavier_init(1, 3);
b2 :: vlin.Types.Matrix = vlin.zeros(1, 1);

# Batch of 2 samples, 4 features each.
X :: vlin.Types.Matrix = vlin.from_flat(2, 4, [
    0.5, -0.2, 0.1, 0.3,
    0.0,  0.7, -0.5, 0.2
]);

# Forward: h = tanh(X @ W1.T + b1);  y = h @ W2.T + b2
h_pre :: vlin.Types.Matrix = vlin.multiply_trans_b(X, W1);
h_biased :: vlin.Types.Matrix = vlin.add(h_pre, b1);     # note: bias row broadcast
                                                          # is not implemented; b1 is
                                                          # shape (1,3) not (2,3).
h :: vlin.Types.Matrix = vlin.apply_tanh(h_biased);       # not in 0.1.0; see Roadmap.

y_pre :: vlin.Types.Matrix = vlin.multiply_trans_b(h, W2);
out("y[0,0] = " + string(y_pre.get(0, 0)));
```

The example above is intentionally incomplete — it exercises exactly
the operations that exist in 0.1.0 and marks the one that does not
(`apply_tanh`) so you can see the shape of the missing surface. For
a forward pass today, replace `vlin.apply_tanh` with a hand-written
loop using `m.data[i] = vmath.tanh(m.data[i])` and construct the
result matrix manually. See **Roadmap** for the plan.

For a fully working example that only uses present functions, see the
`vlin_test.vy` file in `examples/`.

---

## Limitations

### No broadcasting

Binary operations require matching shapes. There is no NumPy-style
implicit expansion. `vlin.add` of a `(N, C)` matrix and a `(1, C)`
row vector will fail; use `vlin.add_bias`, which takes a plain
`Array<Float64>` of length `C` and broadcasts row-wise.

### No views or slicing at the library level

There is no `vlin.slice`. If you need a submatrix, copy the elements
into a fresh matrix yourself. `m.data[lo:hi]` returns a flat array,
not a matrix; reconstructing a matrix from a flat slice requires
`vlin.from_flat`.

### No shape validation in constructors

`vlin.from_flat` and `vlin.from_array` trust that the shape you supply
matches the data. Passing `rows * cols != data.size()` produces a
matrix that will misbehave on any subsequent operation. The
constructor `vlin.Types.Matrix(rows, cols, data)` is even more
permissive — it does no checking at all.

### The random number generator is not strong

`vlin`'s weight initializers call `vmath.random_float`, which uses a
small linear congruential generator. The low-order bits have short
periods and consecutive outputs show visible correlation. Adequate for
weight initialization (any reasonably uniform spread of small values
works); not adequate for cryptographic or statistical use. A stronger
generator is a language-level change, not a library change.

### Performance

Every operation is a scalar loop with no blocking, no vectorization,
and no tuned kernels. The library compiles to code the C compiler can
optimize, but not to code that uses SIMD instructions or multithreaded
BLAS. For small matrices (up to a few thousand elements) the constant
factor is negligible. For larger matrices, runtime is dominated by
memory traffic and will be significantly slower than a tuned library.

If you need fast dense linear algebra, use a system BLAS through the
`extern` module system. `vlin` is not intended to replace one.

### No integer matrices

Every element is a `Float64`. If you need integer arithmetic, work
directly with `Array<Int64>` or accept the floating-point rounding
that comes with representing integers as doubles.

---

## Design notes

### Why a flat buffer instead of nested arrays

A nested `Array<Array<Float64>>` would be more natural to write and
would allow each row to be independently allocated, which is sometimes
useful. The flat buffer is faster because the C backend unboxes the
entire `Array<Float64>` into a contiguous `double*`, and element
access becomes a single index computation. A nested array would have
each row as a separate boxed `VyneArray_f64`, doubling the number of
unboxing boundaries in the inner loops.

The flat representation is also the standard for interop. BLAS,
LAPACK, and most GPU libraries assume row-major or column-major flat
buffers, not nested arrays.

### Why both method and function forms

The method form on `Matrix` is the interface's natural expression: a
matrix "has" a shape, "can" be transposed. The function form in `Ops`
and `Reductions` is what you get when you want to treat operations as
first-class values, compose them, or pass them to higher-order code.

Maintaining both costs one line per operation (the function simply
calls the method, or vice versa) and provides a significantly more
flexible surface. Same convention as Kotlin's collections library and
Swift's standard library.

### Why the `k_` kernels are separate from the ops

The split exists because of the native array ABI. A function whose
parameters are all `Array<Float64>` and whose return type is `Int64`
or `Float64` is emitted as a native C function taking `double*`
arguments and returning a scalar. There is no boxing, no per-element
tag check, no arena traffic inside the loop.

If the shape check lived inside the kernel, the kernel would need to
take two `Matrix` values instead of two `Array<Float64>` values, and
would lose the ABI. Keeping validation in the wrapper and iteration in
the kernel is what makes the fast path available.

### Why no broadcasting

Broadcasting is subtle to specify, subtle to implement, and subtle to
reason about when shapes interact across multiple operations. For a
library whose primary use case is small dense neural networks, the
explicit shapes are clearer and the additional code is negligible.
`add_bias` exists specifically because the bias-broadcast pattern is
common enough to justify its own function, but there is no general
mechanism.

If you want broadcasting, implement it in user code by replicating the
smaller operand into a shape-matched copy and calling the binary
operation. That gives you full control over which broadcast rule
applies.

### Why the group is `Types :: vlin`

The `Types` group isolates the interface definitions from the
free-function namespace. Users write `vlin.Types.Matrix`, not
`vlin.Matrix`, which mirrors how the constructors and ops are
namespaced and makes it obvious at a call site that a name refers to a
type, not an operation.

---

## Roadmap

The following are planned or in progress. They are listed here so
that the manual is honest about the gap between the intended surface
and the current one.

### Activations module (planned: `Activations.vy`)

Element-wise non-linearities: `apply_sigmoid`, `apply_tanh`,
`apply_relu`, `apply_exp`, `apply_log`, plus their derivatives
`sigmoid_prime`, `tanh_prime`, `relu_prime`, and the normalization
helpers `softmax` and `normalize`.

`relu_prime` is blocked on a codegen issue: the current C backend
emits both branches of an `if/else` inside a `collect` block and
pushes `vyne_null()`. Until `ForNode::getCExpr` is fixed, ReLU's
derivative produces a matrix of nulls. Until then, use `tanh` or
`sigmoid` for hidden-layer activations.

### Losses module (planned: `Losses.vy`)

Mean squared error and binary cross-entropy, plus their derivatives:

```
vlin.mse(pred, target)             -> Float64
vlin.mse_prime(pred, target)       -> Matrix
vlin.cross_entropy(pred, target)   -> Float64
vlin.cross_entropy_prime(pred, target) -> Matrix
```

### In-place SGD update (planned)

```vyne
vlin.sgd_update_inplace(W :: Matrix, grad :: Matrix, lr :: Float64)
```

Applies `W[i] = W[i] - lr * grad[i]` directly to `W`'s backing buffer.
Returns `null`.

This is the one mutating operation planned for the library. It exists
for two reasons:

1. It eliminates the two allocations (`multiply_scalar` and `subtract`)
   that the functional equivalent produces. For a training loop, that
   is a real win.
2. It keeps the weight matrix at a fixed address across training
   iterations — required for the weight matrix to remain valid across
   a `vmem.rewind` boundary.

The functional equivalent without the in-place semantics is
`vlin.subtract(W, vlin.multiply_scalar(grad, lr))`. That form is
correct and unambiguous but allocates two intermediate matrices.

### `insert_row` method (planned)

```vyne
m.insert_row(new_row :: Array<Float64>) -> Matrix
```

Appends a row to a matrix. `new_row.size()` must equal `m.col`.

### Dot and outer for matrix-vector (planned)

```vyne
vlin.dot(a :: Matrix, b :: Matrix)   -> Float64
vlin.outer(a :: Matrix, b :: Matrix) -> Matrix
```

`dot` handles the four shapes `1×n · 1×n`, `m×1 · m×1`, `1×n · m×1`,
and `m×1 · 1×n`. `outer` computes `out[i][j] = a[i] * b[j]`.

### More scalar methods (planned)

`m.sub_scalar(s)` and `m.div_scalar(s)`, for symmetry with the current
`add_scalar` / `mul_scalar`.

---

## Version history

**0.1.0** — initial release. `Types`, `Kernels`, `Constructors`,
`Ops`, `Reductions`. Method and function forms for the reductions.
In-place `*_into` variants for element-wise add, matrix product, and
bias addition.
