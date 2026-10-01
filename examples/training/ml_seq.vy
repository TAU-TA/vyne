# ml_seq.vy — RNA sequence classifier, vml edition.
#
# Imports only vml. vml imports vlin. If nested imports work, every
# vlin.* reference below resolves through vml's transitive import.

ruleset { dynamic_casting };

use external "vbio/vbio.vy";
use external "vml/vml.vy";
use external "vcolors.vy";

use native vmath;
use native vmem;

vmath.seed(42);

# ======================================================================
# CONFIG
# ======================================================================
N_PER_CLASS = 120;
SEQ_LEN     = 30;
EPOCHS      = 1000;
LR          = 0.5;
HIDDEN1     = 16;
HIDDEN2     = 12;
PRINT_EVERY = 50;

N_FEATURES = 64;                  # codon usage is 64-dimensional
N_SAMPLES  = N_PER_CLASS * 2;

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
# BIO HELPERS  (unchanged from before)
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

fn trim(s :: String, n :: Int64) -> String {
    output = "";
    through i :: 0..n-1 -> loop {
        output = output + s[i];
    };
    return output;
}

fn make_coding() -> String {
    prot = "";
    through i :: 0..9 -> loop {
        idx = vmath.random(0, 19);
        prot = prot + AA_ALPHABET[idx];
    };
    full = vbio.reverse_translate(prot);
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
# HEADER
# ======================================================================
out("");
out(vcolors.bold("=== RNA Sequence Classifier (vml) ==="));
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
# ======================================================================
out("Generating sequences...");

X_flat :: Array<Float64> = [];
Y_data :: Array<Float64> = [];
seqs   :: Array = [];

through i :: 0..N_PER_CLASS-1 -> loop {
    s = make_coding();
    seqs.push(s);
    feats = codon_features(s);
    through j :: 0..63 -> loop { X_flat.push(feats[j]); };
    Y_data.push(1.0);
};

through i :: 0..N_PER_CLASS-1 -> loop {
    s = make_random();
    seqs.push(s);
    feats = codon_features(s);
    through j :: 0..63 -> loop { X_flat.push(feats[j]); };
    Y_data.push(0.0);
};

# vlin.Types.Matrix is reachable only because vml transitively
# imports vlin. If this line compiles, nested imports work for types.
X :: vlin.Types.Matrix = vlin.Types.Matrix(N_SAMPLES, 64, X_flat);
Y :: vlin.Types.Matrix = vlin.Types.Matrix(N_SAMPLES, 1,  Y_data);

out("  class 1 (structured) " + string(N_PER_CLASS));
out("  class 0 (random)     " + string(N_PER_CLASS));
out("");

# ======================================================================
# MODEL — built via vml
# ======================================================================
L1 = vml.dense(64,      HIDDEN1, "tanh");
L2 = vml.dense(HIDDEN1, HIDDEN2, "tanh");
L3 = vml.dense(HIDDEN2, 1,       "sigmoid");

model = vml.sequential([L1, L2, L3]);
opt   = vml.sgd(LR);

scale = LR / float64(N_SAMPLES);

# Reach into the model for the layer handles we need in the manual
# backward pass. L1..L3 above hold the same references.
W1 = model.layers[0].W;
W2 = model.layers[1].W;
W3 = model.layers[2].W;
b1 = model.layers[0].b;
b2 = model.layers[1].b;
b3 = model.layers[2].b;

# ======================================================================
# TRAINING
# ======================================================================

# --- Optimizer config ---
BATCH      :: Int64 = 32;
N_BATCHES  :: Int64 = N_SAMPLES / BATCH;   # 240 / 32 = 7, with 16 left over.
                                           # If N_SAMPLES % BATCH != 0, the
                                           # last partial batch is dropped by
                                           # this integer division. Cleaner
                                           # than padding; adjust BATCH or
                                           # N_SAMPLES to make it divide evenly.

opt_adam :: vml.Types.Adam = vml.adam(0.001);

# Per-weight Adam state. Size matches each weight matrix.
state_W1 :: vml.Types.AdamState = vml.adam_state(HIDDEN1 * N_FEATURES);
state_W2 :: vml.Types.AdamState = vml.adam_state(HIDDEN2 * HIDDEN1);
state_W3 :: vml.Types.AdamState = vml.adam_state(1       * HIDDEN2);

# Shuffleable index list. Initialised to [0, 1, ..., N_SAMPLES-1].
indices :: Array = [];
through i :: 0..N_SAMPLES-1 -> loop { indices.push(i); };

# Reusable batch index buffer, refilled every batch.
batch_idx :: Array = [];
through i :: 0..BATCH-1 -> loop { batch_idx.push(0); };

# Full-batch forward for the initial loss printout. Unchanged.
h0    = vml.forward_all_fused(model, X);
loss0 = vml.cross_entropy(h0[2], Y);

out(vcolors.bold("Training:"));
out("  initial loss  " + string(loss0));
out("");

lossN :: Float64 = loss0;

# Global optimizer timestep. Incremented once per batch update,
# across all epochs. Adam's bias correction depends on it.
t :: Int64 = 0;

through epoch :: 1..EPOCHS -> loop {
    vml.shuffle_indices(indices, N_SAMPLES);

    epoch_loss :: Float64 = 0.0;
    epoch_acc  :: Float64 = 0.0;

    through b :: 0..N_BATCHES-1 -> loop {
        region train_step {
            scratch db2_buf :: Float64[12];
            scratch db1_buf :: Float64[16];

            # ---- gather batch rows ----
            through j :: 0..BATCH-1 -> loop {
                batch_idx[j] = indices[b * BATCH + j];
            };
            X_b :: vlin.Types.Matrix = vml.gather_rows(X, batch_idx, BATCH);
            Y_b :: vlin.Types.Matrix = vml.gather_rows(Y, batch_idx, BATCH);

            # ---- forward (vml) ----
            h  = vml.forward_all_fused(model, X_b);
            A1 = h[0];
            A2 = h[1];
            A3 = h[2];

            # ---- backprop (manual, reaches into layer weights) ----
            delta3 = vlin.subtract(A3, Y_b);
            dW3    = vlin.multiply(vlin.transpose(A2), delta3);

            db3 = 0.0;
            through r :: 0..BATCH-1 -> loop { db3 = db3 + delta3.data[r]; };

            delta2 = vlin.hadamard(
                vlin.multiply(delta3, vlin.transpose(W3)),
                vlin.tanh_prime(A2));
            dW2 = vlin.multiply(vlin.transpose(A1), delta2);

            delta1 = vlin.hadamard(
                vlin.multiply(delta2, vlin.transpose(W2)),
                vlin.tanh_prime(A1));
            dW1 = vlin.multiply(vlin.transpose(X_b), delta1);

            # ---- weight updates via Adam ----
            t = t + 1;
            vml.adam_step(W1, dW1, state_W1, opt_adam, t);
            vml.adam_step(W2, dW2, state_W2, opt_adam, t);
            vml.adam_step(W3, dW3, state_W3, opt_adam, t);

            # ---- bias gradients, over the batch ----
            through c :: 0..HIDDEN2-1 -> loop {
                db2_buf[c] = 0.0;
                through r :: 0..BATCH-1 -> loop {
                    db2_buf[c] = db2_buf[c] + delta2.data[r * HIDDEN2 + c];
                };
            };
            through c :: 0..HIDDEN1-1 -> loop {
                db1_buf[c] = 0.0;
                through r :: 0..BATCH-1 -> loop {
                    db1_buf[c] = db1_buf[c] + delta1.data[r * HIDDEN1 + c];
                };
            };

            # Biases get plain SGD with 1/BATCH scaling, not Adam.
            # Adam on biases works too, but the classic result is that
            # Adam's per-parameter scaling hurts on biases. Keep it
            # simple; switch to Adam on biases later if you want.
            bscale :: Float64 = opt_adam.lr / float64(BATCH);
            through c :: 0..HIDDEN1-1 -> loop { b1[c] = b1[c] - bscale * db1_buf[c]; };
            through c :: 0..HIDDEN2-1 -> loop { b2[c] = b2[c] - bscale * db2_buf[c]; };
            b3[0] = b3[0] - bscale * db3;

            # ---- accumulate epoch stats ----
            epoch_loss = epoch_loss + vml.cross_entropy(A3, Y_b);
            epoch_acc  = epoch_acc  + vml.accuracy(A3, Y_b, BATCH);
        };
    };

    if epoch % PRINT_EVERY == 0 {
        lossN = epoch_loss / float64(N_BATCHES);
        acc   = epoch_acc  / float64(N_BATCHES);
        out("  " + pad_left(string(epoch), 5) + "/" + string(EPOCHS)
            + "  loss " + string(lossN)
            + "  acc  " + pct(acc)
            + "  " + bar(acc, 18));
    }
};

# ======================================================================
# FINAL EVAL
# ======================================================================
h_final  = vml.forward_all_fused(model, X);
A3_final = h_final[2];

final_acc = vml.accuracy(A3_final, Y, N_SAMPLES);

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