# vrand/Continuous.vy — continuous distributions.

ruleset { dynamic_casting };

use native vmath;

module vrand;

# ---- uniform ----
# Explicit-bounds uniform. Returns lo if hi <= lo.

fn :: vrand uniform(lo :: Float64, hi :: Float64) -> Float64 {
    if hi <= lo { return lo; }
    return lo + (hi - lo) * _u();
}

# ---- normal ----
# Box-Muller. Two uniforms produce two independent normals; this
# function discards the second and returns the first. Use normal_pair()
# if you want both. sigma is standard deviation, not variance.

fn :: vrand normal(mu :: Float64, sigma :: Float64) -> Float64 {
    u1 :: Float64 = _u_avoid_zero();
    u2 :: Float64 = _u();
    r :: Float64 = vmath.sqrt(-2.0 * vmath.log(u1));
    theta :: Float64 = 6.283185307179586 * u2;
    return mu + sigma * r * vmath.cos(theta);
}

# ---- normal_pair ----
# Same Box-Muller, but returns both samples. One log and one sqrt saved
# compared to two separate normal() calls.

fn :: vrand normal_pair(mu :: Float64, sigma :: Float64) -> Array<Float64> {
    u1 :: Float64 = _u_avoid_zero();
    u2 :: Float64 = _u();
    r :: Float64 = vmath.sqrt(-2.0 * vmath.log(u1));
    theta :: Float64 = 6.283185307179586 * u2;
    c :: Float64 = vmath.cos(theta);
    s :: Float64 = vmath.sin(theta);
    output :: Array<Float64> = [];
    output.push(mu + sigma * r * c);
    output.push(mu + sigma * r * s);
    return output;
}

# ---- exponential ----
# Rate parameterisation: mean = 1/rate, variance = 1/rate^2.

fn :: vrand exponential(rate :: Float64) -> Float64 {
    if rate <= 0.0 { return 0.0; }
    return -vmath.log(_u_avoid_zero()) / rate;
}

# ---- lognormal ----
# exp(N(mu, sigma^2)). The parameters are those of the underlying
# normal, not the mean and variance of the lognormal itself.

fn :: vrand lognormal(mu :: Float64, sigma :: Float64) -> Float64 {
    return vmath.exp(normal(mu, sigma));
}

# ---- gamma ----
# Marsaglia-Tsang. shape > 0, scale > 0. Mean = shape * scale.
#
# For shape < 1, the algorithm boosts the shape to shape + 1 and
# applies a U^(1/shape) correction on the way out. For shape >= 1 it
# uses the standard rejection loop with a normal envelope.

fn :: vrand gamma(shape :: Float64, scale :: Float64) -> Float64 {
    if shape <= 0.0 || scale <= 0.0 { return 0.0; }

    d :: Float64 = 0.0;
    c :: Float64 = 0.0;
    boost :: Float64 = 1.0;

    if shape < 1.0 {
        boost = vmath.pow(_u_avoid_zero(), 1.0 / shape);
        d = (shape + 1.0) - 0.3333333333333333;
    } else {
        d = shape - 0.3333333333333333;
    }
    c = 1.0 / vmath.sqrt(9.0 * d);

    result :: Float64 = 0.0;
    done :: Bool = false;
    while !done {
        x :: Float64 = normal(0.0, 1.0);
        v :: Float64 = 1.0 + c * x;
        if v > 0.0 {
            v = v * v * v;
            u :: Float64 = _u();
            x2 :: Float64 = x * x;
            if u < 1.0 - 0.0331 * x2 * x2 {
                result = d * v;
                done = true;
            } else if vmath.log(u) < 0.5 * x2 + d * (1.0 - v + vmath.log(v)) {
                result = d * v;
                done = true;
            }
        }
    }
    return scale * boost * result;
}

# ---- beta ----
# alpha > 0, beta_param > 0. Mean = alpha / (alpha + beta_param).
# Constructed as a ratio of two gammas, which is the standard trick
# and the only method that works for arbitrary alpha and beta.

fn :: vrand beta(alpha :: Float64, beta_param :: Float64) -> Float64 {
    x :: Float64 = gamma(alpha, 1.0);
    y :: Float64 = gamma(beta_param, 1.0);
    if x + y <= 0.0 { return 0.5; }
    return x / (x + y);
}