# Error handling

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Syntax
```text
try-statement ::= "try" block ["catch" ["(" identifier ")"] block]
                  ["finally" block]
throw-statement ::= "throw" expression ";"
```

## Semantics
A `try` requires a `catch`, a `finally`, or both. You may name the caught value in parentheses. `throw` transfers control to a matching handler; an uncaught throw terminates the compiled program. The C runtime uses a bounded exception frame stack.

## Example
```vyne
try {
    throw "problem";
} catch (error) {
    out(error);
}
```

## Edge cases
`break` and `continue` inside protected blocks need compiler-specific testing. Returning from `try` and unwinding regions also affect cleanup; do not infer the order of nested `finally` and region cleanup without an integration test.

### See also
[Control flow](control-flow.md) · [Regions](regions.md)
