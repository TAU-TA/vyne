# vbio/bio.vy — facade.
#
# `use "vbio.vy"` from an application pulls in the full Part-1 surface.
# The linker resolves the order: Types, then Codon and Sequence.

use "Types.vy";
use "Codon.vy";
use "Sequence.vy";

module vbio;