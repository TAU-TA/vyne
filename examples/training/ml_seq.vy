# ml_seq.vy — RNA sequence classifier.
#
# Task: distinguish codon-structured RNA from uniform-random RNA
# using 64-dimensional codon-usage vectors (3-mer composition).
#
# Structured sequences are built by reverse-translating random
# 10-residue proteins through vbio's codon table — so every 3-mer
# comes from a fixed 20-codon subset. Random sequences draw from
# all 64 codons uniformly. The classifier learns the subset.
#
# This is a scaled-down version of a real, decades-old technique:
# codon-usage / k-mer composition has been the workhorse feature
# for gene finding, species identification from metagenomes, and
# detecting horizontal gene transfer since the 1980s — and still
# shows up in modern pipelines as a cheap prior before deep models.
#
# Requires:
#   vbio/vbio.vy       (the bio facade)
#   vlin/vlin.vy       (the linear-algebra facade)
#   vcolors.vy

ruleset { dynamic_casting };

use lib "vbio/vbio.vy";
use lib "vlin/vlin.vy";
use lib "vcolors.vy";

module vmath;
module vmem;

# Deterministic RNG so all three configs of the §5.7 benchmark see
# bit-identical A, B, and initial weights, and checksums are comparable.
vmath.seed(42);

# ======================================================================
# CONFIG
# ======================================================================
N_PER_CLASS = 120;      # sequences per class
SEQ_LEN     = 30;       # nucleotides per sequence (10 codons)
EPOCHS      = 50;
LR          = 0.5;
HIDDEN1     = 16;
HIDDEN2     = 12;
PRINT_EVERY = 50;

N_SAMPLES = N_PER_CLASS * 2;

# ======================================================================
# 64-codon table in canonical order. RNA alphabet.
# ======================================================================
CODONS :: Array = [
    "AAA","AAC","AAG","AAU","ACA","ACC","ACG","ACU",
    "AGA","AGC","AGG","AGU","AUA","AUC","AUG","AUU",
    "CAA","CAC","CAG","CAU","CCA","CCC","CCG","CCU",
    "CGA","CGC","CGG","CGU","CUA","CUC","CUG","CUU",
    "GAA","GAC","GAG","GAU","GCA","GCC","GCG","GCU",
    "GGA","GGC","GGG","GGU","GUA","GUC","GUG","GUU",
    "UAA","UAC","UAG","UAU","UCA","UCC","UCG","UCU",
    "UGA","UGC","UGG","UGU","UUA","UUC","UUG","UUU"
];

AA_ALPHABET :: Array = ["A","R","N","D","C","Q","E","G","H","I",
                        "L","K","M","F","P","S","T","W","Y","V"];

# ======================================================================
# HELPERS
# ======================================================================
fn pad_left(s :: String, width :: Int64) -> String {
    n      = int64(s.size());
    result = "";
    through i :: 0..width-n-1 -> loop { result = result + " "; };
    return result + s;
}

fn pct(x :: Float64) -> String {
    scaled = int64(x * 1000.0);
    ip     = scaled / 10;
    fp     = scaled % 10;
    return string(ip) + "." + string(fp) + "%";
}

fn bar(fraction :: Float64, width :: Int64) -> String {
    filled = int64(fraction * float64(width));
    if filled < 0     { filled = 0; }
    if filled > width { filled = width; }
    s = "[";
    through i :: 0..width-1 -> loop {
        if i < filled { s = s + "#"; } else { s = s + "."; }
    };
    return s + "]";
}

# ======================================================================
# SEQUENCE GENERATION
# ======================================================================
fn trim(s :: String, n :: Int64) -> String {
    # Explicit char-by-char trim — avoids relying on slice
    # semantics that differ between interp and transpiler.
    output = "";
    through i :: 0..n-1 -> loop {
        output = output + s[i];
    };
    return output;
}

