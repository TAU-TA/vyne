# vfft/Kernels.vy — the numerical hot loops.
#
# Everything else in vfft is bookkeeping. These functions dominate
# runtime and are written to run under the native (unboxed) ABI:
# `Array<Float64>` params become bare `double*` in the emitted C, and
# `Array<Int64>` becomes `int64_t*`.
#
# Native-to-native calls with array params are NOT supported by the
# current codegen (tryEmitNativeCall rejects RawArrayPtr args). So
# fft_kernel is a leaf — it calls nothing that takes an array.

ruleset { dynamic_casting };

use native vmath;

module vfft;

# 2^e for e >= 0.
fn :: vfft pow2(e :: Int64) -> Int64 {
    r :: Int64 = 1;
    through _ :: 0..e-1 -> loop { r = r * 2; };
    return r;
}

# log2(n) for n a power of two. Returns -1 otherwise, so callers can
# detect the error rather than silently producing garbage.
fn :: vfft log2_exact(n :: Int64) -> Int64 {
    if n <= 0 { return -1; }
    b :: Int64 = 0;
    r :: Int64 = 1;
    while r < n {
        r = r * 2;
        b = b + 1;
    }
    if r != n { return -1; }
    return b;
}

# Reverse the low k bits of i. Arithmetic, not bitwise — Vyne v1 has
# no >> or & operators, so bit b is extracted as (i / 2^b) % 2 and
# placed at position k-1-b by multiplying by 2^(k-1-b).
fn :: vfft bit_reverse(i :: Int64, k :: Int64) -> Int64 {
    result :: Int64 = 0;
    through b :: 0..k-1 -> loop {
        bit :: Int64 = (i / vfft.pow2(b)) % 2;
        result = result + bit * vfft.pow2(k - 1 - b);
    };
    return result;
}

# In-place radix-2 Cooley-Tukey DIT FFT. n must be a power of two;
# bits = log2(n). Modifies re and im.
fn :: vfft fft_kernel(re :: Array<Float64>, im :: Array<Float64>,
                      n :: Int64, bits :: Int64) -> Int64 {
    # Precompute twiddle factors: w[k] = exp(-2πi k / n), k in [0, n/2).
    half_n :: Int64 = n / 2;
    tw_re :: Array<Float64> = [];
    tw_im :: Array<Float64> = [];
    two_pi :: Float64 = 6.283185307179586;
    through k :: 0..half_n-1 -> loop {
        theta :: Float64 = 0.0 - two_pi * float64(k) / float64(n);
        tw_re.push(vmath.cos(theta));
        tw_im.push(vmath.sin(theta));
    };

    # Bit-reversal permutation: swap i and bitrev(i) exactly once,
    # guarded by i < j so each swap happens exactly once.
    through i :: 0..n-1 -> loop {
        j :: Int64 = vfft.bit_reverse(i, bits);
        if i < j {
            tr :: Float64 = re[i];
            re[i] = re[j];
            re[j] = tr;
            ti :: Float64 = im[i];
            im[i] = im[j];
            im[j] = ti;
        }
    };

    # Butterfly stages. Stage s has block size 2^s; half = 2^(s-1) is
    # the twiddle stride for that stage.
    length :: Int64 = 2;
    through stage :: 0..bits-1 -> loop {
        half :: Int64 = length / 2;
        step :: Int64 = n / length;
        n_blocks :: Int64 = n / length;

        base :: Int64 = 0;
        through blk :: 0..n_blocks-1 -> loop {
            through k :: 0..half-1 -> loop {
                ti_idx :: Int64 = k * step;
                wr :: Float64 = tw_re[ti_idx];
                wi :: Float64 = tw_im[ti_idx];

                i1 :: Int64 = base + k;
                i2 :: Int64 = i1 + half;

                ur :: Float64 = re[i1];
                ui :: Float64 = im[i1];
                vr :: Float64 = re[i2] * wr - im[i2] * wi;
                vi :: Float64 = re[i2] * wi + im[i2] * wr;

                re[i1] = ur + vr;
                im[i1] = ui + vi;
                re[i2] = ur - vr;
                im[i2] = ui - vi;
            };
            base = base + length;
        };

        length = length * 2;
    };

    return 0;
}