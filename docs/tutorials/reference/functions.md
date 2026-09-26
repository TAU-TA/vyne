# Functions and calls

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Syntax
```text
function ::= "fn" identifier ["<" identifier {"," identifier} ">"]
             "(" [identifier "::" type {"," identifier "::" type}] ")"
             ["->" type] "{" {statement} "}"
```

## Semantics
A function can declare typed parameters and a return type. `return` exits the function. The parser accepts type parameter syntax, but generic instantiation limitations need compiler-team verification before documentation promises broad polymorphism. The transpiler emits a boxed call path and has optimized native paths when types are proven.

## Example
```vyne
fn square(x :: Int64) -> Int64 {
    return x * x;
}
out(square(5));
```

## Edge cases
Named arguments and default arity are proposed topics, not verified here. Do not publish their syntax without a tested example. Returning data from a region has lifetime implications.

### See also
[Variables](variables.md) · [Regions](regions.md) · [Errors](errors.md)
