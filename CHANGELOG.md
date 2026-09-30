# Vyne v0.3.0 — vml, lexical regions, and the memory-model release

**Released 2026-09-30**

This release lands the paper's memory-model work in a runnable tree: lexical
regions, shape-typed scratch, a native array ABI, BLAS dispatch, a full linear-
algebra library (`vlin`), a machine-learning library layered on top of it
(`vml`), transitive library resolution, and a set of correctness fixes to the
escape analysis that had been producing false positives on well-typed code.
Along the way, one silent-corruption defect in the emitter's untyped-`Array`
inference was found and closed.

---

## Highlights

- **Lexical regions and shape-typed scratch.** Arena checkpoints and stack-
  resident fixed-shape arrays, with three new compile-time/runtime
  diagnostics (VNE-070, VNE-071, VNE-072). On a 1024×1024 matmul, peak RSS
  drops from 2837 MB to 36 MB at 100 iterations — a 79.9× reduction — with
  bit-identical checksums.
- **vlin + vml library stack.** Two-level library layering resolves
  transitively from a single `use lib` in the user program. The RNA
  sequence classifier trains to 99.5% accuracy through `vml` and produces
  the same loss and the same per-sample predictions as its direct-`vlin`
  counterpart.
- **Native array ABI.** Functions taking `Array<Float64>` or `Array<Int64>`
  are now callable as ordinary C functions taking `double*` or `int64_t*`.
  This is what makes the BLAS bridge and the library kernels reachable
  without a per-element boxing cost.
- **BLAS dispatch.** `--blas` lowers `vlin.multiply` and
  `vlin.multiply_trans_b` to `cblas_dgemm`. 110.5 GFLOP/s at four OpenBLAS
  threads, bit-identical checksum to the emitted kernel.
- **Escape analysis fixes.** VNE-070 was firing on well-typed calls through
  group methods, interface methods, and aliased imports. Registration now
  covers every name the check queries; a narrow suffix-match fallback
  closes the remaining gap. No code-emitting path was touched.

---

## New features

### Lexical regions

`region name { ... }` introduces a lexically scoped checkpoint into the arena.
Everything allocated inside the block is released at its closing brace; the
checkpoint itself is O(1). Region checkpoint/rewind is `vmem_runtime_checkpoint`
/ `vmem_runtime_rewind`. Commit `6748c56`.

### Shape-typed scratch

`scratch name :: Float64[d1, d2];` declares a fixed-shape, stack-resident
numeric array. Indexing lowers to bare C array access — no runtime
allocation, no per-element boxing, no pointer chasing. Multi-index syntax
`x[i, j]` flattens to a linear index with compile-time strides.
Commits `7d29629`, `fdc7987`, `daca5d4`, `39bc0ae`.

### Native array ABI and `RawArrayPtr`

`CType::Kind::RawArrayPtr` represents a borrowed `T*` passed across the
native ABI. `IndexAccessNode`, `IndexAssignmentNode`, `FunctionCallNode`, and
`emitNativeFunctionBody` all handle it. A Vyne function whose parameters are
`Array<Float64>` is now callable with the raw `double*` a C programmer would
write by hand. Commit `7e923a7`.

### BLAS dispatch

`--blas` enables `tryEmitBlasCall` in `codegen/blas.cpp`, consulting a two-
entry table for `vlin.multiply` and `vlin.multiply_trans_b`. Matches lower to
`vyne_blas_matmul` in the runtime, which extracts M, K, N by field ID and
calls `cblas_dgemm`. Commits `0f443de`, `18e0b4f`.

### vlin and vml

`vlin` provides typed `Matrix`, `Vector`, kernels, constructors, reductions,
ops, activations, optimizers, and losses. `vml` layers `Dense`, `Sequential`,
`SGD`, activation dispatch, and `cross_entropy` / `mse` on top. The classifier
of `examples/training/ml_seq.vy` now imports only `vml` and still reaches
`vlin.Types.Matrix` transitively. Commits `d8971e4`, `c21f9fa`, `2b9e99d`.

