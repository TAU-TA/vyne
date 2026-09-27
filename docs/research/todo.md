# The full TODO list

Everything we discussed, ordered. Phases are sequential; items inside a phase can be interleaved.

---

## Phase 0 — Compiler bugs — DONE ✓ (commit ready)

- [x] **Reclaim bug in `vyne_array_push`** — verified in arrays.h
- [x] **Reclaim bug in `vyne_array_f64_push`** — verified in typed_arrays.h
- [x] **Reclaim bug in `vyne_array_i64_push`** — verified in typed_arrays.h
- [x] **Reclaim bug in `vyne_array_place_all`** — verified in arrays.h
- [x] **`vmath.seed` runtime function** — verified in vmath.h
- [x] **Seed registration in `VMATH_MAP`** — verified in native_maps.h
- [x] **Native globals fix in `assignments.cpp`** — verified
- [x] **Same class of bug in `groups_modules.cpp`** — verified
- [x] **Same class in `imports.cpp`** — verified
- [x] **Parser import recursion fix** — verified (shared cache + cycle guard)
- [x] **Loud failure on missing import** — VNE-005 in parser and linker;
      confirmed by run: `./vynec.exe /tmp/bad.vy` → VNE-005 with line number
- [x] **Parameter `typePath` propagation** — verified end-to-end
- [x] **`-march=native` behind `--native` flag** — verified; compile line
      prints "gcc -O3 -march=native" only when flag is passed
- [x] **Duplicate reset block in `arena_free_all`** — bonus, removed

**Commit:** `Fix parser, emitter, and runtime bugs; add native-target flag`

---

## Phase 1 — Safety — DONE ✓ (commit ready)

- [x] **Scratch bounds checks** — emitted in `scratchFlatIndex`; per-dimension
      VNE-072 on violation. Verified: matmul runs with checks enabled show
      identical checksums and 3.5% wall-clock spread.
- [x] **Region depth tracking** — `regionDepthAtDeclaration` in `LocalScope`,
      `committedVars` set, `markCommitted` and `lookupLocalRegionDepth` helpers
- [x] **Escape check in `AssignmentNode::compile`** — VNE-070 on direct escape
- [x] **Escape check in `MemberAssignmentNode::compile`** — same
- [x] **Escape check in `IndexAssignmentNode::compile`** — same
- [x] **Update §2.2** — applied; text now describes the VNE-070 check and
      its soundness gap
- [x] **Update §6.4** — applied; syntactic approximation described, full
      analysis retained as future work

**Commit:** `Add scratch bounds checking and syntactic region escape checks`

---

## Phase 2 — Benchmark completion

### Experiment 1 (baseline vs region over iteration count)

- [x] **Config 3 (hoisted baseline)** — implemented in matmul_1024.vy
- [x] **ITERS=10 on all four configs** — measured (mean of 3, checks enabled):
      | config | peak (MB) | wall (s) | checksum |
      |--------|-------------:|-------------:|----------|
      | 0 | 308.0 ± 6.3 | 1.44 ± 0.03 | 3.47777 |
      | 1 | 62.8 ± 0.2 | 1.46 ± 0.01 | 3.47777 |
      | 2 | 35.5 ± 0.0 | 1.43 ± 0.03 | 3.47777 |
      | 3 | 63.6 ± 0.0 | 1.41 ± 0.02 | 3.47777 |
- [ ] **ITERS=100 on all four configs** — confirm 1, 2, 3 stay flat and 0
      grows linearly. This is the memory-model claim at both ends.
- [ ] **ITERS=1000 on config 0 only, or extrapolate** — 1000 may not fit;
      measure or state "extrapolating from the measured ~16 MB/iteration"

### Experiment 2 (boxed vs region vs scratch)

- [x] Done — configs 0, 1, 2, and 3, all with checks enabled
- [x] Wall-clock parity noted in §5.7 — paper draft updated with mean ± sd table
- [x] Check overhead paragraph added — "Check overhead is bounded" in §5.7

### Experiment 3 (shape specialization)

- [ ] New benchmark: boxed `Array<Float64>` vs typed `VyneArray_f64` vs
      scratch, same operation (element-wise add or a small matmul)
- [ ] Measure runtime, instruction count if possible
- [ ] Write up as §5.8

### Experiment 4 (safety)

- [ ] `examples/safety/` directory, one `.vy` per case:
  - [ ] `correct_index.vy` — should pass
  - [ ] `negative_index.vy` — should now fail with VNE-072
  - [ ] `too_large_index.vy` — should now fail with VNE-072
  - [ ] `wrong_index_count.vy` — compile error from rank check
  - [ ] `wrong_shape_assign.vy` — runtime exit(1)
  - [ ] `escape_via_assignment.vy` — should now fail with VNE-070
  - [ ] `escape_via_member.vy` — should now fail with VNE-070
  - [ ] `escape_via_index.vy` — should now fail with VNE-070
  - [ ] `nested_region.vy` — should pass
  - [ ] `return_from_region.vy` — should pass (primitive return)
- [ ] `run_safety.sh` — compiles each, asserts pass/fail with expected diagnostic
- [ ] Add `test-safety` target to Makefile
- [ ] Write up as §5.9

### Comparisons

- [ ] **Hand-written C equivalent** of config 3 — same hoist, hand-written,
      measured under the same peak-RSS sampler. **This is now the single most
      important item on the list.**
