// SPDX-License-Identifier: AGPL-3.0-only
// Copyright (C) 2026 Tuncay Gafarli
//
// This file is part of the Vyne compiler.
//
// Vyne is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the
// Free Software Foundation, version 3.
//
// Vyne is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public
// License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Vyne. If not, see <https://www.gnu.org/licenses/>.

#pragma once
#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <chrono>
#include <format>
#include <cstdio>

#include "../vyne/compiler/lexer/lexer.h"
#include "../vyne/compiler/parser/parser.h"
#include "../vyne/compiler/ast/ast.h"
#include "../vyne/compiler/ast/value.h"
#include "../vyne/compiler/codegen/codegen.h"
#include "../vyne/compiler/codegen/linker.h"

#define RESET   "\033[0m"
#define RED     "\033[31m"
#define GREEN   "\033[32m"
#define YELLOW  "\033[33m"
#define CYAN    "\033[36m"
#define BOLD    "\033[1m"
#define MAGENTA "\033[35m"

// ---------------------------------------------------------------------------
// Run modes
// ---------------------------------------------------------------------------
// Each mode names the LAST phase the driver runs. Every phase before it runs
// unconditionally, so `--emit-asm` implies `--emit-c` and `--run` implies
// `--compile`. This mirrors `rustc --emit=…` and `cargo build` / `cargo run`.
//
//   Interpret    parse + evaluate (interpreter, no C is emitted)
//   EmitC        parse + emit .vy.c
//   EmitAsm      parse + emit .vy.c + gcc -S -> .vy.s
//   CompileOnly  parse + emit .vy.c + gcc    -> .exe
//   CompileRun   parse + emit .vy.c + gcc    -> .exe, then execute it
//
// CompileRun is the default when a filename is present and no mode flag is
// given, matching `go run` / `cargo run` ergonomics.
// ---------------------------------------------------------------------------
enum class RunMode {
    Interpret,
    EmitC,
    EmitAsm,
    CompileOnly,
    CompileRun
};

// Everything the driver learns from the command line. Passing a struct rather
// than a growing parameter list keeps `runFile`'s signature stable and lets a
// future flag land without touching call sites.
struct BuildOptions {
    RunMode     mode             = RunMode::Interpret;
    bool        nativeIsa        = false;  // -march=native on the gcc step
    bool        enforceIntegrity = false;  // --verify: hash check before parsing
    bool        scratchBounds    = true;   // VNE-072 bounds checks in emitted C
    bool        blasEnabled      = false;  // --blas: route vlin.multiply through cblas
    std::string outputName;                // -o: base name; extension added by mode
};

int runFile(const std::string& filename, SymbolContainer& env,
            const BuildOptions& opts);

template<typename... Args>
static inline void vprint(std::string_view fmt, Args&&... args) {
    std::string s = std::vformat(fmt, std::make_format_args(args...));
    std::printf("%s", s.c_str());
}

template<typename... Args>
static inline void vprintln(std::string_view fmt, Args&&... args) {
    std::string s = std::vformat(fmt, std::make_format_args(args...));
    std::printf("%s\n", s.c_str());
}