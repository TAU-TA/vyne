# vrand/Primitives.vy — RNG access and shared helpers.
#
# Everything in vrand sits directly on top of vmath's PCG32. There is
# one global RNG stream. Seeding through vrand.seed() is seeding through
# vmath.seed(); the two are the same operation.

ruleset { dynamic_casting };

use native vmath;

module vrand;

# ---- seed ----
# Forward to vmath. Provided so callers do not have to import vmath
# just to seed the generator.

fn :: vrand seed(s :: Int64) {
    vmath.seed(s);
    return;
}

# ---- _u ----
# Draw a Float64 uniformly from [0, 1). This is the single primitive
# every distribution in this library is built on. Internal.

fn :: vrand _u() -> Float64 {
    return vmath.random_float(0.0, 1.0);
}

# ---- _u_avoid_zero ----
# Same as _u, but clamps to a value well above the underflow threshold
# so it can be safely passed to log() and pow(_, negative). Box-Muller
# and the Marsaglia-Tsang gamma both need this. Internal.
#
# The clamp of 1e-10 is chosen so that log(u) is at worst about -23
# and sqrt(-2 * log(u)) is at worst about 6.8 standard deviations.
# The probability of hitting the clamp is 1e-10 per call, so the
# resulting tail inflation is invisible in practice.

fn :: vrand _u_avoid_zero() -> Float64 {
    u :: Float64 = vmath.random_float(0.0, 1.0);
    if u < 0.0000000001 { u = 0.0000000001; }
    return u;
}

# ---- _rand_int ----
# Draw an Int64 uniformly from [lo, hi], inclusive on both ends.
# Delegates to vmath.random, which has the same semantics. Internal.

fn :: vrand _rand_int(lo :: Int64, hi :: Int64) -> Int64 {
    return int64(vmath.random(lo, hi));
}