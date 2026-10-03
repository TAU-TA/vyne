ruleset { dynamic_casting };

use external "vjson/vjson.vy";
use native vcore;
use native vfs;

# =====================================================================
# INPUT
# =====================================================================
# The payload comes from a file. This is not a workaround for a bug —
# it is the shape a real use of a JSON parser takes. It also happens
# to sidestep the lexer rule that treats `{` inside a string literal
# as the start of an interpolation. JSON payloads that live in source
# would need `\{` at every opening brace; payloads on disk need
# nothing.
# =====================================================================

PATH :: String = "examples/external/data.json";

src :: String = vfs.read(PATH);
if src.size() == 0 {
    out("fatal: could not read " + PATH);
    exit(1);
}

out("=== vjson demo ===");
out("");
out("input (" + string(src.size()) + " bytes):");
out(src);
out("");

# =====================================================================
# PARSE
# =====================================================================
v = vjson.parse(src);

out("parsed ok");
out("  depth: " + string(vjson.depth(v)));
out("  valid: " + string(vjson.validate(v)));
out("");

# =====================================================================
# FIELD ACCESS
# =====================================================================
# A Map is reached with `[key]`; a nested Map is reached the same way
# through the intermediate result. Every read below returns a boxed
# VyneValue, so `type()` still reports the runtime tag.

out("field access:");
out("  name:    " + string(v["name"]));
out("  version: " + string(v["version"]));
out("  pi:      " + string(v["nested"]["pi"]));
out("  mixed[1]: " + string(v["mixed"][1]));
out("");

# =====================================================================
# RE-SERIALIZE
# =====================================================================
round :: String = vjson.serialize(v);

out("re-emit (" + string(round.size()) + " bytes):");
out(round);
out("");

# =====================================================================
# ROUND-TRIP
# =====================================================================
v2 = vjson.parse(round);

out("round-trip:");
out("  depth: " + string(vjson.depth(v2)));
out("  valid: " + string(vjson.validate(v2)));
out("  name matches: " + string(v2["name"] == v["name"]));
out("");

# =====================================================================
# ERROR PATHS
# =====================================================================
# Every one of these strings is brace-free, so the lexer treats them
# as ordinary string literals. If any "BUG" line prints, the parser
# accepted input it should have rejected.

out("error paths:");

try {
    vjson.parse("[1, 2, ]");
    out("  BUG: trailing comma did not throw");
} catch (e) {
    out("  caught: " + string(e));
}

try {
    vjson.parse("[1, 2, 3");
    out("  BUG: unterminated array did not throw");
} catch (e) {
    out("  caught: " + string(e));
}

try {
    vjson.parse("nope");
    out("  BUG: invalid literal did not throw");
} catch (e) {
    out("  caught: " + string(e));
}

try {
    vjson.parse("");
    out("  BUG: empty input did not throw");
} catch (e) {
    out("  caught: " + string(e));
}

try {
    vjson.parse("123abc");
    out("  BUG: trailing garbage did not throw");
} catch (e) {
    out("  caught: " + string(e));
}

out("");

# =====================================================================
# UNICODE
# =====================================================================
# A single-escape literal that produces three code points:
#   \u0041        -> 'A'
#   \u00E9        -> 'é'  (2-byte UTF-8)
#   \uD83D\uDE00  -> '😀' (surrogate pair, 4-byte UTF-8)
# Only backslash and quote appear in this literal; no braces.

u = vjson.parse("\"\\u0041\\u00E9\\uD83D\\uDE00\"");
out("unicode:");
out("  parsed: " + u);
out("  length: " + string(u.size()) + " bytes");
out("");

# =====================================================================
# PROGRAMMATIC CONSTRUCTION
# =====================================================================
# Build a value with no parser involvement, serialize it, parse it
# back. Exercises the serializer on data whose Map keys are not
# interned by the parser and whose values include every primitive kind.

out("programmatic build:");

built = map();
built.set("greeting", "hello");
built.set("count", 42);
built.set("ratio", 0.125);
built.set("ok", true);
built.set("nothing", null);

items :: Array = [1, 2, 3, "four", true, null];
built.set("items", items);

encoded :: String = vjson.serialize(built);
out("  encoded: " + encoded);

decoded = vjson.parse(encoded);
out("  greeting: " + string(decoded["greeting"]));
out("  count:    " + string(decoded["count"]));
out("  ratio:    " + string(decoded["ratio"]));
out("");

out("Done.");