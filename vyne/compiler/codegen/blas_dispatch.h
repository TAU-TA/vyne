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
#include <string>

// ============================================================================
// BLAS dispatch table
// ----------------------------------------------------------------------------
// Compile-time lowering for group methods that have a direct BLAS
// equivalent. When --blas is enabled and the receiver / method pair
// matches an entry here, the emitter replaces the generic boxed call
// `fn_<group>_<method>(n, args)` with an inline cblas_dgemm block.
//
// This table is deliberately minimal. Adding a new BLAS-accelerated
// operation means adding one entry here, and (only if the new op has
// non-standard semantics) one branch in codegen/blas.cpp. It is the
// single point of contact between Vyne and any BLAS library.
//
// Contract for each entry:
//   - group    : the receiver path, e.g. "vlin"
//   - method   : the method name, e.g. "multiply"
//   - trans_b  : false → C = A·B ; true → C = A·Bᵀ
//
// Both operands must be Matrix-shaped values with `row`/`col`/`data`
// fields. The emitter does not verify this — it dispatches whenever
// the receiver and method match. The runtime behavior is the same as
// the boxed path for correctly-typed inputs; for incorrectly-typed
// inputs the emitted C will produce a runtime error instead of silent
// nonsense because the struct field access fails.
// ============================================================================

struct BlasDispatchEntry {
    const char* group;
    const char* method;
    bool        transpose_a;
    bool        transpose_b;
};

static const BlasDispatchEntry BLAS_DISPATCH_TABLE[] = {
    // C = A·B
    {"vlin", "multiply",                 false, false},
    // C = A·Bᵀ
    {"vlin", "multiply_trans_b",         false, true },
    // C = Aᵀ·B
    {"vlin", "trans_a_multiply",         true,  false},
    // C = Aᵀ·Bᵀ
    {"vlin", "trans_a_multiply_trans_b", true,  true },
};

static inline const BlasDispatchEntry* lookupBlasDispatch(
    const std::string& group, const std::string& method)
{
    for (const auto& e : BLAS_DISPATCH_TABLE) {
        if (group == e.group && method == e.method) return &e;
    }
    return nullptr;
}