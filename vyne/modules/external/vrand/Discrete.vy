# vrand/Discrete.vy — discrete distributions.

ruleset { dynamic_casting };

use native vmath;

module vrand;

# ---- bernoulli ----
# Returns true with probability p. p is clamped to [0, 1].

fn :: vrand bernoulli(p :: Float64) -> Bool {
    if p <= 0.0 { return false; }
    if p >= 1.0 { return true; }
    return _u() < p;
}

# ---- binomial ----
# Sum of n independent Bernoulli(p) trials. O(n) per call. For n
# larger than a few hundred, use the normal approximation directly:
# normal(n*p, sqrt(n*p*(1-p))).

fn :: vrand binomial(n :: Int64, p :: Float64) -> Int64 {
    if n <= 0 { return 0; }
    if p <= 0.0 { return 0; }
    if p >= 1.0 { return n; }
    count :: Int64 = 0;
    through i :: 0..n-1 -> loop {
        if bernoulli(p) { count = count + 1; }
    };
    return count;
}

# ---- geometric ----
# Number of trials until first success, inclusive. Support is 1, 2, 3,
# ...  Mean = 1/p.

fn :: vrand geometric(p :: Float64) -> Int64 {
    if p <= 0.0 { return 1; }
    if p >= 1.0 { return 1; }
    u :: Float64 = _u_avoid_zero();
    lq :: Float64 = vmath.log(1.0 - p);
    if lq >= 0.0 { return 1; }
    k :: Int64 = int64(vmath.log(u) / lq) + 1;
    if k < 1 { return 1; }
    return k;
}

# ---- poisson ----
# Knuth's algorithm for small rate; normal approximation with
# continuity correction for rate > 30. Mean = rate.

fn :: vrand poisson(rate :: Float64) -> Int64 {
    if rate <= 0.0 { return 0; }

    if rate > 30.0 {
        x :: Float64 = normal(rate, vmath.sqrt(rate));
        if x < 0.0 { return 0; }
        return int64(vmath.round(x));
    }

    L :: Float64 = vmath.exp(-rate);
    k :: Int64 = 0;
    p :: Float64 = 1.0;
    while p > L {
        k = k + 1;
        p = p * _u();
    }
    return k - 1;
}

# ---- categorical ----
# Given a vector of probabilities (not required to sum to 1 but should
# in practice) and its length n, returns the index of the sampled
# category. Linear scan; O(n) per call. Build an alias table if n is
# large and calls are hot.
#
# The explicit n parameter is required by the native ABI: array
# parameters arrive at the compiled function as bare double*, so
# anything the body needs to know about the array's length has to be
# passed separately. Same convention as vlin.k_add and vml.k_bias_grad.

fn :: vrand categorical(probs :: Array<Float64>, n :: Int64) -> Int64 {
    if n <= 0 { return 0; }
    u :: Float64 = _u();
    cum :: Float64 = 0.0;
    through i :: 0..n-1 -> loop {
        cum = cum + probs[i];
        if u < cum { return i; }
    };
    return n - 1;
}

# ---- discrete_uniform ----
# Uniform over the integers [lo, hi] inclusive. Thin wrapper over
# vmath.random; provided so vrand's surface is self-contained.

fn :: vrand discrete_uniform(lo :: Int64, hi :: Int64) -> Int64 {
    return _rand_int(lo, hi);
}