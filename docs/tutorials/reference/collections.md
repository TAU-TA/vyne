# Arrays and maps

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Purpose
Use arrays for indexed sequences and maps for string-keyed associations.

## Syntax
```text
array-literal ::= "[" [expression {"," expression}] "]"
index        ::= expression "[" expression "]"
```

## Semantics
Array indexes address elements; typed numeric arrays can avoid per-element boxing when their element type is proven. `map()` constructs an empty map; map operations exist in the runtime and method dispatcher. Map traversal order is unspecified. `sequence(start, end)` currently generates values from `start` up to but **excluding** `end` in the transpiler’s built-in implementation; verify edge cases in the complete compiler.

## Example
```vyne
xs :: Array = [10, 20, 30];
out(xs[0]);
xs[1] = 25;
out(xs[1]);
```

## Edge cases
Slicing and ranges are distinct operations; consult the parser and generated-C tests before publishing assertions about endpoint inclusivity for every syntax form. A typed array is an optimization, not permission to bypass lifetime rules.

### See also
[Types](types.md) · [Control flow](control-flow.md) · [Memory](regions.md)
