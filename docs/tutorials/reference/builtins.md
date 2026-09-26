# Built-in functions

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

The following names are recognized by the supplied lexer/codegen. Their behavior below describes the **compiled** backend; the interpreter may differ.

| Name | Compiled behavior |
|---|---|
| `out(x)` | Print a value and a newline |
| `string(x)` | Convert a value to `String`; no argument gives `""` |
| `int64(x)` | Convert to `Int64` |
| `float64(x)` | Convert to `Float64` |
| `type(x)` | Return a type name string |
| `sizeof(x)` | Return runtime-reported size |
| `sequence(a, b)` | Produce integer values starting at `a`, stopping before `b` |
| `map()` | Create an empty map |
| `free(x)` | Evaluate `x`; no individual arena object is released |
| `exit(code)` | Terminate the generated program |

`map()` has a codegen branch; verify recognition through the complete lexer/parser before publishing a standalone source example. `free` is a no-op for reclamation in compiled mode: do **not** use it as a substitute for region lifetime management.

### See also
[Types](types.md) · [Collections](collections.md) · [Regions](regions.md)
