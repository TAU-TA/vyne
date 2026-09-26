# Variables and assignment

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Syntax
```text
declaration ::= ["const"] identifier "::" type ["=" expression] ";"
assignment  ::= identifier "=" expression ";"
```

## Semantics
You declare a typed variable with `::` and assign a new value with `=`. A `const` declaration restricts reassignment. The parser also handles declarations without an explicit type in non-strict configurations; do not assume they are accepted in strict mode. An indexed assignment uses `array[index] = value;`. Destructuring is not established by the supplied parser.

## Example
```vyne
score :: Int64 = 10;
score = score + 1;
out(score);
```

## Edge cases
The compiler’s distinction between native typed temporaries and boxed values does not change the spelling of an assignment. `??=` exists for variables and member accesses; see [expressions](expressions.md).

### See also
[Types](types.md) · [Rulesets](rulesets.md) · [Collections](collections.md)
