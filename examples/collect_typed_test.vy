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

# Pure-expression body over a typed array: must hit the native fast
# path in ForNode::getCExpr. Before the BlockNode::getStaticType()
# override, bodyType was Unknown and this fell through to the boxed
# path.
scaled = through x :: xs -> collect { x * 2.0 };

if scaled.size() != 5 {
    out("FAIL: scaled.size() = " + string(scaled.size()));
    exit(1);
}
if scaled[0] != 2.0 || scaled[1] != -4.0 || scaled[2] != 6.0
   || scaled[3] != -8.0 || scaled[4] != 10.0 {
    out("FAIL: scaled values wrong");
    exit(1);
}

# Pure-expression body over an Int64 array.
doubled_native = through y :: ys -> collect { y * 10 };
if doubled_native[0] != 10 || doubled_native[1] != 20 || doubled_native[2] != 30 {
    out("FAIL: doubled_native values wrong");
    exit(1);
}

out("collect_typed_test: PASS");