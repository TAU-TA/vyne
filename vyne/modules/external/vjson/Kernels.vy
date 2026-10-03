# vjson/Kernels.vy — character classification and hex decoding.
#
# Every predicate takes a single-character String and returns Bool.
# Callers guarantee the argument is a non-empty one-character string
# (`_peek` returns "" only at end of input, and callers check for that
# separately). The `size() == 1` guard is there so an accidental empty
# string does not match `"0123456789".find("") == 0`.

ruleset { dynamic_casting };

module vjson;

const numbers           :: String = "0123456789";
const numbers_and_chars :: String = "0123456789abcdefABCDEF";

fn :: vjson is_digit(c :: String) -> Bool {
    return c.size() == 1 && numbers.find(c) >= 0;
}

fn :: vjson is_hex(c :: String) -> Bool {
    return c.size() == 1 && numbers_and_chars.find(c) >= 0;
}

fn :: vjson is_ws(c :: String) -> Bool {
    if c == " "  { return true; }
    if c == "\t" { return true; }
    if c == "\n" { return true; }
    if c == "\r" { return true; }
    return false;
}

# Numeric value of a single hex digit. Returns -1 for anything else.
# Verbose by construction because Vyne has no char arithmetic; the
# runtime cost is one string compare per branch and the function is
# only reached on `\uXXXX` escapes, which are rare in real payloads.
fn :: vjson hex_digit(c :: String) -> Int64 {
    if c == "0" { return 0;  }
    if c == "1" { return 1;  }
    if c == "2" { return 2;  }
    if c == "3" { return 3;  }
    if c == "4" { return 4;  }
    if c == "5" { return 5;  }
    if c == "6" { return 6;  }
    if c == "7" { return 7;  }
    if c == "8" { return 8;  }
    if c == "9" { return 9;  }
    if c == "a" || c == "A" { return 10; }
    if c == "b" || c == "B" { return 11; }
    if c == "c" || c == "C" { return 12; }
    if c == "d" || c == "D" { return 13; }
    if c == "e" || c == "E" { return 14; }
    if c == "f" || c == "F" { return 15; }
    return -1;
}