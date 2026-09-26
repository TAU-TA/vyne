# Groups, modules and imports

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

## Syntax
```text
module-declaration ::= "module" identifier ";"
import             ::= "use" ["lib"] string ["as" identifier] ";"
```

## Semantics
`group` names a scope; `module` makes a named built-in module available to source code. `use` imports a path, optionally under an alias; `use lib` selects the external-module route. `deploy` and `dismiss` are distinct statements; their emitted runtime hooks may currently have no observable effect. Import paths are resolved by the project linker.

## Example
```vyne
module vmath;
out(vmath.sqrt(9));
```

## Edge cases
The installed module set is not fully represented in these attachments. Module availability is deployment-dependent; see [module index](../modules/README.md).

### See also
[Interfaces](interfaces.md) · [vmath](../modules/vmath.md)
