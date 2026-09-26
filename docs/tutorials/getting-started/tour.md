# A short tour

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

Start with [Hello, world](hello.md). This example introduces declarations, arithmetic, control flow and a function; test it against your installed Vyne build before using it in a tutorial release.

```vyne
fn twice(x :: Int64) -> Int64 {
    return x * 2;
}

count :: Int64 = 3;
out(twice(count));
if (count > 0) {
    out("positive");
}
```

A declaration uses `::`; a function’s return type follows `->`. `if` selects a branch. Vyne also has arrays and string-keyed maps, `through … loop` iteration, `interface` declarations, `group` namespacing and `region` lifetime blocks. Read their dedicated pages before combining them: regions affect the lifetime of data created inside them.

### Learning path
1. [Types](../reference/types.md) and [variables](../reference/variables.md).
2. [Expressions](../reference/expressions.md), [control flow](../reference/control-flow.md), [functions](../reference/functions.md).
3. [Arrays and maps](../reference/collections.md), [regions](../reference/regions.md), [errors](../reference/errors.md).
4. [Modules](../modules/README.md) and [recipes](../cookbook/README.md).
