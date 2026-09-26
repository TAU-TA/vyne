# Recipe: iterate without a collection

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

**Goal:** Process a fixed count of integer values.

```vyne
i :: Int64 = 0;
while (i < 4) {
    out(i);
    i = i + 1;
}
```

**Expected output** (after integration verification):
```text
0
1
2
3
```

A `while` loop is suitable here because the count is explicit. For collection transformations consult [control flow](../reference/control-flow.md) before selecting a `through` mode.

### See also
[Control flow](../reference/control-flow.md)
