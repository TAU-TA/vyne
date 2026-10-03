# vjson

JSON parsing and serialization for Vyne.

**Version:** 0.1.0
**Status:** unstable — public surface may change between releases
**Module name:** `vjson`
**Import path:** `use external "vjson/vjson.vy";`
**Requires:** `vcore` (character assembly, string builder)

> **On the name.** The module is `vjson` — four letters, no dot, no
> other spelling. Earlier drafts of this document referred to the
> parser entry point as `json.parse`, mirroring the Python module of
> the same name. The source has always used `vjson.parse` and the
> mangled names reflect it. This manual uses `vjson` exclusively.

---

## Contents

1. [Overview](#overview)
2. [Quick start](#quick-start)
3. [Importing](#importing)
4. [Module layout](#module-layout)
5. [The `JsonValue` convention](#the-jsonvalue-convention)
6. [The `Parser` type](#the-parser-type)
7. [Reference semantics and the memory model](#reference-semantics-and-the-memory-model)
8. [API reference](#api-reference)
9. [Worked example](#worked-example)
10. [Limitations](#limitations)
11. [Design notes](#design-notes)
12. [Roadmap](#roadmap)
13. [Version history](#version-history)

---

## Overview

`vjson` is a pure-Vyne JSON parser and serializer. It parses the
standard grammar — objects, arrays, strings, numbers, booleans, null —
into plain Vyne values, and serializes those values back to text.

The library is deliberately minimal. It does not support JSON5,
JSONC, JSON Lines, or the `BigInt` and `OrderedMap` extensions that
some ecosystems add. It does not preserve key order on round-trip.
It does not stream. It does one thing well: it reads a well-formed
JSON document into a value tree, and it writes a value tree back out
as text that any conforming parser on the planet will accept.

The serializer is built on `vcore`'s string builder rather than the
`+` operator. Building an N-byte JSON payload by incrementally
concatenating strings is O(N²) because every `+` allocates a fresh
buffer and copies both operands; the string builder amortizes the
cost to O(N). The library was the first real consumer of the string
builder, and it is the reference case for when a string builder
matters.

The parser is a hand-written recursive descent, one function per
grammar production. The `Parser` interface carries the input string
and a byte cursor; every helper advances the cursor and returns a
value. Errors are raised with `throw` and carry a message plus the
byte offset — the first position the parser could not accept.

---

## Quick start

```vyne
use external "vjson/vjson.vy";

ruleset { dynamic_casting };

src :: String = "[\{\"name\":\"vyne\",\"version\":1,\"ok\":true\}]";

v = vjson.parse(src);

out("kind     = " + string(type(v)));         # Array
out("size     = " + string(v.size()));        # 1
out("first    = " + string(v[0]["name"]));    # vyne
out("depth    = " + string(vjson.depth(v)));  # 3
out("valid    = " + string(vjson.validate(v))); # true

round :: String = vjson.serialize(v);
out(round);
```

Two things are worth flagging in that snippet.

**The `\{` escapes.** The Vyne lexer treats any unescaped `{` inside
a string literal as the start of an interpolation. A JSON payload
written directly in source needs every opening brace escaped as `\{`,
and any embedded `}` that would otherwise close an interpolation
needs `\}`. This is a language-level sharp edge, not a `vjson` one;
see [Limitations](#limitations). Payloads read from disk with
`vfs.read` do not need the escaping, and that is the shape real code
should take.

**The value is untyped.** `vjson.parse` returns a boxed `VyneValue`.
Its tag is one of the seven JSON-compatible tags —
`V_NULL`, `V_BOOL`, `V_INT64`, `V_FLOAT64`, `V_STRING`, `V_ARRAY`, or
`V_MAP`. There is no `JsonValue` struct; the convention is the tag
itself. See [The `JsonValue` convention](#the-jsonvalue-convention).

---

## Importing

```vyne
use external "vjson/vjson.vy";
```

`vjson.vy` is a facade. It pulls in the leaf modules:

| Module          | Contents                                                      |
| --------------- | ------------------------------------------------------------- |
| `Types.vy`      | `Parser` interface, type predicates, the JsonValue convention |
| `Kernels.vy`    | Character classification, hex decoding, whitespace            |
| `Parse.vy`      | Recursive-descent parser, error paths                         |
| `Serialize.vy`  | String-builder serializer                                     |
| `Reductions.vy` | `validate`, `depth`                                           |

You may import individual leaf modules if you want to avoid pulling in
the full surface, but the facade is the recommended entry point.

---

## Module layout

```
vjson/
├── vjson.vy           # facade: use + deploy
├── Types.vy           # Parser interface, type predicates
├── Kernels.vy         # is_digit, is_hex, is_ws, hex_digit
├── Parse.vy           # parse, _parse_value, _parse_string, ...
├── Serialize.vy       # serialize, _serialize_into, _append_*
└── Reductions.vy      # validate, depth
```

### Two-layer design

Every parse and every serialize is a two-layer composition:

1. **Kernels** (`Kernels.vy`): character-level predicates over
   single-character strings. `is_digit(c)`, `is_hex(c)`, `is_ws(c)`,
   `hex_digit(c)`. These have no state and no allocation.

2. **Parse / Serialize**: the grammar productions. `parse` is the
   public entry point; `_parse_value` dispatches on the leading
   character; `_parse_object`, `_parse_array`, `_parse_string`, and
   `_parse_number` handle the four composite forms.

The split is not for performance — unlike `vlin`'s kernel/wrapper
split, nothing in the parser is eligible for the native array ABI,
because every function takes a `Parser` or a `String` and the
native ABI does not carry either. The split exists because the
character predicates are conceptually independent of the parser and
are useful in their own right.

---

## The `JsonValue` convention

A JSON value is a boxed `VyneValue` whose tag is one of:

| Tag         | JSON type        | Notes                                            |
| ----------- | ---------------- | ------------------------------------------------ |
| `V_NULL`    | `null`           |                                                  |
| `V_BOOL`    | `true` / `false` | Stored in `.as.i64` as 0 or 1                    |
| `V_INT64`   | number           | Integers that fit in `int64_t`                   |
| `V_FLOAT64` | number           | Anything with `.`, `e`, or `E`                   |
| `V_STRING`  | string           | UTF-8 bytes, no embedded nulls                   |
| `V_ARRAY`   | array            | Elements are boxed `VyneValue`s                  |
| `V_MAP`     | object           | Keys are `String`, values are boxed `VyneValue`s |

Anything else — `V_STRUCT`, `V_FUNCTION`, `V_MODULE`, `V_REFERENCE`,
`V_F64_ARRAY`, `V_I64_ARRAY` — is not a valid JSON value.
`vjson.serialize` rejects it with a `throw`;
`vjson.validate` returns `false`.

There is no dedicated `JsonValue` type. The convention is entirely
about the runtime tag, and every predicate in `Types.vy` is a
wrapper around `type(v)`:

```vyne
fn :: vjson is_int(v) -> Bool { return type(v) == "Int64"; }
```

That is not a design compromise; it is the design. A `JsonValue` that
boxed a `VyneValue` inside a struct would add a struct allocation to
every parse node for the sole benefit of a nominal type name, and the
`type(v)` predicate already gives you the same discrimination at the
call site.

### Integers versus floats

JSON does not distinguish integer and real numbers in its grammar.
The parser does, because Vyne does: a number literal with no `.`, no
`e`, and no `E` becomes `V_INT64`; anything else becomes `V_FLOAT64`.
This is the same rule the Vyne lexer uses for source literals, and it
means a JSON payload that says `1` round-trips through `vjson` as an
`Int64`, not as `1.0`.

The distinction is lossy in one direction. `1.0` on the wire becomes
`V_FLOAT64` and serializes back as `1.0`, not as `1`. That is the
correct behavior — the decimal point was on the wire, and re-emitting
it preserves the original's intent.

The `_parse_number` function is where this dispatch happens:

```vyne
text :: String = p.src.substr(start, p.pos - start);
if is_float { return float64(text); }
return int64(text);
```

`is_float` is set when the parser sees `.`, `e`, or `E` during the
scan. It is not set by the numeric value — `1e0` is a float even
though it equals `1`.

### Strings and UTF-8

JSON strings are byte sequences. `vjson` treats them as such: the
parser accumulates bytes into a Vyne `String` and does not validate
UTF-8, and the serializer emits whatever bytes it is given, escaping
only the seven characters that JSON requires (`"`, `\`, `\n`, `\r`,
`\t`, `\b`, `\f`).

`\uXXXX` escapes are handled by `_parse_u_escape`, which decodes the
four hex digits into a code point and UTF-8 encodes the result via
`_utf8_encode`. Surrogate pairs — a high surrogate `\uD800..\uDBFF`
immediately followed by a low surrogate `\uDC00..\uDFFF` — are
combined into a single code point before encoding. Lone surrogates
raise an error rather than emitting an invalid UTF-8 sequence.

The encoder handles four widths:

| Code point range    | Bytes | Encoder branch                        |
| ------------------- | ----- | ------------------------------------- |
| `0x00..0x7F`        | 1     | `vcore.chr(cp)`                       |
| `0x80..0x7FF`       | 2     | `192 + (cp / 64)`, then `128 + cp%64` |
| `0x800..0xFFFF`     | 3     | Three-byte sequence                   |
| `0x10000..0x10FFFF` | 4     | Four-byte sequence                    |

Characters above `0x7F` in the input are passed through unchanged, so
a document that already contains UTF-8 literals round-trips
byte-for-byte. Mixed sources — some characters escaped, some literal
— also work, because the parser assembles the output from both
paths into the same accumulator.

---

## The `Parser` type

```vyne
interface Parser {
    src :: String,
    pos :: Int64,
}
```

The parser is a two-field interface: the source string and a byte
cursor. Every helper takes a `Parser` and, where it produces a value,
returns a boxed `VyneValue` or a scalar.

```vyne
fn :: vjson _peek(p :: Parser) -> String {
    if p.pos >= p.src.size() { return ""; }
    return p.src[p.pos];
}
```

`_peek` returns the character at the cursor, or `""` at end of input.
Callers check for `""` explicitly — it is the sentinel for "no more
input" and it is the same value the parser returns for a valid empty
string, so the check has to be by position, not by content. That is a
deliberate design choice: a nullable `String` would have required an
extra tag on every return, and the `pos` check is one comparison.

### Mutation through the interface

`Parser` fields are mutated in place:

```vyne
fn :: vjson _advance(p :: Parser) {
    p.pos = p.pos + 1;
    return;
}
```

This works because Vyne interface values are references to a shared
struct. A `p.pos = new_pos` inside a helper is visible to the caller.
That is the same reference semantics `vlin` documents for `Matrix`,
and it is what makes a hand-written parser expressible without
threading the cursor back through every return value.

### Why a struct, not two parameters

A version that passed `(src, pos)` as two arguments would have to
return the new position alongside every value, which Vyne has no
tuple for. The `Parser` interface is the workaround for the absence
of tuples, and it is a good one — the field-based access reads as
naturally as a mutable local in a language that has them.

---

## Reference semantics and the memory model

### Every parse allocates

Parsing an N-byte document allocates:

- One `VyneArray` per array, plus the element buffer.
- One `VyneMap` per object, plus the entry buffer.
- One `String` per string literal, plus the accumulator garbage
  (`acc = acc + c` in `_parse_string` allocates a fresh buffer per
  character; see [Limitations](#limitations)).
- One `Int64` or `Float64` box per number.

For a 1 KB JSON document with a typical structure, that is a few
hundred allocations and a few KB of arena traffic. For a 1 MB
document, the same shape scaled up.

The entire parse is a natural `region` scope. Wrap it:

```vyne
module vmem;

region doc {
    v = vjson.parse(src);
    # ... use v ...
};
# v is invalid after this point — its storage was reclaimed.
```

The catch is the same as every other region-scoped value: anything
that must outlive the parse has to be either committed via
`region.commit` or extracted out of `v` before the region closes.

### The serializer allocates once

`vjson.serialize` calls `vcore.sb_create`, threads the builder through
every `sb_append`, and calls `vcore.sb_build` once at the end to
produce the final string. The builder's internal buffer grows by
doubling; the final `sb_build` allocates one buffer of exactly the
right size and copies the contents.

Total allocations for an N-byte output: `log₂(N/64) + 1`. For a
1 MB output that is about twenty intermediate buffers of geometric
size plus one final buffer, versus the ~10⁹ byte-copies that the
`+` operator would have made. This is the reason the string builder
exists.

### The intermediate buffers are arena garbage

Every intermediate buffer grown by `_vyne_sb_grow` stays in the
arena until the enclosing region rewinds or the process exits. For
a single serialize call outside any region, the geometric growth
means a few KB of dead intermediates for a few KB of output. Inside
a region, they are reclaimed at the rewind like everything else.

If a program serializes repeatedly in a hot loop, the region scope
is not optional. `vcore.sb_reset` reuses the same builder's buffer
across calls:

```vyne
sb :: Int64 = vcore.sb_create();
through i :: 0..N-1 -> loop {
    vcore.sb_reset(sb);
    # ... _serialize_into(sb, ...) ...
    result :: String = vcore.sb_build(sb);
    # use result ...
};
```

That keeps the peak flat across iterations. `vjson.serialize` creates
a fresh builder each call and does not expose the reset path; if
serialization is on a hot path, drop to `vcore.sb_*` directly.

---

## API reference

### Parsing

```vyne
vjson.parse(src :: String) -> VyneValue
```

Parses a complete JSON document. Skips leading and trailing
whitespace. If any characters remain after the top-level value, raises
an error rather than returning a partial parse.

On success, returns a boxed `VyneValue` whose tag is one of the seven
JSON-compatible tags.

On failure, throws a `String` whose content is a human-readable
diagnostic and whose last word is a byte offset:

```
vjson: unexpected character ']' at position 7
vjson: unterminated string at position 18
vjson: expected ',' or '}' at position 22
```

Wrap the call in `try / catch` to recover. The `catch` variable is a
boxed `VyneValue`; `string(e)` recovers the message.

### Serializing

```vyne
vjson.serialize(v :: VyneValue) -> String
```

Serializes a boxed `VyneValue` to a JSON string. Uses the `vcore`
string builder; see [Reference semantics](#reference-semantics-and-the-memory-model).

Rejects any tag outside the seven JSON-compatible ones with a `throw`:

```
vjson: cannot serialize value of type 'Struct'
```

NaN and infinity are serialized as `null`, matching
`JSON.stringify`'s behavior in JavaScript. The check is in
`_append_float` and consults `vmath.inf()`:

```vyne
fn :: vjson _append_float(sb :: Int64, v :: Float64) {
    if v != v { vcore.sb_append(sb, "null"); return; }
    if v == vmath.inf()  { vcore.sb_append(sb, "null"); return; }
    if v == -vmath.inf() { vcore.sb_append(sb, "null"); return; }
    vcore.sb_append(sb, v);
    return;
}
```

### Structural queries

```vyne
vjson.validate(v :: VyneValue) -> Bool
vjson.depth(v :: VyneValue)    -> Int64
```

`validate` walks the tree and returns `true` if every node's tag is
in the JSON-compatible set. `false` on the first `V_STRUCT`,
`V_FUNCTION`, or other non-JSON tag it encounters.

`depth` returns the deepest object or array nesting. Scalars have
depth 0, `{}` and `[]` have depth 1, `{"a":[]}` has depth 2. `depth`
is defined for any value, valid or not; it returns 0 for a scalar
regardless of its tag.

### Type predicates

```vyne
vjson.is_null(v)   -> Bool
vjson.is_bool(v)   -> Bool
vjson.is_int(v)    -> Bool
vjson.is_float(v)  -> Bool
vjson.is_string(v) -> Bool
vjson.is_array(v)  -> Bool
vjson.is_object(v) -> Bool
vjson.is_number(v) -> Bool
```

Thin wrappers around `type(v) == "..."`. `is_number` is the union of
`is_int` and `is_float`. All are pure, no allocation, no side effects.

### Character predicates

```vyne
vjson.is_digit(c :: String) -> Bool
vjson.is_hex(c :: String)   -> Bool
vjson.is_ws(c :: String)    -> Bool
vjson.hex_digit(c :: String) -> Int64
```

Public because the parser exposes them and because they are useful in
their own right. Each takes a single-character `String` and returns a
`Bool` (or, for `hex_digit`, an `Int64` in `0..15` or `-1` for a
non-hex character).

The predicates check `c.size() == 1` before doing their lookup so
that `""` does not match `"0123456789".find("") == 0`. That guard
is what makes the parser's end-of-input detection correct.

### Internal helpers

The following are part of the public surface only because the parser
resolves the names. Most programs should not call them directly.

```vyne
# Parser primitives
vjson._peek(p :: Parser)               -> String
vjson._peek_at(p :: Parser, off)       -> String
vjson._advance(p :: Parser)
vjson._skip_ws(p :: Parser)
vjson._expect(p :: Parser, ch)

# Grammar productions
vjson._parse_value(p)                  -> VyneValue
vjson._parse_object(p)                 -> VyneValue
vjson._parse_array(p)                  -> VyneValue
vjson._parse_string(p)                 -> String
vjson._parse_number(p)                 -> VyneValue
vjson._parse_literal(p, lit, value)    -> VyneValue
vjson._parse_escape(p)                 -> String
vjson._parse_u_escape(p)               -> String
vjson._read_hex4(p)                    -> Int64
vjson._utf8_encode(cp :: Int64)        -> String

# Serializer internals
vjson._serialize_into(sb :: Int64, v)
vjson._append_float(sb, v :: Float64)
vjson._append_string(sb, s :: String)
vjson._append_array(sb, arr :: Array)
vjson._append_object(sb, m :: Map)
```

---

## Worked example

Round-trip a document and inspect it.

```vyne
use external "vjson/vjson.vy";
use native vfs;
use native vcore;

ruleset { dynamic_casting };

# --- Read from disk. ---
# Source-level JSON literals would need every '{' escaped as '\{'
# and every '}' that appears inside an interpolation-related position
# escaped as '\}'. Reading from disk skips the whole problem.
PATH :: String = "examples/external/data.json";
src :: String = vfs.read(PATH);

if src.size() == 0 {
    out("fatal: could not read " + PATH);
    exit(1);
}

# --- Parse. ---
v = vjson.parse(src);

out("parsed ok");
out("  depth: " + string(vjson.depth(v)));
out("  valid: " + string(vjson.validate(v)));

# --- Field access. ---
# `v["name"]` on a Map returns a boxed VyneValue. Nested Maps compose
# the same way.
out("  name:    " + string(v["name"]));
out("  version: " + string(v["version"]));
out("  pi:      " + string(v["nested"]["pi"]));
out("  mixed[1]: " + string(v["mixed"][1]));

# --- Serialize. ---
round :: String = vjson.serialize(v);
out("");
out("re-emit (" + string(round.size()) + " bytes):");
out(round);

# --- Round-trip. ---
v2 = vjson.parse(round);
out("");
out("round-trip:");
out("  depth: " + string(vjson.depth(v2)));
out("  valid: " + string(vjson.validate(v2)));
out("  name matches: " + string(v2["name"] == v["name"]));

# --- Error paths. ---
# Every string below is brace-free, so the lexer treats it as an
# ordinary literal. If any "BUG:" line prints, the parser accepted
# input it should have rejected.
out("");
out("error paths:");

try { vjson.parse("[1, 2, ]");    out("  BUG: accepted trailing comma"); }
catch (e) { out("  " + string(e)); }

try { vjson.parse("[1, 2, 3");    out("  BUG: accepted unterminated array"); }
catch (e) { out("  " + string(e)); }

try { vjson.parse("nope");        out("  BUG: accepted invalid literal"); }
catch (e) { out("  " + string(e)); }

try { vjson.parse("");            out("  BUG: accepted empty input"); }
catch (e) { out("  " + string(e)); }

try { vjson.parse("123abc");      out("  BUG: accepted trailing garbage"); }
catch (e) { out("  " + string(e)); }

# --- Unicode. ---
# The literal below contains only backslash and quote escapes; the
# '\u' sequences are ordinary characters from the Vyne lexer's
# perspective. The JSON parser is what interprets them.
out("");
u = vjson.parse("\"\\u0041\\u00E9\\uD83D\\uDE00\"");
out("unicode: " + u);
out("  length: " + string(u.size()) + " bytes");
```

Expected output (abbreviated):

```
parsed ok
  depth: 5
  valid: true
  name:    vyne
  version: 1
  pi:      3.14159
  mixed[1]: two

re-emit (190 bytes):
{"mixed":[1,"two",3.0,...],"features":[...],"nested":{...},"name":"vyne","version":1}

round-trip:
  depth: 5
  valid: true
  name matches: true

error paths:
  vjson: unexpected character ']' at position 7
  vjson: unexpected end of input at position 7
  vjson: unexpected character 'o' at position 1
  vjson: unexpected end of input at position 0
  vjson: trailing characters at position 3

unicode: Aé😀
  length: 8 bytes
```

The `re-emit` line shows keys in hash order, not insertion order.
JSON does not require any particular key order, and every parser in
the world accepts this. See [Limitations](#limitations) for what
would need to change to preserve insertion order.

The `length: 8 bytes` is correct: `A` is 1 byte, `é` is 2 bytes in
UTF-8, `😀` is 4 bytes. The `size()` method on a `String` returns
the byte count.

---

## Limitations

### Source-level JSON literals need brace escaping

The Vyne lexer treats any unescaped `{` inside a string literal as
the start of an interpolation. A JSON document written directly in
Vyne source needs every opening brace escaped as `\{`:

```vyne
# This parses as an interpolated string, not as the literal '{"a":1}'
bad :: String = "{\"a\":1}";

# This is the correct source-level form
good :: String = "\{\"a\":1}";
```

The trailing `}` at the end of the object does not need escaping,
because by that point the lexer is not inside an interpolation. But
any `}` that appears while an interpolation is open terminates it,
so a `}` inside a nested object in a source-level literal does need
`\}` if the enclosing `{` was not escaped.

The rule is: escape every `{`, and escape `}` only if the
corresponding `{` was not escaped. In practice, escape both.
Payloads read from disk with `vfs.read` are not affected.

This is a language-level issue, not a `vjson` one. It will be fixed
when the lexer stops treating `{` as interpolation when the next
character is `"` or `}` — see [Roadmap](#roadmap).

### Key order is not preserved

The parser builds a `VyneMap`, and `VyneMap` does not preserve
insertion order. The serializer iterates via `m.keys()`, which walks
the hash table in whatever order the hash function places the keys.

A document `{"a":1,"b":2,"c":3}` round-trips to a document with the
same three key/value pairs in an arbitrary order — a valid JSON
document, semantically equal to the input, but not byte-identical.

If a program needs byte-identical round-trips, it needs an ordered
map. That is a variant of the map, not a fix to this one. See
[Roadmap](#roadmap).

### No depth limit

Recursive-descent parsing consumes C stack proportional to the
document's nesting depth. A payload like `[[[[[...]]]]]` nested one
million deep will exhaust the stack before it exhausts memory. The
parser does not currently count depth, so it cannot reject a
pathological payload before descending.

For trusted input — a config file, a build manifest, a payload from
a service you control — this does not matter. For untrusted input
from the network, it is a real hazard. A depth counter threaded
through `_parse_value` and a hard limit (say 256 or 1024) would close
it. See [Roadmap](#roadmap).

### No streaming

The parser requires the whole document in a `String` before parsing.
There is no `parse_stream(chunk)` API, and no `parse_into(builder)`
for building values incrementally. Documents are parsed as complete
units.

For the config-file and API-payload workloads this library is
designed for, that is fine. For a streaming telemetry pipeline, it
is not; the workaround is to split the input and call `parse` per
record.

### Numbers are `double` or `int64`

JSON does not specify precision. `vjson` maps integers to `int64_t`
and everything else to `double`, which is the same choice the Vyne
runtime makes elsewhere. A JSON document that contains
`9007199254740993` (larger than `2⁵³`) will lose precision if it is
parsed as a float, and a document that contains `10³⁰⁰` will lose
precision if it is parsed as an integer that overflows `int64_t`.

The parser dispatches by syntax, not by magnitude: any number with a
decimal point or exponent becomes `V_FLOAT64`, and any number without
becomes `V_INT64`. If the magnitude does not fit, `int64(text)`
saturates silently. That is a runtime-level behavior, not a `vjson`
one, but callers should be aware of it.

### String concatenation in `_parse_string` is O(n²)

The parser builds the string accumulator by `acc = acc + c`, which
allocates a fresh buffer and copies both operands on each character.
For a JSON string literal of length N, the total cost is O(N²) in
both time and arena traffic.

For typical JSON documents — where strings are a few tens of
characters — this is below the noise floor. For a document with a
single 1 MB string literal, it is fatal. The fix is to route the
accumulator through `vcore.sb_*` the same way the serializer does.
The reason it was not done in 0.1.0 is that the O(N²) path is
simpler to read, and no benchmark has shown it dominating. See
[Roadmap](#roadmap).

### No JSON5, JSONC, or JSON Lines

The grammar implemented is `RFC 8259`, unmodified. No trailing
commas, no comments, no unquoted keys, no single-quoted strings, no
`NaN`/`Infinity` literals, no `undefined`. A document that uses any
of these extensions is rejected. The parser is the standard grammar;
the extensions are a different library.

### Errors are strings

`throw` in Vyne carries a `VyneValue`, and `vjson` throws a `String`.
There is no `JsonError` type with a `position` field and an
`error_code` field. A caller that wants structured error data has to
parse the message string, which is fragile.

Structured errors are a small change once the language has sum types
or interfaces with multiple fields. Until then, the message format
is stable and documented above. See [Roadmap](#roadmap).

---

## Design notes

### Why recursive descent, not a generated parser

A parser generator would produce a table-driven parser that is
marginally faster and significantly harder to read. The recursive
descent in `Parse.vy` is 200 lines of Vyne source, and every helper
corresponds to a production in the grammar. A reader who knows JSON
can read the parser top to bottom and see the grammar reflected in
the code. That is the point.

The cost is stack depth, which is the same limitation any recursive
descent parser has, and which is addressed under
[Limitations](#limitations) by a depth counter when it matters.

### Why a single accumulator in `_parse_string`

The `acc = acc + c` loop is the O(N²) path flagged in
[Limitations](#limitations). The reason it is not the string builder
is that the string builder requires the caller to thread an `Int64`
handle through every string parse, and strings are parsed in the
middle of a hot recursive descent where the extra parameter would
propagate through `_parse_object`, `_parse_array`, and every helper
that calls one of them.

Threading an `Int64` handle through the whole parser to speed up the
0.1% case where a JSON string is larger than a few hundred bytes is
not a tradeoff the library makes. The string builder is the right
tool when a string is being built and the builder is the natural
interface; the parser's strings are accumulated inside a recursive
function whose signature should stay as simple as possible.

If a benchmark shows this mattering, the fix is to allocate one
builder per `_parse_string` call and use `sb_reset` to reuse it. That
is a small change; it just was not the one 0.1.0 shipped.

### Why `_peek` returns `""` at end of input

The alternative is to return `null`. `null` is a valid Vyne value,
and the check would be `if c.type == V_NULL`. Empty string is what
`p.src[p.pos]` returns for an in-range position whose byte is 0x00 —
which a well-formed UTF-8 document cannot contain, but which a
malformed one can.

The check `if c == ""` is one string compare, cheaper than a tag
compare plus a null check. It is also what every caller needs to do
anyway, because the same `""` sentinel is used at every point in the
parser that needs to distinguish "end of input" from "some character
that is not the one I wanted". The alternative would be two separate
checks at every call site.

The cost is that `""` is not a valid single-character match for any
predicate, which is why the predicates check `size() == 1` first. The
savings in the hot path make the extra check in the predicates worth
it — `_peek` is called twenty times per character parsed, and the
predicates are called once per character.

### Why a facade

`vjson.vy` is a facade because the five leaf modules have a natural
dependency order that a reader should not have to reconstruct:

```
Types.vy  →  Kernels.vy  →  Parse.vy
                         →  Serialize.vy
                         →  Reductions.vy
```

The facade encodes the order. A user who imports `vjson.vy` gets the
whole surface in one line; a user who wants a subset imports the
leaves explicitly. Both work; the facade is what the manual recommends.

### Why the serializer uses `vcore.sb_*` directly

An alternative would be for `vjson.serialize` to build the output
with `+` and let the runtime optimize. That was the 0.0.x version,
and it was the reason the library could not exist until the string
builder landed — a 1 MB JSON payload built by `+` produced
quadratic arena traffic and choked on real inputs.

The builder is not a `vjson` concern; it is a runtime primitive. The
serializer uses it because it is the right tool. If a future runtime
change makes `+` amortized-O(1) for accumulated strings, the
serializer could be rewritten to use it; the surface would not
change.

### Why `serialize` takes any `VyneValue`

A `JsonValue` interface with a `.serialize()` method would be more
nominal, but every JSON value is a plain `VyneValue` — that is the
convention described above. Making `serialize` a free function that
takes any `VyneValue` and dispatches on its tag is the natural way
to express that convention. It also means callers can serialize a
value they built by hand without wrapping it in a `JsonValue`
constructor.

The cost is that a `V_STRUCT` reaches the dispatcher and is rejected
at runtime rather than at compile time. That is the correct tradeoff
for a dynamically-typed tree; the error message is specific enough
to be actionable, and the compiler cannot know in general that a
value's tag will be JSON-compatible at runtime.

---

## Roadmap

The following are planned or in progress. They are listed here so
the manual is honest about the gap between the intended surface and
the current one.

### Depth limit

A counter threaded through `_parse_value` and a hard limit, defaulting
to 256. Every recursive call increments the counter; the check fires
before descending. This closes the stack exhaustion hazard for
untrusted input.

The API shape is either a fixed limit (simple, no configuration) or
a variant `parse_with_limit(src, max_depth)`. The fixed limit is what
most JSON parsers offer and is the right default.

### Ordered map variant

A `vjson.parse_ordered` that returns an ordered map and a
`vjson.serialize` that consults insertion order when present. This
requires an ordered-map type, which is a separate change to the
runtime — the parallel-`order[]` array sketched earlier.

Not a priority. Every JSON parser in the world is content with hash
order, and no consumer of the output has ever cared. The trigger
condition is a diffable-serialization use case, not a desire for
aesthetic round-trips.

### Structured errors

A `JsonError` interface with `message`, `line`, `column`, and `code`
fields. Thrown instead of a raw `String`. Requires the language to
have interfaces with heterogeneous field types, which it does, but
the ergonomics of catching a boxed interface value are worse than
catching a string in the current runtime. Wait for the string
conversion machinery to improve.

### `_parse_string` through the string builder

The O(N²) accumulator becomes a per-call `sb_create` /
`sb_build`. Deferred until a benchmark shows strings large enough
to matter.

### Streaming parse

`parse_stream(read_chunk)` that accepts a chunked source and yields
one value per call. Requires the parser to be resumable across
chunks, which means the `Parser` interface gains a state field and
every helper gets a continuation-passing rewrite. A significant
change; the current design is the whole-document form.

### Bounded number handling

Reject integer literals that do not fit in `int64_t` instead of
saturating. Reject floats that would overflow `double` instead of
emitting `inf`. Both require runtime support for detecting the
saturation, which `int64(text)` and `float64(text)` do not currently
provide.

### Lexer fix for source-level JSON

The real fix for the brace-escaping problem is in the lexer, not the
library. When `{` is followed by `"` or `}`, it is not the start of
an interpolation — it is the start of a JSON object or an empty map
literal. The lexer can peek and decide. Landing this would let
source-level JSON literals be written without escapes, which would
make the library usable from a `.vy` file for the first time without
a workaround.

This is a language-level change; it affects every existing
interpolation, so it belongs in a versioned release with a migration
note, not in a patch.

---

## Version history

**0.1.0** — initial release. `Types` (`Parser` interface, type
predicates), `Kernels` (`is_digit`, `is_hex`, `is_ws`, `hex_digit`),
`Parse` (`parse` and the recursive-descent productions), `Serialize`
(`serialize` and the string-builder append helpers), `Reductions`
(`validate`, `depth`). UTF-8 and surrogate pairs handled. Errors as
raw strings. No depth limit, no streaming, no ordered maps.
