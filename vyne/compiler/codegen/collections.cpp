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

// Array construction, index access/assignment, ranges, and slicing.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// ARRAY AND INDEX ACCESS
// ============================================================

std::string ArrayNode::getCExpr(C_Emitter& e) const {
    VType elem = inferArrayElemType(this);
    if (elem != VType::Unknown && !elements.empty()) {
        std::string name = e.newTemp("arr");
        std::string ctor = (elem == VType::Float64)
            ? "vyne_array_f64_create"
            : "vyne_array_i64_create";

        e.emit(CType::arrayContainerName(elem) + " " + name + " = " +
               ctor + "(" + std::to_string(elements.size()) + ");");

        for (size_t i = 0; i < elements.size(); ++i) {
            std::string raw = elements[i]->getCExpr(e);
            std::string native = coerceToNative(e, elements[i].get(), raw, elem);
            e.emit(name + ".data[" + std::to_string(i) + "] = " + native + ";");
        }

        CType ct;
        ct.kind = CType::Kind::Array;
        ct.args.push_back(CType::fromVType(elem));
        e.declareNativeTemp(name, ct);
        return name;
    }

    // Boxed fallback — unchanged except the per-element boxing uses
    // boxTypedArray so a nested typed array literal still boxes correctly.
    std::string temp = e.newTemp("arr");
    int size = (int)elements.size();
    e.emit("VyneValue " + temp + " = vyne_array_create(" +
           std::to_string(size) + ");");
    for (int i = 0; i < size; i++) {
        std::string elemExpr = e.boxAny(elements[i]->getCExpr(e));
        e.emit("vyne_array_set(" + temp + ", vyne_int(" +
               std::to_string(i) + "), " + elemExpr + ");");
    }
    return temp;
}

void ArrayNode::compile(C_Emitter& e) const { getCExpr(e); }

std::string IndexAccessNode::getCExpr(C_Emitter& e) const {
    std::string bRaw = base->getCExpr(e);
    const CType* bt = e.lookupType(bRaw);

    if (bt && bt->hasShape()) {
        if (bt->shape.size() != 1) {
            throw std::runtime_error(
                "Shape Error (VNE-071): single index on rank-" +
                std::to_string(bt->shape.size()) + " shaped array (line " +
                std::to_string(lineNumber) + ").");
        }

        VType elem = bt->args.empty() ? VType::Float64
                                      : bt->args[0].toVType();
        std::string rawIdx = index->getCExpr(e);
        std::string idx = coerceToNative(e, index.get(), rawIdx, VType::Int64);

        // Bounds check (VNE-072). Materialize the index once so the
        // check and the load read the same value. Gated behind
        // emitter::isScratchBoundsEnabled so a benchmark build can
        // elide the check.
        std::string iv;
        if (e.isScratchBoundsEnabled()) {
            iv = e.newTemp("si");
            e.emit("int64_t " + iv + " = " + idx + ";");
            e.emit("if (VYNE_UNLIKELY(" + iv + " < 0 || " + iv + " >= " +
                   std::to_string(bt->shape[0]) + ")) {");
            e.emit("    fprintf(stderr, \"Runtime error (VNE-072): scratch index "
                   "out of bounds: dim 0 of shape [" +
                   std::to_string(bt->shape[0]) + "] got %lld at line " +
                   std::to_string(lineNumber) + "\\n\", (long long)" + iv + ");");
            e.emit("    exit(1);");
            e.emit("}");
        } else {
            iv = idx;
        }

        std::string name = e.newTemp("idx");
        e.emit((elem == VType::Float64 ? "double " : "int64_t ") + name +
               " = " + bRaw + "[" + iv + "];");
        e.declareNativeTemp(name, CType::fromVType(elem));
        return name;
    }

    if (bt && bt->kind == CType::Kind::RawArrayPtr) {
        VType elem = bt->args.empty() ? VType::Float64 : bt->args[0].toVType();
        std::string rawIdx = index->getCExpr(e);
        std::string idx = coerceToNative(e, index.get(), rawIdx, VType::Int64);

        std::string name = e.newTemp("idx");
        e.emit((elem == VType::Float64 ? "double " : "int64_t ") + name +
            " = " + bRaw + "[" + idx + "];");
        e.declareNativeTemp(name, CType::fromVType(elem));
        return name;
    }

    if (bt && bt->kind == CType::Kind::Array && !bt->args.empty()) {
        VType elem = bt->args[0].toVType();
        std::string rawIdx = index->getCExpr(e);
        std::string idx = coerceToNative(e, index.get(), rawIdx, VType::Int64);

        std::string name = e.newTemp("idx");
        e.emit((elem == VType::Float64 ? "double " : "int64_t ") + name +
               " = " + bRaw + ".data[" + idx + "];");
        e.declareNativeTemp(name, CType::fromVType(elem));
        return name;
    }

    // Boxed path — unchanged.
    std::string b = e.boxAny(bRaw);
    std::string idx = e.boxAny(index->getCExpr(e));
    std::string temp = e.newTemp("idx");
    e.emit("VyneValue " + temp + " = vyne_index_get(" + b + ", " + idx + ");");
    return temp;
}

