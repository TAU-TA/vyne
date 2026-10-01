# vfft/Ops.vy — the user-facing transforms.
#
# Every function takes and returns boxed `Array` values so callers can
# pass native Array<Float64> locals, bare `[]` literals, or arrays
# pulled out of a struct, all interchangeably. Each op unboxes to
# native locals at entry, runs the numeric work under the native ABI,
# and reboxes at the return boundary.

ruleset { dynamic_casting };

use "Kernels.vy";
use native vmath;

module vfft;

# Smallest power of two >= n. n = 0 or 1 return 1.
fn :: vfft next_pow2(n :: Int64) -> Int64 {
    if n <= 1 { return 1; }
    r :: Int64 = 1;
    while r < n { r = r * 2; }
    return r;
}

# Forward complex FFT, in place. Modifies re and im.
# re.size() and im.size() must both equal n, a power of two.
fn :: vfft forward(re :: Array, im :: Array) -> Int64 {
    n :: Int64 = re.size();
    if n <= 1 { return 0; }

    bits :: Int64 = vfft.log2_exact(n);
    if bits < 0 {
        out("vfft.forward: length must be a power of two, got " + string(n));
        exit(1);
    }

    # Unbox into native locals. Two O(N) passes, once each.
    re_n :: Array<Float64> = [];
    im_n :: Array<Float64> = [];
    through i :: 0..n-1 -> loop {
        re_n.push(re[i]);
        im_n.push(im[i]);
    };

    vfft.fft_kernel(re_n, im_n, n, bits);

    # Box back. Writes through the shared data pointer, so the
    # caller's arrays see the update in place.
    through i :: 0..n-1 -> loop {
        re[i] = re_n[i];
        im[i] = im_n[i];
    };
    return 0;
}

# Inverse complex FFT, in place. Conjugates input, runs forward,
# conjugates output, scales by 1/n.
fn :: vfft inverse(re :: Array, im :: Array) -> Int64 {
    n :: Int64 = re.size();
    if n <= 1 { return 0; }

    bits :: Int64 = vfft.log2_exact(n);
    if bits < 0 {
        out("vfft.inverse: length must be a power of two, got " + string(n));
        exit(1);
    }

    re_n :: Array<Float64> = [];
    im_n :: Array<Float64> = [];
    through i :: 0..n-1 -> loop {
        re_n.push(re[i]);
        im_n.push(0.0 - im[i]);   # conjugate input
    };

    vfft.fft_kernel(re_n, im_n, n, bits);

    inv_n :: Float64 = 1.0 / float64(n);
    through i :: 0..n-1 -> loop {
        re[i] = re_n[i] * inv_n;
        im[i] = (0.0 - im_n[i]) * inv_n;   # conjugate + scale
    };
    return 0;
}

# Real-input FFT. x has length n (power of two). Returns [re_half, im_half]:
# the first n/2 + 1 bins. Bins n/2+1 .. n-1 are the Hermitian mirror
# of bins 1 .. n/2-1 and are not materialized.
fn :: vfft rfft(x :: Array) -> Array {
    n :: Int64 = x.size();
    re :: Array<Float64> = [];
    im :: Array<Float64> = [];
    through i :: 0..n-1 -> loop {
        re.push(x[i]);
        im.push(0.0);
    };

    vfft.forward(re, im);

    half :: Int64 = n / 2 + 1;
    out_re :: Array<Float64> = [];
    out_im :: Array<Float64> = [];
    through i :: 0..half-1 -> loop {
        out_re.push(re[i]);
        out_im.push(im[i]);
    };

    return [out_re, out_im];
}

# Inverse of rfft. re_in, im_in are the half-spectrum (length n/2+1);
# n is the original real length. Returns the real signal (length n).
fn :: vfft irfft(re_in :: Array, im_in :: Array, n :: Int64) -> Array<Float64> {
    re_full :: Array<Float64> = [];
    im_full :: Array<Float64> = [];
    through i :: 0..n-1 -> loop {
        re_full.push(0.0);
        im_full.push(0.0);
    };

    half :: Int64 = n / 2 + 1;
    through i :: 0..half-1 -> loop {
        re_full[i] = re_in[i];
        im_full[i] = im_in[i];
    };

    # Hermitian symmetry: X[n-k] = conj(X[k]).
    through i :: 1..(n/2)-1 -> loop {
        re_full[n - i] =  re_in[i];
        im_full[n - i] = 0.0 - im_in[i];
    };

    vfft.inverse(re_full, im_full);

    output :: Array<Float64> = [];
    through i :: 0..n-1 -> loop { output.push(re_full[i]); };
    return output;
}