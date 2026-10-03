# vjson/Types.vy — the JSON value convention and the parser state.

ruleset { dynamic_casting };

module vjson;

# A JsonValue is a plain VyneValue whose tag is one of:
#
#   V_NULL     -> JSON null
#   V_BOOL     -> JSON true / false
#   V_INT64    -> JSON integer
#   V_FLOAT64  -> JSON real
#   V_STRING   -> JSON string
#   V_ARRAY    -> JSON array (elements are JsonValues)
#   V_MAP      -> JSON object (String keys -> JsonValues)
#
# Anything else (V_STRUCT, V_FUNCTION, ...) is not a valid JSON value.
# vjson.serialize rejects it; vjson.validate returns false.

# Internal parser state. Mutated in place through member assignment.
# VyneValue copies share the same heap-allocated VyneStruct, so a
# `p.pos = new_pos` inside a helper is visible to the caller.
interface Parser {
    src :: String,
    pos :: Int64,
}

# ---- type predicates ------------------------------------------------
# `type(v)` returns the runtime tag as a String. These wrap it so user
# code does not have to remember the exact spelling.

fn :: vjson is_null(v) -> Bool   { return type(v) == "Null";    }
fn :: vjson is_bool(v) -> Bool   { return type(v) == "Boolean"; }
fn :: vjson is_int(v)  -> Bool   { return type(v) == "Int64";   }
fn :: vjson is_float(v)-> Bool   { return type(v) == "Float64"; }
fn :: vjson is_string(v)-> Bool  { return type(v) == "String";  }
fn :: vjson is_array(v)-> Bool   { return type(v) == "Array";   }
fn :: vjson is_object(v)-> Bool  { return type(v) == "Map";     }

fn :: vjson is_number(v) -> Bool {
    t :: String = type(v);
    return t == "Int64" || t == "Float64";
}