fn make_coding() -> String {
    # 10 random amino acids -> reverse_translate -> 33 nt RNA.
    # Trim to SEQ_LEN so both classes have identical length.
    prot = "";
    through i :: 0..9 -> loop {
        idx = vmath.random(0, 19);
        prot = prot + AA_ALPHABET[idx];
    };
    full = vbio.reverse_translate(prot);   # 33 nt (30 + UAA stop)
    return trim(full, SEQ_LEN);
}

fn make_random() -> String {
    bases :: Array = ["A","U","G","C"];
    s = "";
    through i :: 0..SEQ_LEN-1 -> loop {
        idx = vmath.random(0, 3);
        s = s + bases[idx];
    };
    return s;
}

# ======================================================================
# FEATURE EXTRACTION — 64-dim codon-usage vector
#
# Returns Array<Float64> rather than Array: the typed return lets the
# caller accumulate features into X_flat without unboxing each element,
# and lets vlin.from_flat see a native buffer when we build the matrix.
# ======================================================================
fn codon_features(seq :: String) -> Array<Float64> {
    counts   = vbio.codon_usage(seq);
    n_codons = seq.size() / 3;
    total    = float64(n_codons);
    if total < 1.0 { total = 1.0; }

    features :: Array<Float64> = [];
    through i :: 0..63 -> loop {
        c = CODONS[i];
        v = 0.0;
        if counts.has(c) {
            v = float64(counts[c]) / total;
        }
        features.push(v);
    };
    return features;
}

# ======================================================================
# NETWORK
# ======================================================================
fn forward(X_in, W1, b1, W2, b2, W3, b3) -> Array {
    A1 = vlin.apply_tanh   (vlin.add_bias(vlin.multiply(X_in, W1), b1));
    A2 = vlin.apply_tanh   (vlin.add_bias(vlin.multiply(A1,   W2), b2));
    A3 = vlin.apply_sigmoid(vlin.add_bias(vlin.multiply(A2,   W3), b3));
    return [A1, A2, A3];
}

fn accuracy(A3, Y, n :: Int64) -> Float64 {
    correct = 0;
    through i :: 0..n-1 -> loop {
        p  = A3.data[i];
        a  = Y.data[i];
        pi = 0;
        ai = 0;
        if p > 0.5 { pi = 1; }
        if a > 0.5 { ai = 1; }
        if pi == ai { correct = correct + 1; }
    };
    return float64(correct) / float64(n);
}

# ======================================================================
# HEADER
# ======================================================================
out("");
out(vcolors.bold("=== RNA Sequence Classifier ==="));
out("");
out("  task           codon-structured vs uniform-random");
out("  features       64-dim codon usage (3-mer composition)");
out("  architecture   64 -> " + string(HIDDEN1) + " -> " + string(HIDDEN2) + " -> 1");
out("  samples        " + string(N_SAMPLES) + " (" + string(N_PER_CLASS) + " per class)");
out("  seq length     " + string(SEQ_LEN) + " nt");
out("  learning rate  " + string(LR));
out("  epochs         " + string(EPOCHS));
out("");

# ======================================================================
# DATA
#
# X_flat and Y_data are Array<Float64>, not Array. The typed container
# means each push appends a double directly — no VyneValue boxing on
# the write side and no unboxing on the read side later.
#
# These allocations are permanent: they live in the arena for the whole
# program, and no region rewinds them. That's correct — they're the
# training set. Their size (N_SAMPLES * 64 + N_SAMPLES doubles) is
# fixed and small (~125 KB).
# ======================================================================
out("Generating sequences...");

X_flat :: Array<Float64> = [];
Y_data :: Array<Float64> = [];
seqs   :: Array = [];

# Class 1 — codon-structured RNA
through i :: 0..N_PER_CLASS-1 -> loop {
    s = make_coding();
    seqs.push(s);
    feats = codon_features(s);
    through j :: 0..63 -> loop {
        X_flat.push(feats[j]);
    };
    Y_data.push(1.0);
};

# Class 0 — uniform-random RNA
through i :: 0..N_PER_CLASS-1 -> loop {
    s = make_random();
    seqs.push(s);
    feats = codon_features(s);
    through j :: 0..63 -> loop {
        X_flat.push(feats[j]);
    };
    Y_data.push(0.0);
};

