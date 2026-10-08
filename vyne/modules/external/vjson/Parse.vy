# vjson/Parse.vy — recursive-descent JSON parser.
#
# Every internal helper takes a Parser and, where it produces a value,
# returns it as a boxed VyneValue. Errors are raised with `throw` and
# carry a message plus the byte offset; wrap the call in `try / catch`
# to recover.

ruleset { dynamic_casting };

use "Types.vy";
use "Kernels.vy";
use native vcore;

module vjson;

# ---- Parser primitives ----------------------------------------------

fn :: vjson _peek(p :: Parser) -> String {
    if p.pos >= p.src.size() { return ""; }
    return p.src[p.pos];
}

fn :: vjson _peek_at(p :: Parser, off :: Int64) -> String {
    i :: Int64 = p.pos + off;
    if i < 0 { return ""; }
    if i >= p.src.size() { return ""; }
    return p.src[i];
}

fn :: vjson _advance(p :: Parser) {
    p.pos = p.pos + 1;
    return;
}

fn :: vjson _skip_ws(p :: Parser) {
    while p.pos < p.src.size() {
        c :: String = p.src[p.pos];
        if !is_ws(c) { return; }
        p.pos = p.pos + 1;
    }
    return;
}

fn :: vjson _expect(p :: Parser, ch :: String) {
    c :: String = _peek(p);
    if c != ch {
        throw "vjson: expected '" + ch + "' at position " + string(p.pos)
              + " (got '" + c + "')";
    }
    p.pos = p.pos + 1;
    return;
}
# ---- public entry point --------------------------------------------

fn :: vjson parse(src :: String) {
    p :: Parser = Parser(src, 0);
    _skip_ws(p);
    v = _parse_value(p);
    _skip_ws(p);
    if p.pos < p.src.size() {
        throw "vjson: trailing characters at position " + string(p.pos);
    }
    return v;
}

# ---- value dispatch -------------------------------------------------

fn :: vjson _parse_value(p :: Parser) {
    c :: String = _peek(p);
    if c == "" {
        throw "vjson: unexpected end of input at position " + string(p.pos);
    }
    if c == "\{" { return _parse_object(p); }
    if c == "["  { return _parse_array(p);  }
    if c == "\"" { return _parse_string(p); }
    if c == "t" { return _parse_literal(p, "true",  true);  }
    if c == "f" { return _parse_literal(p, "false", false); }
    if c == "n" { return _parse_literal(p, "null",  null);  }
    if c == "-" { return _parse_number(p); }
    if is_digit(c) { return _parse_number(p); }
    throw "vjson: unexpected character '" + c + "' at position " + string(p.pos);
}

# ---- literals -------------------------------------------------------

fn :: vjson _parse_literal(p :: Parser, lit :: String, value) {
    n :: Int64 = lit.size();
    if p.pos + n > p.src.size() {
        throw "vjson: unexpected end of input at position " + string(p.pos);
    }
    chunk :: String = p.src.substr(p.pos, n);
    if chunk != lit {
        throw "vjson: expected '" + lit + "' at position " + string(p.pos);
    }
    p.pos = p.pos + n;
    return value;
}

# ---- numbers --------------------------------------------------------
# JSON number grammar: -? (0 | [1-9][0-9]*) (. [0-9]+)? ([eE][+-]?[0-9]+)?
# Integers that fit in Int64 come back as V_INT64, everything else as
# V_FLOAT64.

fn :: vjson _parse_number(p :: Parser) {
    start :: Int64 = p.pos;
    is_float :: Bool = false;

    if _peek(p) == "-" { p.pos = p.pos + 1; }

    if !is_digit(_peek(p)) {
        throw "vjson: expected digit at position " + string(p.pos);
    }
    while is_digit(_peek(p)) { p.pos = p.pos + 1; }

    if _peek(p) == "." {
        is_float = true;
        p.pos = p.pos + 1;
        if !is_digit(_peek(p)) {
            throw "vjson: expected digit after '.' at position " + string(p.pos);
        }
        while is_digit(_peek(p)) { p.pos = p.pos + 1; }
    }

    ec :: String = _peek(p);
    if ec == "e" || ec == "E" {
        is_float = true;
        p.pos = p.pos + 1;
        sc :: String = _peek(p);
        if sc == "+" || sc == "-" { p.pos = p.pos + 1; }
        if !is_digit(_peek(p)) {
            throw "vjson: expected digit in exponent at position " + string(p.pos);
        }
        while is_digit(_peek(p)) { p.pos = p.pos + 1; }
    }

    text :: String = p.src.substr(start, p.pos - start);
    if is_float { return float64(text); }
    return int64(text);
}

# ---- strings --------------------------------------------------------
# Single accumulator string is fine here: JSON strings are typically
# short enough that the O(n²) cost of `+` is below the noise floor.
# Swap to the string builder if a workload ever shows otherwise.

fn :: vjson _parse_string(p :: Parser) -> String {
    p.pos = p.pos + 1;   # caller verified leading '"'
    acc :: String = "";
    while true {
        if p.pos >= p.src.size() {
            throw "vjson: unterminated string at position " + string(p.pos);
        }
        c :: String = p.src[p.pos];
        if c == "\"" {
            p.pos = p.pos + 1;
            return acc;
        }
        if c == "\\" {
            p.pos = p.pos + 1;
            acc = acc + _parse_escape(p);
        } else {
            acc = acc + c;
            p.pos = p.pos + 1;
        }
    }
    return acc;
}

