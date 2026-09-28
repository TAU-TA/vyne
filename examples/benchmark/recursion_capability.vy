# benchmarks/recursion_capability.vy
#
# Capability demonstration: recursion.
#
# A buffer hoisted to file scope is shared across every dynamic
# instance of the function that uses it. Under recursion, the inner
# call's writes clobber the outer call's intermediate state, and the
# outer call resumes with stale data. This is not a performance
# issue: the hoisted program is simply wrong.
#
# A buffer declared inside a region gets a fresh instance per
# invocation, because the region's checkpoint bounds the buffer's
# lifetime to the region body. Three configurations:
#
#   0 = hoisted global buffer         (shared across calls -> wrong)
#   1 = boxed Array inside region     (fresh per call -> correct)
#   2 = scratch buffer inside region  (fresh per call -> correct,
#                                      and stack-allocated)
#
# Each recursive invocation writes its own value into the buffer,
# recurses, then reads the buffer back and checks whether it still
# sees its own value. Correct code sees DEPTH successes; hoisted
# code sees exactly one (the innermost call's write survives, every
# outer write is lost).

ruleset { dynamic_casting };
module vmem;

CONFIG :: Int64 = 2;
DEPTH  :: Int64 = 8;

# -------------------------------------------------------------------
# Config 0 - one buffer, shared by every dynamic instance.
# -------------------------------------------------------------------
hoisted :: Array = [0];

fn check_hoisted(n :: Int64) -> Int64 {
    hoisted[0] = n;
    child_ok = 0;
    if n > 1 {
        child_ok = check_hoisted(n - 1);
    }
    if hoisted[0] == n {
        return child_ok + 1;
    } else {
        return child_ok;
    }
}

# -------------------------------------------------------------------
# Config 1 - boxed Array declared inside the region.
# The region's rewind frees the previous invocation's array, so the
# arena is clean when the next call allocates its own.
# -------------------------------------------------------------------
fn check_boxed(n :: Int64) -> Int64 {
    region body {
        buf :: Array = [0];
        buf[0] = n;
        child_ok = 0;
        if n > 1 {
            child_ok = check_boxed(n - 1);
        }
        if buf[0] == n {
            return child_ok + 1;
        } else {
            return child_ok;
        }
    };
}

# -------------------------------------------------------------------
# Config 2 - scratch inside the region. Stack-allocated, so each
# invocation's buffer is distinct by construction.
# -------------------------------------------------------------------
fn check_scratch(n :: Int64) -> Int64 {
    region body {
        scratch buf :: Int64[1];
        buf[0] = n;
        child_ok = 0;
        if n > 1 {
            child_ok = check_scratch(n - 1);
        }
        if buf[0] == n {
            return child_ok + 1;
        } else {
            return child_ok;
        }
    };
}

# ===================================================================
out("");
out("=== Recursion: hoisted vs region-scoped buffer ===");
out("  CONFIG = " + string(CONFIG));
out("  DEPTH  = " + string(DEPTH));
out("  expected correct result = " + string(DEPTH));
out("");

if CONFIG == 0 {
    r = check_hoisted(DEPTH);
    out("  hoisted global buffer: " + string(r) + "/" + string(DEPTH));
    if r == DEPTH {
        out("  PASS (unexpected)");
    } else {
        out("  FAIL - " + string(DEPTH - r) + " levels saw a foreign value");
        out("  the innermost write survived; every outer write was lost");
    }
} else if CONFIG == 1 {
    r = check_boxed(DEPTH);
    out("  boxed Array inside region: " + string(r) + "/" + string(DEPTH));
    if r == DEPTH {
        out("  PASS - region rewind gives each call a fresh array");
    } else {
        out("  FAIL");
    }
} else {
    r = check_scratch(DEPTH);
    out("  scratch buffer inside region: " + string(r) + "/" + string(DEPTH));
    if r == DEPTH {
        out("  PASS - scratch is per-invocation by construction");
    } else {
        out("  FAIL");
    }
}

out("");