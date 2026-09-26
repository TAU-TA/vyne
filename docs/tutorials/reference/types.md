# Values and types

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Purpose
Types describe the values that expressions produce and the storage strategy the transpiler can choose.

## Syntax
```text
type ::= Int64 | Float64 | Bool | String | Array | Array<type> | Map | interface-name
```

## Semantics
`Int64` and `Float64` are numeric; `Bool` represents `true` or `false`. `null` is the absence of a value. `String` is a string value. `Array<T>` can use a typed numeric representation when `T` is `Int64` or `Float64` and the compiler can prove the element type; `Array` is a boxed representation. They are not separate user-visible container APIs. `Map` has string keys; do not rely on iteration order. Interfaces create structured values; see [interfaces](interfaces.md).

A bare declaration may receive a default value: numeric zero, `false`, empty string or array, or `null` for a structured value. Whether an untyped declaration is accepted depends on type strictness and rulesets.

## Example
```vyne
n :: Int64 = 12;
name :: String = "Vyne";
out(n);
out(name);
```

## Edge cases
Do not treat a value created inside a region as valid after the region rewinds unless it was committed. Exact sizes and layout are not part of the source-language contract.

### See also
[Collections](collections.md) · [Variables](variables.md) · [Regions](regions.md)
