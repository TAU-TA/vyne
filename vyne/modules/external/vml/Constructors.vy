# vml/Constructors.vy — factories for ML objects.

use "Types.vy";

use lib "vlin/vlin.vy";

ruleset { dynamic_casting };

module vml;
module vmath;

fn :: vml dense(in_features :: Int64, out_features :: Int64,
                activation :: String) -> vml.Types.Dense {
    W :: vlin.Types.Matrix = vlin.xavier_init(in_features, out_features);
    b :: Array<Float64> = [];
    through i :: 0..out_features-1 -> loop { b.push(0.0); };
    return vml.Types.Dense(W, b, activation);
}

fn :: vml dense_scaled(in_features :: Int64, out_features :: Int64,
                       activation :: String, scale :: Float64) -> vml.Types.Dense {
    W :: vlin.Types.Matrix = vlin.multiply_scalar(
        vlin.xavier_init(in_features, out_features), scale);
    b :: Array<Float64> = [];
    through i :: 0..out_features-1 -> loop { b.push(0.0); };
    return vml.Types.Dense(W, b, activation);
}

fn :: vml sequential(layers :: Array) -> vml.Types.Sequential {
    return vml.Types.Sequential(layers);
}

fn :: vml sgd(lr :: Float64) -> vml.Types.SGD {
    return vml.Types.SGD(lr);
}