# Enums

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Purpose
Use an enum to give names to related values.

## Semantics
The parser and codegen include `EnumNode`; consult your build’s tests before relying on auto-numbering rules, duplicate-name handling or an `Int64` backing type as a stable public guarantee.

## Example
The declaration grammar and a runnable snippet remain a publication gate; see [verification](../verification.md). Avoid guessing the initializer syntax.

### See also
[Types](types.md) · [Expressions](expressions.md)
