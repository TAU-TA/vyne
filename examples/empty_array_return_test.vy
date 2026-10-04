ruleset { dynamic_casting };

fn empty_f64() -> Array<Float64> {
    return [];
}

fn empty_i64() -> Array<Int64> {
    return [];
}

fn reset_repeatedly() -> Int64 {
    xs :: Array<Float64> = [1.0, 2.0, 3.0];
    xs = [];
    xs.push(9.0);
    xs.push(10.0);
    return xs.size();
}

fn inferred_from_first() -> Array<Float64> {
    return [1.0, 2.0, 3.0];
}

fn inferred_from_mixed() -> Array<Float64> {
    return [1, 2.0, 3];
}

a = empty_f64();
b = empty_i64();
c = reset_repeatedly();
d = inferred_from_first();
e = inferred_from_mixed();

out("empty_f64 size: " + string(a.size()));
out("empty_i64 size: " + string(b.size()));
out("reset_repeatedly: " + string(c));
out("inferred_from_first size: " + string(d.size()));
out("inferred_from_mixed size: " + string(e.size()));