### Transitive library resolution

`use lib "vml/vml.vy"` pulls in `vml`'s transitive imports without the user
program naming `vlin` directly. Types, groups, and interfaces all resolve
through the same registry. The classifier imports one library and uses three.
Commit `1e6c701`.

### Extended CLI

New flags for `vynec`: `--compile` (emit `.exe`, don't run), `--run`
(compile + run), `--emit-c` (stop at C), `--emit-asm` (stop at assembly),
`-o <name>`, `-h`, `-V`. Bare `vynec script.vy` compiles and runs, matching
`go run` / `cargo run` ergonomics. Commit `8970ad6`.

### Benchmark harness

`bench.ps1` gains a `-Source` mode (compile-then-benchmark), `-Blas`,
`-Native`, `-NoScratchBounds` forwarding, `-Json` export, `-Baseline`
comparison, median + MAD reporting, environment fingerprint, and fail-fast
warmup. Commit `8970ad6` and follow-up work.

---

## Bug fixes

### VNE-070 false positives on group and interface methods

**Closes the escape-check defect found during classifier development.**
Calls to `vlin.cross_entropy`, `vlin.apply_tanh`, and friends inside a
region were rejected as VNE-070 even though they return `Float64`. Root
cause: the escape check queried the emitter's return-type table with a
short list of name candidates that did not cover group methods
(`<group>_<method>`), interface methods (emitted inline by
`InterfaceNode::compile`, never routed through `FunctionNode::compile`),
or `use lib` aliased imports (routed through `FunctionNode::compileAs`).
Fixes: registration now covers every candidate spelling in
`GroupNode::compile`, `FunctionNode::compile`,
`FunctionNode::compileAs`, `ImportNode::compile`, and
`InterfaceNode::compile`; `checkRegionEscape` falls back to a
primitive-return-only suffix match against the whole table when named
lookup misses. The code-emitting path is untouched. Commit `fc72d7e`.

### Untyped `Array = []` silent narrowing

**Silent-corruption defect. Potentially affects any program with an untyped
array accumulator.**

`x :: Array = [];` was lowered directly to `vyne_array_f64_create(0)` because
the emitter defaulted an unknown element type to `Float64`. Every subsequent
`x.push(v)` then coerced `v` to a `double` through the `VyneValue` union's
`as.i64` member. For a string, a struct, or any non-numeric value, this wrote
the low 64 bits of a pointer where a `double` was expected, under a static
type claiming the values were legitimate. The symptom during classifier
development was a runtime error several call frames from the actual defect
(`Invalid operation between Int64 and Null`).

Fix: the empty-literal fast path now fires only when the declared element
type is known (i.e., the source said `Array<Float64>` or `Array<Int64>`).
An untyped `Array = []` falls through to the boxed path and every later push
goes through the tag-preserving runtime helper. Commit `dfa5ae4`
_(confirm this — the commit message mentions the fix but not the defect)_.

### `sgd_step` overshoot

`vml.sgd_step(W, grad, opt)` was using `opt.lr` (0.5) instead of the mean-
scaled learning rate (`0.5 / N_SAMPLES`), giving a 240× overshoot per epoch.
Loss climbed 0.70 → 10.36 and accuracy stayed at 50% because sigmoid saturated
immediately. Now takes the effective learning rate explicitly. Commit
`bec8224`.

### `vyne_array_place_all` / `vyne_array_i64_push` allocation

Both now amortize growth on the arena. Commit `54c45bd`.

### Unresolved-import diagnostics

`parseImportModule` and `VyneLinker` produce actionable errors naming the
file, the line, and the search directory. Commit `8d3c8c0`, `932846d`.

### `arena_free_all` redundant init

Commit `8839781`.

### Member and index assignment inside regions

`IndexAssignmentNode` and `MemberAssignmentNode` now run the same region
escape check as `AssignmentNode`. Commits `904add2`, `fdd65f7`.

---

## Safety diagnostics

Three new codes, all triggered by the region/scratch constructs:

| Code        | Trigger                                                                                      |
| ----------- | -------------------------------------------------------------------------------------------- |
| **VNE-070** | Region escape: assignment of a region-local non-primitive into a shallower-declared variable |
| **VNE-071** | Rank mismatch on multi-index scratch access                                                  |
| **VNE-072** | Scratch index out of bounds (per-dimension, runtime)                                         |

The safety test suite at `examples/safety/` covers all three plus six
safe-pattern cases. Commit `a7fa011`, `cba685d`.

---

## Performance

### 1024×1024 matmul, ITERS = 100

| Config                                 |        Peak RSS |     Wall clock | Checksum |
| -------------------------------------- | --------------: | -------------: | -------: |
| Baseline (boxed `Array` per iteration) | 2836.6 ± 2.7 MB | 13.83 ± 0.07 s |  3.47777 |
| Region-only                            |   63.6 ± 0.1 MB | 13.72 ± 0.06 s |  3.47777 |
| Region + scratch                       |   35.5 ± 0.0 MB | 14.54 ± 1.27 s |  3.47777 |
| Hand-written C                         |   35.4 ± 0.0 MB |  13.11–15.08 s |  3.47777 |

### BLAS dispatch, 1024×1024 × 100

| Config                       | Threads |    Wall | GFLOP/s | Checksum |
| ---------------------------- | ------: | ------: | ------: | -------: |
| Emitted kernel (no `--blas`) |       1 |  ~231 s |     0.9 |  3.47777 |
| `cblas_dgemm`                |       1 | 4.005 s |    53.6 |  3.47777 |
| `cblas_dgemm`                |       4 | 1.944 s |   110.5 |  3.47777 |
| `cblas_dgemm`                |      28 | ~1.78 s |    ~121 |  3.47777 |

All checksums bit-identical across configs and thread counts.

### RNA classifier

| Config              | Final acc | Final loss | Peak RSS |   Wall |
| ------------------- | --------: | ---------: | -------: | -----: |
| vlin-based (direct) |     99.5% |   0.226304 |   6.4 MB | 0.13 s |
| vml-based (layered) |     99.5% |   0.226304 |   2.6 MB | 0.06 s |

The vml-based numbers are collected on a lower-floor machine; the point is
that the library layering adds nothing, not that it accelerates.

---

## Documentation

- **Technical report** on lexical regions and shape-typed scratch —
  `regions.md`. Commits `6748c56`, `6d10701`, `35c0205`, `12c1630`.
- **Optimization roadmap** — `todo_optimization.md`. Commit `c8e0199`.
- **Per-file safety rulesets** (design draft) — `todo_rulesets.md`.
  Commits `f66be85`, `c8e0199`.
- **Native array ABI documentation** with corrected code formatting.
  Commit `fbf0cbe`.
- **Standard library TODO** — `todo_stdlib.md`. Commit `5a3e610`.
- **Post-paper feature axes** — `todo_2.md`. Commit `444f036`.

---

## Internal changes

### Codegen architecture split

The monolithic `codegen.cpp` is replaced by feature-per-file translation
units: `assignments.cpp`, `blas.cpp`, `builtins.cpp`, `collections.cpp`,
`control_flow.cpp`, `exceptions.cpp`, `functions.cpp`, `function_calls.cpp`,
`groups_modules.cpp`, `imports.cpp`, `interfaces.cpp`, `language_features.cpp`,
`literals.cpp`, `loops.cpp`, `maps_strings_scratch.cpp`, `members.cpp`,
`method_calls.cpp`, `native_dispatch.cpp`, `operators.cpp`, `program.cpp`,
`regions.cpp`. Commit `d5a5833`.

### Type lookup unification

`C_Emitter::lookupType` replaces `exprNativeType` / `lookupAnyType` /
`lookupCType`. One API, one ordering (nativeTemps → locals → globals).
Commit `07d603c`.

### Typed arrays

`V_F64_ARRAY` and `V_I64_ARRAY` value kinds with O(1) boxing and unboxing at
the boundary. Commit `8483692`.

### Region policies

Parameterizable allocation strategies per region. Commit `ea6b109`.

### AST accessors

`IndexAccessNode::takeBase`, `takeIndex`, `ScratchIndexNode::takeIndices`, and
similar. Commit `ffdd501`.

---

## Breaking changes

### CLI: `--compile` no longer runs the program

`vynec --compile foo.vy` used to compile and then execute `foo.exe`. It now
compiles and stops. Use `vynec --run foo.vy` (or the bare `vynec foo.vy`,
which now means compile-and-run) if you want the program to execute.

Replace:

```bash
vynec --compile foo.vy           # old: compile + run
```

With:

```bash
vynec foo.vy                     # new: compile + run
vynec --run foo.vy               # new: same, explicit
vynec --compile foo.vy           # new: compile only
```

### CLI: `--c` alias removed

`vynec --c` is gone. Use `vynec --emit-c` to emit C without compiling.

### Library rename: `bio` → `vbio`

Commit `c7340b1`, `fafeb5c`, `0ec3dc6`. Any `.vy` file importing the old
`bio` library must update the import path.

### `vlinalg` removed, replaced by `vlin`

Commit `a0530ac`, `ce2bd11`, `d0b6670`. The Matrix interface now declares
`Array<Float64>` rather than `Array` for its data field. Programs that
relied on the untyped field will need to add the element type.

---

## Upgrade guide

1. **Update CLI invocations.** `vynec --compile` now stops at `.exe`.
   Anything that wanted the program to run must use `--run` or drop the
   flag. See the breaking-changes section above.

2. **Rename `bio` imports to `vbio`.** In any file that still uses
   `use lib "bio/..."`, change to `use lib "vbio/vbio.vy"`.

3. **Rename `vlinalg` references to `vlin`.** The old module is gone.
   Interfaces, function names, and constructors moved to `vlin` with the
   same semantics.

4. **Add element types to `Matrix.data` accesses.** The field is now
   `Array<Float64>`, not `Array`. Code that constructed a Matrix from a
   boxed `Array` still works, but a Matrix whose `.data` is a typed
   `VyneArray_f64` is required for the native-array ABI to fire.

5. **Check any `Array = []` accumulator.** The emitter no longer silently
   narrows an untyped `Array = []` to `Array<Float64>`. Code that depended
   on the old behaviour (implicitly pushing numbers into an array that was
   declared untyped and then indexing it as if it were typed) will now get
   boxed semantics. This is almost certainly a _fix_ for your program, but
   if you had code that relied on the previous narrowing, add an explicit
   `Array<Float64>` annotation.

---

## Known limitations

- **Native-array indexing is not bounds-checked.** Indexing through a
  `RawArrayPtr` is undefined behavior on out-of-range access, matching C.
  The boxed path remains checked.
- **Escape analysis is syntactic.** It rejects direct escape, member-store
  escape, and index-store escape but does not track escape through a
  function return or through a container. A full analysis is future work
  (§6.4 of the technical report).
- **`region.commit` grows the commit arena linearly.** Reclamation requires
  the same escape analysis as above (§6.5).
- **Shaped-assignment from a boxed source checks element type per element.**
  A shaped `Array` type would let the check be elided (§6.6).
- **Scratch arrays are bounded by the process stack.** Large scratch arrays
  require `-Wl,--stack,67108864` on Windows or the equivalent; the compiler
  driver passes this flag by default.

---

## Contributors

- **Tuncay** — all commits in this release.

## Full commit list

See `git log v0.2.0..v0.3.0` for the raw list. The 100 commits this release
covers span `d60be2f` (2026-09-26) through `8970ad6` (2026-09-30).
