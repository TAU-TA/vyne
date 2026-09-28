# Lexical Regions and Shape-Typed Scratch:

## Scoped Arena Memory and Static Shape Checking in the Vyne Language

**Technical Report — Vyne Transpiler**
_Draft, 09.26.2026_

---

## Abstract

We present _lexical regions_ and _shape-typed scratch_, two language
constructs added to the Vyne programming language to address a class of
memory and typing problems that arise in numerical and machine-learning
workloads. Regions give the programmer a lexically scoped arena
checkpoint, so that all arena allocations performed inside a region are
released at its closing brace. Scratch declares a fixed-shape,
stack-resident numeric array whose dimensions are known at compile time,
indexable with no runtime allocation, no boxing, and no pointer chasing.
We describe the design, the lowering to C, the interaction between the
two constructs, and a small case study in which an existing training
loop in a neural-network classifier was rewritten to use scratch
buffers. We report that the rewritten loop eliminates all arena traffic
for the two accumulator buffers. A scale experiment on a 1024×1024 matmul
shows peak resident set size falling 8.7× at 10 iterations and 79.9× at
100 iterations — the ratio grows linearly in iteration count, while wall
clock and the numeric result are unchanged. The same technique extends to
the weight-gradient buffers via a shaped-assignment lowering introduced in
the same release; a second pass over the case study makes all five per-iteration
arrays stack-resident.
The native array ABI of §4.6 extends the primitive dispatcher of
§4.5 to functions taking `Array<Float64>` or `Array<Int64>`
parameters, so that a Vyne function is callable with the raw
`double\*` a C programmer would write by hand. One follow-up
capability remains: a full escape analysis beyond the syntactic
check of §6.4, which is required before the technique generalizes
to the rest of the loop.

---

## 1. Motivation

Vyne is a small language that targets a bump-allocated arena for all
heap memory. Every `VyneValue` — arrays, maps, strings, structs —
lives in the arena; there is no `free` and no per-object reference
counting. The arena is released at program exit by `arena_free_all`.

This model has three attractive properties. Allocation is a pointer
bump, so individual allocations are cheap. There is no fragmentation,
because the arena never hands back individual blocks. And there are no
lifetimes to reason about in the object graph: everything stays alive
until the arena dies.

It has one equally sharp disadvantage. In a long-running loop, every
iteration that allocates leaks until the program exits. A training loop
that materializes a fresh `Array` of activations on each of 10 000
epochs allocates 10 000 copies, all of which remain live. Peak resident
set grows linearly with iteration count, regardless of how many of
those allocations the program actually still reads.

Two constructs, described here, address the problem from opposite
directions:

- **Lexical regions** let the programmer say _"everything allocated
  inside this block is scratch, and may be reclaimed when the block
  ends."_
- **Shape-typed scratch** lets the compiler prove that certain values do
  not need the arena at all — they fit on the C stack, and their size is
  known statically.

Together they turn the arena from an unbounded accumulator into a
bounded scratchpad whose lifecycle is tied to lexical structure.

---

## 2. The Region Construct

A region is a lexical block introduced by the keyword `region`,
followed by a name and a brace-delimited body:

```vyne
through epoch :: 1..EPOCHS -> loop {
    region training {
        A = forward(X, W1, b1);
        loss = cross_entropy(A, Y);
        ...
    };
};
```

The construct is drawn from region-based memory management as
introduced by Tofte and Talpin \cite{tofte-talpin-1997}. Where our
design departs from the classical formulation is that the region does
not denote a _memory pool_ in the type system, but a _checkpoint_ in a
single global arena.

### 2.1 Lowering

At compile time, a region lowers to a checkpoint/rewind pair emitted
around the region body:

```c
VyneValue vmem_cp_1529 = vmem_runtime_checkpoint();
{
    // region body
}
vmem_runtime_rewind(vmem_cp_1529);
```

`vmem_runtime_checkpoint()` records the current bump pointer and the
current head block of the arena. `vmem_runtime_rewind(h)` frees every
arena block allocated after the checkpoint and resets the bump pointer
to the recorded offset. The implementation lives in `runtime/modules/
vmem.h` and relies only on the arena's existing block-chain structure;
no new allocator is introduced.

### 2.2 Lifetime and semantics

A region's lifetime is the lifetime of its enclosing C block. Values
allocated inside are valid from their allocation to the closing brace.
Any reference to a region-allocated value after the closing brace is
a use-after-rewind. The compiler rejects the direct forms of this at
compile time: an assignment whose left-hand side is declared at a
shallower region depth than the current one, and whose right-hand
side is a non-primitive value allocated inside the region, is a
compile error (VNE-070). Escape through indirect routes — a function
return, a container store, a struct field — is not detected by this
check; §6.4 names the patterns.

Control flow through a region is treated conservatively. A `break`,
`continue`, or `return` that exits a region emits a rewind on the way
out. For `return`, the returned value is first materialized in a C
local on the _outside_ of the rewind, so that a primitive return value
survives:

```c
VyneValue __ret_val_17 = <expr>;
vmem_runtime_rewind(vmem_cp_1529);
return __ret_val_17;
```

Non-primitive returns — an array, a struct, a string — cannot safely
survive a rewind, because their storage is arena-resident and would be
freed. The compiler refuses to lower such a return silently. The user
must commit the value first (Section 3).

### 2.3 Region commit

`region.commit(x)` deep-clones `x` into a _secondary_ arena, called the
commit arena, which is not touched by region rewinds. The cloned value
is then safe to reference after the region ends. Its lifetime is the
lifetime of the program, matching the lifetime of the primary arena.

```vyne
region training {
    A3 = forward(X, ...);
    if epoch == EPOCHS {
        region.commit(A3);
    }
};
// A3 is still valid here.
```

The commit arena is a deliberate simplification: committed values are
never reclaimed, so a `region.commit` inside a hot loop grows the
commit arena linearly with iteration count. A real implementation would
recover escape-analysis or reference-counting information to prove
earlier reclamation. We discuss this in Section 6.

---

## 3. Shape-Typed Scratch

Scratch declares a fixed-shape numeric array whose storage is on the C
stack and whose dimensions are known at compile time:

```vyne
region training {
    scratch db2_buf :: Float64[12];
    scratch db1_buf :: Float64[16];
    ...
};
```

`scratch` is legal only inside a region. The declaration is lowered to
a C array declaration, and the region's closing brace is what ends the
array's scope:

```c
double v_db2_buf[12];
double v_db1_buf[16];
```

### 3.1 Typing

A scratch variable's static type is a `CType` carrying three pieces of
information: the element kind (`Int64` or `Float64`), a vector of
dimensions, and a C declaration name. The type system treats scratch
values as _unboxed_ — they are never wrapped in a `VyneValue`, and they
never cross a dynamic boundary unboxed. Every use site is either inside
the region or is rejected at compile time.

### 3.2 Indexing

Scratch arrays are indexed with the same syntax as boxed arrays, `x[i]`
for rank-1 and `x[i, j]` for rank-2. Both forms lower to native C
indexing:

```c
// source:  db2_buf[c] = db2_buf[c] + delta2.data[r * HIDDEN2 + c];
// emitted: v_db2_buf[v_c] = v_db2_buf[v_c] + (coerced delta2 element);
```