- [ ] **NumPy reference** — time and memory for a 100-iteration loop,
      with and without `out=`
- [ ] **Footnote in §5.7** — name the ISA/codegen gap; frame the comparison
      as memory, not speed

---

## Phase 2.5 — Corpus hygiene

- [ ] **Update §5.6 with current classifier numbers.** Still "to be filled in."
      Post-Phase-0 execution is ~100 ms, not ~38 s. Re-run without `--native`
      for the portable figure, then fill in the table.
- [x] **Fix the seed position in ml_seq.vy** — `vmath.seed(42)` above
      "Generating sequences..."
- [x] **Correct §5.7 config count and numbering** — four-config draft applied
- [x] **Re-verify the ~11 MB growth-path decomposition in §5.7** — old
      decomposition was stale; replaced with "16 MB elements + 148 MB block
      overhead and transient copy"
- [x] **Delete §6.7 (growth-path reclaim)** — bug is fixed; section describes
      an unfixed state that no longer exists. Renumber 6.8–6.10 → 6.7–6.9.

---

## Phase 3 — Paper updates

- [x] **Abstract** — 8.7× / identical-checksum sentence present
- [x] **§2.2** — VNE-070 described with soundness gap pointer to §6.4
- [x] **§3.3** — stack-limit bullet present
- [x] **§4.5** — native scalar ABI documented
- [x] **§5.7** — four-config table with mean ± sd, check overhead paragraph,
      interpretation corrected
- [x] **§6.4** — syntactic check described, full analysis retained as future
- [ ] **§5.4** — SLP-vectorization mechanism, cite the disassembly
      (draft has it; verify against actual `gcc -S` output)
- [ ] **§5.6** — training-loop measurements (post-Phase-0 numbers)
- [ ] **§5.8** — shape specialization (after Exp 3)
- [ ] **§5.9** — safety (after Exp 4)
- [ ] **§6.6** — one sentence naming the scratch/storage-class conflation
- [ ] **§6.7–6.10 renumber** — after deleting the reclaim bug section
- [ ] **§7 Related Work** — paragraph contrasting scratch with `std::array`,
      `std::inplace_vector`, Rust `[T; N]`, Ada constrained arrays
- [x] **§8 Availability** — benchmark path and safety suite path documented

---

## Phase 4 — The design fix — RECOMMENDATION: DO NOT DO THIS WEEK

The minimal version is the §6.6 sentence. The full version is a paper-sized
project. Middle path (shape-typed signatures) is 3–5 days and competes with
Futhark/SaC on an axis you haven't measured on yet.

- [ ] (Deferred) Shape-typed function signatures
- [ ] (Deferred) Scratch as a value of a shape type
- [ ] (Deferred) Composability demo
- [ ] (Deferred) §4.3, §4.6, §6.6 updates

**Honest recommendation unchanged: write §6.6 as future work, ship the
memory-model paper, save shape types for Paper 3.**

---

## Phase 5 — Deferred to next papers (do NOT touch now)

**Paper 2 — Linear Tensors:**

- Linear/affine tensor types
- In-place vlinalg ops with static uniqueness proofs
- Buffer pools with size classes
- Copy-on-write with region-scoped refcounts

**Paper 3 — Lightweight Shape-Typed Numerical Programming:**

- Full shape types with arithmetic
- Static memory planning
- Compile-time peak bounds
- Kernel specialization

**Later:**

- Borrow parameters (`&`)
- Views
- Region-scoped cleanup hooks
- Automatic scratch promotion via escape analysis
- Region inference
- Region-scoped threads
- Region-aware FFI
- Activation checkpointing as a language primitive

---

## The recommended order from here

1. ~~Phase 0~~ — done.
2. ~~Phase 1 (safety)~~ — done.
3. ~~ITERS=10 all four configs~~ — done.
4. **ITERS=100 on all four configs** (30 min). Confirms the memory-model
   claim at both ends. Then the paper's §5.7 numbers are final.
5. **Hand-written C comparison** (half day). Single biggest remaining lever.
6. **§5.6 classifier numbers** — re-run without `--native`, fill in the table.
7. **Safety test files** (Experiment 4, half day) — makes the VNE-070/072
   checks testable, closes §5.9.
8. **Delete §6.7, renumber §6.8–6.10** — paper hygiene.

Do not start Phase 4. Do not chase cuBLAS or GPU support. Finish the paper.

---

## Commit boundary

- Phase 0: `Fix parser, emitter, and runtime bugs; add native-target flag` ← **READY**
- Phase 1: `Add scratch bounds checking and syntactic region escape checks` ← **READY**
- Phase 2 (partial): `Add hoisted baseline; measure four-config matmul at ITERS=10 with checks enabled` ← **READY**
- Phase 2 (complete): `Complete benchmark suite: 4 configs, 4 experiments, safety tests`
- Phase 3: `Paper updates for §5.6–§5.9, §6.6–§6.9, §7`
- Phase 4 (if done): `Shape-typed scratch: types, ABI, composability demo`

---

**Current single most important item: the hand-written C comparison.**
Without it, every number in §5.7 compares Vyne against Vyne. The C baseline
is what turns "the region construct works" into "the region construct
matches what a C programmer would do, at the same speed, without the manual
hoisting work." Either outcome strengthens the paper. Run it before starting
Experiment 3 or the safety test files.
