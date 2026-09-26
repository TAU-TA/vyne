# Memory and regions

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Purpose
A region bounds the lifetime of arena-allocated values created while the region is active.

## Syntax
```text
region-statement ::= "region" identifier "{" {statement} "}" ";"
commit-statement ::= "region" "." "commit" "(" expression ")" ";"
```

## Semantics
The compiled backend saves an arena checkpoint when it enters a region and rewinds when it leaves. A committed value is copied into a second arena that survives the rewind. Commit storage currently persists until global arena cleanup, so commits in an unbounded loop can grow memory. `vmem.total_allocated()` reports arena accounting; do not interpret it as exact process memory usage.

## Example
```vyne
region temporary {
    out("inside region");
};
```

> **Caution:** A value referring to memory allocated inside a region may dangle after rewind. Do not assume an alias escapes safely; commit the value when it must survive.

## Edge cases
The parser requires `;` after the closing region brace. Regions are a compiled-code feature; the interpreter's behavior must be verified before promising support. Returns, breaks and continues use special cleanup paths.

### See also
[vmem](../modules/vmem.md) · [Control flow](control-flow.md) · [Errors](errors.md)
