# Recipe: compute and print a value

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

**Goal:** Define a typed function and print its result.

```vyne
fn triple(n :: Int64) -> Int64 {
    return n * 3;
}
out(triple(7));
```

**Expected output** (after integration verification):
```text
21
```

The `Int64` parameter and return type make the contract explicit. Compare [functions](../reference/functions.md) and [built-ins](../reference/builtins.md).

### See also
[Functions](../reference/functions.md) · [Variables](../reference/variables.md)
