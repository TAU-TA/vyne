# vjson/Serialize.vy — string-builder based JSON serializer.
#
# Every append goes through a vcore string builder, so building an N-byte
# payload costs O(N) total allocations and O(N) total memcpy. The old
# `out = out + chunk` idiom would be O(N²) — the reason this library
# needed a runtime change before it could exist.

ruleset { dynamic_casting };

use "Types.vy";
use native vcore;
use native vmath;

module vjson;

fn :: vjson serialize(v) -> String {
    sb :: Int64 = vcore.sb_create();
    _serialize_into(sb, v);
    return vcore.sb_build(sb);
}

# Dispatch on the runtime tag of `v`. Anything not in the JSON tag set
# is a hard error, not a silent best-effort.
fn :: vjson _serialize_into(sb :: Int64, v) {
    t :: String = type(v);

    if t == "Null" {
        vcore.sb_append(sb, "null");
        return;
    }
    if t == "Boolean" {
        if v { vcore.sb_append(sb, "true"); }
        else  { vcore.sb_append(sb, "false"); }
        return;
    }
    if t == "Int64" {
        vcore.sb_append(sb, v);
        return;
    }
    if t == "Float64" {
        _append_float(sb, v);
        return;
    }
    if t == "String" {
        _append_string(sb, v);
        return;
    }
    if t == "Array" {
        _append_array(sb, v);
        return;
    }
    if t == "Map" {
        _append_object(sb, v);
        return;
    }
    throw "vjson: cannot serialize value of type '" + t + "'";
}

# JSON forbids NaN and Infinity. The runtime's `string(Float64)` would
# happily produce "nan" / "inf", which most parsers reject. Emit null
# instead, matching JavaScript's JSON.stringify.
fn :: vjson _append_float(sb :: Int64, v :: Float64) {
    if v != v {
        vcore.sb_append(sb, "null");
        return;
    }
    if v == vmath.inf() {
        vcore.sb_append(sb, "null");
        return;
    }
    if v == -vmath.inf() {
        vcore.sb_append(sb, "null");
        return;
    }
    vcore.sb_append(sb, v);
    return;
}

fn :: vjson _append_string(sb :: Int64, s :: String) {
    vcore.sb_append(sb, "\"");
    n :: Int64 = s.size();
    through i :: 0..n-1 -> loop {
        c :: String = s[i];
        if      c == "\""   { vcore.sb_append(sb, "\\\""); }
        else if c == "\\"   { vcore.sb_append(sb, "\\\\"); }
        else if c == "\n"   { vcore.sb_append(sb, "\\n");  }
        else if c == "\r"   { vcore.sb_append(sb, "\\r");  }
        else if c == "\t"   { vcore.sb_append(sb, "\\t");  }
        else if c == "\010" { vcore.sb_append(sb, "\\b");  }
        else if c == "\014" { vcore.sb_append(sb, "\\f");  }
        else                { vcore.sb_append(sb, c);      }
    };
    vcore.sb_append(sb, "\"");
    return;
}

fn :: vjson _append_array(sb :: Int64, arr :: Array) {
    vcore.sb_append(sb, "[");
    n :: Int64 = arr.size();
    through i :: 0..n-1 -> loop {
        if i > 0 { vcore.sb_append(sb, ","); }
        v = arr[i];
        _serialize_into(sb, v);
    };
    vcore.sb_append(sb, "]");
    return;
}

fn :: vjson _append_object(sb :: Int64, m :: Map) {
    vcore.sb_append(sb, "\{");
    keys :: Array = m.keys();
    n :: Int64 = keys.size();
    through i :: 0..n-1 -> loop {
        if i > 0 { vcore.sb_append(sb, ","); }
        k :: String = keys[i];
        _append_string(sb, k);
        vcore.sb_append(sb, ":");
        v = m[k];
        _serialize_into(sb, v);
    };
    vcore.sb_append(sb, "}");
    return;
}