# test_molecule.vyne
#
# Exercises the four fixes landed this session against the vchem-shaped
# Molecule/Atom pair. Each section is independent — if a later section
# fails, the earlier ones still give you signal.
#
# Compile:  <your build command> test_molecule.vyne
# Expect:   stdout matches the "# -> " annotations below, exit code 0.


# ---------------------------------------------------------------------
# Interfaces: Atom is a leaf native struct (all primitive fields).
# Molecule has an Array<Atom>, a String, and a Map — the exact shape
# Slice 3g's fixed-point pass has to mark C-eligible, and the exact
# shape Fix 2's unboxToNative loop has to handle.
# ---------------------------------------------------------------------

interface Atom {
    x        :: Float64,
    y        :: Float64,
    z        :: Float64,
    element  :: Int64,
    aromatic :: Bool,
}

interface Molecule {
    atoms :: Array<Atom>,
    name  :: String,
    props :: Map,
}


# ---------------------------------------------------------------------
# Section 1 — FIX 1 regression: field read on a native-struct variable.
# Pre-fix this hit the dead duplicate block; post-fix it hits only the
# 3c-extension block. Either way the values must be correct.
# ---------------------------------------------------------------------

mol :: Molecule = Molecule(
    [Atom(1.0, 0.0, 0.0, 6, false), Atom(0.0, 1.0, 0.0, 1, false)],
    "methane",
    {"formula": "CH4"}
);

out(mol.name);                    # -> methane
out(mol.atoms[0].element);        # -> 6
out(mol.atoms[1].x);              # -> 0


# ---------------------------------------------------------------------
# Section 2 — FIX 3a: write through an index receiver.
# `mol.atoms[0].x = 99.0` has an INDEX_ACCESS receiver, not a VARIABLE.
# Pre-fix this silently no-op'd (wrote to a boxed throwaway copy).
# Post-fix it must land on the real element.
# ---------------------------------------------------------------------

mol.atoms[0].x = 99.0;
out(mol.atoms[0].x);              # -> 99

mol.atoms[1].element = 8;
out(mol.atoms[1].element);        # -> 8


# ---------------------------------------------------------------------
# Section 3 — FIX 3b: write through a chained field receiver.
# Requires a nested struct. Build a tiny Inner/Outer pair rather than
# extending Atom, so a failure here is unambiguously the chained-receiver
# path and not Section 2's index path.
# ---------------------------------------------------------------------

interface Inner { n :: Int64, }
interface Outer { inner :: Inner, }

o :: Outer = Outer(Inner(5));
out(o.inner.n);                   # -> 5

o.inner.n = 42;
out(o.inner.n);                   # -> 42


# ---------------------------------------------------------------------
# Section 4 — FIX 3c: evaluation order and single-evaluation.
# `next()` must be called exactly once. If the receiver is evaluated
# twice, counter ends at 2 instead of 1 — that's the double-eval bug,
# not the intended source-order change.
# ---------------------------------------------------------------------

counter :: Int64 = 0;

fn next() -> Int64 {
    counter = counter + 1;
    return counter;
}

probe :: Array<Atom> = [Atom(0.0, 0.0, 0.0, 0, false),
                        Atom(0.0, 0.0, 0.0, 0, false)];

probe[next()].x = 7.0;            # next() returns 1 -> probe[1].x = 7
out(counter);                     # -> 1   (NOT 2)
out(probe[0].x);                  # -> 0
out(probe[1].x);                  # -> 7


# ---------------------------------------------------------------------
# Section 5 — FIX 4: empty-array literal on a struct-element field.
# Only meaningful if the parser sets arrayElemType = Struct for the
# annotation. If it doesn't, both before and after compile identically
# and this section is a no-op — that's fine, note it in the commit.
# ---------------------------------------------------------------------

empty_atoms :: Array<Atom> = [];
out(empty_atoms.size());          # -> 0

blank :: Molecule = Molecule(
    [],
    "empty",
    {}
);
out(blank.atoms.size());          # -> 0
out(blank.name);                  # -> empty


# ---------------------------------------------------------------------
# Section 6 — FIX 2: String/Map round-trip on the native struct.
# Reads back the non-primitive fields. If unboxToNative dropped them,
# either the compile fails (empty compound-literal slot) or the values
# are garbage.
# ---------------------------------------------------------------------

out(mol.props["formula"]);        # -> CH4
out(mol.atoms.size());            # -> 2


# ---------------------------------------------------------------------
# Section 7 — sanity: the writes from Sections 2 and 4 didn't clobber
# anything else on `mol`.
# ---------------------------------------------------------------------

out(mol.atoms[0].y);              # -> 0
out(mol.atoms[0].z);              # -> 0
out(mol.atoms[0].element);        # -> 6   (unchanged by Section 2, which touched .x)
out(mol.name);                    # -> methane