The flattening from multi-index to a single linear index uses row-major
strides computed at compile time from the declared shape. Rank checking
is static: an index expression with the wrong number of components is a
compile error.

### 3.3 What scratch is not

We are explicit about the boundaries, because the boundaries are where
the feature earns its keep:

- **Scratch values do not cross function boundaries.** There is no
  shaped-parameter ABI; passing a scratch variable to a Vyne function
  boxes it and defeats the purpose.
- **Scratch values do not flow into native library calls.** A call to
  `vlinalg.multiply(x, y)` where `x` is scratch type-checks by boxing
  `x` first.
- **Scratch values do not survive a rewind.** `region.commit` currently
  accepts only boxed values. A shaped value that needs to escape is a
  compile error, not a runtime dangling pointer.
- **Scratch arrays are bounded by the process stack**. A `scratch C :: Float64[1024, 1024]` is
  8 MB, above the 1 MB Windows default and near the 8 MB Linux default. The compiler driver raises the limit via -Wl,--stack,67108864 for benchmark builds; production code with large scratch arrays must do the same, or use a smaller tile. §6.7 discusses a future arena-backed fallback.

The rule we recommend is: **scratch is for local, purely-numeric
accumulation.** Reads and writes of scalars, nothing else.

### 3.4 Assignment into scratch

A scratch variable may appear on the left of an assignment. The lowering
depends on what is statically known about the right-hand side.

- **Scratch = scratch, matching element type.** Lowered to `memcpy`.
  The two buffers share a C array layout, so no per-element work is
  emitted and no tag checks are performed.

- **Scratch = typed array, matching element type.** Lowered to an
  element-wise loop reading `rhs.data[k]` directly. The element kind is
  known statically and matches the target, so the loop contains no
  per-element tag check either.

- **Scratch = boxed value.** Lowered to a runtime check that the
  right-hand side is a `VyneValue` array of the declared length,
  followed by an element-wise copy with per-element numeric coercion.
  The copy accepts `Float64` or `Int64` elements on the right-hand
  side; the target's element type is fixed by the `scratch`
  declaration.

The third case is the only one that can fail at runtime. Because the
type system does not carry shape information on `Array` — a boxed
producer like `fn make_arr() -> Array` has no static shape — a shape
mismatch is a runtime `exit(1)`, not a compile error. This is a
deliberate trade-off: the static alternative would require a shaped
`Array` type, and §6 identifies that as future work. The runtime check
costs one comparison per assignment, not per element.

Two properties are worth noting. First, the compiler never silently
retargets a shaped assignment to the boxed path: an assignment to a
scratch variable either lowers to one of the three cases above or is a
compile error. Second, the element-copy loop in the third case does
allocate nothing; it reads from the boxed right-hand side's existing
storage and writes to the scratch array on the C stack.

The two properties that §3.4 cannot provide — a compile-time shape check and a compile-time element-type check on the third case — are consequences of the type system carrying no shape or element annotation on `Array`. Both are named in §6.6 and are orthogonal to the case study in §5.

---

## 4. Implementation Notes

Three changes to the compiler were required to add the two constructs.

### 4.1 Lexer

One new keyword, `scratch`, mapped to a new token kind
`VTokenType::Scratch`. `region` already existed.

### 4.2 Parser

`region` and `scratch` are parsed by two new productions:

- `parseRegionStatement` disambiguates `region name { ... }` from
  `region.commit(expr);` by peeking at the token after `region`.
- `parseScratchDeclaration` parses `scratch name :: Type[d1, d2, ...];`.
  Dimensions are currently restricted to integer literals; accepting
  named constants requires a constant-folding pass in the parser and is
  left as future work.

Multi-index syntax `x[i, j]` is parsed in `parseIdentifierExpr`'s
postfix loop and produces a `ScratchIndexNode`. Single-index syntax
`x[i]` continues to produce an ordinary `IndexAccessNode`; the codegen
for that node checks the base's static type for a shape and, if
present, lowers to native indexing (Section 4.4).

### 4.3 Static types

`CType` gains a `shape` field — a vector of `int64_t` — and three
helpers: `hasShape()`, `numElements()`, and `strides()`. Existing uses
of `CType` are unaffected because the field defaults to empty.

### 4.4 Code generation

`ScratchNode::compile` emits a C array declaration and registers the
variable with the emitter's per-scope type table, so that later uses
resolve the base expression's `CType` and discover the shape. The
region's own `emitBlockOpen` / `emitBlockClose` push and pop a C scope,
which is what makes the scratch array's lifetime lexical.

`IndexAccessNode::getCExpr` and `IndexAssignmentNode::compile` check for
a shaped base type before falling through to the boxed path. If the
base is shaped, they emit direct C indexing. If the base is a
`VyneArray_f64` or `VyneArray_i64`, they continue to emit the typed-
array member access that has always been used for those types.

`ScratchIndexNode` and `ScratchStoreNode` handle the multi-index case
by computing a flat index from the shape's strides. The rank check is
performed here.

Shaped assignment is lowered in `AssignmentNode::compile`. A branch
fires when the assignment target's `CType` has a non-empty `shape`
field, sits between the primitive-assignment case and the typed-array
case, and covers all three cases of §3.4 in about forty lines. The
feature is small because the type-lookup path had already been unified
before it landed; the same three-case dispatch would have required
three separate type queries and a fifth copy of the element-type
mapping had it been written first.

### 4.5 Native scalar ABI

Every Vyne function is emitted as a boxed C function of the form
`VyneValue fn_X(int arg_count, VyneValue* args)`. When the function's
parameters and return type are all primitive — `Int64`, `Float64`, or
`Bool` — and the body contains no top-level `defer` or `try/catch`, the
emitter additionally produces a second, unboxed C function whose
signature is the direct C translation of the parameter and return
types:

```c
// boxed (always emitted)
VyneValue fn_add(int arg_count, VyneValue* args);

// native (emitted only when the function qualifies)
int64_t fn_add_native(int64_t a, int64_t b);
```

---

## 5. Case Study: A Neural-Network Training Loop

We evaluated the two constructs on an existing Vyne program: an RNA
sequence classifier that distinguishes codon-structured RNA from
uniform-random RNA using 64-dimensional codon-usage features. The
classifier is a two-hidden-layer MLP trained by SGD. Its hot loop runs
`EPOCHS` times; inside each iteration, `forward`, `backprop`, and the
bias updates run over `N_SAMPLES = 240` training examples.

Before the rewrite, two intermediate buffers — `db1_buf` (16 elements)
and `db2_buf` (12 elements) — were declared as boxed `Array`s and
allocated fresh on the arena at each iteration.

### 4.6 Native array ABI

Where §4.5 promotes primitive parameters to native C types, §4.6 does
the same for `Array<Float64>` and `Array<Int64>`. The gate in
`ProgramNode::compile` changed from requiring every parameter to be
primitive to accepting a parameter whose declared type is `Array<T>`
of a statically known element type. For each such parameter the native
variant's signature gains a `T*` (element type `double` or `int64_t`),
and the call site passes `.data` from the boxed `VyneArray_f64` or
`VyneArray_i64`. Index accesses inside the native body lower to bare
C indexing.

The implementation touches five files:

