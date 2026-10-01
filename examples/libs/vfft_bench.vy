# examples/libs/vfft_bench.vy — real FFT throughput measurement.
#
# Runs forward FFT of length N for a fixed iteration count, timed
# end-to-end. Reports time per transform and GFLOP/s using the standard
# 5·N·log2(N) convention (matches FFTW's own paper and benchmark
# harness).
#
# The warm-up pass exists so the first-call arena allocations and any
# page-fault costs are excluded from the measured loop.

use external "vfft/vfft.vy";
use native vmath;
use native vcore;

ruleset { dynamic_casting };

N     :: Int64 = 1024;
ITERS :: Int64 = 10000;
WARMUP :: Int64 = 100;

out("");
out("=== vfft benchmark ===");
out("  N      = " + string(N));
out("  iters  = " + string(ITERS));
out("");

# Build a fixed input signal once. Anything non-trivial works; the
# point is to have a non-degenerate spectrum so the kernel actually
# does the work.
re0 :: Array<Float64> = [];
im0 :: Array<Float64> = [];
vmath.seed(42);
through i :: 0..N-1 -> loop {
    re0.push(vmath.random_float(-1.0, 1.0));
    im0.push(0.0);
};

# ---- warm-up ----
re :: Array<Float64> = [];
im :: Array<Float64> = [];
through i :: 0..N-1 -> loop { re.push(re0[i]); im.push(im0[i]); };
through w :: 0..WARMUP-1 -> loop {
    vfft.forward(re, im);
    vfft.inverse(re, im);
};

# ---- measured loop ----
out("Running...");

re = [];
im = [];
through i :: 0..N-1 -> loop { re.push(re0[i]); im.push(im0[i]); };

start_ns :: Int64 = vcore.now_ns();

through it :: 0..ITERS-1 -> loop {
    vfft.forward(re, im);
};

end_ns :: Int64 = vcore.now_ns();
elapsed_ns :: Int64 = end_ns - start_ns;
elapsed_s :: Float64 = float64(elapsed_ns) / 1000000000.0;

# log2(N) for the flop count. N is a power of two; log2_exact is exact.
bits :: Int64 = vfft.log2_exact(N);
flops_per_fft :: Int64 = 5 * N * bits;
total_flops :: Float64 = float64(flops_per_fft) * float64(ITERS);
gflops :: Float64 = total_flops / (elapsed_s * 1000000000.0);

us_per_fft :: Float64 = (elapsed_s * 1000000.0) / float64(ITERS);

# A stable checksum for bench.ps1: the DC bin after ITERS of forward
# FFTs is (N * mean(x)) each time, so re[0] is deterministic. The
# exact value depends on the fixed seed.
out("");
out("  elapsed     " + string(elapsed_s) + " s");
out("  per FFT     " + string(us_per_fft) + " us");
out("  GFLOP/s     " + string(gflops));
out("");
out("checksum: " + string(re[0]));