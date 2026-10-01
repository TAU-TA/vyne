# vfft/vfft.vy — facade. `use external "vfft/vfft.vy"` pulls the whole
# surface.

use "Kernels.vy";
use "Ops.vy";

ruleset { dynamic_casting };

module vfft;

deploy vfft;