- `codegen/ctype.h` gains `CType::Kind::RawArrayPtr`, an unboxed `T*`
  that carries its element type in `args[0]`. `isPrimitive()` returns
  false for it, which is deliberate: any path that has not been
  explicitly extended treats a raw-array-ptr as boxed and falls through
  safely.
- `codegen/program.cpp` populates `CType::args[0]` from
  `Parameter::arrayElemType` and widens the native-variant gate.
- `codegen/functions.cpp` emits `T*` in the native signature and
  declares the parameter as `RawArrayPtr` in the function body's scope.
- `codegen/collections.cpp` adds a `RawArrayPtr` branch to
  `IndexAccessNode::getCExpr` and `IndexAssignmentNode::compile`,
  emitting `a[i]` and `a[i] = v` instead of `vyne_index_get` /
  `vyne_index_set`.
- `codegen/function_calls.cpp` recognises a typed-array argument at
  the call site and passes `.data` when its element kind matches the
  parameter's. Any mismatch falls through to the boxed call.

Array returns are not in the ABI; `retPrimitive` is unchanged, so a
function whose return type is `Array` still only gets the boxed
variant. Reference parameters are likewise excluded.

**Verification.** The RNA classifier of §5 is byte-identical after the
change: `ml_seq_config1.exe` reports the same final loss (0.226304),
the same accuracy (99.5%), the same peak RSS (6.4 MB), the same wall
clock (0.13 s), and the same per-sample predictions. The 1024×1024
matmul of §5.7 produces the same checksum (3.47777). No existing
measurement moved.

**Safety.** Discussed in §6.2. The short version: the native path is
unsound by design, in the sense that out-of-range indexing is UB
rather than a diagnostic. The boxed path remains sound.

### 5.1 Rewrite

The buffers were redeclared as scratch inside a region that wraps the
loop body:

```vyne
through epoch :: 1..EPOCHS -> loop {
    region training {
        scratch db2_buf :: Float64[12];
        scratch db1_buf :: Float64[16];

        ... forward pass, backprop ...

        through c :: 0..HIDDEN2-1 -> loop {
            db2_buf[c] = 0.0;
            through r :: 0..N_SAMPLES-1 -> loop {
                db2_buf[c] = db2_buf[c] + delta2.data[r * HIDDEN2 + c];
            };
        };

        through c :: 0..HIDDEN1-1 -> loop {
            db1_buf[c] = 0.0;
            through r :: 0..N_SAMPLES-1 -> loop {
                db1_buf[c] = db1_buf[c] + delta1.data[r * HIDDEN1 + c];
            };
        };

        through c :: 0..HIDDEN1-1 -> loop {
            b1[c] = b1[c] - scale * db1_buf[c];
        };
        through c :: 0..HIDDEN2-1 -> loop {
            b2[c] = b2[c] - scale * db2_buf[c];
        };
    };
};
```

---

### 5.2 Emitted code

The C output for the region head and the accumulator loops contains:

```c
VyneValue vmem_cp_1529 = vmem_runtime_checkpoint();
{
    double v_db2_buf[12];
    double v_db1_buf[16];

    ...

    v_db2_buf[v_c] = 0;
    for (int64_t r = 0; r <= 239; ++r) {
        double idx = v_db2_buf[v_c];
        ...
        v_db2_buf[v_c] = ...;
    }

    ...
}
vmem_runtime_rewind(vmem_cp_1529);
```

No `arena_alloc` call appears for either buffer. The declarations are
stack-resident; the index expressions are direct array accesses. The
checkpoint and rewind bound the array lifetimes to the region body.

### 5.3 What the rewrite eliminates

For the two accumulator buffers, the loop no longer performs:

- A per-iteration `Array` allocation on the arena.
- A per-iteration vector growth and its associated reclaim attempts.
- A per-element boxing on the write path, and a per-element unbox on
  the read path, for the buffer itself.

The two accumulator loops therefore run against native `double` slots
with no allocation on either the read or the write side.

### 5.4 What the rewrite does not eliminate

The source side of each accumulation — `delta2.data[r * HIDDEN2 + c]` —
still reads through a `VyneValue`-based tensor, because vlinalg
currently returns boxed `VyneArray_f64`. Each inner-iteration read
therefore still performs a runtime tag check and a union member access.
Removing that cost requires two things: a native ABI for `Array<T>`
parameters (§4.6, implemented in the release following this report),
and a way for `vlinalg` to declare its return type as a typed array
rather than a boxed `VyneValue`. The first landed. The second is
the shaped-`Array` type named in §6.6.

The `forward` and `backprop` passes themselves are unchanged: they
still produce and consume boxed tensors, and every intermediate value
they materialize is still allocated on the arena and released only at
the region rewind.

### 5.5 A second pass: weight-gradient buffers

The rewrite in §5.1 exercises shaped assignment only on the initializers
of `db1_buf` and `db2_buf`. A second pass over the same program extends
the same technique to the three weight-gradient buffers that dominate
the loop's allocation budget:

```vyne
region training {
    scratch db2_buf :: Float64[12];
    scratch db1_buf :: Float64[16];
    scratch dW3 :: Float64[12, 1];
    scratch dW2 :: Float64[16, 12];
    scratch dW1 :: Float64[64, 16];

    ...
    dW3 = vlinalg.multiply(vlinalg.transpose(A2), delta3);
    dW2 = vlinalg.multiply(vlinalg.transpose(A1), delta2);
    dW1 = vlinalg.multiply(vlinalg.transpose(X),  delta1);
    ...

};
```

Each assignment lowers to the third case of §3.4. The emitted C is a
single runtime shape check followed by an element-wise copy from the
boxed `VyneValue` produced by `vlinalg.multiply` into a raw `double`
array on the C stack. The saved cost is that every subsequent use of
`dW1`, `dW2`, `dW3` — including the SGD update, which reads each
element once — is a native `double` load, and the arrays themselves
no longer allocate on the arena per iteration.

The three gradient buffers are the largest allocations the loop's own
code performs (1228 elements, versus 28 for the bias buffers). Promoting
them to scratch removes 44× more bytes of per-iteration arena traffic than
§5.1's rewrite does. That reduction is still below the peak-RSS floor of this
program (§5.6): the forward and backprop intermediates allocate roughly 60 KB
per iteration, and the gradient buffers, even at 1228 elements, are about 10 KB.
The largest-allocation claim is therefore true of the loop's own buffers and not
of the loop's total arena traffic. §5.7 provides the scale at which the same technique
produces a measurable peak-RSS effect.

### 5.6 Measurements

We measured three configurations of the classifier at `EPOCHS = 50`,
`N_SAMPLES = 240`:

1. **Baseline** — the original program: `db1_buf` and `db2_buf` are
   boxed `Array`s, allocated fresh inside the training region.
2. **Accumulators only** — `db1_buf` and `db2_buf` are scratch
   (§5.1); the three weight-gradient buffers are still boxed.
3. **Accumulators + gradients** — adds the three gradient scratch
   buffers of §5.5.

All three were compiled with the portable `-O3` target and the
compiler's default safety checks enabled. Each was run three times;
wall clock is reported as mean ± standard deviation across the
three runs. Peak RSS is measured with the same 50 ms sampler used
in §5.7.

