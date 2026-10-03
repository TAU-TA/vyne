# Vyne

> A C-flavored scripting language with optional strict typing, interface-based
> structs, and a standard library that ranges from scalar math to 3D graphics,
> real-time audio DSP, and HTTP servers.

[![CI](https://github.com/tuncaygafarli/vyne/actions/workflows/c-cpp.yml/badge.svg)](https://github.com/tuncaygafarli/vyne/actions/workflows/c-cpp.yml)
[![Docs](https://github.com/tuncaygafarli/vyne/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/tuncaygafarli/vyne/actions/workflows/pages/pages-build-deployment)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![C++17](https://img.shields.io/badge/C%2B%2B-17-00599C.svg)](https://isocpp.org/)
[![Version](https://img.shields.io/badge/version-0.0.4--alpha-orange.svg)](CHANGELOG.md)
[![Platforms](https://img.shields.io/badge/platforms-linux%20%7C%20macOS%20%7C%20windows-lightgrey.svg)](#build-from-source)

---

## Overview

Vyne is a statically-analyzable scripting language with two execution
backends sharing a single AST:

- a **tree-walking interpreter** for fast iteration and REPL use, and
- a **C transpiler** that lowers the same AST to a single, self-contained C
  translation unit that links against a small arena-based runtime.

The language is deliberately C-shaped: braces, semicolons, `fn` for
declarations, `if`/`while`/`through` for control flow, and `::` for
type-annotated bindings. It adds the features that make a scripting layer
pleasant to write — first-class functions, pipeline operator, null
coalescing, string interpolation, interface-based structs, generics via
monomorphization — without giving up the ability to run without a garbage
collector.

Every value the compiled backend produces lives in an arena. There is no
GC, no reference counting, no hidden allocator traffic inside numeric
loops. A region block scopes that arena lexically: `region name { ... }`
takes a checkpoint on entry, and every allocation made inside the block is
reclaimed at the closing brace. Programs that use regions have flat peak
memory regardless of iteration count.

```vyne
# hello.vy
msg = "vyne" + " language";
out(msg);                     # vyne language

# typed binding with explicit strictness
age :: Int64 = 30;

# range loop that collects
doubled = through x :: 0..10 -> collect { x * 2 };
out(doubled);                 # [0, 2, 4, ..., 20]

# pipeline
result = 5 |> double |> square;
```

---

## Table of contents

- [Why Vyne](#why-vyne)
- [Quick start](#quick-start)
- [Language tour](#language-tour)
- [Memory model](#memory-model)
- [Standard library](#standard-library)
- [External library system](#external-library-system)
- [Transpiler architecture](#transpiler-architecture)
- [Diagnostics](#diagnostics)
- [Performance](#performance)
- [CLI reference](#cli-reference)
- [Build from source](#build-from-source)
- [Project layout](#project-layout)
- [Editor support](#editor-support)
- [Limitations](#limitations)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

---

## Why Vyne

Most scripting languages force a choice between two extremes: either an
interpreter with a garbage collector and no path to a standalone binary, or
a compiled language where a quick edit means a full build cycle. Vyne is
built to occupy the middle ground.

**Two backends, one AST.** The interpreter and the C transpiler consume the
same parsed tree. A program that runs under `vynec script.vy` behaves
identically under `vynec --compile script.vy`; the difference is that the
second form produces a native binary that links against a small runtime
(~50 KB baseline) and inherits the host C compiler's optimizer.

**Deterministic memory, no GC.** Values live in a bump arena. `region`
blocks reclaim everything allocated inside them. There are no pauses, no
finalizers, and no inference about liveness in the compiled output.

**Native ABI where it matters.** The transpiler specializes functions
whose parameters and return type are all primitives or typed arrays. A
function with signature `(Array<Float64>, Int64) -> Float64` compiles to
the equivalent C function taking `double*` and `int64_t`, with no boxing,
no tag check, and no arena traffic inside the loop. The kernel/wrapper
split that appears throughout the library ecosystem (`vlin`, `vfft`,
`vml`) is a direct consequence of this design.

**A standard library that reaches from scalar math to web servers.**
`vmath`, `vcore`, `vfs`, `vmem` cover the basics. `vglib` (Raylib),
`vaudio` (DSP), `vserv` (HTTP/WebSocket), `vnet` (raw sockets), `vcv`
(computer vision), and `vurage` (embedded database) cover the rest.
They are native C++ modules registered into the interpreter and exposed
identically to compiled programs.

---

## Quick start

```bash
git clone https://github.com/tuncaygafarli/vyne.git
cd vyne
make
./vynec examples/hello.vy
```

Transpile a program to a standalone binary:

```bash
./vynec --compile examples/logic_test.vy
# emits logic_test.vy.c and compiles it against runtime/vyne_runtime.h
# produces ./logic_test
```

Enable BLAS dispatch for matrix operations:

```bash
./vynec --compile examples/benchmark/matmul_1024_vlin.vy --blas
```

Start the REPL:

```bash
./vynec
```

---

## Language tour

### Bindings

```vyne
x = 42;                     # inferred
y :: Int64 = 42;            # explicit
const PI :: Float64 = 3.141592653589793;
```

Under `ruleset { strict_mode = true }`, `x = 42` without a type is a
compile error. The default is dynamic binding with a warning.

### Primitive types

| Type       | Example           | Notes                                    |
| ---------- | ----------------- | ---------------------------------------- |
| `Int64`    | `42`              | 64-bit signed                            |
| `Float64`  | `3.14`            | IEEE-754 double                          |
| `String`   | `"hello"`         | UTF-8, immutable, interned               |
| `Bool`     | `true`, `false`   |                                          |
| `Null`     | `null`            |                                          |
| `Array`    | `[1, "two", 3.0]` | heterogeneous                            |
| `Array<T>` | `Array<Float64>`  | typed array, native ABI on the C backend |
| `Map`      | `{"key": 42}`     | string keys                              |

### Control flow

```vyne
if x > 0 {
    out("positive");
} else if x < 0 {
    out("negative");
} else {
    out("zero");
}

while running {
    step();
}

# range loop with a mode
squares = through i :: 1..10 -> collect { i * i };
evens   = through i :: 0..100 -> filter { i % 2 == 0 };
allPos  = through i :: list -> every { i > 0 };
uniq    = through i :: list -> unique { i };
```

The `through ... -> mode` form is the language's canonical iteration
construct. Modes are `loop` (side effects only), `collect`, `filter`,
`every`, and `unique`.

### Functions

```vyne
fn add(a :: Int64, b :: Int64) -> Int64 {
    return a + b;
}

fn max_of<T>(a :: T, b :: T) -> T {
    if a > b { return a; }
    return b;
}
```

Generic parameters (`<T>`) are monomorphized at code generation time;
calls like `max_of<Int64>(3, 5)` and `max_of<Float64>(3.0, 5.0)` produce
two distinct C functions.

### Interfaces

`interface` declares a struct as a set of typed fields plus methods that
close over them. An interface is also the constructor for values of that
type.

```vyne
interface Circle {
    r :: Float64;
    area() -> Float64 {
        return r * r * 3.141592653589793;
    }
}

c = Circle(4.0);
out(c.area());     # 50.26544
```

Interfaces are the mechanism behind every struct-typed value in the
standard library — `vlin.Types.Matrix`, `vfft.Plan`, `vjson.Parser`,
`vml.Types.Dense`. Their field layouts participate in the native-ABI
dispatch: a struct-typed parameter expands into one C argument per field,
so the caller and callee agree on a flat, unboxed calling convention.

### Groups

`group` namespaces functions and constants without introducing a type.

```vyne
group Geometry {
    fn area_of_circle(r :: Float64) -> Float64 {
        return r * r * 3.141592653589793;
    }
    const TAU :: Float64 = 6.283185307179586;
}

out(Geometry.area_of_circle(2.0));
```

### Enums

```vyne
enum Color {
    RED = 0,
    GREEN,
    BLUE,
}

out(Color.GREEN);   # 1
```

### Error handling

```vyne
try {
    parse(input);
} catch (err) {
    out("failed: " + string(err));
} finally {
    cleanup();
}
```

Exceptions are `longjmp`-based on the compiled backend (`VYNE_MAX_EXC_FRAMES`
= 64) and stack-unwound in the interpreter. `throw` accepts any value.

### Operators

| Operator | Meaning                  | Example                  |
| :------- | :----------------------- | :----------------------- |
| `..`     | Range (inclusive)        | `0..10`                  |
| `:`      | Slice (in `[...]`)       | `s[1:3]`                 |
| `?:`     | Ternary                  | `ready ? "go" : "wait"`  |
| `??`     | Null coalesce            | `name ?? "anon"`         |
| `??=`    | Null coalesce assignment | `cfg.mode ??= "default"` |
| `\|>`    | Pipeline                 | `data \|> normalize`     |
| `in`     | Membership               | `x in [1, 2, 3]`         |
| `//`     | Floor division           | `7 // 2`                 |
| `**`     | Power                    | `2 ** 10`                |
| `&`      | Reference parameter      | `fn bump(v :: Int64&)`   |
| `$`      | Address-of               | `$target`                |

### Rulesets

`ruleset` declares compile-time and runtime policy. It can appear at any
scope; the effect applies from that point forward.

```vyne
ruleset {
    strict_mode      = true,
    dynamic_casting  = false,
    memory_limit     = 256 * 1024 * 1024,
    optimization     = 2,
    warnings         = "all",
    warnings_ignore  = ["unused_variable"],
};
```

Available categories: type system, memory, performance, runtime, security,
warnings, and experimental flags. The full table is in
[`docs/content/rulesets.html`](docs/content/rulesets.html).

### Regions

A `region` block scopes arena lifetime lexically.

```vyne
through epoch :: 1..N -> loop {
    region train_step {
        scratch grad :: Float64[64, 16];
        # every allocation here is reclaimed at the closing brace
    };
};
```

Three region policies exist:

- `region name { ... }` — default bump-checkpoint/rewind behavior.
- `@pool<Float64, 64> region name { ... }` — fixed-capacity slot
  allocator for repeated same-sized buffers.
- `@speculative region name { ... }` — the rewind is conditional on
  `region.commit_if(predicate)`; the region's allocations survive if any
  commit fires.

Region escape analysis (`VNE-070`) rejects assignments that would write a
region-local pointer into a shallower variable, catching the most common
use-after-rewind bug at compile time.

### Shaped scratch arrays

```vyne
region kernel {
    scratch grad_w1 :: Float64[64, 16];
    scratch grad_b1 :: Float64[16];
    # lowered to `double grad_w1[1024];` on the C stack
}
```

`scratch` is codegen-only. The interpreter rejects it with a clear
diagnostic rather than silently emulating the semantics.

---

## Memory model

Vyne's compiled backend uses a bump arena with three components.

### Main arena

`arena_alloc(n)` bumps a pointer in the current block. Blocks default to
8 MB and are backed by `mmap` with `MADV_HUGEPAGE` on Linux, `VirtualAlloc`
on Windows, and `malloc` elsewhere. Allocation is a pointer increment plus
a bounds check.

### Commit arena

`region.commit(x)` deep-clones `x` into a parallel arena that survives
region rewinds. The committed value stays valid after the enclosing region
closes. Committed storage is freed at program exit; escape analysis to
determine earlier free points is a planned feature.

### Checkpoints

`vmem.checkpoint()` records `(block, offset)` and returns an `Int64`
handle. `vmem.rewind(h)` frees every block created after that checkpoint
and resets the bump pointer. Nested checkpoints form a stack; rewinding to
slot `k` invalidates slots `k..top`.

The region syntax is sugar over this. `region name { ... }` compiles to
a checkpoint, the body, and a rewind at the closing brace.

### Interning

Every identifier and map key is interned in a process-global string pool.
Symbol lookups compare `uint32_t` IDs instead of strings. The intern table
itself lives outside the arena (malloc-backed) so a rewind cannot
invalidate it.

### Typed arrays

`Array<Float64>` and `Array<Int64>` are represented at runtime by
`VyneArray_f64` and `VyneArray_i64`, structs holding a raw `double*` or
`int64_t*` plus size and capacity. Boxing a typed array into a `VyneValue`
is O(1) — it wraps the pointer, it does not copy elements. Unboxing a
`V_F64_ARRAY` is likewise O(1). This is what makes `A.data[i]` compile to
a direct load.

---

## Standard library

Native modules are implemented in C++ and registered into the interpreter's
symbol tables. The C transpiler emits calls into a parallel set of
`static inline` C functions in `runtime/modules/`. Both backends expose the
same surface.

### Core

| Module  | Purpose                                                                                                              |
| :------ | :------------------------------------------------------------------------------------------------------------------- |
| `vcore` | System utilities: `now`, `now_ns`, `sleep`, `platform`, `input`, string builder, `memory_usage`, `pid`, process info |
| `vmath` | Trig, exp/log, rounding, sigmoid/relu, clamp, PCG32 random                                                           |
| `vfs`   | Filesystem: read, write, lines, bytes, walk, glob, mkdir, path ops                                                   |
| `vmem`  | Arena checkpoints, peak tracking, live-state inspection, commit                                                      |

### Extended

| Module   | Purpose                                                                |
| :------- | :--------------------------------------------------------------------- |
| `vglib`  | 2D/3D graphics on Raylib: shapes, cameras, shaders, input, textures    |
| `vaudio` | Real-time DSP: compressor, 7-band EQ, FDN reverb, LUFS, BPM, saturator |
| `vserv`  | HTTP/WebSocket server: Express-style routing, middleware, static files |
| `vnet`   | Raw sockets                                                            |
| `vcv`    | Computer vision                                                        |
| `vurage` | Embedded key/value database                                            |

### Built-in functions

```vyne
out(x)          # print
type(x)         # "Int64" | "Float64" | "String" | "Array" | "Map" | ...
sizeof(x)       # length of a string or array
string(x)       # any value -> String
int64(x)        # any value -> Int64
float64(x)      # any value -> Float64
sequence(lo, hi)# generate [lo, hi)
exit(code)      # terminate
free(x)         # no-op on the compiled backend (arena); releases object on the interpreter
```

---

## External library system

Libraries written in Vyne itself live under `modules/external/`. A facade
`.vy` file re-exports the leaf modules via `use lib` and `module`. The
language's own numeric and data-processing stack is written this way.

### Libraries in this repository

| Library    | Purpose                                                                 |
| :--------- | :---------------------------------------------------------------------- |
| `vjson`    | RFC 8259 parser and serializer, built on the vcore string builder       |
| `vlin`     | Dense linear algebra: matrices, matmul, reductions, element-wise ops    |
| `vml`      | Dense neural network primitives: `Dense`, `Sequential`, `SGD`, `Adam`   |
| `vfft`     | Iterative radix-2 Cooley-Tukey FFT with plan caching and bit-reversal   |
| `vrand`    | Distributions and sampling: normal, gamma, beta, Poisson, categorical   |
| `vbio`     | Nucleotide and protein sequence primitives: complement, translation, GC |
| `vcolors`  | ANSI color helpers                                                      |
| `vconvert` | Data format conversion                                                  |
| `vstring`  | String utilities                                                        |
| `vplot`    | Plotting                                                                |

Each library ships with a full manual in its directory. `vlin/README.md`,
`vml/README.md`, `vjson/README.md`, `vfft/README.md`, `vrand/README.md`,
and `vbio/README.md` are the reference for the user-visible surface.

### Kernel/wrapper pattern

Every performance-sensitive library in this repository splits into two
layers:

```
Kernels.vy    # loops over typed arrays; native ABI; no boxing
Ops.vy        # shape checks, allocation, dispatch to kernels
```

The kernels are functions of the form
`(Array<Float64>, Int64) -> Float64` or
`(Array<Float64>, Array<Float64>, Int64) -> Int64`. The transpiler
recognizes this shape and emits a direct C function; the wrappers handle
shape validation, scratch buffer allocation, and dispatch.

### BLAS dispatch

`vlin.multiply` and `vlin.multiply_trans_b` lower to `cblas_dgemm` when
the compiler is invoked with `--blas`. The dispatch table lives in
`compiler/codegen/blas_dispatch.h`; the runtime bridge is
`runtime/detail/blas_bridge.h`. Source is unchanged between the two
modes — only the lowering of the matched calls differs.

---

## Transpiler architecture

### Pipeline

```
source.vy
    │
    ▼
tokenize()          compiler/lexer
    │
    ▼
Parser              compiler/parser
    │  recursive descent, scope tracking, type resolution
    ▼
ASTNode tree        compiler/ast
    │
    ├──► Interpreter    evaluate(env, scopeId) against SymbolContainer
    │
    └──► C_Emitter      compiler/codegen
            │
            ▼
        single .c file  linked against runtime/vyne_runtime.h
```

### Codegen structure

The codegen directory is split per feature, not per file-organization
convenience. Each `.cpp` owns one category of AST node and its lowering:

| Source                                              | Responsibility                                          |
| :-------------------------------------------------- | :------------------------------------------------------ |
| `literals.cpp`                                      | Number, string, bool, null                              |
| `assignments.cpp`                                   | Variables, assignment, native init, region escape       |
| `operators.cpp`                                     | Binary, unary, postfix                                  |
| `builtins.cpp`                                      | `out`, `string`, `int64`, `sizeof`, ...                 |
| `control_flow.cpp`, `loops.cpp`                     | `if`, `while`, `through`, `return`, `break`, `continue` |
| `functions.cpp`, `function_calls.cpp`               | Definitions, calls, native dispatch                     |
| `collections.cpp`                                   | Arrays, indexing, slicing, ranges                       |
| `members.cpp`, `interfaces.cpp`, `method_calls.cpp` | Fields and methods                                      |
| `groups_modules.cpp`, `imports.cpp`                 | Groups, modules, imports                                |
| `language_features.cpp`                             | Enums, defer, coalescing, membership, pipeline          |
| `exceptions.cpp`                                    | Try/catch/finally/throw                                 |
| `regions.cpp`                                       | `region`, `@pool`, `@speculative`, `region.commit`      |
| `maps_strings_scratch.cpp`                          | Maps, interpolated strings, shaped scratch arrays       |
| `program.cpp`                                       | Program, block, ternary                                 |
| `native_dispatch.cpp`                               | Native-ABI call lowering                                |
| `blas.cpp`                                          | BLAS lowering under `--blas`                            |

`emitter.h` holds all per-compilation state: output streams, scope stack,
static type tables, native variant registry, region stack, pool stack,
speculative stack, monomorphization cache. Every `C_Emitter` method is
either a query against that state or a mutation of it; the AST nodes
themselves are immutable after parsing.

### Name mangling

Groups, interfaces, and function names mangle deterministically:

```
Master.Element.getName()      →  fn_Master_Element_getName
vlin.Types.Matrix             →  struct_vlin_Types_Matrix
vlin.cross_entropy            →  fn_vlin_Reductions_cross_entropy
```

The mangling scheme is the interface between the compiler and the runtime
method table (`vyne_register_method`). `VYNE_MAX_METHODS` is 4096; the
compiler emits a diagnostic when a program exceeds it.

### Native ABI

A function is a candidate for native lowering when:

- every parameter is a primitive (`Int64`, `Float64`, `Bool`), a typed
  array (`Array<Float64>` or `Array<Int64>`), or a struct with a
  registered field layout,
- the return type is a primitive, a typed array, or such a struct, and
- the body does not contain a top-level `defer` or `try`.

Such a function is emitted twice: once with the standard boxed signature
`(int arg_count, VyneValue* args) -> VyneValue`, and once with the native
signature, e.g.

```c
double fn_vlin_k_dot(double* a, double* b, int64_t n);
```

Call sites prefer the native variant when every argument matches the
declared parameter type. Struct-typed parameters expand into one C
argument per field, in field-declaration order. Array-typed parameters
pass `.data` directly.

### Monomorphization

Generic functions with explicit type arguments are instantiated per
distinct type tuple. The cache is keyed on
`<mangled-fn-name>__<type-tuple>` and stores the emitted C name. Recursive
instantiation is detected and terminates cleanly.

### Region escape analysis

`checkRegionEscape` in `assignments.cpp` rejects the pattern

```vyne
outer = allocate_inside_region();
```

where `outer` was declared at shallower region depth than the current one
and the RHS is not provably primitive. The diagnostic (`VNE-070`) names
the variable, both depths, the line, and three fixes. This is deliberately
syntactic; the regions paper documents what the check cannot see, and the
current implementation does not attempt to close those gaps.

---

## Diagnostics

The compiler produces colorized, source-annotated diagnostics with stable
codes. `runtime/diagnostics.h` owns the emission engine; every site in
`compiler/` uses `emitError` / `emitWarning` / `emit`.

```
Error [VNE-070]: variable 'out' is declared outside the current region
    (depth 0) but is being assigned a value allocated inside a region
    (current depth 1) at line 42.
  Suggestions:
    - declare 'out' inside the region, or
    - copy the value out with region.commit(tmp) and assign from tmp, or
    - move the assignment to before the region.
   42 |     out = make_buffer();
      |     ^
```

Selected codes:

| Code      | Meaning                              |
| :-------- | :----------------------------------- |
| `VNE-001` | Unexpected token                     |
| `VNE-002` | Missing semicolon                    |
| `VNE-003` | Unknown type name                    |
| `VNE-005` | Unresolved import                    |
| `VNE-070` | Region escape                        |
| `VNE-071` | Scratch shape mismatch               |
| `VNE-072` | Scratch index out of bounds          |
| `VNE-080` | Invalid region policy argument       |
| `VNE-082` | Pool region exhausted                |
| `VNE-084` | `region.commit` on typed-array local |
| `VNE-085` | `commit_if` outside `@speculative`   |
| `VNE-100` | Method table overflow                |

The full list is in `docs/content/errcodes.html`.

---

## Performance

### Recursive Fibonacci (n = 30)

Both numbers are wall time of the fib(30) call, measured in-process.
Process startup and codegen/compile time are excluded.

| Backend      | Time     | Relative     |
| :----------- | :------- | :----------- |
| Interpreter  | 54.52 ms | 1.00x        |
| C transpiler | 19.87 ms | 2.74x faster |

Measured on i7-14700, Windows 11. Transpiler build: `--blas --native`,
GCC `-O3 -march=native`. Source is untyped-recursion `fn fib(n)`;
adding `:: Int64` annotations does not change the transpiler result
(the native-variant path is already taken) but does improve the
interpreter by roughly 2x.

### Dense matmul (1024x1024, 100 iterations)

The same Vyne source is compiled three ways:

| Build                             | Kernel                               |
| :-------------------------------- | :----------------------------------- |
| `vynec --compile`                 | Emitted C triple loop                |
| `vynec --compile --blas`          | `cblas_dgemm`                        |
| `vynec --compile --blas --native` | `cblas_dgemm` + host `-march=native` |

See `examples/benchmark/matmul_1024_vlin.vy`. The source is byte-identical
across the three modes; only the lowering of `vlin.multiply` differs.

### End-to-end ML workload

`examples/training/ml_seq.vy` trains a 64→16→12→1 classifier on 240 RNA
sequences for 1000 epochs. With regions scoping per-iteration allocations,
peak RSS stays flat regardless of epoch count.

---

## CLI reference

```
vynec [options] <file.vy>
```

| Flag           | Effect                                                    |
| :------------- | :-------------------------------------------------------- |
| _(none)_       | Run under the interpreter                                 |
| `--compile`    | Transpile to C and invoke the host C compiler             |
| `--interp`     | Force the interpreter even for scripts that ship compiled |
| `--blas`       | Lower matched matrix calls to BLAS                        |
| `--native`     | Add `-march=native` to the host compiler invocation       |
| `--emit-c`     | Emit the C source without invoking the host compiler      |
| `--out <name>` | Set the output binary name                                |
| `--quiet`      | Suppress notes and warnings                               |
| `--strict`     | Enable strict type checking                               |

Diagnostics are written to stderr. Exit codes are `0` on success, `1` on
compilation or runtime error, `2` on CLI misuse.

---

## Build from source

### Prerequisites

- C++17 compiler (GCC 9+, Clang 10+, MSVC 19.20+)
- Make or CMake 3.15+
- A C11 compiler for the generated output (default: the same compiler)

Vendored dependencies under `vendor/`: Raylib (graphics and audio),
OpenBLAS (optional, for `--blas`), stb (image, font, truetype), Urage
(embedded database). OpenSSL is optional and only required for the
WebSocket SHA-1 handshake path in `vserv`.

### Build

```bash
make
```

Produces `vynec` in the repository root. On Windows, `build.bat` performs
the equivalent.

### Test

```bash
make test
```

Runs the suite under `tests/`, including compiler tests, DSP tests,
graphics smoke tests, and the region-safety harness under
`examples/safety/`.

---

## Project layout

```
vyne/
├── main.cpp                       # entry point
├── Makefile
├── compiler/
│   ├── lexer/                     # tokenizer, string interpolation
│   ├── parser/                    # recursive descent, type resolution
│   ├── ast/                       # AST nodes, Value type, SymbolContainer
│   │   ├── ast.h / ast.cpp
│   │   ├── ast_helpers.h
│   │   └── value.h / value.cpp
│   ├── codegen/                   # C transpiler (split per feature)
│   │   ├── emitter.h              # per-compilation state
│   │   ├── ctype.h                # VType -> C type mapping
│   │   ├── native_maps.h          # native module symbol tables
│   │   ├── native_dispatch.cpp    # native-ABI call lowering
│   │   ├── blas.cpp, blas_dispatch.h
│   │   ├── regions.cpp            # region/pool/speculative lowering
│   │   ├── linker.cpp             # import graph, topological order
│   │   └── *.cpp                  # per-feature emitters
│   └── types.h                    # VType enum
│
├── runtime/                       # C runtime, linked into compiled output
│   ├── vyne_runtime.h             # public entry
│   ├── diagnostics.h              # diagnostic engine (shared with compiler)
│   ├── detail/                    # arena, arrays, maps, strings, structs,
│   │                              # operators, equality, exceptions, ...
│   └── modules/                   # C mirror of each native module
│       ├── vcore.h, vfs.h, vmath.h, vmem.h
│       └── vyne_pool_runtime.h
│
├── modules/
│   ├── common/                    # native C++ module bindings
│   │   ├── vcore/                 # system utilities
│   │   ├── vmath/                 # scalar math
│   │   ├── vfs/                   # filesystem
│   │   ├── vmem/                  # memory
│   │   ├── vglib/                 # graphics (Raylib)
│   │   ├── vaudio/                # DSP: compressor, EQ, reverb, LUFS, ...
│   │   ├── vserv/                 # HTTP/WebSocket
│   │   ├── vnet/                  # sockets
│   │   ├── vcv/                   # computer vision
│   │   ├── vml/                   # ML native bindings
│   │   └── vurage/                # embedded database
│   └── external/                  # libraries written in Vyne
│       ├── vjson/                 # JSON parser and serializer
│       ├── vlin/                  # linear algebra
│       ├── vml/                   # neural network primitives
│       ├── vfft/                  # FFT with plan caching
│       ├── vrand/                 # distributions and sampling
│       ├── vbio/                  # bioinformatics
│       ├── vcolors.vy, vconvert.vy, vplot.vy, vstring.vy
│
├── cli/                           # REPL, file handler, packager
├── editors/
│   ├── vscode/lsp/                # VS Code extension + LSP backend
│   └── nvim/                      # Neovim plugin
│
├── examples/                      # language and library examples
│   ├── benchmark/                 # matmul, recursion, ML training
│   ├── dsp/                       # vaudio pipelines
│   ├── graphics/                  # vglib demos, shaders
│   ├── network/                   # vnet and vserv
│   ├── safety/                    # region escape negative tests
│   ├── training/                  # vlin/vml training scripts
│   └── transpiler/                # codegen coverage tests
│
├── models/                        # pre-trained weights (.dat)
├── tests/                         # test suite
├── docs/                          # documentation site
├── scripts/                       # build and test scripts
└── vendor/                        # third-party libraries
    ├── raylib/
    ├── openblas/
    ├── stb/
    └── urage/
```

---

## Editor support

### VS Code

A language server and extension are under `editors/vscode/lsp/`. The
extension ships syntax highlighting (TextMate grammar), a language
configuration file, and a client for the LSP backend in `backend/`.
Prebuilt VSIX packages are checked in.

### Neovim

A minimal plugin under `editors/nvim/` provides file-type detection
(`ftdetect/vyne.lua`), an LSP client (`lua/vyne_lsp.lua`), and a syntax
file (`syntax/vyne.vim`).

### Doxygen

The compiler and runtime are Doxygen-annotated. `doxygen Doxyfile`
generates HTML documentation covering the AST hierarchy, module
bindings, and call graphs.

---

## Limitations

The project is at an early alpha. The following constraints are known and
tracked; they are documented here so users and contributors have accurate
expectations.

**No bitwise operators.** `&`, `|`, `^`, `~`, `<<`, `>>` are not part of
the grammar. `&` is unary address-of, `&&` and `||` are logical
connectives. This affects library code that would otherwise use bit
manipulation (the bit-reversal routine in `vfft` is arithmetic for this
reason; see `vfft/README.md`).

**Codegen is not yet complete in every corner.** The generic-array
element-type inference has a fallback path that keeps `vml.forward_all`
returning a boxed array. `relu_prime` in `vlin` produces null elements
under the current `ForNode::getCExpr` emission. These are tracked; the
user-visible workarounds are documented in the affected library manuals.

**No integer overflow checking.** `int64(text)` saturates silently on
out-of-range input. Arithmetic wraps.

**No GC.** The interpreter relies on arena lifetime for the compiled
backend and on `shared_ptr` for interpreter-only object graphs. Programs
that accumulate long-lived values without region scoping will grow
linearly. `vmem` is the intended tool.

**Single-process RNG.** `vmath`'s PCG32 state is process-global. Two
independent streams require a state-carrying RNG type that has not yet
landed.

**Native-to-native array calls are rejected.** A function whose body calls
another function taking an array argument must inline that call or opt out
of native registration. This is a codegen constraint and it is documented
at the call sites that care.

---

## Contributing

Contributions are welcome. Before opening a pull request:

1. Fork the repository and create a feature branch.
2. Follow the existing code style: feature-split `.cpp` files in
   `compiler/codegen/`, `static inline` functions in `runtime/detail/`,
   `.vy` leaf modules with a facade under `modules/external/`.
3. Add tests. New language features belong under `examples/transpiler/`
   or `tests/`; new library functions belong in the library's own test
   file and, where applicable, in `examples/`.
4. Update the relevant README under `modules/external/<lib>/` if the
   public surface changed.
5. Run `make test` and ensure everything passes.

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the full guide. Bug reports
and feature requests use the templates under `.github/ISSUE_TEMPLATE/`.

---

## License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for the full
text.

---

## Acknowledgments

- **Raylib** for the graphics and audio primitives underlying `vglib` and
  `vaudio`.
- **OpenBLAS** for the matmul kernels dispatched under `--blas`.
- **Urage** for the embedded database backing `vurage`.
- **stb** for the image, font, and truetype utilities vendored under
  `vendor/stb/`.
- Everyone who has filed issues, contributed patches, or shipped code in
  Vyne.
