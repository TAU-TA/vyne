# Recipe: catch a thrown value

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

**Goal:** Convert a thrown value into a visible diagnostic.

```vyne
try {
    throw "not ready";
} catch (message) {
    out(message);
}
```

**Expected output** (after integration verification):
```text
not ready
```

The catch variable is scoped to its handler. For cleanup and nested regions, see [error handling](../reference/errors.md) and [regions](../reference/regions.md).

### See also
[Error handling](../reference/errors.md)