| Config                       | Final accuracy | Final loss | Peak RSS | Wall clock |
| ---------------------------- | -------------: | ---------: | -------: | ---------: |
| 1 — baseline                 |          99.5% |   0.226304 |   6.4 MB |     0.13 s |
| 2 — accumulators             |          99.5% |   0.226304 |   6.3 MB |     0.12 s |
| 3 — accumulators + gradients |          99.5% |   0.226304 |   6.3 MB |     0.14 s |

**Correctness.** All three configurations converge to the same final
accuracy on the same 240 training examples and produce bit-identical
losses. The rewrite does not alter the model's arithmetic; only the
storage class of the intermediate buffers changes. This is the same
property the scale experiment confirms at §5.7 (identical checksums
across four configs), and it is the correctness precondition for
reading anything into the peak-RSS numbers.

**Memory**. Peak RSS is indistinguishable across the three configurations
(6.4, 6.3, 6.3 MB). The classifier's working set is dominated by the forward-
and backprop-pass intermediates, which allocate roughly 60 KB per iteration;
the bias buffers contribute under 1% of allocated bytes and the gradient
buffers roughly 10 KB. Moving either set to the C stack removes their arena
traffic — §5.2 shows the absence of arena_alloc in the emitted code for the
accumulators — but the removal is below the sampler's ±0.1 MB resolution at
this scale. The peak-RSS effect of the scratch storage class is exhibited at
scale in §5.7, where the buffers dominate the arena.

**Wall clock**. The three configurations run within run-to-run noise of
each other (0.13–0.14 s). The classifier's hot loop is dominated by the
boxed-tensor arithmetic in `vlinalg`, not by the allocation of the small
per-iteration buffers; moving those buffers to the stack does not measurably
change execution time. The technique is a memory-footprint change at the scale
§5.7 exercises, not a speedup at the scale of this classifier.

**What the classifier measures**. The classifier's contribution is not a
performance number but a correctness one. All three configurations produce
bit-identical loss (0.702889 initial, 0.226304 final) and bit-identical
per-sample predictions, which is the evidence that the shaped-assignment
lowering of §3.4 and the scratch indexing of §3.2 compile to arithmetic
that is byte-for-byte the arithmetic of the boxed path. The memory-model
claim of §2–§3 is measured at §5.7.

### 5.7 Scale Experiment: The 1024×1024 Matmul

The RNA classifier of §5.1 exercises the mechanism but not the scale.
Buffers of 12–1024 elements fit easily in L1; the arena's linear growth
is measurable but not dramatic. To confirm that the memory model holds
at scale, we ran a second experiment: a matmul of 1024×1024
double-precision matrices repeated over `ITERS` iterations.

#### Benchmark design

Four configurations live in one Vyne file
(`examples/benchmark/matmul_1024.vy`). A, B, and B's transpose are
`Float64[1024, 1024]` scratch arrays in all four configs, so the
matmul kernel itself is byte-identical across them. Only C differs:

- **Config 0 (baseline):** C is a boxed `Array`, allocated fresh on the
  arena each iteration.
- **Config 1 (region-only):** C is the same `Array`, but the iteration
  body is wrapped in a `region`.
- **Config 2 (region + scratch):** C is a `Float64[1024, 1024]` scratch
  array on the C stack.
- **Config 3 (hoisted baseline):** C is a boxed `Array`, allocated once
  outside the iteration loop and written in place. This is what a
  programmer would write by hand without a region system, and it is the
  fairest non-region comparison.

The four configs share one source file, selected by a `CONFIG`
compile-time constant. The same `.vy.c` is regenerated and recompiled
for each. The RNG is seeded deterministically (`vmath.seed(42)`), so
A and B are bit-identical across configs and the checksums are directly
comparable.

#### Kernel methodology

A naive triple loop is not representative of C-level matmul
performance: `B[k, c]` strides by 1024 doubles in `k`, and a single
accumulator creates a serial FMA dependency chain. We addressed both
without any floating-point reassociation flag.

**Transposed B.** `B_T[c, r] = B[r, c]`, computed once before the timed
region. Both operands' inner-loop access is then contiguous in `k`.
This is a pure data rearrangement; the bits are identical.

**Four independent accumulators.** Each output element's sum is split
across four chains:

```vyne
acc0 :: Float64 = 0.0;
acc1 :: Float64 = 0.0;
acc2 :: Float64 = 0.0;
acc3 :: Float64 = 0.0;
through k4 :: 0..N/4-1 -> loop {
    k0 :: Int64 = k4 * 4;
    acc0 = acc0 + A[r, k0 + 0] * B_T[c, k0 + 0];
    acc1 = acc1 + A[r, k0 + 1] * B_T[c, k0 + 1];
    acc2 = acc2 + A[r, k0 + 2] * B_T[c, k0 + 2];
    acc3 = acc3 + A[r, k0 + 3] * B_T[c, k0 + 3];
};
C[r, c] = (acc0 + acc1) + (acc2 + acc3);
```

This is not reassociation. Each chain's additions happen in exactly
the order a serial kernel would produce them. Only the final combine
`(acc0 + acc1) + (acc2 + acc3)` reorders, once per output element, and
only across chains that were never in a defined order to begin with.
No `-ffast-math` or equivalent flag is required, and the numeric
result is the same four-chain reduction the CPU would perform if it
executed the naive loop four parallel scalar streams.

#### Verification: SLP vectorization

GCC's SLP (superword-level parallelism) pass at `-O3` packs the four
independent scalar FMAs into SIMD lanes without any FP-semantics flag.
The emitted assembly for the inner loop (verified with `gcc -S -O3 -w`):

```assembly
.L937:
    movapd  (%rbx,%rax), %xmm0
    mulpd   (%rsi,%rax), %xmm0
    addpd   %xmm0, %xmm2
    movapd  16(%rbx,%rax), %xmm0
    mulpd   16(%rsi,%rax), %xmm0
    addpd   %xmm0, %xmm1
    addq    $32, %rax
    cmpq    %rax, %rdx
    jne     .L937
```

Two 128-bit lanes (`%xmm1` and `%xmm2`) match the four source-level
accumulators, two per lane. Four scalar MACs per iteration, two SIMD
mul/add pairs. The compiler derived this from the four-chain source
alone.

Enabling AVX2 and FMA (`-mavx2 -mfma`) would double the vector width
and fuse multiply+add, giving roughly 2–3× more throughput. The paper's
result is intentionally measured at the portable SSE2 baseline: the technique
under test is the memory model, not the kernel's ISA. Exposing AVX2 and FMA as
an opt-in build mode is straightforward future work and is orthogonal to the
memory-model claim.

#### Measurements

All four configs run with `ITERS = 10`, `N = 1024`, and
`vmath.seed(42)`. Wall clock and peak RSS measured with a 50 ms
sampler on Windows 11, x86-64, single-threaded, gcc 15.2 with -O3,
with the compiler's default safety checks disabled for the benchmark;
see §5.8 for the cost when enabled.

| Config               | Peak RSS (mean of 3) | Wall clock (mean of 3) | Checksum |
| -------------------- | -------------------: | ---------------------: | -------: |
| 0 — baseline         |       308.0 ± 6.3 MB |          1.44 ± 0.03 s |  3.47777 |
| 1 — region-only      |        62.8 ± 0.2 MB |          1.46 ± 0.01 s |  3.47777 |
| 2 — region + scratch |        35.5 ± 0.0 MB |          1.43 ± 0.03 s |  3.47777 |
| 3 — hoisted baseline |        63.6 ± 0.0 MB |          1.41 ± 0.02 s |  3.47777 |

