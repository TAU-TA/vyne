# tests/test_pool.vy — positive coverage for the @pool region policy.
#
# Compile:
#   vynec --compile tests/test_pool.vy
#
# Expected output:
#   === @pool region policy test suite ===
#
#     PASS  T1 float64 basic
#     PASS  T2 LIFO slot reuse
#     PASS  T3 int64 basic
#     PASS  T4 three live slots
#     PASS  T5a inner int64 pool
#     PASS  T5b outer survives inner rewind
#     PASS  T6 fn with pool
#     PASS  T7 alloc/free churn x20
#
#   === positive suite complete ===
#
# Negative cases (compile errors and runtime traps) are deliberately
# NOT in this file — they terminate compilation or the process. See the
# block comment at the bottom of this file for the four companion files
# that should live under tests/negative/.

ruleset { dynamic_casting };

out("=== @pool region policy test suite ===");
out("");

# ---------------------------------------------------------------------
# T1 — Float64 basic alloc/write/read/free
# ---------------------------------------------------------------------
@pool<Float64, 4> region t1 {
    buf = pool_alloc();
    buf[0] = 1.5;
    buf[1] = 2.5;
    buf[2] = 3.5;
    total = buf[0] + buf[1] + buf[2];
    tag = "FAIL";
    if total == 7.5 { tag = "PASS"; }
    out("  " + tag + "  T1 float64 basic");
    pool_free(buf);
};

# ---------------------------------------------------------------------
# T2 — LIFO slot reuse
#
# Write a marker, free, re-allocate. The next allocation must reuse the
# same slot index, so the marker is still visible. If the free list is
# not LIFO, buf2[0] is uninitialized garbage and the test fails.
# ---------------------------------------------------------------------
@pool<Float64, 2> region t2 {
    buf1 = pool_alloc();
    buf1[0] = 42.0;
    pool_free(buf1);
    buf2 = pool_alloc();
    tag = "FAIL";
    if buf2[0] == 42.0 { tag = "PASS"; }
    out("  " + tag + "  T2 LIFO slot reuse");
    pool_free(buf2);
};

# ---------------------------------------------------------------------
# T3 — Int64 pool
# ---------------------------------------------------------------------
@pool<Int64, 8> region t3 {
    buf = pool_alloc();
    buf[0] = 100;
    buf[1] = 200;
    buf[2] = 300;
    total = buf[0] + buf[1] + buf[2];
    tag = "FAIL";
    if total == 600 { tag = "PASS"; }
    out("  " + tag + "  T3 int64 basic");
    pool_free(buf);
};

# ---------------------------------------------------------------------
# T4 — Three simultaneous live slots
#
# Distinct writes to three concurrent allocations must land in distinct
# storage. Aliasing or a miscalculated stride would make the sum wrong.
# ---------------------------------------------------------------------
@pool<Float64, 4> region t4 {
    a = pool_alloc();
    b = pool_alloc();
    c = pool_alloc();
    a[0] = 1.0;
    b[0] = 2.0;
    c[0] = 3.0;
    total = a[0] + b[0] + c[0];
    tag = "FAIL";
    if total == 6.0 { tag = "PASS"; }
    out("  " + tag + "  T4 three live slots");
    pool_free(c);
    pool_free(b);
    pool_free(a);
};

# ---------------------------------------------------------------------
# T5 — Nested @pool regions
#
# The inner region allocates from its own pool. Any pool_alloc inside
# the inner body binds to the inner pool; any pool_alloc in the outer
# body (before or after the inner region) binds to the outer pool.
# Different element types (Float64 outer, Int64 inner) make a mix-up
# visible as either a type error or a garbage value.
#
# The outer allocation must survive the inner region's rewind — the
# inner checkpoint is taken after the outer pool's backing store is
# allocated, so the inner rewind reclaims only the inner pool.
# ---------------------------------------------------------------------
@pool<Float64, 2> region outer {
    a = pool_alloc();
    a[0] = 1.0;

    @pool<Int64, 8> region inner {
        b = pool_alloc();
        b[0] = 1000;
        b[1] = 2000;
        tag = "FAIL";
        if b[0] + b[1] == 3000 { tag = "PASS"; }
        out("  " + tag + "  T5a inner int64 pool");
        pool_free(b);
    };

    tag2 = "FAIL";
    if a[0] == 1.0 { tag2 = "PASS"; }
    out("  " + tag2 + "  T5b outer survives inner rewind");
    pool_free(a);
};

# ---------------------------------------------------------------------
# T6 — Pool inside a function
#
# The outer Float64 `result` lives on the function's stack. The region
# body reassigns it from a pool-buffer read (a primitive copy), then
# the region closes and rewinds. `result` survives because it was
# copied by value, not by reference.
#
# The return sits OUTSIDE the region body on purpose: a return from
# inside a pool region in a native-return-type function is a known
# leak (checkpoint popped without rewind). See the header note.
# ---------------------------------------------------------------------
fn compute_with_pool(x :: Float64) -> Float64 {
    result :: Float64 = 0.0;
    @pool<Float64, 4> region work {
        tmp = pool_alloc();
        tmp[0] = x;
        tmp[1] = x * x;
        result = tmp[0] + tmp[1];
        pool_free(tmp);
    };
    return result;
}

r = compute_with_pool(3.0);
tag = "FAIL";
if r == 12.0 { tag = "PASS"; }
out("  " + tag + "  T6 fn with pool");

# ---------------------------------------------------------------------
# T7 — Alloc/free churn
#
# Same slot reused 20 times in a row. If the free list leaked a slot
# or drifted off the top of its stack, the pool (capacity 8) would
# run dry before 20 iterations complete and the process would abort
# with VNE-082. Reaching the end proves the cursor is stable.
# ---------------------------------------------------------------------
@pool<Float64, 2> region t7 {
    count :: Int64 = 0;
    through i :: 1..20 -> loop {
        buf = pool_alloc();
        buf[0] = 1.0;
        count = count + 1;
        pool_free(buf);
    };
    tag = "FAIL";
    if count == 20 { tag = "PASS"; }
    out("  " + tag + "  T7 alloc/free churn x20");
};

out("");
out("=== positive suite complete ===");