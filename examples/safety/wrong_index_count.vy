# SAFETY: rank mismatch on multi-index scratch access.
# Expected: compile error, VNE-071.

region r {
    scratch m :: Float64[4, 4];
    m[0, 0, 0] = 1.0;
};