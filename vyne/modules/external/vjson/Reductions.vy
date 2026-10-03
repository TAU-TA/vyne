# vjson/Reductions.vy — structural queries over parsed values.

ruleset { dynamic_casting };

use "Types.vy";

module vjson;

# True if v contains only JSON-compatible tags at every level.
fn :: vjson validate(v) -> Bool {
    t :: String = type(v);
    if t == "Null"    { return true; }
    if t == "Boolean" { return true; }
    if t == "Int64"   { return true; }
    if t == "Float64" { return true; }
    if t == "String"  { return true; }

    if t == "Array" {
        n :: Int64 = v.size();
        through i :: 0..n-1 -> loop {
            if !validate(v[i]) { return false; }
        };
        return true;
    }
    if t == "Map" {
        keys :: Array = v.keys();
        n :: Int64 = keys.size();
        through i :: 0..n-1 -> loop {
            if !validate(v[keys[i]]) { return false; }
        };
        return true;
    }
    return false;
}

# Deepest object/array nesting. Scalars have depth 0, `{}` and `[]`
# have depth 1, `{"a":[]}` has depth 2. Cycles are impossible in Vyne
# data, so this terminates.
fn :: vjson depth(v) -> Int64 {
    t :: String = type(v);

    if t == "Array" {
        n :: Int64 = v.size();
        if n == 0 { return 1; }
        best :: Int64 = 0;
        through i :: 0..n-1 -> loop {
            d :: Int64 = depth(v[i]);
            if d > best { best = d; }
        };
        return 1 + best;
    }
    if t == "Map" {
        keys :: Array = v.keys();
        n :: Int64 = keys.size();
        if n == 0 { return 1; }
        best :: Int64 = 0;
        through i :: 0..n-1 -> loop {
            d :: Int64 = depth(v[keys[i]]);
            if d > best { best = d; }
        };
        return 1 + best;
    }
    return 0;
}