X :: vlin.Types.Matrix = vlin.Types.Matrix(N_SAMPLES, 64, X_flat);
Y :: vlin.Types.Matrix = vlin.Types.Matrix(N_SAMPLES, 1,  Y_data);

out("  class 1 (structured) " + string(N_PER_CLASS));
out("  class 0 (random)     " + string(N_PER_CLASS));
out("");

# ======================================================================
# WEIGHTS AND BIASES
#
# All of these are allocated before the training loop and never
# reassigned. `vlin.sgd_update_inplace` and the scalar bias loops
# below write through their `.data` buffers, so the matrices and
# arrays keep the same arena addresses across every region rewind.
#
# This is the load-bearing invariant of the memory strategy: a
# region rewind drops everything allocated inside the region, and
# nothing outside it — so anything that must survive an epoch has
# to be allocated here, at top level, and mutated in place.
#
# b1, b2, b3 are declared Array<Float64>, not Array. Same reasoning
# as X_flat: typed elements avoid a boxing round-trip on every
# element of every bias-update loop.
# ======================================================================
W1 = vlin.xavier_init(64,      HIDDEN1);
W2 = vlin.xavier_init(HIDDEN1, HIDDEN2);
W3 = vlin.xavier_init(HIDDEN2, 1);

b1 :: Array<Float64> = [];
through j :: 0..HIDDEN1-1 -> loop { b1.push(0.0); };

b2 :: Array<Float64> = [];
through j :: 0..HIDDEN2-1 -> loop { b2.push(0.0); };

b3 :: Array<Float64> = [0.0];

# ======================================================================
# TRAINING
#
# Memory strategy in one paragraph:
#
#   The training loop wraps its body in `region train_step { ... }`.
#   Every intermediate the forward pass and backprop allocate — the
#   activations A1/A2/A3, the deltas, every product of a transpose
#   and a matrix, every tanh_prime result — is allocated inside this
#   region and freed at the closing rewind. Peak arena usage is
#   therefore bounded by a single epoch's working set, not by the
#   full run's cumulative allocation.
#
#   The only things that must survive each rewind are W1, W2, W3,
#   b1, b2, b3, X, Y, and the loss/accuracy scalars. The first six
#   are allocated above, outside the region, and mutated in place.
#   The scalars are Float64 values, not references, so they cross
#   the rewind boundary by value.
#
#   The two scratch arrays `db1_buf` and `db2_buf` live on the C
#   stack — `scratch` lowers to a fixed-size local C array — so they
#   cost nothing in the arena. They only have to be in scope at the
#   point of use, which is why they're declared inside the region
#   even though they don't need region lifetime.
#
# There is deliberately no `region.commit` here. The alternative to
# the final forward pass below would be to commit A3 on the last
# epoch, but that couples the escape machinery to the loop bound
# (`if epoch == EPOCHS`) and breaks if EPOCHS is ever parameterized
# or the loop exits early. Doing one forward pass after the loop is
# cheaper to reason about and allocates a bounded, one-time amount.
# ======================================================================
scale = LR / float64(N_SAMPLES);

# Initial loss. h0 allocates ~9 matrices at top level; they persist
# until program end, which is fine — a single forward pass is small
# relative to the training loop's total allocation.
h0    = forward(X, W1, b1, W2, b2, W3, b3);
loss0 = vlin.cross_entropy(h0[2], Y);

out(vcolors.bold("Training:"));
out("  initial loss  " + string(loss0));
out("");

lossN = loss0;

