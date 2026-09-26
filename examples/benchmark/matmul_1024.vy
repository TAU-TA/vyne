# benchmarks/matmul_1024.vy
#
# Three configurations, selected by CONFIG at the top of this file:
#   0 = baseline       matmul in a loop, boxed, no region
#   1 = region-only    same, but a region wraps each iteration
#   2 = region+scratch matmul written inline, output lives in scratch
#
# The compiled binary is otherwise identical across configs, so peak RSS
# is the only variable that changes.

ruleset { dynamic_casting };

module vmath;
module vmem;

use "vlinalg/vlinalg.vy";    # adjust path to your tree

CONFIG :: Int64 = 0;
N      :: Int64 = 1024;
ITERS  :: Int64 = 100;

# -----------------------------------------------------------------
# Setup. Build A and B on the arena before the timed region.
# -----------------------------------------------------------------
out("config=" + string(CONFIG) + " N=" + string(N) + " iters=" + string(ITERS));

A :: Array = [];
through i :: 0..N*N-1 -> loop {
    A.push(vmath.random_float(-1.0, 1.0));
};

B :: Array = [];
through i :: 0..N*N-1 -> loop {
    B.push(vmath.random_float(-1.0, 1.0));
};

Amat :: vlinalg.Types.Matrix = vlinalg.Types.Matrix(N, N, A);
Bmat :: vlinalg.Types.Matrix = vlinalg.Types.Matrix(N, N, B);

# -----------------------------------------------------------------
# CONFIG 0 — baseline.
# Every iteration allocates a fresh 8 MB output matrix on the
# arena. Nothing is reclaimed until arena_free_all() at exit.
# -----------------------------------------------------------------
if CONFIG == 0 {
    through iter :: 1..ITERS -> loop {
        C :: vlinalg.Types.Matrix = vlinalg.multiply(Amat, Bmat);
        if iter == ITERS {
            out("checksum: " + string(C.data[0]));
        }
    };
}

# -----------------------------------------------------------------
# CONFIG 1 — region-only.
# The checkpoint at the top of the region and the rewind at the
# bottom release each iteration's allocation before the next one
# starts. The matmul path is unchanged; only the lifetime is.
# -----------------------------------------------------------------
if CONFIG == 1 {
    through iter :: 1..ITERS -> loop {
        region matmul_iter {
            C :: vlinalg.Types.Matrix = vlinalg.multiply(Amat, Bmat);
            if iter == ITERS {
                out("checksum: " + string(C.data[0]));
            }
        };
    };
}

# -----------------------------------------------------------------
# CONFIG 2 — region + scratch.
# The output matrix is a raw double[1024*1024] on the C stack.
# The inner loops read A.data / B.data through the boxed
# VyneArray_f64 the interface field exposes, so the reads still
# cross a tag check; only the writes and the accumulator stay
# native. This is the honest version — no vlinalg change, just
# the language doing the work.
# -----------------------------------------------------------------
if CONFIG == 2 {
    ad :: Array<Float64> = Amat.data;
    bd :: Array<Float64> = Bmat.data;

    through iter :: 1..ITERS -> loop {
        region matmul_iter {
            scratch Cbuf :: Float64[1024, 1024];

            through r :: 0..N-1 -> loop {
                through c :: 0..N-1 -> loop {
                    acc :: Float64 = 0.0;
                    through k :: 0..N-1 -> loop {
                        acc = acc + ad[r * N + k] * bd[k * N + c];
                    };
                    Cbuf[r, c] = acc;
                };
            };

            if iter == ITERS {
                out("checksum: " + string(Cbuf[0, 0]));
            }
        };
    };
}