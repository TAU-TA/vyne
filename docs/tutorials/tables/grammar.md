# Grammar quick reference

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

Descriptive EBNF fragments, not a formal normative specification:

```text
program      ::= {statement}
block        ::= "{" {statement} "}"
function     ::= "fn" identifier "(" [parameters] ")" ["->" type] block
variable     ::= ["const"] identifier "::" type ["=" expression] ";"
region       ::= "region" identifier block ";"
commit       ::= "region.commit(" expression ");"
try          ::= "try" block ["catch" ["(" identifier ")"] block]
                 ["finally" block]
module       ::= "module" identifier ";"
iteration    ::= "through" [identifier "::"] expression ["->"] mode block
mode         ::= "loop" | "collect" | "filter" | "every" | "unique"
```

These productions abbreviate parser alternatives. `block` after `through` may be omitted in the supplied parser, which supplies an iterator expression by default. Treat this page as a navigation aid until a formal grammar is extracted and tested.

### See also
[Reference index](../reference/README.md)
