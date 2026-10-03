# examples/random/vrand_demo.vy — exercise every distribution and
# sampling utility in vrand.
#
# Every numeric section prints an empirical statistic next to its
# theoretical value and the relative deviation. With N = 10000 the
# deviations should stay within a few percent. Anything larger points
# at a bug in the sampler, not at sampling noise.

ruleset { dynamic_casting };

use external "vrand/vrand.vy";
use native vmath;

# =====================================================================
# CONFIG
# =====================================================================
vrand.seed(42);
N :: Int64 = 10000;

# =====================================================================
# HELPERS
# =====================================================================
# Defined at the top so the demo body reads without forward
# references. Vyne emits a forward declaration for every function in
# the file before any body, so ordering is cosmetic — this is purely
# for the reader.

fn _mean(xs :: Array<Float64>, n :: Int64) -> Float64 {
    if n <= 0 { return 0.0; }
    s :: Float64 = 0.0;
    through i :: 0..n-1 -> loop { s = s + xs[i]; };
    return s / float64(n);
}

# Two-pass standard deviation. The mean is computed inline rather than
# delegated to _mean, because a native variant cannot call a function
# with an array argument — its own array parameter arrives as a bare
# double* under the native ABI, and there is no length metadata to
# reconstruct a boxed container at the call site. Any function whose
# body calls another function with an array argument must either
# inline that call or opt out of native registration.

fn _stddev(xs :: Array<Float64>, n :: Int64) -> Float64 {
    if n <= 1 { return 0.0; }

    s :: Float64 = 0.0;
    through i :: 0..n-1 -> loop { s = s + xs[i]; };
    m :: Float64 = s / float64(n);

    ss :: Float64 = 0.0;
    through i :: 0..n-1 -> loop {
        d :: Float64 = xs[i] - m;
        ss = ss + d * d;
    };
    return vmath.sqrt(ss / float64(n));
}

# One-line comparison printer. Computes the relative deviation,
# strips its sign into a separate string, and pads the label with
# trailing spaces so all lines align regardless of label length.
fn _show(label :: String, empirical :: Float64, expected :: Float64) {
    pct :: Float64 = 0.0;
    if expected != 0.0 {
        pct = 100.0 * (empirical - expected) / expected;
    }
    sign :: String = "+";
    if pct < 0.0 { sign = "-"; pct = -pct; }
    out("    " + label
        + " = " + string(empirical)
        + "   expect " + string(expected)
        + "   " + sign + string(pct) + "%");
    return;
}

# =====================================================================
# CONTINUOUS DISTRIBUTIONS
# =====================================================================
out("=== vrand demo ===");
out("");
out("Continuous distributions");
out("");

# --- Normal(mu=5, sigma=2) ---
xs :: Array<Float64> = [];
through i :: 0..N-1 -> loop { xs.push(vrand.normal(5.0, 2.0)); };
out("  Normal(5.0, 2.0),  n=" + string(N));
_show("mean  ", _mean(xs, N),   5.0);
_show("stddev", _stddev(xs, N), 2.0);
out("");

# --- Exponential(rate=2) ---
ys :: Array<Float64> = [];
through i :: 0..N-1 -> loop { ys.push(vrand.exponential(2.0)); };
out("  Exponential(2.0),  n=" + string(N));
_show("mean  ", _mean(ys, N), 0.5);
out("");

# --- Gamma(shape=3, scale=1.5) ---
zs :: Array<Float64> = [];
through i :: 0..N-1 -> loop { zs.push(vrand.gamma(3.0, 1.5)); };
out("  Gamma(3.0, 1.5),   n=" + string(N));
_show("mean  ", _mean(zs, N), 4.5);
out("");

# --- Beta(alpha=2, beta=5) ---
bs :: Array<Float64> = [];
through i :: 0..N-1 -> loop { bs.push(vrand.beta(2.0, 5.0)); };
out("  Beta(2.0, 5.0),    n=" + string(N));
_show("mean  ", _mean(bs, N), 0.2857142857);
out("");

# =====================================================================
# DISCRETE DISTRIBUTIONS
# =====================================================================
out("Discrete distributions");
out("");

# --- Poisson(rate=3.5) ---
s_po :: Int64 = 0;
through i :: 0..N-1 -> loop { s_po = s_po + vrand.poisson(3.5); };
out("  Poisson(3.5),      n=" + string(N));
_show("mean  ", float64(s_po) / float64(N), 3.5);
out("");

# --- Binomial(n=20, p=0.3) ---
s_bi :: Int64 = 0;
through i :: 0..N-1 -> loop { s_bi = s_bi + vrand.binomial(20, 0.3); };
out("  Binomial(20, 0.3), n=" + string(N));
_show("mean  ", float64(s_bi) / float64(N), 6.0);
out("");

# --- Categorical([0.1, 0.2, 0.3, 0.4]) ---
probs :: Array<Float64> = [0.1, 0.2, 0.3, 0.4];
K :: Int64 = probs.size();

counts :: Array<Int64> = [0, 0, 0, 0];
through i :: 0..N-1 -> loop {
    k :: Int64 = vrand.categorical(probs, K);
    counts[k] = counts[k] + 1;
};

out("  Categorical([0.1, 0.2, 0.3, 0.4]), n=" + string(N));
through k :: 0..K-1 -> loop {
    _show("p[" + string(k) + "]", float64(counts[k]),
          probs[k] * float64(N));
};
out("");

# =====================================================================
# SAMPLING UTILITIES
# =====================================================================
out("Sampling utilities");
out("");

# --- shuffle (boxed Array, in place) ---
cards :: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
out("  before shuffle: " + string(cards));
vrand.shuffle(cards);
out("  after  shuffle: " + string(cards));
out("");

# --- reservoir (Algorithm R, O(n) time, O(k) space) ---
source :: Array = [];
through i :: 0..99 -> loop { source.push(i); };
sample :: Array = vrand.reservoir(source, 5);
out("  reservoir(0..99, k=5):");
out("    " + string(sample));
out("");

# --- sample_without_replacement (full Fisher-Yates on indices) ---
picked :: Array = vrand.sample_without_replacement(cards, 3);
out("  sample_without_replacement(10 cards, k=3):");
out("    " + string(picked));
out("");

# =====================================================================
# DETERMINISM
# =====================================================================
out("Determinism");
out("");

vrand.seed(1);
a1 :: Int64   = vrand.poisson(3);
a2 :: Float64 = vrand.normal(0.0, 1.0);

vrand.seed(1);
b1 :: Int64   = vrand.poisson(3);
b2 :: Float64 = vrand.normal(0.0, 1.0);

out("  first run:  poisson=" + string(a1) + "  normal=" + string(a2));
out("  second run: poisson=" + string(b1) + "  normal=" + string(b2));
out("  match:      " + string(a1 == b1 && a2 == b2));
out("");

out("Done.");