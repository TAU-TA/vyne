# Rulesets

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Syntax
```text
ruleset-declaration ::= "ruleset" identifier ...
ruleset-block       ::= "ruleset" "{" {rule} "}"
```

## Semantics
The lexer recognizes `warnings`, `dynamic_casting` and `memory_limit`. The parser accepts both a single setting and a block of settings; block values can include integers, strings, identifiers or arrays. Exact setting names, accepted values and scope of effect must be confirmed with parser diagnostics and tests before examples claim a particular mode.

## Edge cases
Do not assume a ruleset toggles only a runtime flag. Some settings affect parsing or type checking; ordering can matter.

### See also
[Variables](variables.md) · [Types](types.md)
