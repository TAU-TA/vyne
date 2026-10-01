use external "vml/vml.vy";
use external "vlin/vlin.vy";
use native vmath;

ruleset { dynamic_casting };

vmath.seed(42);

X :: vlin.Types.Matrix = vlin.random_uniform(8, 4, -0.5, 0.5);

L :: vml.Types.Dense = vml.dense(4, 3, "tanh");

a :: vlin.Types.Matrix = L.forward(X);
b :: vlin.Types.Matrix = vml.dense_forward_fused(L, X);

out("unfused[0,0]  = " + string(a.get(0, 0)));
out("fused[0,0]    = " + string(b.get(0, 0)));
out("unfused[7,2]  = " + string(a.get(7, 2)));
out("fused[7,2]    = " + string(b.get(7, 2)));

dmax :: Float64 = 0.0;
through i :: 0..7 -> loop {
    through j :: 0..2 -> loop {
        d :: Float64 = a.get(i, j) - b.get(i, j);
        if d < 0.0 { d = 0.0 - d; }
        if d > dmax { dmax = d; }
    };
};
out("max abs diff  = " + string(dmax));