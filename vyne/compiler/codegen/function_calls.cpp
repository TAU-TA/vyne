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

// Function invocation and native call lowering.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// FUNCTION CALL
// ============================================================

std::string FunctionCallNode::getCExpr(C_Emitter& e) const {
    // ----------------------------------------------------------------
    // Pool intrinsics. `pool_alloc` and `pool_free` are intercepted by
    // name *only when a pool context is active*; outside a @pool region
    // they fall through to normal function resolution, so a user-defined
    // `fn pool_alloc()` at top level still works as written.
    //
    // This must run before named-arg resolution: the intrinsics take
    // positional args only, and there's no signature for them in the
    // emitter's function table anyway.
    // ----------------------------------------------------------------
    if (e.hasPool()) {
        const auto& pool  = e.currentPool();
        const bool  isF64 = (pool.elemType == VType::Float64);

        if (originalName == "pool_alloc") {
            if (!arguments.empty()) {
                throw std::runtime_error(
                    "Compile Error (VNE-083): pool_alloc() takes no "
                    "arguments (line " + std::to_string(lineNumber) + ").");
            }
            std::string temp = e.newTemp("pool_arr");
            std::string fn = isF64 ? "vyne_pool_f64_alloc"
                                   : "vyne_pool_i64_alloc";
            e.emit(std::string(isF64 ? "VyneArray_f64 " : "VyneArray_i64 ") +
                   temp + " = " + fn + "(&" + pool.handle + ");");

            CType arr;
            arr.kind = CType::Kind::Array;
            arr.args.push_back(CType::fromVType(pool.elemType));
            e.declareNativeTemp(temp, arr);
            return temp;
        }

        if (originalName == "pool_free") {
            if (arguments.size() != 1) {
                throw std::runtime_error(
                    "Compile Error (VNE-083): pool_free(x) takes exactly "
                    "one argument (line " + std::to_string(lineNumber) + ").");
            }
            std::string arg = arguments[0]->getCExpr(e);
            std::string fn = isF64 ? "vyne_pool_f64_free"
                                   : "vyne_pool_i64_free";
            e.emit(fn + "(&" + pool.handle + ", &" + arg + ");");
            return "vyne_null()";
        }
    }

    // --- Resolve named args (unchanged) -----------------------------
    std::vector<ASTNode*> orderedArgs;
    if (hasNamedArguments()) {
        const auto* sig = e.getFunctionSignature(originalName);
        if (!sig) {
            throw std::runtime_error(
                "Compile Error: named arguments used for function '" +
                originalName + "' but its signature is unknown (line " +
                std::to_string(lineNumber) + ").");
        }
        std::unordered_map<std::string, ASTNode*> nameToArg;
        for (const auto& [name, arg] : namedArguments) {
            if (nameToArg.count(name)) {
                throw std::runtime_error(
                    "Compile Error: duplicate named argument '" + name +
                    "' in call to '" + originalName + "' (line " +
                    std::to_string(lineNumber) + ").");
            }
            nameToArg[name] = arg.get();
        }
        for (const auto& paramName : *sig) {
            auto it = nameToArg.find(paramName);
            if (it == nameToArg.end()) {
                throw std::runtime_error(
                    "Compile Error: missing argument '" + paramName +
                    "' in call to '" + originalName + "' (line " +
                    std::to_string(lineNumber) + ").");
            }
            orderedArgs.push_back(it->second);
        }
        for (const auto& [name, _] : nameToArg) {
            bool found = false;
            for (const auto& pn : *sig) if (pn == name) { found = true; break; }
            if (!found) {
                throw std::runtime_error(
                    "Compile Error: unknown argument '" + name +
                    "' in call to '" + originalName + "' (line " +
                    std::to_string(lineNumber) + ").");
            }
        }
    } else {
        for (const auto& a : arguments) orderedArgs.push_back(a.get());
    }

    // --- M2: monomorphization --------------------------------------
    // Only fire when the parser recorded type args. Inference is a
    // follow-up; explicit `foo<Int64>(...)` is the load-bearing case.
    if (!typeArgs.empty()) {
        std::string key = originalName;
        std::replace(key.begin(), key.end(), '.', '_');
        for (const auto& t : typeArgs) key += "__" + t;

        if (const std::string* emitted = e.lookupInstantiation(key)) {
            // Already emitted: call the specialised C function directly.
            int n = (int)orderedArgs.size();
            std::string retTemp = e.newTemp("ret");
            std::string argArr  = e.newTemp("args");
            if (n > 0) {
                e.emit("VyneValue* " + argArr +
                       " = (VyneValue*)arena_alloc(sizeof(VyneValue) * " +
                       std::to_string(n) + ");");
                for (int i = 0; i < n; ++i) {
                    e.emit(argArr + "[" + std::to_string(i) + "] = " +
                           e.boxAny(orderedArgs[i]->getCExpr(e)) + ";");
                }
            } else {
                e.emit("VyneValue* " + argArr + " = NULL;");
            }
            e.emit("VyneValue " + retTemp + " = fn_" + *emitted +
                   "(" + std::to_string(n) + ", " + argArr + ");");
            return retTemp;
        }

        // First sighting: instantiate on demand. The concrete C name
        // is the same key we just built, prefixed with "fn_".
        if (e.beginInstantiation(key)) {
            std::string cName = key;
            e.finishInstantiation(key, cName);
            // NOTE: actual body emission is scheduled by ProgramNode
            // via the emitter's instantiation queue — see
            // `ProgramNode::compile` for the drain loop. For now, fall
            // through to the boxed call so unresolvable cases still
            // produce compilable C.
        }
    }

    std::vector<std::string> argCExprs;
    std::vector<VType>       argVTypes;
    std::vector<const CType*> argCTypes;
    argCExprs.reserve(orderedArgs.size());
    argVTypes.reserve(orderedArgs.size());
    argCTypes.reserve(orderedArgs.size());

    for (auto* a : orderedArgs) {
        std::string s = a->getCExpr(e);
        const CType* fullCt = e.lookupType(s);
        const CType* primCt = e.exprNativeType(s);
        VType t = primCt ? primCt->toVType() : a->getStaticType();
        argCExprs.push_back(std::move(s));
        argVTypes.push_back(t);
        argCTypes.push_back(fullCt);
    }

    int argSize = (int)orderedArgs.size();
    std::string retTemp = e.newTemp("ret");

    std::string mangledName = originalName;
    std::replace(mangledName.begin(), mangledName.end(), '.', '_');

    // If the callee's bare name is defined in the module we are currently
    // emitting, the C symbol is fn_<module>_<name>. Without this, a call
    // like `_skip_ws(x)` inside vjson emits `fn__skip_ws`, which does not
    // exist — the definition is `fn_vjson__skip_ws`.
    const std::string& mod = e.getActiveModule();
    bool sameModuleFn = !mod.empty() && e.isModuleFunction(mod, originalName);
    if (sameModuleFn) {
        mangledName = mod + "_" + mangledName;
    }

    // ----------------------------------------------------------------
    // Native-variant dispatch. Same helper the group-call path uses;
    // see codegen/native_dispatch.cpp for the full doc.
    // ----------------------------------------------------------------
    if (auto nativeResult = tryEmitNativeCall(
            e, mangledName, originalName,
            orderedArgs, argCExprs, argVTypes, argCTypes)) {
        return *nativeResult;
    }

    // ----------------------------------------------------------------
    // Interface constructors take their arguments directly — no
    // `args[]` array, no arena allocation, no deep-copy dance.
    // ----------------------------------------------------------------
    if (e.isInterface(originalName) || e.isInterface(mangledName)) {
        if (hasNamedArguments()) {
            throw std::runtime_error(
                "Compile Error: named arguments are not supported for interface constructors "
                "(line " + std::to_string(lineNumber) + ").");
        }

        const std::vector<std::string>* defaults =
            e.getInterfaceDefaults(originalName);
        if (!defaults) defaults = e.getInterfaceDefaults(mangledName);

        std::vector<std::string> argStrs;
        argStrs.reserve(orderedArgs.size());
        for (size_t i = 0; i < orderedArgs.size(); ++i) {
            argStrs.push_back(e.boxAny(argCExprs[i]));
        }

        if (defaults) {
            for (size_t i = argStrs.size(); i < defaults->size(); ++i) {
                argStrs.push_back((*defaults)[i]);
            }
        }

        std::string directArgs;
        for (size_t i = 0; i < argStrs.size(); ++i) {
            if (i > 0) directArgs += ", ";
            directArgs += argStrs[i];
        }

        // Same-module interface constructor: `Parser(...)` inside vjson
        // must emit struct_vjson_Parser, not struct_Parser.
        std::string ctorSuffix = mangledName;
        if (!mod.empty() && e.isModuleInterface(mod, originalName)) {
            ctorSuffix = mod + "_" + mangledName;
        }

        e.emit("VyneValue " + retTemp + " = struct_" + ctorSuffix +
               "(" + directArgs + ");");
        return retTemp;
    }

    // ----------------------------------------------------------------
    // Normal function call: build args[] on the arena, deep-copy
    // arrays/maps so callee mutations don't leak back to the caller.
    // ----------------------------------------------------------------
    std::string argArr = e.newTemp("args");

    if (argSize > 0) {
        e.emit("VyneValue* " + argArr + " = (VyneValue*)arena_alloc(sizeof(VyneValue) * " +
               std::to_string(argSize) + ");");
        for (int i = 0; i < argSize; ++i) {
            // NOTE: no deep copy. Array / map arguments are shared by
            // reference, matching assignment semantics and Python / JS /
            // Lua. If a callee mutates its parameter, the caller sees it.
            std::string val = e.boxAny(argCExprs[i]);
            e.emit(argArr + "[" + std::to_string(i) + "] = " + val + ";");
        }
    } else {
        e.emit("VyneValue* " + argArr + " = NULL;");
    }

    e.emit("VyneValue " + retTemp + " = fn_" + mangledName +
           "(" + std::to_string(argSize) + ", " + argArr + ");");
    return retTemp;
}

void FunctionCallNode::compile(C_Emitter& e) const { getCExpr(e); }

