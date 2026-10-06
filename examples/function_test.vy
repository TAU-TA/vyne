ruleset { dynamic_casting };

fn add<T>(a :: T, b :: T) -> T {
    return a + b;
}

out(add(1,2));
out(add(1.0, 2.0));
out(add("A" + "B"));