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

mol :: Molecule = Molecule(
    [Atom(1.0, 0.0, 0.0, 6, false), Atom(0.0, 1.0, 0.0, 1, false)],
    "methane",
    {"formula": "CH4"}
);

out(mol.name);
out(mol.atoms[0].element);
out(mol.atoms[1].x);