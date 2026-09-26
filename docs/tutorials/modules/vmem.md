# vmem — memory checkpoints

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Importing
```vyne
module vmem;
```

## Function index
| Function | Purpose |
|---|---|
| `checkpoint()` | Obtain a checkpoint handle |
| `rewind(handle)` | Rewind to a previously acquired checkpoint |
| `total_allocated()` | Report arena allocation accounting |
| `reset()` | Drop arena storage (development use only) |

The native map exposes these four functions. A separate compiler-generated `region.commit(...)` path uses the module header's clone helper but is not a normal `vmem` method. Handles are invalid after rewind/reset; preserve no references to reclaimed allocations.

## Example
```vyne
module vmem;
out(vmem.total_allocated());
```

> **Caution:** `reset()` invalidates arena-backed values. `total_allocated()` is not a portable measure of process RSS.

### See also
[Regions](../reference/regions.md) · [Module index](README.md)
