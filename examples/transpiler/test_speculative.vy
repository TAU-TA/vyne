# tests/test_speculative.vy — positive coverage for the @speculative region policy.
#
# Compile:
#   vynec --compile tests/test_speculative.vy
#
# Expected output:
#   === @speculative region policy test suite ===
#
#     PASS  T1 commit on true
#     PASS  T2 rewind on false
#     PASS  T3 default rewind (no decision)
#     PASS  T4 last decision wins
#     PASS  T5 nested speculative
#
#   === positive suite complete ===

ruleset { dynamic_casting };

use native vmem;

out("=== @speculative region policy test suite ===");
out("");

# ---------------------------------------------------------------------
# T1 — commit_if(true) keeps the region's allocations alive.
#
# We can't directly observe the arena from Vyne, so we test the
# observable consequence: after a committed region, the arena's
# total_allocated does NOT go back to its pre-region value.
#
# Actually, we CAN observe it: vmem.total_allocated() returns the
# arena's live byte count. Grab it before/after and compare.
# ---------------------------------------------------------------------
before1 :: Int64 = vmem.total_allocated();

@speculative region t1 {
    a :: Array<Float64> = [1.0, 2.0, 3.0, 4.0, 5.0];
    b :: Array<Float64> = [6.0, 7.0, 8.0, 9.0, 10.0];
    region.commit_if(true);
};

after1 :: Int64 = vmem.total_allocated();

tag = "FAIL";
if after1 > before1 { tag = "PASS"; }
out("  " + tag + "  T1 commit on true");

# ---------------------------------------------------------------------
# T2 — commit_if(false) rolls back. After the region, the live byte
# count should be back to what it was before we entered.
# ---------------------------------------------------------------------
before2 :: Int64 = vmem.total_allocated();

@speculative region t2 {
    a :: Array<Float64> = [1.0, 2.0, 3.0, 4.0, 5.0];
    b :: Array<Float64> = [6.0, 7.0, 8.0, 9.0, 10.0];
    region.commit_if(false);
};

after2 :: Int64 = vmem.total_allocated();

tag2 = "FAIL";
if after2 == before2 { tag2 = "PASS"; }
out("  " + tag2 + "  T2 rewind on false");

# ---------------------------------------------------------------------
# T3 — no commit_if call means default rewind.
# ---------------------------------------------------------------------
before3 :: Int64 = vmem.total_allocated();

@speculative region t3 {
    a :: Array<Float64> = [1.0, 2.0, 3.0, 4.0, 5.0];
    b :: Array<Float64> = [6.0, 7.0, 8.0, 9.0, 10.0];
    # no commit_if here
};

after3 :: Int64 = vmem.total_allocated();

tag3 = "FAIL";
if after3 == before3 { tag3 = "PASS"; }
out("  " + tag3 + "  T3 default rewind (no decision)");

# ---------------------------------------------------------------------
# T4 — two commit_if calls, last one wins.
#
# The body commits then rolls back. Expected final state is "rewound",
# because the last decision was false.
# ---------------------------------------------------------------------
before4 :: Int64 = vmem.total_allocated();

@speculative region t4 {
    a :: Array<Float64> = [1.0, 2.0, 3.0, 4.0, 5.0];
    region.commit_if(true);
    b :: Array<Float64> = [6.0, 7.0, 8.0, 9.0, 10.0];
    region.commit_if(false);   # this wins
};

after4 :: Int64 = vmem.total_allocated();

tag4 = "FAIL";
if after4 == before4 { tag4 = "PASS"; }
out("  " + tag4 + "  T4 last decision wins");

# ---------------------------------------------------------------------
# T5 — nested @speculative regions.
#
# Inner rolls back, outer commits. The outer region's allocation should
# survive; the inner's should be gone. Net byte delta > 0.
# ---------------------------------------------------------------------
before5 :: Int64 = vmem.total_allocated();

@speculative region outer5 {
    a :: Array<Float64> = [1.0, 2.0, 3.0, 4.0, 5.0];

    @speculative region inner5 {
        b :: Array<Float64> = [6.0, 7.0, 8.0, 9.0, 10.0];
        region.commit_if(false);   # inner always rolls back
    };

    region.commit_if(true);        # outer commits
};

after5 :: Int64 = vmem.total_allocated();

tag5 = "FAIL";
if after5 > before5 { tag5 = "PASS"; }
out("  " + tag5 + "  T5 nested speculative");

out("=== Total allocated : " + string(vmem.total_allocated() // 1024) + " bytes ===");

out("");
out("=== positive suite complete ===");