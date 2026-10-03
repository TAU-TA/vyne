# vrand/Sampling.vy — sampling utilities that operate on collections.

ruleset { dynamic_casting };

use native vmath;

module vrand;

# ---- shuffle ----
# Fisher-Yates on a boxed Array, in place. Elements are any type.

fn :: vrand shuffle(arr :: Array) {
    n :: Int64 = arr.size();
    if n <= 1 { return; }
    through i :: 0..n-2 -> loop {
        j :: Int64 = _rand_int(i, n - 1);
        tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    };
    return;
}

# ---- shuffle_f64 ----
# Same algorithm over a typed Array<Float64>. Uses the native-ABI
# element path so the swaps are direct double loads.

fn :: vrand shuffle_f64(arr :: Array<Float64>) {
    n :: Int64 = arr.size();
    if n <= 1 { return; }
    through i :: 0..n-2 -> loop {
        j :: Int64 = _rand_int(i, n - 1);
        tmp :: Float64 = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    };
    return;
}

# ---- shuffle_i64 ----
fn :: vrand shuffle_i64(arr :: Array<Int64>) {
    n :: Int64 = arr.size();
    if n <= 1 { return; }
    through i :: 0..n-2 -> loop {
        j :: Int64 = _rand_int(i, n - 1);
        tmp :: Int64 = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    };
    return;
}

# ---- reservoir ----
# Uniform random sample of k elements from a stream of arbitrary
# length. Classic Algorithm R. O(n) time, O(k) space.

fn :: vrand reservoir(stream :: Array, k :: Int64) -> Array {
    n :: Int64 = stream.size();
    result :: Array<Float64> = [];
    if k <= 0 { return result; }
    if k >= n {
        through i :: 0..n-1 -> loop { result.push(stream[i]); };
        return result;
    }
    through i :: 0..k-1 -> loop { result.push(stream[i]); };
    through i :: k..n-1 -> loop {
        j :: Int64 = _rand_int(0, i);
        if j < k {
            result[j] = stream[i];
        }
    };
    return result;
}

# ---- sample_without_replacement ----
# Uniform random sample of k distinct indices from an array of length
# n. Implemented as a full Fisher-Yates on an index array, then taking
# the first k. O(n) regardless of k; for very small k against very
# large n use a partial shuffle.

fn :: vrand sample_without_replacement(arr :: Array, k :: Int64) -> Array {
    n :: Int64 = arr.size();
    result :: Array<Float64> = [];
    if k <= 0 { return result; }
    if k >= n {
        through i :: 0..n-1 -> loop { result.push(arr[i]); };
        return result;
    }

    idx :: Array<Int64> = [];
    through i :: 0..n-1 -> loop { idx.push(i); };

    through i :: 0..n-2 -> loop {
        j :: Int64 = _rand_int(i, n - 1);
        tmp = idx[i];
        idx[i] = idx[j];
        idx[j] = tmp;
    };

    through i :: 0..k-1 -> loop {
        result.push(arr[idx[i]]);
    };
    return result;
}