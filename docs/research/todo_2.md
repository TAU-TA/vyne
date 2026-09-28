# TODO 2 — Post-Paper-1 feature axes

Draft, saved for after Paper 1 ships. **Do not start any of this until
TODO.md is fully checked.** This document exists so the direction is
written down while it's fresh; it is not a work plan yet.

The through-line: regions gave us **lifetime** as a compile-time fact.
Every item below is a _different axis_ the compiler can see. Each is
orthogonal to regions, each composes with regions, and each is a
decision that a numeric language can move from runtime to compile time
but that mainstream languages cannot.

---

## The axes

| Axis           | Feature                        | What it eliminates                                   |
| -------------- | ------------------------------ | ---------------------------------------------------- |
| Lifetime       | Regions (Paper 1)              | Per-iteration allocation                             |
| **Identity**   | Uniqueness / linear types      | Runtime alias checks, defensive copies               |
| **Shape**      | Shape types `Float64[M,N]`     | Runtime shape checks, dim mismatches                 |
| **Range**      | Refinement types `Int<0..N>`   | **All bounds checks** — VNE-072 becomes a type error |
| **Unit**       | Dimensional types `Float<m/s>` | Unit-conversion bugs                                 |
| **Layout**     | SoA/AoS as a type              | Cache misses, manual restructuring                   |
| **Effect**     | Purity / allocation typing     | "Does this allocate?" becomes a signature            |
| **Precision**  | f32/f64/bf16 as a type         | Manual precision tuning                              |
| **Mutability** | Read-only as a type            | Aliasing bugs, unintended mutation                   |

Pick any two; they compose. That's the design space.

---

## Ranked features

### Tier 1 — the four strongest

---

#### F1. Refinement types for ranges

**What.** Give `Int64` a range annotation: `Int64<0..N>`. The compiler
proves each arithmetic result stays in range, and elides the runtime
bounds check when it can.

```vyne
through k4 :: 0..N/4-1 -> loop {
    k0 :: Int64<0..N-4> = k4 * 4;
    // A[r, k0 + i] is provably in-bounds. No VNE-072 emitted.
};
```

Why it's first. The §5.7 measurement shows a 45% wall-clock cost
from bounds checks in the hot loop (2.25 s checks-on vs. 1.54 s
checks-off at ITERS=10, on the same kernel). The reason GCC couldn't
hoist those checks was that it couldn't see the range of k0. The
reason Vyne couldn't either was that Int64 carried no range. Range
refinement is the direct fix, and the paper writes itself: "we measured
the cost; range refinement eliminates it statically; here's the proof."

What lands.

· Int64<lo..hi> as a type, with lo and hi either literals or
expressions in scope.
· Refinement propagation through +, -, \*, /, % with
conservative interval arithmetic.
· Loop induction variable types inherit their range from the through
bounds.
· A bounds_check fallback for values whose range can't be proven —
today's VNE-072, unchanged.
· Interaction with scratch: if all indices to a scratch access are
proven in-range, scratchFlatIndex emits no check.

Effort. 2–3 weeks. The refinement solver is the hard part; the
codegen side is a small diff to scratchFlatIndex and
IndexAccessNode.

Paper. Yes — Paper 3's core. Composes with F2 and F3.

Depends on. Nothing. Can start the day Paper 1 ships.

---

F2. Uniqueness / linear types

What. A unique annotation on a value means the callee holds the
only reference. The compiler can then mutate in place, with no runtime
alias check and no defensive copy.

```vyne
fn relu_inplace(x :: unique Float64[N]) {
    through i :: 0..N-1 -> loop {
        if x[i] < 0 { x[i] = 0; };
    };
};

fn matmul(A :: unique [M,K], B :: [K,N]) -> unique [M,N] { ... };
```

Why it's second. It's the feature that makes vlinalg fast without
leaving the language. PyTorch has out= parameters but can't enforce
they're used correctly. JAX forbids in-place mutation outright. A
linear type system enforces it at compile time and gives you the
in-place mutation for free.

What lands.

