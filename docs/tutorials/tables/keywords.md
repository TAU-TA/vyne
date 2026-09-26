# Keywords and reserved words

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

From the supplied `lexer.h` keyword table:

| Group | Words |
|---|---|
| Values/types | `true`, `false`, `null`, `const` |
| Declarations | `fn`, `interface`, `group`, `module`, `enum`, `ruleset` |
| Control | `if`, `else`, `while`, `through`, `loop`, `collect`, `filter`, `every`, `unique`, `break`, `continue`, `return` |
| Modules/lifetime | `use`, `lib`, `as`, `deploy`, `dismiss`, `region`, `scratch` |
| Errors | `try`, `catch`, `finally`, `throw` |
| Built-ins/other | `out`, `sizeof`, `type`, `string`, `int64`, `float64`, `sequence`, `exit`, `free`, `in`, `warnings`, `dynamic_casting`, `memory_limit` |

`map()` has a codegen handler but is not listed as a keyword in the supplied lexer table. A keyword list is not a list of all valid identifiers or callable built-ins.

### See also
[Grammar](grammar.md)
