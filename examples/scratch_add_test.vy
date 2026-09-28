module vmem;

region outer {
    scratch A :: Float64[64];
    scratch B :: Float64[64];
    scratch C :: Float64[64];

    through i :: 0..63 -> loop {
        A[i] = 1.0;
        B[i] = 2.0;
    };

    C = A + B;

    out("C[0] = " + string(C[0]));
};