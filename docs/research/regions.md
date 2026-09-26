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
for the two accumulator buffers. The same technique extends to the weight-gradient
buffers via a shaped-assignment lowering introduced in the same release; a second
pass over the case study makes all five per-iteration arrays stack-resident.
Two follow-up capabilities — a native ABI for primitive-typed
scalar parameters (landed, §4.5) and the corresponding ABI for array parameters,
together with escape analysis — are still required before the technique generalizes to
the rest of the loop.

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
Any reference to a region-allocated value after the closing brace is a
use-after-rewind and is a programmer error, not a runtime error — the
compiler does not currently insert escape checks.

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

````c
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
````

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
Removing that cost requires shape-aware overloads on the linear-algebra
library and is outside the scope of the current report.

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

The three gradient buffers are the largest allocations in the loop
(1024 + 192 + 12 = 1228 elements, versus 28 for the bias buffers).
Promoting them to scratch is the single biggest reduction in arena
traffic that this technique can deliver on this program without
modifying `vlinalg` itself. The reduction is bounded by the same
boundary §5.4 names: the source of each copy is still a boxed
tensor, and the result of `dW1` in the SGD update is still read
through the arena because `sgd_update_inplace` takes boxed arguments.
What disappears is the per-iteration allocation of the destination.

### 5.6 Measurements

_To be filled in._ The three configurations to measure are:

1. **Baseline** — original program, no scratch, no shaped assignment.
2. **Accumulators only** — the rewrite of §5.1; `db1_buf` and `db2_buf`
   are scratch, everything else is boxed.
3. **Accumulators + gradients** — the rewrite of §5.1 plus the gradient
   buffers of §5.5.

For each configuration, record:

- **Final classification accuracy** at `EPOCHS = 50`. This is a
  correctness check, not a performance check. All three should be equal
  to the last decimal; a difference means the rewrite changed behaviour
  and the change needs to be understood before any other number is
  reported.
- **Peak resident set size** at `EPOCHS ∈ {50, 500, 5000}`. This is the
  point of the exercise. Under the memory model of §2, the baseline
  should grow linearly with `EPOCHS`, and the two rewritten
  configurations should be flat. If configuration (3) is flat across
  `EPOCHS` and configuration (1) is linear, the memory model is doing
  what §2 promises.
- **Wall-clock time per epoch** for the same three values of `EPOCHS`.
  This is a secondary number. The technique is not a speedup; it is a
  memory-footprint change. If it is also a speedup, that is worth
  reporting; if it is neutral, that is expected.

Peak RSS is best measured with `/usr/bin/time -v` on Linux or
`Get-Process` on Windows. Report the mean of five runs and the standard
deviation, not the minimum; the arena's block size of 8 MB makes the
minimum unrepresentative.

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

Distinct from borrowing a scratch array is the question of passing an
ordinary `Array<Float64>` natively. Today, passing an `Array<Float64>`
to a Vyne function boxes it, even though the emitter already knows the
argument is a `VyneArray_f64` and could pass `(const double\*, int64_t)`
directly. Extending §4.5's dispatcher to this case requires the native
variant signature to reflect the array element type, and the argument
coercion at the call site to produce `.data` and `.size` rather than a
pointer to the container.

This is the load-bearing step for numerical kernels. Without it, every
loop that reads an array parameter pays a runtime tag check per element,
and the C compiler cannot vectorize the loop body even when the element
type is statically known. The primitive ABI in §4.5 is the prerequisite;
the array case is the payoff. The two together are what would let a
Vyne-defined `matmul` reach the same generated code that a C
implementation would.

The distinction from §6.1 is worth stating explicitly. Borrow parameters
are a language-level feature: the programmer writes `&` and the
semantics of the call change. The native array ABI is a compiler-level
optimization: the source code is unchanged, and the emitter chooses a
narrower calling convention when the argument's static type permits it.
Both are needed. Borrow parameters let scratch be passed into functions;
the native array ABI lets ordinary `Array<Float64>` be passed without
the boxing cost.

**Effort**: moderate. The signature computation is mechanical once §4.5
exists; the harder part is the interaction with deep-copy semantics,
since Vyne arrays are passed by reference and the native path must
preserve that.

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

The shaped-assignment lowering described in §3.4 landed alongside the
constructs of §2–§3 and is exercised by `tests/transpiler/scratch_assign_test.vy`.

---

## References

- Tofte, M. and Talpin, J.-P. _Region-Based Memory Management._
  Information and Computation, 132(2), 1997.
- Grossman, D. et al. _Region-Based Memory Management in Cyclone._
  PLDI 2002.
- Hallenberg, N., Elsman, M., Tofte, M. _Combining Region Inference
  and Region-Based Memory Management._ TOPLAS 24(4), 2002.

````

---

```

```

```

```
````
