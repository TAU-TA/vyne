# Diagnostics index

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

The compiler emits `VNE-*` identifiers for some diagnostics. Confirm descriptions against the current diagnostics implementation before treating this as a complete index.

| Codes visible in supplied parser | Topic |
|---|---|
| `VNE-040`, `VNE-041` | Malformed interface type parameters |
| `VNE-042`, `VNE-043` | Malformed function type parameters |
| `VNE-050` | Invalid `region.` method (expected `commit`) |

Other codes exist in the parser and diagnostics header; enumerate them with tests before claiming a comprehensive error-code reference.

### See also
[Error handling](../reference/errors.md)
