# vml/Kernels.vy — the few ML-specific hot loops.
#
# Most numerics live in vlin/Kernels.vy. What belongs here is the
# handful of routputines that only make sense in a training context.

ruleset { dynamic_casting };

module vml;
module vmath;

# db[c] = sum over rows r of delta[r * cols + c].
# delta is row-major, shape [rows x cols].
fn :: vml k_bias_grad(output :: Array<Float64>, delta :: Array<Float64>,
                      rows :: Int64, cols :: Int64) -> Int64 {
    through c :: 0..cols-1 -> loop { output[c] = 0.0; };
    through r :: 0..rows-1 -> loop {
        through c :: 0..cols-1 -> loop {
            output[c] = output[c] + delta[r * cols + c];
        };
    };
    return 0;
}