# Consume one escape sequence (backslash already eaten). Returns the
# replacement string.
fn :: vjson _parse_escape(p :: Parser) -> String {
    e :: String = _peek(p);
    if e == "\"" { p.pos = p.pos + 1; return "\""; }
    if e == "\\" { p.pos = p.pos + 1; return "\\"; }
    if e == "/"  { p.pos = p.pos + 1; return "/";  }
    if e == "b"  { p.pos = p.pos + 1; return "\010"; }   # backspace
    if e == "f"  { p.pos = p.pos + 1; return "\014"; }   # form feed
    if e == "n"  { p.pos = p.pos + 1; return "\n"; }
    if e == "r"  { p.pos = p.pos + 1; return "\r"; }
    if e == "t"  { p.pos = p.pos + 1; return "\t"; }
    if e == "u"  { p.pos = p.pos + 1; return _parse_u_escape(p); }
    throw "vjson: invalid escape '\\" + e + "' at position " + string(p.pos);
}

# Consume the 4 hex digits of a \uXXXX escape (the 'u' already eaten).
# Surrogate pairs are combined into a single code point, then UTF-8
# encoded via vcore.chr.
fn :: vjson _parse_u_escape(p :: Parser) -> String {
    cp :: Int64 = _read_hex4(p);

    if cp >= 55296 && cp <= 56319 {        # 0xD800..0xDBFF high surrogate
        if _peek(p) != "\\" {
            throw "vjson: lone high surrogate at position " + string(p.pos);
        }
        p.pos = p.pos + 1;
        if _peek(p) != "u" {
            throw "vjson: expected '\\u' after high surrogate at position "
                  + string(p.pos);
        }
        p.pos = p.pos + 1;
        lo :: Int64 = _read_hex4(p);
        if lo < 56320 || lo > 57343 {      # 0xDC00..0xDFFF low surrogate
            throw "vjson: invalid low surrogate at position " + string(p.pos);
        }
        cp = 65536 + (cp - 55296) * 1024 + (lo - 56320);
    }

    return _utf8_encode(cp);
}

fn :: vjson _read_hex4(p :: Parser) -> Int64 {
    if p.pos + 4 > p.src.size() {
        throw "vjson: truncated \\u escape at position " + string(p.pos);
    }
    h1 :: String = p.src[p.pos];
    h2 :: String = p.src[p.pos + 1];
    h3 :: String = p.src[p.pos + 2];
    h4 :: String = p.src[p.pos + 3];
    if !is_hex(h1) || !is_hex(h2) || !is_hex(h3) || !is_hex(h4) {
        throw "vjson: invalid hex in \\u escape at position " + string(p.pos);
    }
    v :: Int64 = hex_digit(h1) * 4096
               + hex_digit(h2) * 256
               + hex_digit(h3) * 16
               + hex_digit(h4);
    p.pos = p.pos + 4;
    return v;
}

# Standard UTF-8 encoder. Assumes cp is a valid scalar (not a surrogate)
# — the surrogate case is resolved by the caller before reaching here.
fn :: vjson _utf8_encode(cp :: Int64) -> String {
    if cp < 128 {
        return vcore.chr(cp);
    }
    if cp < 2048 {
        b1 :: Int64 = 192 + (cp / 64);
        b2 :: Int64 = 128 + (cp % 64);
        return vcore.chr(b1) + vcore.chr(b2);
    }
    if cp < 65536 {
        b1 :: Int64 = 224 + (cp / 4096);
        b2 :: Int64 = 128 + ((cp / 64) % 64);
        b3 :: Int64 = 128 + (cp % 64);
        return vcore.chr(b1) + vcore.chr(b2) + vcore.chr(b3);
    }
    b1 :: Int64 = 240 + (cp / 262144);
    b2 :: Int64 = 128 + ((cp / 4096) % 64);
    b3 :: Int64 = 128 + ((cp / 64) % 64);
    b4 :: Int64 = 128 + (cp % 64);
    return vcore.chr(b1) + vcore.chr(b2) + vcore.chr(b3) + vcore.chr(b4);
}

# ---- arrays ---------------------------------------------------------

fn :: vjson _parse_array(p :: Parser) {
    p.pos = p.pos + 1;   # consume '['
    arr = [];
    _skip_ws(p);
    if _peek(p) == "]" {
        p.pos = p.pos + 1;
        return arr;
    }
    while true {
        _skip_ws(p);
        v = _parse_value(p);
        arr.push(v);
        _skip_ws(p);
        c :: String = _peek(p);
        if c == "," {
            p.pos = p.pos + 1;
            continue;
        }
        if c == "]" {
            p.pos = p.pos + 1;
            return arr;
        }
        throw "vjson: expected ',' or ']' at position " + string(p.pos);
    }
    return arr;
}

# ---- objects --------------------------------------------------------

fn :: vjson _parse_object(p :: Parser) {
    p.pos = p.pos + 1;   # consume '{'
    m = map();
    _skip_ws(p);
    if _peek(p) == "}" {
        p.pos = p.pos + 1;
        return m;
    }
    while true {
        _skip_ws(p);
        if _peek(p) != "\"" {
            throw "vjson: expected object key at position " + string(p.pos);
        }
        key :: String = _parse_string(p);
        _skip_ws(p);
        _expect(p, ":");
        _skip_ws(p);
        v = _parse_value(p);
        m.set(key, v);
        _skip_ws(p);
        c :: String = _peek(p);
        if c == "," {
            p.pos = p.pos + 1;
            continue;
        }
        if c == "}" {
            p.pos = p.pos + 1;
            return m;
        }
        throw "vjson: expected ',' or '}' at position " + string(p.pos);
    }
    return m;
}