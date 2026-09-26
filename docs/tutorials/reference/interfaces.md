# Interfaces and structured values

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Syntax
```text
interface-declaration ::= "interface" identifier ["::" identifier] "{" ... "}"
```

## Semantics
You use `interface` to declare structured types with fields and methods. A declaration can bind to a module/group namespace with `::`. Member access and assignment use `object.field`. The compiler tracks some typed array fields; see [collections](collections.md).

## Example
A complete constructor and `self` example must be validated against the interface declaration grammar and method dispatcher before publication. The declaration above is a partial grammar sketch, not a runnable snippet.

## Edge cases
Do not assume all interface members have C-struct value semantics: the runtime uses tagged structured values. Field names and methods can take different dispatch routes.

### See also
[Groups and modules](groups-modules.md) · [Types](types.md)