· unique as a type modifier, orthogonal to shape.
· Linearity checking: a value declared unique can appear in exactly
one place at a time. Assignment consumes; return consumes; passing
to a unique parameter consumes.
· unique + & (borrow parameters, §6.1) — a borrowed unique gives
in-place mutation through a reference. This is what makes
matmul(A, B, C) where C is the destination work without a copy.
· Interaction with regions: a unique scratch buffer can be passed
by reference and mutated in place with no runtime check.

Effort. 3–4 weeks. Linearity checking is well-understood but
touches every AST node.

Paper. Yes — Paper 2 ("Linear Tensors"). This is the biggest of
the four.

Depends on. F4 (effect typing) for the !alloc-checked version
of in-place ops. Can be built independently otherwise.

---

F3. Shape types

What. Dimensions as part of the type:

```vyne
fn matmul(A :: Float64[M, K], B :: Float64[K, N]) -> Float64[M, N] {
    // M, K, N are type variables, unified at the call site.
};
```

Type-level dimensions. Mismatches are compile errors. The compiler
knows the sizes and can plan memory layout.

Why it's third. Futhark and SaC have this. Nobody has combined it
with a region-based memory model or with a lexical-scratch storage
class. It's the natural complement to regions: regions say when
memory dies, shapes say how much it is.

What lands.

· Shape variables at the type level, with unification at call sites.
· Arithmetic on shape expressions (M \* K, M + N) with simplification.
· Shape inference for vlinalg return types — multiply gets the
right shape for free.
· Interaction with scratch: scratch buf :: Float64[M, N] for type
variables M, N in scope. Turns the runtime shape check of §3.4's
third case into a compile-time check.
· Interaction with F1: shape and range are the same kind of fact.
Float64[N] indexed by Int64<0..N-1> is a rank-1 array with a
provably-safe access.

Effort. 4–6 weeks. Unification + arithmetic on shapes is the hard
part.

Paper. Yes — Paper 3. Composes with F1.

Depends on. Nothing strictly, but F1 and F3 land well together —
both are "type-level facts about values."

---

F4. Effect typing for allocation (and purity)

What. A !alloc effect marker on functions and regions that
asserts the body performs no arena_alloc call.

```vyne
fn process_block(x :: Float64[512]) -> Float64[512] !alloc {
    // Compiler proves: no allocation in this body.
};

region callback !alloc {
    process_block(in, out);
};
```

Why it's fourth. Not because it's weak — it's the contract form
of everything you've been building. The audio callback rule ("never
allocate in the callback") becomes a checkable signature instead of a
convention. It's the smallest of the four, but it's the one that
turns the memory-model work into a verifiable promise rather than a
measured property.

What lands.

· A small effect lattice: !alloc, !io, !block, !throw, with
pure = !alloc + !io + !block + !throw.
· Effect inference: a function's effects are the union of its
callees', unless explicitly annotated.
· Effect checking at annotation sites.
· Interaction with regions: region X !alloc { ... } proves the
region body never allocates, which combined with the region rewind
gives you a provably-allocation-free region.
· Interaction with F2: a !alloc function that receives unique
arguments can mutate in place without violating its effect
contract.

Effort. 1 week. A constraint solver over a small lattice.

Paper. Section, not a paper. But it's the section a reviewer will
quote.

Depends on. Nothing.

---

Tier 2 — real features, smaller papers

---

F5. Units of measure

Float64<meters> * Float64<seconds> → Float64<meters*seconds>. F# has
this; nobody else does. Niche but the community that wants it wants it
badly. Natural fit for scientific and engineering code.

Effort. 2 weeks.

Paper. Section. Maybe a short workshop paper.

---

F6. Layout types

Float64[N] stored AsAoS vs stored AsSoA. Compile-time layout
choice; same source-level operations. Big cache-performance win.

Effort. 3 weeks.

Paper. Maybe. The combination with shape types (compiler picks
layout from access patterns) is the interesting version.

Depends on. F3 (shape types) for the interesting version.

---

F7. Mutability as a type

x :: const Float64[N] — read-only parameter. C++ has const, Rust
has &. The interesting version is the interaction with F2:
const unique means "you own it, but you can't mutate it";
const shared means "you can read it, anyone can read it, nobody
can write it."

Effort. 1 week.

Paper. Section.

Depends on. F2.

---

F8. Precision types

