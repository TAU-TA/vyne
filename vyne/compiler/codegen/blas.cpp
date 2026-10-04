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

#include "detail/codegen_helpers.h"
#include "blas_dispatch.h"

// ============================================================================
// BLAS lowering
// ----------------------------------------------------------------------------
// For a call whose (receiver, method) pair matches BLAS_DISPATCH_TABLE and
// whose --blas flag is set, emit a call to `vyne_blas_matmul` (defined in
// runtime/detail/blas_bridge.h). That function does the field extraction,
// the cblas_dgemm call, and the result wrapping — the compiler's only job
// here is to pass the current Matrix layout's field IDs and type name along
// with the two operands.
//
// The layout metadata (field IDs, type name) is compiled in at each call
// site rather than baked into the runtime, so if `Types.vy` ever renames a
// field the compiler-side change propagates automatically. The runtime
// stays generic — it knows nothing about `vlin.Types.Matrix` specifically.
//
// Returns the name of the temp holding the result, or nullopt if the call
// doesn't match. MethodCallNode::getCExpr falls through to the boxed path
// on nullopt.
// ============================================================================

std::optional<std::string> tryEmitBlasCall(
    C_Emitter& e,
    const std::string& recvPath,
    const std::string& methodName,
    const std::vector<std::unique_ptr<ASTNode>>& arguments)
{
    if (!e.isBlasEnabled()) return std::nullopt;
    if (arguments.size() != 2) return std::nullopt;

    const BlasDispatchEntry* d = lookupBlasDispatch(recvPath, methodName);
    if (!d) return std::nullopt;

    // Same interning the interface constructor uses, so the IDs match
    // whatever `struct_vlin_Types_Matrix` writes at construction time.
    const uint32_t fidRow  = StringPool::intern("row");
    const uint32_t fidCol  = StringPool::intern("col");
    const uint32_t fidData = StringPool::intern("data");

    // Materialize both operands as boxed VyneValue. Evaluation order is
    // preserved (a then b), matching every other call path.
    std::string aExpr = e.boxAny(arguments[0]->getCExpr(e));
    std::string bExpr = e.boxAny(arguments[1]->getCExpr(e));

    std::string tA = e.newTemp("blas_a");
    std::string tB = e.newTemp("blas_b");
    std::string tR = e.newTemp("blas_r");

    e.emit("VyneValue " + tA + " = " + aExpr + ";");
    e.emit("VyneValue " + tB + " = " + bExpr + ";");
    e.emit("VyneValue " + tR + " = vyne_blas_matmul(" + tA + ", " + tB + ",");
    e.emit("    \"vlin.Types.Matrix\",");
    e.emit("    " + std::to_string(fidRow)  + ", " +
                   std::to_string(fidCol)  + ", " +
                   std::to_string(fidData) + ",");
    e.emit("    " + std::string(d->transpose_a ? "1" : "0") + ", " +
                 std::string(d->transpose_b ? "1" : "0") + ");");
    return tR;
}