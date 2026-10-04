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

// Member access and assignment.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// MEMBER ACCESS / ASSIGNMENT
// ============================================================

std::string MemberAccessNode::getCExpr(C_Emitter& e) const {
    // --- Existing native-module / group resolution -------------------
    if (receiver->type() == NodeType::VARIABLE) {
        auto* var = static_cast<VariableNode*>(receiver.get());
        std::string modName = var->getOriginalName();

        std::string native = e.getNativeMapping(modName, memberName, false);
        if (native.find("v_" + modName) == std::string::npos) {
            return native;
        }

        if (e.isGroup(modName)) {
            std::string name = "v_" + modName + "_" + memberName;
            std::replace(name.begin(), name.end(), '.', '_');
            return name;
        }
    }

    if (receiver->type() == NodeType::VARIABLE) {
        auto* var = static_cast<VariableNode*>(receiver.get());
        std::string recvName = var->getOriginalName();

        std::string typeName;
        if (recvName == "self") {
            typeName = e.getCurrentInterfaceType();
        } else {
            std::string prefix = e.getActiveFunctionPrefix();
            std::string lookupKey = prefix.empty()
                ? ("v_" + recvName)
                : ("v_" + prefix + "_" + recvName);
            if (const std::string* t = e.lookupLocalStructType(lookupKey))
                typeName = *t;
            else if (const std::string* t = e.lookupGlobalStructType("v_" + recvName))
                typeName = *t;
        }

        if (!typeName.empty()) {
            VType elem = e.getInterfaceArrayElem(typeName, memberName);
            if (elem == VType::Int64 || elem == VType::Float64) {
                std::string cacheKey = recvName + "." + memberName;
                if (const auto* cached = e.getFieldCache(cacheKey))
                    return cached->temp;

                std::string recv = e.boxAny(receiver->getCExpr(e));
                uint32_t fid = StringPool::intern(memberName);
                std::string temp = e.newTemp("fld");
                const char* cName = (elem == VType::Float64)
                    ? "VyneArray_f64" : "VyneArray_i64";
                const char* fn = (elem == VType::Float64)
                    ? "vyne_value_to_array_f64" : "vyne_value_to_array_i64";

                e.emit(std::string(cName) + " " + temp + " = " + fn +
                       "(vyne_struct_get(" + recv + ", " +
                       std::to_string(fid) + "));");

                CType ct;
                ct.kind = CType::Kind::Array;
                ct.args.push_back(CType::fromVType(elem));
                e.declareNativeTemp(temp, ct);
                e.setFieldCache(cacheKey, temp, ct);
                return temp;
            }

            // M4-C1B: scalar (Int64/Float64) interface fields. Struct
            // storage is always boxed VyneValue; unbox once into a native
            // temp so downstream native dispatch (tryEmitNativeCall) sees
            // a provably-typed operand.
            VType ptype = e.getInterfacePrimitiveField(typeName, memberName);
            if (ptype == VType::Int64 || ptype == VType::Float64) {
                std::string cacheKey = recvName + "." + memberName + ":prim";
                if (const auto* cached = e.getFieldCache(cacheKey))
                    return cached->temp;

                std::string recv = e.boxAny(receiver->getCExpr(e));
                uint32_t fid = StringPool::intern(memberName);
                std::string boxed = e.newTemp("fb");
                e.emit("VyneValue " + boxed + " = vyne_struct_get(" +
                       recv + ", " + std::to_string(fid) + ");");

                std::string temp = e.newTemp("fp");
                if (ptype == VType::Float64) {
                    e.emit("double " + temp + " = (" + boxed +
                           ".type == V_FLOAT64) ? " + boxed +
                           ".as.f64 : (double)" + boxed + ".as.i64;");
                    e.declareNativeTemp(temp, CType::fromVType(VType::Float64));
                } else {
                    e.emit("int64_t " + temp + " = (" + boxed +
                           ".type == V_INT64) ? " + boxed +
                           ".as.i64 : (int64_t)" + boxed + ".as.f64;");
                    e.declareNativeTemp(temp, CType::fromVType(VType::Int64));
                }
                e.setFieldCache(cacheKey, temp, CType::fromVType(ptype));
                return temp;
            }
        }
    }

    // --- Boxed fallback ----------------------------------------------
    std::string recv = e.boxAny(receiver->getCExpr(e));
    uint32_t fid = StringPool::intern(memberName);
    return "vyne_struct_get(" + recv + ", " + std::to_string(fid) + ")";
}

void MemberAccessNode::compile(C_Emitter& e) const {
    // Bare member access as statement — no-op
}

void MemberAssignmentNode::compile(C_Emitter& e) const {
    // Any write invalidates all cached unboxes for this function.
    e.clearFieldCache();

    // --- Region escape check ------------------------------------------
    // If the receiver is a variable at a shallower region depth than
    // the current one, and RHS is a non-primitive from a deeper region,
    // we're writing a region-local pointer into outer memory.
    if (e.hasRegion() && receiver->type() == NodeType::VARIABLE) {
        auto* var = static_cast<VariableNode*>(receiver.get());
        std::string rs = var->getOriginalName();
        std::replace(rs.begin(), rs.end(), '.', '_');
        std::string prefix = e.getActiveFunctionPrefix();
        std::string rname = prefix.empty()
            ? ("v_" + rs)
            : ("v_" + prefix + "_" + rs);
        int recvDepth = e.lookupLocalRegionDepth(rname);
        if (recvDepth < 0) recvDepth = 0;
        if (recvDepth < e.currentRegionDepth()) {
            // See the note in assignments.cpp:checkRegionEscape.
            bool safe = (rhs->type() == NodeType::STRING);
            if (!safe) {
                VType st = rhs->getStaticType();
                safe = (st == VType::Int64 || st == VType::Float64 ||
                        st == VType::Bool  || st == VType::Null);
            }
            if (!safe) {
                throw std::runtime_error(
                    "Escape Error (VNE-070): member assignment writes a "
                    "region-local value into '" + var->getOriginalName() +
                    "' (declared outside the region) at line " +
                    std::to_string(lineNumber) + ".\n"
                    "  The value would dangle after the region's rewind.");
            }
        }
    }
    // --- End escape check --------------------------------------------

    std::string val = e.boxAny(rhs->getCExpr(e));

    if (receiver->type() == NodeType::VARIABLE) {
        auto* var = static_cast<VariableNode*>(receiver.get());
        std::string modName = var->getOriginalName();

        if (e.isGroup(modName)) {
            std::string name = "v_" + modName + "_" + memberName;
            std::replace(name.begin(), name.end(), '.', '_');
            e.emit(name + " = " + val + ";");
            return;
        }

        if (modName == "self") {
            uint32_t fid = StringPool::intern(memberName);
            e.emit("vyne_struct_set(v_self, " + std::to_string(fid) +
                   ", \"" + memberName + "\", " + val + ");");
            return;
        }
    }

    std::string recv = e.boxAny(receiver->getCExpr(e));
    uint32_t fid = StringPool::intern(memberName);
    e.emit("vyne_struct_set(" + recv + ", " + std::to_string(fid) +
           ", \"" + memberName + "\", " + val + ");");
}

std::string MemberAssignmentNode::getCExpr(C_Emitter& e) const {
    compile(e);
    if (receiver->type() == NodeType::VARIABLE) {
        auto* var = static_cast<VariableNode*>(receiver.get());
        std::string name = "v_" + var->getOriginalName() + "_" + memberName;
        std::replace(name.begin(), name.end(), '.', '_');
        return name;
    }
    return receiver->getCExpr(e) + "_" + memberName;
}

