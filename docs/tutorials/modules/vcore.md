# vcore — environment and utilities

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Importing
```vyne
module vcore;
```

## Export index (compiled backend)
| Name | Shape | Purpose |
|---|---|---|
| `now()` | no arguments | Current time value |
| `sleep(ms)` | one value | Pause execution |
| `platform()` | no arguments | Platform identifier |
| `input(...)` | variable arguments | Read input |
| `parse_array(text)` | one string | Parse a simple array representation |
| `hex_to_int64(text)` | one string | Convert hexadecimal text |
| `version`, `engine`, `build` | properties | Build/version descriptors |
| `processor_count`, `pid`, `memory_usage` | properties | Environment information |

The properties above are referenced without `()` in the native dispatch map. Check OS-specific behavior of `sleep`, `pid`, and `memory_usage` in your build before relying on units beyond those stated by the implementation.

## Example
```vyne
module vcore;
out(vcore.version);
```

> **Note:** The header contains platform-specific system APIs; source availability and portability depend on the target build.

### See also
[Module index](README.md) · [Built-ins](../reference/builtins.md)