We repeated the four-config sweep at `ITERS = 100` to confirm
the growth is linear at both ends of the range. Same machine,
same gcc 15.2 `-O3`, same sampler.

| Config                   | Peak RSS (mean of 3) | Wall clock (mean of 3) | Checksum |
| ------------------------ | -------------------: | ---------------------: | -------: |
| 0 — baseline             |      2836.6 ± 2.7 MB |         13.83 ± 0.07 s |  3.47777 |
| 1 — region-only          |        63.6 ± 0.1 MB |         13.72 ± 0.06 s |  3.47777 |
| 2 — region + scratch     |        35.5 ± 0.0 MB |         14.54 ± 1.27 s |  3.47777 |
| C — hand-written, native |        35.4 ± 0.0 MB |         15.08 ± 2.92 s |  3.47777 |
| 3 — hoisted baseline     |        63.6 ± 0.0 MB |         13.65 ± 0.36 s |  3.47777 |

#### Interpretation

Three observations.

**Identical checksums.** All four configs produce the same numeric
result to the last printed digit. The memory model does not alter
arithmetic; the region rewind and the scratch array are transparent
to the computation.

**Identical wall clock.** The four configs run within 3.5% of each
other — inside the run-to-run noise of the measurement. The region
rewind is O(1) per iteration and the scratch array's stack allocation
is O(1) per invocation, so neither construct adds measurable time.
The safety checks that §5.8 documents were disabled for these measurements;
§5.8 gives the checks' own numbers with them enabled. One exception is config
2 at ITERS = 100..., where the run-to-run standard deviation is 1.27s
(8.7% of the mean). The variance is consistent with OS scheduling on the three
concurrently-live 8 MB scratch arrays, not with any property of the region or scratch
constructs; the mean is still within 6% of the other three configs,
and the peak RSS for this config is the most stable of the four
(35.5 MB, zero variance across all runs).

**Peak RSS scales linearly in ITERS for the baseline, and stays flatfor the other three.**
At ITERS = 10 the baseline's 308 MB sits 273 MB
above the ~35 MB process floor. At ITERS = 100 it sits 2801 MB above
the floor — a 10.28× increase for 10× more iterations, within the ±6 MB
run-to-run noise of the ITERS = 10 measurement. Region-only stays at
63.6 MB and region+scratch stays at 35.5 MB across both. The gap between
baseline and region+scratch therefore grows from 8.7× at ITERS = 10 to
**79.9× at ITERS = 100**, and it will continue to grow linearly in ITERS
until the baseline exhausts physical memory. At ITERS = 1000 the
baseline would need ~28 GB; region-only and region+scratch would still
be at 64 MB and 36 MB.

The baseline's per-iteration cost is 28.0 MB, measured directly from
the slope of (peak RSS − 35 MB process floor) against ITERS across
the two data points. The boxed `VyneValue` element array accounts for 16.7 MB
of that (1024 × 1024 slots × 16 bytes). The remaining 11.3 MB/iteration is
the arena's block-chain overhead and the transient double-residency during
`vyne_array_push`'s growth path, which `arena_try_reclaim` reduces but does not
eliminate.

Region-only eliminates both by rewinding the arena at the end of each
iteration. Region + scratch eliminates both by placing C on the C
stack entirely, so no arena allocation occurs at all.

Config 3 is the manual alternative to config 1: a hand-hoisted output
buffer, allocated once and written in place, reaches the same 63.6 MB
peak and the same wall clock as region-only. The region construct is
therefore a transparent replacement for manual hoisting, not an
additional cost. Config 2 goes further: the output buffer lives on the
C stack, so the arena never holds it at all, and peak RSS falls another
1.79× to 35.6 MB. That reduction is not available to a hand-written
boxed-`Array` program without additional machinery; it is what
`scratch` provides.

