# examples/libs/vfft_bench.vy — vfft workload for bench.ps1.
#
# The whole job of this program is to run the FFT a large number of
# times and print a deterministic checksum. bench.ps1 wraps it and
# reports wall time and peak RSS. No internal timing.

use external "vfft/vfft.vy";
use native vmath;

ruleset { dynamic_casting };

N     :: Int64 = 1024;
ITERS :: Int64 = 100000;

# Seed a fixed signal so the checksum is reproducible across runs.
vmath.seed(42);

re :: Array<Float64> = [];
im :: Array<Float64> = [];
through i :: 0..N-1 -> loop {
    re.push(vmath.random_float(-0.99, 0.99));
    im.push(0.0);
};

# Forward + inverse per iteration keeps magnitudes bounded — 10,000
# forward-only passes drive re[0] to +inf and then to NaN. Round-trip
# also exercises the inverse path, so the measured number covers both.
vfft.forward(re, im);
vfft.inverse(re, im);

through it :: 0..ITERS-1 -> loop {
    region step {
        vfft.forward(re, im);
        vfft.inverse(re, im);
    };
};

# A fixed bin index, printed at full precision. bench.ps1 compares
# this across runs to prove the loop actually executed.
out("checksum: " + string(re[0]));