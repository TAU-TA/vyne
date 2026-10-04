ruleset { dynamic_casting };

module dumm_test;

fn :: dumm_test add(a, b) {
    return a + b;
}

fn :: dumm_test multiply(a, b) {
    return a * b;
}

deploy dumm_test;