Float32, Float64, BFloat16 as first-class types, with automatic
promotion rules. The interesting version is precision-error
tracking: "this computation accumulates at most 1e-6 relative error."
Nobody does this.

Effort. 2 weeks for the types; 6+ weeks for the interesting
version.

Paper. Maybe, if the ML angle is right. Otherwise section.

---

F9. Explicit value semantics

Make it a type property whether an assignment copies or shares. Right
now Vyne shares arrays by reference (see function_calls.cpp). Making
that explicit as x :: value Array<f64> vs x :: share Array<f64>
clarifies a lot of code and closes a family of aliasing bugs.

Effort. 2 weeks.

Paper. Section.

Depends on. F2 (uniqueness) — they overlap.

---

How they compose

These features multiply. The interesting interactions:

· F1 + F3 (range + shape) → every scratch access is provably
in-bounds. VNE-072 disappears entirely for well-typed code.
· F2 + F4 (uniqueness + effect) → !alloc functions can only
mutate what they uniquely own. In-place ops with zero-allocation
proof, statically.
· F2 + F3 (uniqueness + shape) → matmul(A: unique [M,K], B:
[K,N]) -> unique [M,N]. A correct-by-construction BLAS.
· F3 + F6 (shape + layout) → the compiler picks SoA vs. AoS from
the access patterns it can see in the shape-typed code.
· F1 + F3 + F4 → a numeric kernel whose signature proves: no
allocation, in-bounds access, correct shapes, in-place mutation.
That's the whole pitch of the language in one function header.

---

Paper sequence

```
Paper 1 (in progress):  Regions + scratch + compile-time peak bounds
Paper 2:                Uniqueness + linear tensors + in-place ops
Paper 3:                Shape types + range refinement + static bounds
Paper 4:                Effects + purity + allocation contracts
Paper 5+:               Units, layout, precision — the long tail
```

Each paper is independent of the ones after it. Each is a legitimate
contribution on its own. Together they are "the language where every
property of a numeric computation is a compile-time fact."

---

What to pick for the next year

Two bets, both orthogonal to regions, both with a clear payoff:

Bet 1 — Range refinement (F1)

Because it kills the 45% check overhead you just measured, and it's
the feature with the cleanest demo. The paper writes itself: "we
measured the cost in §5.7; range refinement eliminates it statically;
here's the proof."

First deliverable. Int64<lo..hi> types, refinement propagation
through arithmetic, scratchFlatIndex elides provable checks. Target:
the §5.7 matmul at ITERS=10 with range-typed induction variables runs
at checks-off speed with checks on.

Bet 2 — Uniqueness / linear types (F2)

Because it's the feature that makes Vyne a numeric language rather
than a general one, and it's what the diffDSP summer project needs.
In-place mutation with a compile-time proof, no aliasing, no
defensive copies.

First deliverable. unique annotation, linearity checking, in-place
vlinalg ops. Target: relu_inplace(x: unique Float64[N]) compiles
to a scalar loop with no COW check and no defensive copy.

Why these two

They're the two axes that (a) don't need the other features first,
(b) have demos you can write in a week, and (c) compose with everything
else. Land them, and Papers 2 and 3 are already half-written.

---

What NOT to do

· Multi-stage programming (MetaOCaml-style, Zig comptime). It's
tempting because it sounds compile-time-y, but it's orthogonal to
the pitch. Staging is about generating code at compile time; the
pitch is about proving properties. They compose but don't
reinforce each other. Save for never, or for a much later paper.
· A general-purpose language. The pitch is numeric code with
compile-time proofs. Don't chase Python or Go.
· GPU before Papers 2 and 3. Requires unique ownership (F2) and
shape types (F3) as prerequisites. It's a paper-sized project, not
a library binding.
· External BLAS before §6.2 (native array ABI). Same reason.
· All nine features at once. Pick two. Land them. Then pick two
more. Nine half-built features is worse than two complete ones.

---

Sequencing note

TODO.md (Paper 1) is the priority. Nothing here starts until:

· The C comparison is done.
· §5.6 numbers are filled in.
· §6.9 (hoisting gaps) is written.
· §1 is reframed (layered, not parallel).
· Paper 1 is submitted.

Then — and only then — pick Bet 1 or Bet 2. Not both. One.

---

```

```
