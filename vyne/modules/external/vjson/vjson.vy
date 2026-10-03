# vjson.vy — facade. `use external "vjson/vjson.vy"` pulls the whole
# surface. Users do not normally import the leaf modules.

use "Types.vy";
use "Kernels.vy";
use "Parse.vy";
use "Serialize.vy";
use "Reductions.vy";

module vjson;

deploy vjson;