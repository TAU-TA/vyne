# The full TODO list

Everything we discussed, ordered. Phases are sequential; items inside a phase can be interleaved.

---

## Phase 0 — Compiler bugs — DONE

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
      verify once with `./vynec.exe /tmp/bad.vy` → expect "VNE-005 ... line 1"
- [x] **Parameter `typePath` propagation** — verified end-to-end
- [x] **`-march=native` behind `--native` flag** — verified (compile line prints
      "gcc -O3 -march=native" only when flag is passed)

---

## Phase 1 — Safety (not started)

- [ ] **Scratch bounds checks** — emit a comparison in `ScratchIndexNode::getCExpr`
      and `ScratchStoreNode::compile` before the array access
- [ ] **Region depth tracking** — add `regionDepthAtDeclaration` to `LocalScope`
      in `emitter.h`
- [ ] **Escape check in `AssignmentNode::compile`**
- [ ] **Escape check in `MemberAssignmentNode::compile`**
- [ ] **Escape check in `IndexAssignmentNode::compile`**
- [ ] **Update §2.2** — "the compiler does not currently insert escape checks" →
      "the compiler rejects direct escape; §6.4 names the unsound cases"
- [ ] **Update §6.4** — describe the syntactic check and its soundness gap

**Time estimate: 6–8 hours.**

---

## Phase 2 — Benchmark completion

### Experiment 1 (baseline vs region over iteration count)

- [x] **Config 3 (hoisted baseline)** — implemented in matmul_1024.vy
- [x] **ITERS=10 on all four configs** — measured:
      | config | peak | wall | checksum |
      |--------|-------|-------|----------|
      | 0 | 315.6 | 1.45s | 3.47777 |
      | 1 | 63.6 | 1.43s | 3.47777 |
      | 2 | 35.6 | 1.40s | 3.47777 |
      | 3 | 63.6 | 1.40s | 3.47777 |
- [ ] **ITERS=100 on all four configs** — confirm 1, 2, 3 stay flat and 0
      grows linearly (~3 GB expected). This is the memory-model claim at
      both ends of the range.
- [ ] **ITERS=1000 on config 0 only, or extrapolate** — 1000 may not fit;
      either measure or state "extrapolating from the measured 27 MB/iteration"

### Experiment 2 (boxed vs region vs scratch)

- [x] Done — configs 0, 1, 2, and 3
- [ ] **Note the wall-clock parity in §5.7** — fixed §5.7 draft ready, needs
      config-4 renumber and "three → four" corrections applied

### Experiment 3 (shape specialization)

- [ ] New benchmark: boxed `Array<Float64>` vs typed `VyneArray_f64` vs
      scratch, same operation (element-wise add or a small matmul)
- [ ] Measure runtime, instruction count if possible
- [ ] Write up as §5.8

### Experiment 4 (safety)

- [ ] `tests/safety/` directory, one `.vy` per case (10 files listed
      in prior draft)
- [ ] `run_safety.sh` — compiles each, asserts pass/fail with expected
      diagnostic
- [ ] Write up as §5.9

### Comparisons (NEW PRIORITY)

- [ ] **Hand-written C equivalent** — same hoisted baseline as config 3,
      hand-written, measured under the same peak-RSS sampler. This is now
      the single most useful addition: it turns "Vyne flat, baseline not"
      into "Vyne matches C's flat, C's flat is the reference." Without it,
      the memory-model claim is internal.
- [ ] **NumPy reference** — time and memory for a 100-iteration loop,
      with and without `out=`
- [ ] **Footnote in §5.7** — name the ISA/codegen gap; frame the comparison
      as memory, not speed

**Time estimate: 1 day of running + 3 hours of setup + writing.**

---

## Phase 2.5 — Corpus hygiene (NEW)

These surfaced during the Phase 0 fixes and are worth addressing before
the paper ships.

- [ ] **Update §5.6 with current classifier numbers.** The paper reports
      `execution ~38s` for the RNA classifier. Post-Phase-0 that number is
      ~100 ms. Cause: native-typing fast paths and typed-array inlining,
      not the region/scratch constructs. Re-run without `--native` for the
      portable figure, then update the section. The memory claim is
      unaffected; the discrepancy is a reviewer trap if left unaddressed.
- [ ] **Fix the seed position in ml_seq.vy** — currently produces different
      initial weights across runs, which means A/B comparisons are contaminated
      by RNG drift. Add `vmath.seed(42)` above `Generating sequences...`.
- [ ] **Correct §5.7 config count and numbering** — the draft says "three
      configs" and lists the table in an order that doesn't match the source
      file's `CONFIG` constants. Apply the corrected draft.
- [ ] **Re-verify the ~11 MB growth-path decomposition in §5.7** after the
      reclaim fix. If the fix landed between the 315.6 MB measurement and
      now, the number may not decompose the way the draft claims.

---

## Phase 3 — Paper updates

- [ ] **Abstract** — add the 8.7× / identical-checksum sentence
- [ ] **§3.3** — stack-limit bullet
- [ ] **§5.4** — SLP-vectorization mechanism, cite the disassembly
- [ ] **§5.6** — training-loop measurements (post-Phase-0 numbers)
- [ ] **§5.7** — apply corrected 4-config draft
- [ ] **§5.8** — shape specialization (after Exp 3)
- [ ] **§5.9** — safety (after Exp 4)
- [ ] **§6.6** — one sentence naming the scratch/storage-class conflation
- [ ] **§6.7–6.10** — four limitation sections (already drafted)
- [ ] **§7 Related Work** — paragraph contrasting scratch with `std::array`,
      `std::inplace_vector`, Rust `[T; N]`, Ada constrained arrays
- [ ] **§8 Availability** — benchmark path

**Time estimate: 1 week of writing.**

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

[unchanged from prior draft]

---

## The recommended order for this week

1. ~~Finish Phase 0~~ — done.
2. ~~Run hoisted baseline (config 3) at ITERS=10~~ — done.
3. **Run ITERS=100 on all four configs** (30 min). Confirm 1, 2, 3 stay flat.
4. **Apply the corrected §5.7 draft** and add the missing §5.6 numbers.
5. **Write the hand-written C comparison** (half day). This is the biggest
   remaining lever on the paper's strength.
6. **Then**, if time allows, start Phase 1.

Do not start Phase 1 until ITERS=100 is measured and §5.7 is corrected.
Do not start Phase 4 at all.

---

## The commit boundary

- Phase 0: `Fix parser, emitter, and runtime bugs; add native-target flag` ← READY
- Phase 2 (partial): `Add hoisted baseline; measure four-config matmul at ITERS=10`
- Phase 2 (complete): `Complete benchmark suite: 4 configs, 4 experiments, safety tests`
- Phase 3: `Paper updates for §5.6–§5.9, §6.6–§6.10, §7`
- Phase 4 (if done): `Shape-typed scratch: types, ABI, composability demo`

---

**The single most important item on this list is now the hand-written C
comparison.** Without it, every number in §5.7 compares Vyne against Vyne
and a reviewer can dismiss the result as "your baseline is just badly
written." A C program doing the same work with a per-iteration `malloc`
and `free`, measured under the same sampler, either matches Vyne's flat
RSS (which is a genuine result — "Vyne gives you C's memory discipline
without manual free") or doesn't (which is a stronger result — "the region
construct has no external equivalent at this code size"). Either answer
strengthens the paper. Run it before touching Phase 1.
