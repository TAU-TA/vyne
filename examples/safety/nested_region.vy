# SAFETY: nested regions with scratch arrays.
# Expected: PASS.

region outer_r {
    scratch a :: Float64[4];
    region inner_r {
        scratch b :: Float64[4];
        through i :: 0..3 -> loop { b[i] = float64(i); };
        through i :: 0..3 -> loop { a[i] = b[i] * 2.0; };
    };
    out("nested_region: a[3]=" + string(a[3]));
};