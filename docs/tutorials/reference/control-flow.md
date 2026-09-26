# Control flow and iteration

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Syntax
```text
conditional ::= "if" "(" expression ")" statement ["else" statement]
iteration   ::= "through" [identifier "::"] expression ["->"] mode block
mode        ::= "loop" | "collect" | "filter" | "every" | "unique"
```

## Semantics
`if` chooses a branch; `while` repeats a body while its condition is truthy. `through` accepts an optional named iterator before `::`, an iterable, an optional `->`, then one of five modes. `loop` performs iterations; other modes produce or evaluate derived results, with mode-specific behavior requiring runnable regression examples before a normative promise. `break` and `continue` leave/advance a loop.

## Example
```vyne
i :: Int64 = 0;
while (i < 3) {
    out(i);
    i = i + 1;
}
```

## Edge cases
The supplied codegen rejects some `break` and `continue` placements inside `try`; verify the exact diagnostic and scope before documenting a universal rule. Exiting a region from a loop invokes special cleanup logic.

### See also
[Functions](functions.md) · [Regions](regions.md) · [Errors](errors.md)
