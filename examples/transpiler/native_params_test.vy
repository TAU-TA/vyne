ruleset { dynamic_casting };

# --- 1. Simplest possible: both params primitive, return primitive ---
fn add(a :: Int64, b :: Int64) -> Int64 {
    return a + b;
}

# --- 2. Float64 params, Float64 return ---
fn scale(x :: Float64, factor :: Float64) -> Float64 {
    return x * factor;
}

# --- 3. Bool return ---
fn is_positive(x :: Int64) -> Bool {
    return x > 0;
}

# --- 4. Recursive (exercises the dispatcher once Step D lands) ---
fn fib(n :: Int64) -> Int64 {
    if n <= 1 {
        return n;
    }
    return fib(n - 1) + fib(n - 2);
}

# --- 5. Mixed: one primitive, one boxed -> should NOT get a native variant ---
fn consume_boxed(v :: Array, n :: Int64) -> Int64 {
    return n;
}

# --- 6. Contains defer -> should NOT get a native variant ---
fn with_defer(n :: Int64) -> Int64 {
    defer { out("cleanup"); }
    return n * 2;
}

# --- Call sites: typed and untyped ---
out("=== native params ===");
out(add(3, 4));           # 7
out(scale(2.5, 4.0));     # 10
out(is_positive(5));      # true
out(fib(10));             # 55
out(consume_boxed([1,2], 5));   # 5
out(with_defer(7));       # cleanup\n14
out("done");