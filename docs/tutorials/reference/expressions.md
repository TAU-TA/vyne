# Literals and expressions

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Syntax
```text
expression ::= literal | identifier | call | expression operator expression
range      ::= expression ".." expression
```

## Semantics
The lexer recognizes integer and floating literals, quoted strings, booleans, `null`, arithmetic and comparison operators, membership `in`, null-coalescing `??`, assignment `??=`, and pipeline `|>`. The parser also builds interpolated-string nodes. Consult [the operator table](../tables/operators.md) before depending on precedence.

## Example
```vyne
a :: Int64 = 2;
b :: Int64 = 3;
out(a + b);
out(a < b);
```

## Edge cases
Do not extrapolate string escape support or pipeline evaluation order from familiar languages. The source and generated-C paths must be tested for examples using nested calls with side effects.

### See also
[Variables](variables.md) · [Control flow](control-flow.md) · [Operator table](../tables/operators.md)
