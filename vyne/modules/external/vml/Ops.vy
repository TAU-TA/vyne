# vml/Ops.vy — forward / activation / optimizer steps.

use "Types.vy";

use lib "vlin/vlin.vy";

ruleset { dynamic_casting };

module vml;
module vmath;

fn :: vml apply_activation(m :: vlin.Types.Matrix, kind :: String) -> vlin.Types.Matrix {
    if kind == "tanh"    { return vlin.apply_tanh(m); }
    if kind == "sigmoid" { return vlin.apply_sigmoid(m); }
    if kind == "relu"    { return vlin.apply_relu(m); }
    if kind == "linear"  { return m; }
    return m;
}

fn :: vml apply_activation_prime(a :: vlin.Types.Matrix, kind :: String) -> vlin.Types.Matrix {
    if kind == "tanh"    { return vlin.tanh_prime(a); }
    if kind == "sigmoid" { return vlin.sigmoid_prime(a); }
    if kind == "relu"    { return vlin.relu_prime(a); }
    if kind == "linear"  { return vlin.ones(a.row, a.col); }
    return vlin.ones(a.row, a.col);
}

fn :: vml forward(model :: vml.Types.Sequential, x :: vlin.Types.Matrix) -> vlin.Types.Matrix {
    return model.forward(x);
}

# Forward through every layer, returning all intermediate activations
# as an Array. h[0] is the first layer's output, etc.
fn :: vml forward_all(model :: vml.Types.Sequential, x :: vlin.Types.Matrix) -> Array {
    # We seed the accumulator from a one-element literal on purpose:
    # the emitter's `Array = []` empty-literal fast path defaults the
    # element type to Float64, which then tries to coerce each pushed
    # Dense struct through `.as.i64` — silently producing garbage
    # doubles instead of boxed matrices. Starting with `[first]`
    # forces element-type inference to bail (Unknown), so the
    # accumulator stays boxed and every push stores the struct
    # intact.

    n :: Int64 = model.layers.size();
    if n == 0 { return []; }

    first = model.layers[0].forward(x);
    results = [first];
    current = first;

    through i :: 1..n-1 -> loop {
        layer = model.layers[i];
        current = layer.forward(current);
        results.push(current);
    };

    return results;
}

# W -= lr * grad, in place.
fn :: vml sgd_step(W :: vlin.Types.Matrix, grad :: vlin.Types.Matrix,
                   opt :: vml.Types.SGD) {
    vlin.sgd_update_inplace(W, grad, opt.lr);
    return W;
}