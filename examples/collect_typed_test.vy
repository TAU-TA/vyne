# Collect with conditionals over a typed array. Before the fix, the
# boxed fallback guarded on V_ARRAY, so typed arrays produced an empty
# result silently.

ruleset { dynamic_casting };

xs :: Array<Float64> = [1.0, -2.0, 3.0, -4.0, 5.0];

clamped = through x :: xs -> collect {
    if x > 0.0 { x } else { 0.0 }
};

expected :: Array<Float64> = [1.0, 0.0, 3.0, 0.0, 5.0];
n = clamped.size();

if n != 5 {
    out("FAIL: expected 5 elements, got " + string(n));
    exit(1);
}

through i :: 0..4 -> loop {
    if clamped[i] != expected[i] {
        out("FAIL: clamped[" + string(i) + "] = " + string(clamped[i]) +
            ", expected " + string(expected[i]));
        exit(1);
    }
};

# Every over a typed array with a conditional body.
all_positive = through x :: xs -> every { x > -10.0 };
if !all_positive {
    out("FAIL: every() returned false");
    exit(1);
}

# Untyped array for comparison — this path already worked.
ys :: Array = [1, 2, 3];
doubled = through y :: ys -> collect {
    if y > 1 { y * 10 } else { y }
};

if doubled[0] != 1 || doubled[1] != 20 || doubled[2] != 30 {
    out("FAIL: untyped collect regressed");
    exit(1);
}

out("collect_typed_test: PASS");