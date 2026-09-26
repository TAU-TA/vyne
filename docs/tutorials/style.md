# Editorial style and notation

**Since:** v0.0.1-alpha (documentation target; release tag to confirm)

Use second person and present tense. Write types as `Int64`, `Array<Float64>`; prefer *interface* for user-visible declarations and *group* for namespacing. Use `vyne` fences for source, `sh` for commands and `text` for output. A reference topic follows **Purpose → Syntax → Semantics → Example → Edge cases → See also**. Use `> **Note:**` for context and `> **Caution:**` for lifetime or aliasing hazards.

Grammar uses light EBNF: `declaration ::= identifier "::" type ["=" expression] ";"`. Brackets mean optional, braces mean repetition; they are not source text. All examples here are illustrative until integration-tested. Never substitute a guessed CLI command or signature for missing evidence.

**Version policy:** the alpha tag above is the proposed documentation baseline, not a verified release number. Confirm it before publication.
