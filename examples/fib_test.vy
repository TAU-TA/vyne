ruleset { dynamic_casting };

fn fib(n :: Int64) -> Int64 {
    if (n < 2) {
        return n;
    }
    return fib(n - 1) + fib(n - 2);
}

out("Fibonacci(30) result:");
out(fib(30));