void IndexAccessNode::compile(C_Emitter& e) const { getCExpr(e); }

void IndexAssignmentNode::compile(C_Emitter& e) const {
    std::string bRaw = base->getCExpr(e);
    const CType* bt = e.lookupType(bRaw);

    // --- Region escape check ------------------------------------------
    if (e.hasRegion() && base->type() == NodeType::VARIABLE) {
        auto* var = static_cast<VariableNode*>(base.get());
        std::string bs = var->getOriginalName();
        std::replace(bs.begin(), bs.end(), '.', '_');
        std::string prefix = e.getActiveFunctionPrefix();
        std::string bname = prefix.empty()
            ? ("v_" + bs)
            : ("v_" + prefix + "_" + bs);
        int baseDepth = e.lookupLocalRegionDepth(bname);
        if (baseDepth >= 0 && baseDepth < e.currentRegionDepth()) {
            // String literals live in .rodata — see the full note in
            // assignments.cpp:checkRegionEscape. Computed strings and
            // anything else fall through to the AST/emitter resolution
            // and are only accepted if provably primitive.
            bool safe = (rhs->type() == NodeType::STRING);
            if (!safe) {
                VType st = resolveRHSKind(e, rhs.get());
                safe = (st == VType::Int64 || st == VType::Float64 ||
                        st == VType::Bool  || st == VType::Null);
            }
            if (!safe) {
                throw std::runtime_error(
                    "Escape Error (VNE-070): index assignment writes a "
                    "region-local value into '" + var->getOriginalName() +
                    "' (declared outside the region) at line " +
                    std::to_string(lineNumber) + ".\n"
                    "  The value would dangle after the region's rewind.");
            }
        }
    }
    // --- End escape check --------------------------------------------

    if (bt && bt->hasShape()) {
        if (bt->shape.size() != 1) {
            throw std::runtime_error(
                "Shape Error (VNE-071): single index on rank-" +
                std::to_string(bt->shape.size()) + " shaped array (line " +
                std::to_string(lineNumber) + ").");
        }
        
        VType elem = bt->args.empty() ? VType::Float64
                                      : bt->args[0].toVType();
        std::string rawIdx = index->getCExpr(e);
        std::string idx = coerceToNative(e, index.get(), rawIdx, VType::Int64);
        std::string rawVal = rhs->getCExpr(e);
        std::string val = coerceToNative(e, rhs.get(), rawVal, elem);

        std::string iv;
        if (e.isScratchBoundsEnabled()) {
            iv = e.newTemp("si");
            e.emit("int64_t " + iv + " = " + idx + ";");
            e.emit("if (VYNE_UNLIKELY(" + iv + " < 0 || " + iv + " >= " +
                   std::to_string(bt->shape[0]) + ")) {");
            e.emit("    fprintf(stderr, \"Runtime error (VNE-072): scratch index "
                   "out of bounds: dim 0 of shape [" +
                   std::to_string(bt->shape[0]) + "] got %lld at line " +
                   std::to_string(lineNumber) + "\\n\", (long long)" + iv + ");");
            e.emit("    exit(1);");
            e.emit("}");
        } else {
            iv = idx;
        }
        e.emit(bRaw + "[" + iv + "] = " + val + ";");
        return;
    }

    if (bt && bt->kind == CType::Kind::RawArrayPtr) {
        VType elem = bt->args.empty() ? VType::Float64 : bt->args[0].toVType();
        std::string rawIdx = index->getCExpr(e);
        std::string idx = coerceToNative(e, index.get(), rawIdx, VType::Int64);
        std::string rawVal = rhs->getCExpr(e);
        std::string val = coerceToNative(e, rhs.get(), rawVal, elem);
        e.emit(bRaw + "[" + idx + "] = " + val + ";");
        return;
    }

    if (bt && bt->kind == CType::Kind::Array && !bt->args.empty()) {
        VType elem = bt->args[0].toVType();
        std::string rawIdx = index->getCExpr(e);
        std::string idx = coerceToNative(e, index.get(), rawIdx, VType::Int64);
        std::string rawVal = rhs->getCExpr(e);
        std::string val = coerceToNative(e, rhs.get(), rawVal, elem);
        e.emit(bRaw + ".data[" + idx + "] = " + val + ";");
        return;
    }

    // Boxed fallback — same as before, routed through boxTypedArray so a
    // typed array literal on the RHS still boxes correctly.
    std::string b = e.boxAny(bRaw);
    std::string i = e.boxAny(index->getCExpr(e));
    std::string r = e.boxAny(rhs->getCExpr(e));
    e.emit("vyne_index_set(" + b + ", " + i + ", " + r + ");");
}

