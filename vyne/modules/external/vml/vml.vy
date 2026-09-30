# vml/vml.vy — facade. `use lib "vml/vml.vy"` pulls the full ML surface.
#
# vml is a thin layer on top of vlin. Importing vml transitively
# brings in vlin's Matrix type and all of its primitives.

use "Types.vy";
use "Kernels.vy";
use "Constructors.vy";
use "Ops.vy";
use "Reductions.vy";

use external "vlin/vlin.vy";

module vml;

deploy vml;