through epoch :: 1..EPOCHS -> loop {
    region train_step {
        # Per-epoch scratch. C stack, not arena.
        scratch db2_buf :: Float64[12];
        scratch db1_buf :: Float64[16];

        # ---- forward ----
        h  = forward(X, W1, b1, W2, b2, W3, b3);
        A1 = h[0];
        A2 = h[1];
        A3 = h[2];

        # ---- backprop ----
        delta3 = vlin.subtract(A3, Y);
        dW3    = vlin.multiply(vlin.transpose(A2), delta3);

        db3 = 0.0;
        through r :: 0..N_SAMPLES-1 -> loop { db3 = db3 + delta3.data[r]; };

        delta2 = vlin.hadamard(
            vlin.multiply(delta3, vlin.transpose(W3)),
            vlin.tanh_prime(A2)
        );
        dW2 = vlin.multiply(vlin.transpose(A1), delta2);

        delta1 = vlin.hadamard(
            vlin.multiply(delta2, vlin.transpose(W2)),
            vlin.tanh_prime(A1)
        );
        dW1 = vlin.multiply(vlin.transpose(X), delta1);

        # ---- weight updates: in-place, weights live outside the region ----
        # A rebinding form (W1 = W1 - scale * dW1) would allocate a fresh
        # matrix inside the region; after the rewind that matrix is gone
        # and W1 would dangle. The in-place update writes into the
        # pre-existing .data buffer and survives.
        vlin.sgd_update_inplace(W1, dW1, scale);
        vlin.sgd_update_inplace(W2, dW2, scale);
        vlin.sgd_update_inplace(W3, dW3, scale);

        # ---- bias gradient accumulation ----
        through c :: 0..HIDDEN2-1 -> loop {
            db2_buf[c] = 0.0;
            through r :: 0..N_SAMPLES-1 -> loop {
                db2_buf[c] = db2_buf[c] + delta2.data[r * HIDDEN2 + c];
            };
        };

        through c :: 0..HIDDEN1-1 -> loop {
            db1_buf[c] = 0.0;
            through r :: 0..N_SAMPLES-1 -> loop {
                db1_buf[c] = db1_buf[c] + delta1.data[r * HIDDEN1 + c];
            };
        };

        # ---- bias updates: b1, b2, b3 live outside the region ----
        through c :: 0..HIDDEN1-1 -> loop { b1[c] = b1[c] - scale * db1_buf[c]; };
        through c :: 0..HIDDEN2-1 -> loop { b2[c] = b2[c] - scale * db2_buf[c]; };
        b3[0] = b3[0] - scale * db3;

        # ---- progress ----
        # Every string built here is allocated inside the region and
        # freed at rewind. lossN and acc are Float64, copied out by value.
        if epoch % PRINT_EVERY == 0 {
            lossN = vlin.cross_entropy(A3, Y);
            acc   = accuracy(A3, Y, N_SAMPLES);
            out("  " + pad_left(string(epoch), 5) + "/" + string(EPOCHS)
                + "  loss " + string(lossN)
                + "  acc  " + pct(acc)
                + "  " + bar(acc, 18));
        }
    };
};

# ======================================================================
# FINAL EVALUATION
#
# This is the payoff of dropping the commit: a single forward pass
# outside any region produces an A3 that is guaranteed to still be
# valid at the end of the program, with no coupling to EPOCHS and no
# dependence on which iteration of the loop happened to run last.
# ======================================================================
h_final  = forward(X, W1, b1, W2, b2, W3, b3);
A3_final = h_final[2];

final_acc = accuracy(A3_final, Y, N_SAMPLES);

out("");
out(vcolors.bold("Training complete."));
out("  initial loss   " + string(loss0));
out("  final loss     " + string(lossN));
out("  final accuracy " + pct(final_acc));
out("");

# ======================================================================
# SAMPLE PREDICTIONS
# ======================================================================
out(vcolors.bold("Sample predictions:"));
out("");

through i :: 0..5 -> loop {
    idx = i;
    s   = seqs[idx];
    p   = A3_final.data[idx];
    tag = "  random";
    if p > 0.5 { tag = "  struct"; }
    out(tag + "  " + s + "   p(struct) = " + string(p));
};

out("");

through i :: 0..5 -> loop {
    idx = N_PER_CLASS + i;
    s   = seqs[idx];
    p   = A3_final.data[idx];
    tag = "  random";
    if p > 0.5 { tag = "  struct"; }
    out(tag + "  idx=" + string(idx) + "  " + s + "   p(struct) = " + string(p));
};

out("");
out(vcolors.green("Done."));