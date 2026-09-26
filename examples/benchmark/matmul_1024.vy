# benchmarks/matmul_1024.vy — no imports, scratch-only
#
# Three configurations:
#   0 = baseline       boxed Array output, per-iteration arena alloc
#   1 = region-only    same output, wrapped in a region
#   2 = region+scratch output on the C stack
#
# A and B are scratch in all three configs, so the matmul kernel is
# byte-identical across them. The only variable is where C lives.
#
# Kernel notes:
#   - B is transposed once into B_T so both inner-loop loads are
#     contiguous in k (row-major).
#   - The accumulation is split across four independent chains.
#     No reassociation: each chain's adds happen in the same order
#     they would in a serial kernel. Only the final combine changes
#     order, and that's outside the hot loop.
#   - No -ffast-math. -O3 only.

ruleset { dynamic_casting };
module vmath;
module vmem;

vmath.seed(42);

CONFIG :: Int64 = 2;
N      :: Int64 = 1024;
ITERS  :: Int64 = 100;

out("config=" + string(CONFIG) + " N=" + string(N) + " iters=" + string(ITERS));

region outer {
    scratch A   :: Float64[1024, 1024];
    scratch B   :: Float64[1024, 1024];
    scratch B_T :: Float64[1024, 1024];

    through r :: 0..N-1 -> loop {
        through c :: 0..N-1 -> loop {
            A[r, c] = vmath.random_float(-1.0, 1.0);
            B[r, c] = vmath.random_float(-1.0, 1.0);
        };
    };

    # Transpose B once. B_T[c, k] == B[k, c], contiguous in k.
    through r :: 0..N-1 -> loop {
        through c :: 0..N-1 -> loop {
            B_T[c, r] = B[r, c];
        };
    };

    if CONFIG == 0 {
        through iter :: 1..ITERS -> loop {
            C :: Array = [];
            through r :: 0..N-1 -> loop {
                through c :: 0..N-1 -> loop {
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
                    C.push((acc0 + acc1) + (acc2 + acc3));
                };
            };
            if iter == ITERS { out("checksum: " + string(C[0])); }
        };
    }

    if CONFIG == 1 {
        through iter :: 1..ITERS -> loop {
            region inner {
                C :: Array = [];
                through r :: 0..N-1 -> loop {
                    through c :: 0..N-1 -> loop {
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
                        C.push((acc0 + acc1) + (acc2 + acc3));
                    };
                };
                if iter == ITERS { out("checksum: " + string(C[0])); }
            };
        };
    }

    if CONFIG == 2 {
        through iter :: 1..ITERS -> loop {
            region inner {
                scratch C :: Float64[1024, 1024];
                through r :: 0..N-1 -> loop {
                    through c :: 0..N-1 -> loop {
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
                    };
                };
                if iter == ITERS { out("checksum: " + string(C[0, 0])); }
            };
        };
    }
};