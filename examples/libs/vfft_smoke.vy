# examples/vfft_smoke.vy — smoke test for the vfft library.
#
# Three analytic checks plus one round-trip. Every check prints its
# expected value next to the computed one so a numeric bug is
# immediately visible.
ruleset { dynamic_casting };

use external "vfft/vfft.vy";
use native vmath;

out("");
out("=== vfft smoke test ===");
out("");

# ---- Test 1: FFT of an impulse is all-ones ------------------------
out("Test 1: FFT([1,0,0,0,0,0,0,0])  →  expect all bins = 1 + 0i");
re1 :: Array<Float64> = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
im1 :: Array<Float64> = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
vfft.forward(re1, im1);
through i :: 0..7 -> loop {
    out("  bin[" + string(i) + "] = " + string(re1[i]) + " + " + string(im1[i]) + "i");
};
out("");

# ---- Test 2: FFT of a constant is a single spike ------------------
out("Test 2: FFT([1,1,1,1,1,1,1,1])  →  expect bin[0] = 8, rest 0");
re2 :: Array<Float64> = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];
im2 :: Array<Float64> = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
vfft.forward(re2, im2);
through i :: 0..7 -> loop {
    out("  bin[" + string(i) + "] = " + string(re2[i]) + " + " + string(im2[i]) + "i");
};
out("");

# ---- Test 3: forward + inverse = identity -------------------------
out("Test 3: forward + inverse recovers the original signal");
orig :: Array<Float64> = [1.5, -2.25, 3.75, 0.125, -1.0, 4.5, 2.0, -0.5];
re3 :: Array<Float64> = [];
im3 :: Array<Float64> = [];
through i :: 0..7 -> loop {
    re3.push(orig[i]);
    im3.push(0.0);
};

vfft.forward(re3, im3);
vfft.inverse(re3, im3);

err :: Float64 = 0.0;
through i :: 0..7 -> loop {
    d :: Float64 = re3[i] - orig[i];
    if d < 0.0 { d = 0.0 - d; }
    if d > err { err = d; }
    out("  x[" + string(i) + "] = " + string(re3[i]) + "  (orig " + string(orig[i]) + ")");
};
out("  max |err| = " + string(err));
out("");

# ---- Test 4: rfft shape -------------------------------------------
out("Test 4: rfft([1..8]) returns two half-spectrum arrays");
x4 :: Array<Float64> = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0];
pair = vfft.rfft(x4);
out("  rfft returned " + string(pair.size()) + " array(s)");
through i :: 0..pair.size()-1 -> loop {
    out("  part[" + string(i) + "].size() = " + string(pair[i].size()));
};
out("");
out("=== done ===");