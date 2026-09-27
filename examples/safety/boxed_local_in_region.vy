# SAFETY: a boxed local declared inside a region and re-assigned
# inside the same region must not trigger VNE-070.
# Expected: PASS.

region r {
    acc = 0.0;
    through i :: 0..9 -> loop {
        acc = acc + float64(i);
    };
    out("boxed_local_in_region: acc=" + string(acc));
};