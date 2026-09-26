# Publication and verification checklist

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

**Status:** source-informed draft, not release-validated documentation.

For every `vyne` snippet, save it as a file and run: parser → transpiler → C compiler → program. Record the compiler version and command in the documentation repository. Also run the interpreter when a page claims interpreter support. Check exact output, including newline and failures.

Before release, obtain and document:
1. Official CLI commands, install locations and supported platforms.
2. Full module source and dispatch metadata for `vfs`, `vurage`, `vcv`, `vaudio`, `vnet`, `vserv`, `vml`, `vglib`.
3. Precedence/associativity table from parser tests; `through` mode results; interface and enum runnable examples.
4. Generic-instantiation guarantees, named arguments and default arity behavior.
5. Map traversal order, `free` policy, interpreter coverage, `break`/`continue` inside `try`.
6. Release version confirmation and diagnostics index completeness.

A source-visible feature is not automatically a user-stable guarantee. Mark unverified claims as such until a corresponding runnable test exists.