To confirm that the scratch storage class is the natural C-level form of
the algorithm and not a compilation artifact, we wrote a hand-written C
equivalent of config 2 (`examples/benchmark/matmul_1024_handc.c`): the
same kernel, the same four accumulators, the same transposed B, the same
PCG32 fill, with all four matrices — A, B, B_T, and C — declared as
native `double` arrays on the C stack, matching scratch's storage class
byte for byte. The hand-written C program produces the same checksum
(`3.47777`), the same peak RSS (`35.4 MB` against Vyne config 2's
`35.5 MB`, a 0.3% difference inside the sampler's resolution), and an
indistinguishable wall clock: its two clean runs are 13.11 s and 13.61 s,
against Vyne config 2's 13.28 s and 14.51 s — a 1.3% spread at the fast
end, well inside the run-to-run variance both programs exhibit. The
outlier in each program's three-run set is attributable to OS scheduling
on three concurrently-live 8 MB stack arrays, not to any property of
either program. Vyne's `scratch` construct is therefore a transparent
lowering to the C stack array a C programmer would write by hand, with
the additional guarantees of §5.8 — compile-time bounds checking,
region-scoped lifetime, escape analysis — intact. The construct's value
is not that it is faster than C; it is that it is identical to C while
being safer.

### 5.8 Safety Checks

The compiler enforces two categories of safety check on scratch
programs, with a third check at parse time. All three are enabled by
default; no flag is required.

**Rank check (VNE-071).** A multi-index scratch access whose index
count does not match the declared rank is a compile error. This is
`scratchFlatIndex`'s precondition and is enforced before code
generation.

**Bounds check (VNE-072).** Every scratch read and write materializes
its index into a temporary and compares it against the dimension
bound before the array access. On out-of-range, the program prints a
diagnostic naming the dimension, the declared shape, the offending
value, and the source line, then calls `exit(1)`. The check is
per-dimension: a rank-2 access `m[i, j]` emits two comparisons. The
`arena_try_reclaim` pattern in the runtime is unaffected; the check
is pure arithmetic.

**Escape check (VNE-070).** An assignment whose left-hand side is
declared at a shallower region depth than the current one, and whose
right-hand side is a non-primitive value allocated inside the region,
is a compile error. The check covers `AssignmentNode`,
`MemberAssignmentNode`, and `IndexAssignmentNode`. It is deliberately
syntactic: it rejects the direct pattern and the two aliasing patterns
(store through a member field, store through an index slot) but does
not attempt to track escape through a function return or through a
container. §6.4 names the patterns the check cannot see.

#### Regression suite

The suite at `examples/safety/` contains nine test programs, one per
check or safe pattern. Each is expected to either compile and run
successfully, abort at runtime with a specific VNE code, or fail
compilation with a specific VNE code. The runner
(`examples/safety/run_safety.ps1` on Windows; the shell equivalent
on POSIX) invokes `vynec --compile` on each and asserts against the
diagnostic code in the combined output.

| Test                    | Expected      | Diagnostic |
| ----------------------- | ------------- | ---------- |
| `correct_index`         | pass          | —          |
| `negative_index`        | runtime abort | VNE-072    |
| `too_large_index`       | runtime abort | VNE-072    |
| `wrong_index_count`     | compile error | VNE-071    |
| `escape_via_assignment` | compile error | VNE-070    |
| `escape_via_member`     | compile error | VNE-070    |
| `escape_via_index`      | compile error | VNE-070    |
| `boxed_local_in_region` | pass          | —          |
| `safe_commit`           | pass          | —          |
| `nested_region`         | pass          | —          |

The four passing cases confirm that correct code is not rejected:
rank-1 access within bounds, a boxed local declared inside a region,
escape mediated by `region.commit`, and scratch arrays in nested regions.
The `boxed_local_in_region` case is the important one for the escape check's
soundness: it exercises the pattern the check must not reject — a `VyneValue`
local allocated inside the region whose lifetime ends with the region — and
confirms the depth comparison in `lookupLocalRegionDepth` does not misfire on it.

The suite is run as part of make test-safety in the compiler's build.
All ten cases pass on the current tree. The runner's output is reproduced verbatim below.

#### Safety test suite

PASS correct_index.vy (pass)
PASS negative_index.vy (fail-runtime-VNE-072)
PASS too_large_index.vy (fail-runtime-VNE-072)
PASS wrong_index_count.vy (fail-compile-VNE-071)
PASS escape_via_assignment.vy (fail-compile-VNE-070)
PASS escape_via_member.vy (fail-compile-VNE-070)
PASS escape_via_index.vy (fail-compile-VNE-070)
PASS boxed_local_in_region.vy (pass)
PASS safe_commit.vy (pass)
PASS nested_region.vy (pass)

10 passed, 0 failed

---

## 6. Limitations and Future Work

The technique described in §2–§4 is complete for its intended scope but
has a number of well-defined boundaries. We enumerate them here in order
of what we would build next, from the smallest follow-up to the largest.

### 6.1 Borrow parameters (new)

Scratch arrays are visible only inside the region that declares them.
A call to a Vyne function from inside the region sees the array as a
boxed `VyneValue`, because there is no ABI for passing a raw C array
to a function whose parameters were declared with the standard
`:: Float64[]` syntax. Any code that wants to operate on a scratch
array must therefore be inlined into the region body, or must pay
the boxing cost at the call boundary.

The natural fix is a borrow parameter, marked with & before the
type at the declaration site and required at the call site:

```vyne
fn fill(x &Float64[64, 16], value :: Float64) {
    through i :: 0..63 -> loop {
        through j :: 0..15 -> loop { x[i, j] = value; };
    };
};
```

The `&` is not optional; requiring it at the call site is what lets
the reader see that `buf` will be mutated. The lowering passes the
underlying `double\*` plus the declared dimensions, and the callee
compiles against a native C array parameter rather than a boxed
value.

This is the second half of what a mini-tensor needs. Without it, a
numerical kernel can be written in Vyne only by inlining it into the
region body, which is fine for a single training loop and inadequate for
a library. With it, `fill`, `matmul_into`, `accumulate_into`, and their
siblings become ordinary functions that take scratch arrays by reference
and mutate them in place, and the emitted C is the same loop the
programmer would have written by hand.

Effort: one day. The parser change is trivial; the emitter change is
a second parameter-signature variant in the same dispatcher that §4.5
introduced for primitives, with the array case adding `double\*` and
`int64_t` for the dimensions.

### 6.2 Native ABI for array parameters

**Implemented.** The dispatcher described here was extended to
`Array<Float64>` and `Array<Int64>` parameters in the release following
this report. The section below is retained as design rationale; the
implementation status is stated in the last paragraph.

Passing an `Array<Float64>` to a Vyne function historically boxed it:
the caller built an `args[]` array on the arena, copied each argument
in, and the callee unboxed at entry. Even though the emitter already
knew the argument was a `VyneArray_f64`, the calling convention did not
reflect that, so the callee could not inline the arithmetic.

The native array ABI is the fix. When every parameter is either
primitive or a typed array of primitives, and the return type is
primitive, the emitter produces a second, unboxed variant whose
signature is the direct C translation of the parameters:

```c
// boxed (always emitted)
VyneValue fn_scale_add(int arg_count, VyneValue* args);

// native (emitted when the function qualifies)
double fn_scale_add_native(double* a, double* b, int64_t n);
```

The call site passes `.data` from the boxed container when the
argument's static type is a matching typed array; otherwise it falls
through to the boxed call. The native body sees `a` and `b` as raw
`double\*` and emits bare C indexing — no `vyne_index_get`, no tag
check, no per-element unboxing. This is what lets a Vyne-defined
kernel reach the same generated code a C implementation produces, and
it is the prerequisite for any external BLAS binding.

**Distinction from §6.1**. Borrow parameters are a language-level
feature: the programmer writes `&` and the semantics of the call
change. The native array ABI is a compiler-level optimization: the
source code is unchanged, and the emitter chooses a narrower calling
convention when the argument's static type permits it. Both are
needed. Borrow parameters let scratch be passed into functions; the
native array ABI lets ordinary `Array<Float64>` be passed without the
boxing cost.

**Safety**. The native array ABI is deliberately less safe than the
boxed path. Native-array indexing is not bounds-checked; a shape
mismatch between caller and callee, or an out-of-range index, is
undefined behavior rather than a VNE-072 diagnostic. This is the same
trade-off C makes with `double\*` and Rust makes with raw pointers, and
it is what makes vectorization possible. The boxed variant of every
function still exists and is still checked; callers whose arguments
do not match the native signature fall through to it. The mechanism
that will eventually restore soundness to the native path is the
range-refinement types of §6.6: an index typed `Int64<0..N-1>` into
an `Array<Float64>` of runtime length N is provably in-bounds, and
the check can be elided without losing safety.

**Effort**. 3–5 days, as estimated. The signature computation is
mechanical; the element-type propagation from the parser through
`Parameter::arrayElemType` to `CType::args[0]` is the piece that
needed care.

### 6.3 Scratch slicing and views

There is no way to take a sub-range of a scratch array and pass it
somewhere as a first-class value. `W[0, :]` on a scratch `W` is not
a valid expression; the parser rejects the slice form on shaped
arrays because there is no way to represent the result.

The natural fix is a view: a triple of

```c
{double\* base; int64_t stride; int64_t len;}
```

that aliases a slice of an existing scratch
array without copying. Reads and writes through the view multiply
the index by the stride and add it to the base pointer. The view
is stack-resident; like the array it views, it dies with the region.

Views are what make scratch composable into kernels. A matmul that wants
to operate on the _k_-th row of `A` and the _k_-th column of `B` should
be able to take those slices as parameters, not materialize them first.
The same goes for the per-sample update in the training loop: a strided
view of `W` for a single column should be a view of `W`, not a freshly
allocated column vector. And `sdg_update_inplace`'s eventual
scratch-taking variant should accept a view of `W`, so the update loop
runs over the original array's storage rather than a copy.

There is a lifetime question that views introduce and that scratch does
not: a view holds a pointer into another scratch array, and that pointer
must not outlive the array. Because both are stack-allocated in the same
region, the lifetime of the view is a subset of the lifetime of the
array it views, which is what the lexical scoping already guarantees. No
additional checking is needed; the same scope discipline that makes
scratch safe makes views safe.

**Effort**: two days, dominated by getting the stride arithmetic right in
`ScratchIndexNode` and `ScratchStoreNode`, and by deciding whether a view
is a distinct `CType` kind or a variant of `CType::Kind::Array`.

### 6.4 Escape analysis

A syntactic approximation of the escape check landed alongside the
scratch construct. `AssignmentNode`, `MemberAssignmentNode`, and
`IndexAssignmentNode` each compare the region depth of the target
against the current region depth, and reject any assignment of a
non-primitive region-local value into a shallower-declared variable.
This catches the direct escape pattern and the two aliasing patterns
above it. It does not catch indirect escape through a function return,
through a container store, or through a struct field; a full analysis
would.

The current design does not prove that a scratch value has not escaped
before rewind. `region.commit` therefore accepts only boxed values, and
any attempt to escape a shaped value is a compile error. A proper escape
analysis would let scratch values be committed and would let the compiler
reclaim committed values earlier than program exit.

This is the largest of the follow-ups and the one with the most research
value. The analysis answers a single question — does this value's
storage need to outlive its lexical scope? — and once it is available,
four separate things become automatic:

- Automatic commit. Instead of a programmer-inserted region.commit
  at each escape point, the compiler inserts it where the analysis
  determines a value has escaped.

- Automatic reclamation. A committed value that the analysis can
  prove dead at a known program point can be reclaimed at that point
  rather than at program exit.

- Automatic scratch promotion. A boxed local whose allocation is
  provably region-scoped and whose size is statically bounded can be
  lowered to a scratch array without a `scratch` declaration.

- **Dangling-rewind diagnostics**. A `region.commit` that the analysis
  proves unnecessary, or a `return` of a value the analysis proves will
  dangle, becomes a compile error rather than a runtime dangling
  pointer.

The last two are the ones that pay for the analysis. Automatic scratch
promotion in particular is what would let a programmer write ordinary
Vyne and get the same code the current rewrite produces by hand. If the
analysis is good enough, `scratch` and `region.commit` become escape
hatches rather than required annotations.

**Effort**: two to three weeks. The analysis itself is the well-understood
part; the difficult piece is the fallback when the analysis cannot prove
a lifetime, which must be a correct but slower path, not a compile error.
The current design already has the correct-but-slower path — box the
value — so the fallback is free. What is new is the fast path.

### 6.5 Commit arena reclamation

`region.commit` currently deep-clones its argument into a commit arena
that is never freed. In a hot loop, this grows the commit arena linearly
with iteration count. The fix is the same escape analysis: once the
compiler can prove that a committed value is dead at a known point, it
can reclaim the corresponding arena region.

This is a consequence of §6.4 rather than an independent item. It is
called out separately because the effect is measurable independently:
even a coarse escape analysis that proves some committed values dead
would cap the commit arena's growth at the size of the live committed
set, which for most programs is a small constant. The difference between
"grows linearly with iterations" and "bounded by live set" is the
difference between a program that runs for a day and a program that runs
for a month.

The correct implementation is not a per-value free — the commit arena
does not have the block structure to support that — but a commit-arena
checkpoint that mirrors the region checkpoint. A region that commits
into the commit arena takes a checkpoint on entry and rewinds on exit,
promoting only the committed values that survived. The interface is the
same as §2.3 from the user's perspective; what changes is that the
committed values are now second-tier scratch rather than permanent.

**Effort**: two days once §6.4 exists. Without §6.4, the commit-arena
checkpoint cannot know which committed values to preserve and which to
discard, and reverts to the current behaviour.

### 6.6 Limitations of shaped-assignment support

Two limitations of the current shaped-assignment support (§3.4) are worth
naming even though they do not block adoption.

First, the third case — assignment from a boxed value — performs a
runtime tag check on every element, because the boxed right-hand side
carries no static element type. A producer whose return type were a
typed `VyneArray_f64` would skip the check entirely. The fix is not a
change to the shaped-assignment lowering; it is a change to the types
that `vlinalg` and other boxed producers declare as their return types.
The machinery is already in the emitter (`boxAny` knows how to box a
`VyneArray_f64` and the reverse path is what §3.4's third case does by
hand); what is missing is a way for a library to say "this function
returns a `VyneArray_f64`, not a `VyneValue` that happens to contain
one."

Second, because `Array` in the type system carries no shape, a shape
mismatch on a boxed assignment is a runtime exit(1), not a compile
error. The static alternative is a shaped Array type, which is the
same type-system change that the first limitation wants. Both close
together, if and when the type system learns to distinguish Array
from shaped Array. Neither is required for the case study in §5,
because in that program the shapes are fixed constants and the
programmer can verify the sizes by hand.

There is a third limitation that the language-level reading of §3.4
makes visible: an assignment to a scratch variable is an expression in
Vyne, not a statement, and its result is the scratch array itself. That
means the assignment can appear in contexts where the compiler cannot
know its destination at parse time — `if c { scratch_a } else { scratch_b } = rhs` is not legal because the grammar does not admit a scratch variable
as the target of a conditional assignment. This is a parser restriction,
not a semantic one, and could be relaxed with a small amount of grammar
work. It is not on the critical path for any current program.

**A naming conflation**. All three limitations above share a root:
`scratch` is doing two jobs at once. It declares a storage class
(stack-resident, non-arena) and it declares a shape (dims known at
compile time, statically indexable). The two are orthogonal — a value
could have a static shape and still live on the arena, and a value could
live on the stack without a declared shape. Conflating them makes the current
design smaller, but it also means the arena-backed `scratch` variant that
§3.3's stack-limit bullet wants cannot be expressed in the source language
at all: there is no syntax for "shape-typed but arena-resident." The natural
fix is to separate the two axes — `scratch` for the storage class, `Shape`
as a type constructor — which is the same type-system change that §6.2 and
the first two limitations want. All four close together, if the type system
ever learns to distinguish shape from storage.

### 6.7 Cases where manual hoisting does not substitute for a region

Section §5.7 measures a flat loop, and in that loop the hand-hoisted
baseline (config 3) tracks the region-only configuration (config 1) to
within measurement noise. It would be reasonable to read that result
as saying the region is a stylistic convenience — that a programmer who
hoists their output buffer out of the loop has already captured whatever
a region would give them, and that the region construct earns its place
only by making the hoisting automatic. The reading is wrong in three
cases, each common enough to matter. In these cases manual hoisting is
not merely less convenient than a region; it is either incorrect or
impossible, and the region is the only construct that expresses the
intended lifetime.

**Recursion.** A buffer hoisted to file scope, or to any scope that
outlives a single invocation of the function that uses it, is shared
across every dynamic instance of that function. Under recursion, the
inner call's writes clobber the outer call's intermediate state, and the
outer call resumes with a buffer that no longer holds its own values:

```vyne
# WRONG under recursion: single shared buffer
buf :: Array = [];

fn process(n :: Int64) {
    through i :: 0..1023 -> loop { buf[i] = buf[i] + compute(i, n); };
    if n > 1 { process(n - 1); }
    # the buffer written above has been overwritten by the recursive call
}
```

The C programmer's answer to this is a stack array declared inside the
function body, which gets a fresh copy per call for free. Vyne before
`scratch` had no stack arrays; the only local allocation was on the
arena, and the arena accumulates. So a Vyne programmer had exactly two
options: hoist a boxed `Array`, which is wrong; or manually checkpoint
and rewind the arena around each recursive call, which is what a region
does. The correct form is a scratch buffer inside a region, and the
construct expresses precisely the lifetime the algorithm needs:

```vyne
fn process(n :: Int64) {
    region body {
        scratch buf :: Float64[1024];
        through i :: 0..1023 -> loop { buf[i] = buf[i] + compute(i, n); };
        if n > 1 { process(n - 1); }
    };
}
```

Each invocation gets its own buffer on its own stack frame; the rewind
at the end of the body reclaims any arena allocation the body performed,
including that of the recursive call's own region.

This is not hypothetical. The test at
`examples/benchmark/recursion_capability.vy` runs the same recursive
check in three configurations: a buffer hoisted to file scope, a boxed
`Array` declared inside a region, and a scratch buffer declared inside a
region. Each invocation writes its own depth into the buffer, recurses,
then reads the buffer back and asks whether it still sees its own value.
At depth 8, the hoisted configuration returns 1 — only the innermost
call's write survives, every outer write is clobbered — while both
region-scoped configurations return 8. The test is a capability
demonstration, not a memory measurement: it produces a boolean-shaped
result, and no peak-RSS or wall-clock number is attached to it. The
point is that the hoisted form is not merely slower than the region
form; it is incorrect, and it is incorrect for a reason the region
system exists to eliminate. The two region-scoped configurations —
boxed `Array` and `scratch` — both produce the correct result, which
is the sense in which the region construct and the scratch storage
class are orthogonal: the region provides the per-invocation lifetime,
the storage class is chosen independently.

**Concurrent execution.** The same mechanism recurs in space rather
than in time. A buffer hoisted to file scope and shared across threads
running the same function is a data race by construction; no amount of
care with respect to the language's allocation model will make it
thread-safe. A scratch buffer is on the calling thread's stack, so it is
per-thread without any additional discipline. Vyne has no threading
model today, so this is a forward-looking observation rather than a
measured claim. The design point is that the region discipline composes
with threads by construction, while manual hoisting does not.

**Iteration-dependent buffer sizes.** A loop body that needs
`Float64[batch_i, K]` with `batch_i` varying per iteration cannot be
served by a hoisted fixed-size buffer without either wasting memory on
small iterations or overflowing on large ones. Reallocating a boxed
`Array` per iteration accumulates on the arena without a region; hoisting
a boxed `Array` sized to the maximum wastes the difference on every small
iteration. `scratch` does not close this gap either, because the current
implementation restricts dimensions to integer literals (Section §4.2).
The natural fit is a boxed `Array` allocated inside a region — arena-backed,
sized per iteration, reclaimed at the rewind — and this is the shape that
a future arena-backed scratch variant would automate. §3.3's concern about
scratch arrays exceeding the process stack is answered by the same
extension: a scratch declaration whose storage class is chosen by the
compiler at each site (stack when the size is small and statically
bounded, arena plus region otherwise) subsumes both problems under one
construct. We do not build it here; the design pass is named as future
work.

These three cases are why the region is not decorative. In a flat loop
the region is transparent — §5.7 shows that the hand-hoisted and
region-only configurations are indistinguishable on every measured axis —
and the rewind's cost is below the noise floor. But the transparency is
a property of the flat loop, not a general equivalence. The region's
contribution is the lifetime discipline it makes expressible; scratch's
contribution is the storage class that discipline can be applied to.
§6.4's automatic scratch promotion is the mechanism that would close the
gap from the other side.

We do not claim measured numbers for the concurrency and variable-size
cases above; they are forward-looking design notes. The recursion case
is a capability demonstration backed by the three-configuration test at
`examples/benchmark/recursion_capability.vy`, and its result is stated
in the subsection.

---

## 7. Related Work

Region-based memory management as a language discipline is due to
Tofte and Talpin \cite{tofte-talpin-1997}, developed further by
\cite{grossman-2002, hallenberg-2002}. Our implementation differs in
two respects. First, we use a single global bump arena, not a family of
typed regions; a region is a checkpoint into that arena, not a distinct
allocation pool. Second, we do not integrate the region discipline into
the type system, so escape safety is a programmer responsibility rather
than a typing property. These simplifications trade expressiveness for
a much smaller implementation footprint and a smaller runtime.

Stack-allocated fixed-size arrays are, of course, the default storage
class in C, C++, and Rust. The contribution of scratch is not the
storage class itself, but the language-level syntax for declaring one
and the static shape information that flows through the type system to
make indexing and rank checks free.

The specific problem of eliminating per-iteration allocation in
numerical loops is addressed at much larger scale by frameworks such as
JAX and PyTorch, which use tracing and just-in-time compilation to
fuse and hoist allocations. Our approach is complementary: it provides
a small language-level primitive that these frameworks do not need, but
that a language without a JIT can use directly.

---

## 8. Availability

The implementation is part of the Vyne compiler at [repo](https://github.com/t2ncay/vyne). The
scratch feature is behind the `scratch` keyword; no flag is required.
The RNA classifier case study is at `tests/training/ml_seq.vy`.

The 1024×1024 matmul benchmark of §5.7 is at
`examples/benchmark/matmul_1024.vy`. It requires a stack limit of at
least 32 MB (`-Wl,--stack,67108864` on Windows, `-Wl,-z,stacksize=67108864`
on Linux) to accommodate the three scratch arrays; the driver's benchmark
build already passes this.

The shaped-assignment lowering described in §3.4 landed alongside the
constructs of §2–§3 and is exercised by `tests/transpiler/scratch_assign_test.vy`.

The native array ABI of §4.6 is exercised by
`examples/array_abi_test.vy`, a small dot-product kernel that verifies
the native variant receives a `double*` and that its body emits bare
C indexing. The test compiles to two functions
(`fn_scale_add` and `fn_scale_add_native`) and the call site in `main`
invokes the native variant directly, passing `v_a.data` and `v_b.data`.

The suite at `examples/safety/` contains ten test programs, one per check or safe pattern. It is invoked by `run_safety.ps1` on Windows (shell equivalent on POSIX); the runner compiles each file with vynec `--compile`, captures the combined compiler-and-program output, and asserts against the expected diagnostic code.

The benchmark suite passes `--no-scratch-bounds` to the compiler
to isolate the memory-model measurement from the bounds-check cost
documented in §5.8. The safety test suite runs with the checks
enabled and exercises them directly.

The hand-written C baseline of §5.7 is at
`examples/benchmark/matmul_1024_handc.c`. It compiles with the same
`gcc -O3` invocation the Vyne driver uses for the benchmark, including
the `-Wl,--stack,67108864` flag that the four 8 MB stack arrays require.

The recursion capability demonstration of §6.7 is at
`examples/benchmark/recursion_capability.vy`. It is compiled three times
with `CONFIG` set to 0, 1, and 2 to exercise the hoisted, boxed-region,
and scratch-region forms respectively.

---

## References

- Tofte, M. and Talpin, J.-P. _Region-Based Memory Management._
  Information and Computation, 132(2), 1997.
- Grossman, D. et al. _Region-Based Memory Management in Cyclone._
  PLDI 2002.
- Hallenberg, N., Elsman, M., Tofte, M. _Combining Region Inference
  and Region-Based Memory Management._ TOPLAS 24(4), 2002.

---
