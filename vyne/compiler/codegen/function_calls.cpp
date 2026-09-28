#include "detail/codegen_helpers.h"

// Function invocation and native call lowering.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// FUNCTION CALL
// ============================================================

std::string FunctionCallNode::getCExpr(C_Emitter& e) const {
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

    // ----------------------------------------------------------------
    // Native-variant dispatch. Fires only when the callee has a native
    // variant AND every argument's static type matches the parameter
    // (Int64 → Float64 widening permitted). Otherwise the boxed path
    // below runs unchanged.
    // ----------------------------------------------------------------
    {
        const std::string* nativeName = e.lookupNativeVariant(mangledName);
        const std::vector<CType>* paramTypes =
            e.getFunctionParamTypes(originalName);
        const CType* retCt = e.getFunctionReturnType(originalName);

        if (nativeName && paramTypes && retCt && retCt->isPrimitive() &&
            paramTypes->size() == orderedArgs.size())
        {
            bool allMatch = true;

            for (size_t i = 0; i < orderedArgs.size(); ++i) {
                const CType& want = (*paramTypes)[i];

                if (want.kind == CType::Kind::Array && !want.args.empty()) {
                    // Array-typed param: the argument must be a typed array
                    // with a matching element kind. If it's a boxed Array,
                    // fall through to the boxed call.
                    const CType* have = argCTypes[i];
                    if (!have || have->kind != CType::Kind::Array ||
                        have->args.empty() ||
                        have->args[0].toVType() != want.args[0].toVType()) {
                        allMatch = false; break;
                    }
                } else {
                    VType wantVT = want.toVType();
                    bool ok = (argVTypes[i] == wantVT) ||
                            (wantVT == VType::Float64 && argVTypes[i] == VType::Int64);
                    if (!ok) { allMatch = false; break; }
                }
            }

            if (allMatch) {
                std::string argList;
                for (size_t i = 0; i < orderedArgs.size(); ++i) {
                    if (i > 0) argList += ", ";
                    const CType& want = (*paramTypes)[i];

                    if (want.kind == CType::Kind::Array && !want.args.empty()) {
                        // Pass the raw element buffer. No length — the callee
                        // receives n as a separate Int64 parameter if it needs it.
                        argList += argCExprs[i] + ".data";
                    } else {
                        argList += coerceToNative(e, orderedArgs[i], argCExprs[i],
                                                want.toVType());
                    }
                }
                std::string nret = e.newTemp("nret");
                e.emit(retCt->cTypeName() + " " + nret + " = fn_" +
                    *nativeName + "(" + argList + ");");
                e.declareNativeTemp(nret, *retCt);
                return nret;
            }
        }
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

        e.emit("VyneValue " + retTemp + " = struct_" + mangledName +
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

