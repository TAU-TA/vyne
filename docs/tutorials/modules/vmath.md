# vmath — numeric functions

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Importing
```vyne
module vmath;
```

## Function index
| Shape | Exported names |
|---|---|
| unary | `sqrt`, `abs`, `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `sinh`, `cosh`, `tanh`, `log`, `exp`, `floor`, `ceil`, `round`, `erf`, `erfc`, `tgamma`, `lgamma`, `sigmoid`, `relu`, `degrees`, `radians` |
| binary | `pow`, `hypot`, `fmod`, `min`, `max`, `random`, `random_float` |
| ternary | `clamp` |
| properties | `pi`, `e`, `tau`, `phi`, `inf`, `nan` |

This is the attached native map’s source-visible list. The header defines additional C helpers such as `log10` and `atan2`; do not assume those helpers are source-visible without dispatch entries. Trigonometric functions use radians. `random` uses an internal generator; do not rely on an implementation-specific sequence.

## Example
```vyne
module vmath;
out(vmath.sqrt(9));
out(vmath.pi);
```

### See also
[Module index](README.md) · [Expressions](../reference/expressions.md)
