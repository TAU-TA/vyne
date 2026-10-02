# vmem_peak_test.vy
#
# Verifies that vmem.peak_allocated() reports the true high-water mark
# of the arena, including allocations inside a region body that never
# calls vmem itself. That case is what distinguishes exact tracking
# (arena.h hooks) from sampled tracking (vmem boundary samples).

ruleset { dynamic_casting };

use native vmem;
use external "vlin/vlin.vy";

out("");
out("=== vmem peak tracking test ===");
out("");

# --- [1] baseline ------------------------------------------------
vmem.peak_reset();
out("[1] baseline after peak_reset");
out("    live = " + string(vmem.total_allocated()));
out("    peak = " + string(vmem.peak_allocated()));
out("");

# --- [2] outer allocation grows live and peak together -----------
warm = vlin.zeros(128, 128);
out("[2] after one 128x128 matrix at top level");
out("    live = " + string(vmem.total_allocated()));
out("    peak = " + string(vmem.peak_allocated()));
out("");

# --- [3] THE KEY TEST --------------------------------------------
# Reset peak, then allocate 2 MB inside a region with no vmem calls.
# Sampling-based tracking would report delta == 0 here.
vmem.peak_reset();
p_before = vmem.peak_allocated();

region hot_loop {
    a = vlin.zeros(256, 256);
    b = vlin.zeros(256, 256);
    c = vlin.zeros(256, 256);
    d = vlin.zeros(256, 256);
};

p_after = vmem.peak_allocated();
delta   = p_after - p_before;

out("[3] KEY TEST — peak inside region with no vmem calls");
out("    before = " + string(p_before));
out("    after  = " + string(p_after));
out("    delta  = " + string(delta));
out("    expect delta >= 2097152 (2 MB)");
out("    live after region closed = " + string(vmem.total_allocated()));
out("");

# --- [4] commit arena --------------------------------------------
vmem.peak_reset();
region make_committed {
    m = map();
    m.set("a", "one");
    m.set("b", "two");
    m.set("c", "three");
    region.commit(m);
};
out("[4] commit arena");
out("    commit_live = " + string(vmem.commit_total_allocated()));
out("    commit_peak = " + string(vmem.commit_peak_allocated()));
out("    expect commit_peak > 0");
out("");

# --- [5] diagnostics ---------------------------------------------
out("[5] diagnostics");
out("    depth                = " + string(vmem.checkpoint_depth()));
out("    capacity             = " + string(vmem.checkpoint_capacity()));
out("    remaining            = " + string(vmem.checkpoint_remaining()));
out("    is_balanced          = " + string(vmem.is_balanced()));
out("    block_count          = " + string(vmem.block_count()));
out("    head_used            = " + string(vmem.current_block_used()));
out("    head_capacity        = " + string(vmem.current_block_capacity()));
out("");

# --- [6] stats map -----------------------------------------------
m = vmem.stats();
out("[6] stats map");
out("    live             = " + string(m["live"]));
out("    peak             = " + string(m["peak"]));
out("    commit_live      = " + string(m["commit_live"]));
out("    commit_peak      = " + string(m["commit_peak"]));
out("    blocks           = " + string(m["blocks"]));
out("    checkpoint_depth = " + string(m["checkpoint_depth"]));
out("");

# --- [7] checkpoint stack ----------------------------------------
out("[7] manual checkpoint stack");
h1 = vmem.checkpoint();
h2 = vmem.checkpoint();
out("    depth after 2 checkpoints = " + string(vmem.checkpoint_depth()));
out("    verify h1 = " + string(vmem.verify_checkpoint(h1)));
out("    verify h2 = " + string(vmem.verify_checkpoint(h2)));

region nested {
    scratch tmp :: Float64[128];
    h3 = vmem.checkpoint();
    out("    inside region, depth = " + string(vmem.checkpoint_depth()));
    freed = vmem.rewind_freed(h3);
    out("    rewind_freed(h3) = " + string(freed) + " bytes");
};

out("    depth after rewind(h1) = " + string(vmem.checkpoint_depth()));
vmem.rewind(h1);
out("    is_balanced = " + string(vmem.is_balanced()));
out("");

# --- [8] dump to stderr ------------------------------------------
out("[8] full state dump (goes to stderr)");
vmem.dump();
out("");

vmem.assert_balanced();
out("all tests complete");