std::string IndexAssignmentNode::getCExpr(C_Emitter& e) const {
    compile(e);
    return "vyne_null()";
}

// ============================================================
// RANGE
// ============================================================

std::string RangeNode::getCExpr(C_Emitter& e) const {
    if (!left || !right) return "vyne_null()";
    std::string l = e.boxAny(left->getCExpr(e));
    std::string r = e.boxAny(right->getCExpr(e));
    std::string temp = e.newTemp("rng");
    e.emit("VyneValue " + temp + " = vyne_range_create(" + l + ", " + r + ");");
    return temp;
}

void RangeNode::compile(C_Emitter& e) const { getCExpr(e); }

std::string SliceNode::getCExpr(C_Emitter& e) const {
    std::string bRaw = base->getCExpr(e);
    const CType* bt = e.lookupType(bRaw);

    if (bt && bt->kind == CType::Kind::Array && !bt->args.empty()) {
        VType elem = bt->args[0].toVType();
        std::string rawLo = low  ? low->getCExpr(e)  : "";
        std::string rawHi = high ? high->getCExpr(e) : "";
        std::string lo = low
            ? coerceToNative(e, low.get(),  rawLo, VType::Int64)
            : "0";
        std::string hi = high
            ? coerceToNative(e, high.get(), rawHi, VType::Int64)
            : (bRaw + ".size");

        std::string fn = (elem == VType::Float64)
            ? "vyne_array_f64_slice"
            : "vyne_array_i64_slice";
        std::string name = e.newTemp("slc");
        e.emit(CType::arrayContainerName(elem)+ " " + name + " = " +
               fn + "(&" + bRaw + ", " + lo + ", " + hi + ");");

        CType ct;
        ct.kind = CType::Kind::Array;
        ct.args.push_back(CType::fromVType(elem));
        e.declareNativeTemp(name, ct);
        return name;
    }

    // Boxed fallback — same as before, with boxTypedArray on the base.
    std::string b  = e.boxAny(bRaw);
    std::string lo = low  ? e.boxAny(low->getCExpr(e))  : "vyne_null()";
    std::string hi = high ? e.boxAny(high->getCExpr(e)) : "vyne_null()";
    std::string temp = e.newTemp("slc");
    e.emit("VyneValue " + temp + " = vyne_slice_get(" +
           b + ", " + lo + ", " + hi + ");");
    return temp;
}

void SliceNode::compile(C_Emitter& e) const { getCExpr(e); }

