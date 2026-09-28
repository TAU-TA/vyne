ruleset { dynamic_casting };
module vmath;
use lib "vlin/vlin.vy";

vmath.seed(42);

# Typed literal construction
a :: vlin.Types.Matrix = vlin.from_flat(2, 2, [1.0, 2.0, 3.0, 4.0]);
b :: vlin.Types.Matrix = vlin.from_flat(2, 2, [5.0, 6.0, 7.0, 8.0]);

c :: vlin.Types.Matrix = vlin.multiply(a, b);
# [[1,2],[3,4]] @ [[5,6],[7,8]] = [[19,22],[43,50]]
out("c[0,0] = " + string(c.get(0, 0)));   # 19.0
out("c[0,1] = " + string(c.get(0, 1)));   # 22.0
out("c[1,0] = " + string(c.get(1, 0)));   # 43.0
out("c[1,1] = " + string(c.get(1, 1)));   # 50.0

d :: vlin.Types.Matrix = vlin.add(a, b);
out("d.sum() = " + string(d.sum()));       # 36.0

e :: vlin.Types.Matrix = vlin.transpose(a);
out("e[0,1] = " + string(e.get(0, 1)));   # 3.0
out("e[1,0] = " + string(e.get(1, 0)));   # 2.0