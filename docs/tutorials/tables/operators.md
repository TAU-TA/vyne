# Operators and precedence

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

The lexer and AST support arithmetic, comparisons, logical operations, membership `in`, coalescing `??`, coalescing assignment `??=`, pipeline `|>`, ranges `..` and ternary `?:`.

| Family | Examples | Notes |
|---|---|---|
| arithmetic | `+`, `-`, `*`, `/`, `%`, `**` | Verify exact power token against the lexer before publication |
| comparison | `==`, `!=`, `<`, `<=`, `>`, `>=` | Return boolean results |
| logical | `&&`, `||`, `!` | Confirm evaluation/short-circuit semantics per backend |
| membership | `in` | Collection-dependent behavior |
| null handling | `??`, `??=` | Fallback and conditional assignment |
| composition | `|>`, `?:`, `..` | Pipeline, ternary and range |

**Precedence ordering is intentionally not asserted here.** A definitive table requires an exhaustive check of recursive-descent parser layers and executable associativity tests, especially for pipeline and range. Parenthesize mixed operators meanwhile.

### See also
[Expressions](../reference/expressions.md)
