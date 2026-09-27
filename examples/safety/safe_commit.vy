# SAFETY: escape via region.commit is allowed.
# Expected: PASS.

fn test() {
    outer :: Array = [];
    region r {
        inner :: Array = [1.0, 2.0, 3.0];
        region.commit(inner);
        outer = inner;
    };
    out("safe_commit: len=" + string(outer.size()));
};

test();