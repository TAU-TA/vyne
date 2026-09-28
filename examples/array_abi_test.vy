ruleset { dynamic_casting };
module vmath;

vmath.seed(42);

# What we want to reach the native ABI.
fn scale_add(a :: Array<Float64>, b :: Array<Float64>, n :: Int64) -> Float64 {
    s :: Float64 = 0.0;
    through i :: 0..n-1 -> loop {
        s = s + a[i] * b[i];
    };
    return s;
}

# Typed-array literals: the assignments create VyneArray_f64 locals,
# so the call site sees CType{Array, [Float64]} and can pass .data.
a :: Array<Float64> = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0];
b :: Array<Float64> = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5];

r :: Float64 = scale_add(a, b, 8);
out("dot: " + string(r));   # expect 18.0