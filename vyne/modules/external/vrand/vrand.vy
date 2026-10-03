# vrand.vy — facade. `use external "vrand/vrand.vy"` pulls the whole
# surface. Do not reorder the `use` statements: Primitives.vy must be
# imported before the other files so that _u() and _u_avoid_zero() are
# in the module registry by the time Continuous.vy and Discrete.vy
# reference them.

use "Primitives.vy";
use "Continuous.vy";
use "Discrete.vy";
use "Sampling.vy";

module vrand;

deploy vrand;