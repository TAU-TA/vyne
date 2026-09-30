#include "detail/codegen_helpers.h"

// Function declarations and body emission, including parameter and return handling.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// FUNCTIONS
// ============================================================

static void emitFunctionBody(C_Emitter& e,
                             const std::vector<Parameter>& parameters,
                             const std::vector<std::shared_ptr<ASTNode>>& body,
                             const std::string& mangledName) {
    // Parameters
    for (size_t i = 0; i < parameters.size(); ++i) {
        std::string paramSanitized = parameters[i].name;
        std::replace(paramSanitized.begin(), paramSanitized.end(), '.', '_');
        std::string paramName = "v_" + mangledName + "_" + paramSanitized;

        std::string arg = "args[" + std::to_string(i) + "]";
        std::string guard = "(arg_count > " + std::to_string(i) + ")";

        // M1 (issue #79): unbox known-primitive params into native locals at
        // function entry. The ABI stays `(int, VyneValue*)` — callers still
        // box, and any dynamic value (e.g. a Float64 where Int64 is declared)
        // is coerced here exactly like the old ForNode bound conversion.
        // Non-reference params only; reference params go through the
        // interpreter path and stay boxed.
        CType pt = CType::fromVType(parameters[i].type);
        if (pt.isPrimitive() && !parameters[i].isReference) {
            std::string init = "0";
            switch (pt.kind) {
                case CType::Kind::Int64:
                    init = "(" + guard + ") ? ((" + arg + ".type == V_INT64) ? " +
                           arg + ".as.i64 : (int64_t)" + arg + ".as.f64) : 0";
                    break;
                case CType::Kind::Float64:
                    init = "(" + guard + ") ? ((" + arg + ".type == V_FLOAT64) ? " +
                           arg + ".as.f64 : (double)" + arg + ".as.i64) : 0.0";
                    break;
                case CType::Kind::Bool:
                    init = "(" + guard + ") ? (" + arg + ".as.i64 != 0) : false";
                    break;
                default: break;
            }
            e.declareLocal(paramName, pt);
            e.emit(pt.cTypeName() + " " + paramName + " = " + init + ";");
            } else {
                e.registerDeclaration(paramName);
                e.emit("VyneValue " + paramName +
                    " = " + guard + " ? " + arg + " : vyne_null();");

                if (parameters[i].type == VType::Struct &&
                    !parameters[i].typePath.empty()) {
                    e.setLocalStructType(paramName, parameters[i].typePath);
                }
            }
    }

    // Return-value slot (shared by defer and try/catch paths).
    std::string retVar = "__ret_" + mangledName;
    std::string retFlag = "__returning_" + mangledName;
    std::string cleanupLabel = "__cleanup_" + mangledName;

    e.emit("VyneValue " + retVar + " = vyne_null();");
    e.emit("int " + retFlag + " = 0;");

    e.setReturnVars(retVar, retFlag);

    // Top-level defers (unchanged collection logic)
    std::vector<DeferNode*> defers;
    for (const auto& s : body) {
        if (s && s->type() == NodeType::DEFER) {
            auto* d = static_cast<DeferNode*>(s.get());
            d->markCollected();
            defers.push_back(d);
        }
    }

    if (!defers.empty()) {
        e.pushDeferContext(cleanupLabel, retVar);
    }

    for (const auto& stmt : body)
        if (stmt) stmt->compile(e);

        if (!defers.empty()) {
        e.emit("goto " + cleanupLabel + ";");

        e.dedent();
        e.emit(cleanupLabel + ":");
        e.indent();

        for (auto it = defers.rbegin(); it != defers.rend(); ++it) {
            (*it)->getBody()->compile(e);
        }

        e.emit("return " + retVar + ";");
        e.popDeferContext();
    } else {
        e.emit("return " + retVar + ";");
    }

    e.clearReturnVars();
}

static void emitNativeFunctionBody(
        C_Emitter& e,
        const std::vector<Parameter>& parameters,
        const std::vector<std::shared_ptr<ASTNode>>& body,
        const std::string& nativeName,
        const CType& returnType)
{
    e.pushFunctionContext();
    e.enterFunction(nativeName);         // prefix used for local resolution
    e.setNativeReturnType(returnType);   // tells ReturnNode to emit native

    // Resolve the native return type name once.
    std::string retCName;
    if (returnType.kind == CType::Kind::Array && !returnType.args.empty()) {
        VType elem = returnType.args[0].toVType();
        retCName = (elem == VType::Float64) ? "VyneArray_f64" : "VyneArray_i64";
    } else {
        retCName = returnType.cTypeName();
    }

    std::string paramList;
    for (size_t i = 0; i < parameters.size(); ++i) {
        if (i > 0) paramList += ", ";
        std::string pName = "v_" + nativeName + "_" + parameters[i].name;

        if (parameters[i].type == VType::Array &&
            parameters[i].arrayElemType != VType::Unknown) {
            VType elem = parameters[i].arrayElemType;
            std::string elemC = (elem == VType::Float64) ? "double" : "int64_t";
            paramList += elemC + "* " + pName;
        } else {
            CType pt = CType::fromVType(parameters[i].type);
            paramList += pt.cTypeName() + " " + pName;
        }
    }

    e.emitGlobalDecl(retCName + " fn_" + nativeName +
                    "(" + paramList + ");");

    e.emit("// native variant of " + nativeName);
    e.emitBlockOpen(retCName + " fn_" + nativeName +
                    "(" + paramList + ") {");

    for (size_t i = 0; i < parameters.size(); ++i) {
        std::string pName = "v_" + nativeName + "_" + parameters[i].name;
        CType pt = CType::fromVType(parameters[i].type);

        if (parameters[i].type == VType::Array &&
            parameters[i].arrayElemType != VType::Unknown) {
            CType raw;
            raw.kind = CType::Kind::RawArrayPtr;
            raw.args.push_back(CType::fromVType(parameters[i].arrayElemType));
            e.declareLocal(pName, raw);
        } else {
            e.declareLocal(pName, pt);
        }
    }

    for (const auto& stmt : body)
        if (stmt) stmt->compile(e);

    switch (returnType.kind) {
        case CType::Kind::Float64: e.emit("return 0.0;");   break;
        case CType::Kind::Int64:   e.emit("return 0;");     break;
        case CType::Kind::Bool:    e.emit("return false;"); break;
        case CType::Kind::Array:
            if (!returnType.args.empty() &&
                returnType.args[0].toVType() == VType::Float64) {
                e.emit("return vyne_array_f64_create(0);");
            } else if (!returnType.args.empty() &&
                    returnType.args[0].toVType() == VType::Int64) {
                e.emit("return vyne_array_i64_create(0);");
            } else {
                e.emit("VyneArray_f64 __empty = {NULL, 0, 0}; return __empty;");
            }
            break;
        default: e.emit("return 0;"); break;
    }

    e.emitBlockClose();
    e.emit("");
    e.exitFunction();
    e.popFunctionContext();
    e.clearNativeReturnType();
}

void FunctionNode::compile(C_Emitter& e) const {
    std::string mangledName = originalName;
    std::replace(mangledName.begin(), mangledName.end(), '.', '_');

    if (!targetModule.empty()) {
        mangledName = targetModule + "_" + mangledName;
    }

    // Register this function's return type so the region escape check
    // can see through calls to it. This fires for EVERY function that
    // ever gets compiled — top-level, group member, aliased import —
    // which makes the check robust against whichever container the
    // function happens to live in. Without it, an interface method or
    // any function that skips GroupNode::compile's FUNCTION branch
    // leaves no entry in functionReturnTypes, and `x = fn(...)` inside
    // a region trips VNE-070 even when fn returns a primitive.
    {
        CType retCt = CType::fromVType(returnType);
        if (returnType == VType::Array &&
            getReturnArrayElemType() != VType::Unknown) {
            retCt.args.push_back(CType::fromVType(getReturnArrayElemType()));
        }
        std::string orig    = originalName;
        std::string mangled = orig;
        std::replace(mangled.begin(), mangled.end(), '.', '_');

        e.registerFunctionReturnType(orig,    retCt);
        e.registerFunctionReturnType(mangled, retCt);

        // Also under the module / group prefix if there is one.
        if (!targetModule.empty()) {
            e.registerFunctionReturnType(
                targetModule + "_" + mangled, retCt);
            e.registerFunctionReturnType(
                targetModule + "." + orig,    retCt);
        }
    }

    e.emitGlobalDecl("VyneValue fn_" + mangledName + "(int arg_count, VyneValue* args);");
    e.pushFunctionContext();
    e.enterFunction(mangledName);

    e.emit("// fn: " + originalName);
    e.emitBlockOpen("VyneValue fn_" + mangledName +
                    "(int arg_count, VyneValue* args) {");

    emitFunctionBody(e, parameters, body, mangledName);

    e.emitBlockClose();
    e.emit("");

    e.exitFunction();
    e.popFunctionContext();

    {
        std::string nativeMangled = originalName;
        std::replace(nativeMangled.begin(), nativeMangled.end(), '.', '_');
        if (!targetModule.empty())
            nativeMangled = targetModule + "_" + nativeMangled;

        if (const std::string* nv = e.lookupNativeVariant(nativeMangled)) {
            CType retCt = CType::fromVType(returnType);
            if (returnType == VType::Array &&
                getReturnArrayElemType() != VType::Unknown) {
                retCt.args.push_back(CType::fromVType(getReturnArrayElemType()));
            }
            emitNativeFunctionBody(e, parameters, body, *nv, retCt);
        }
    }
}

void FunctionNode::compileAs(C_Emitter& e, const std::string& mangledName) const {
    std::string name = mangledName;
    std::replace(name.begin(), name.end(), '.', '_');

    // Register under the two names we know for sure. The dotted
    // alias-form (`vlin.cross_entropy`) is registered by the caller
    // (ImportNode::compile), because only the caller knows the alias.
    {
        CType retCt = CType::fromVType(returnType);
        if (returnType == VType::Array &&
            getReturnArrayElemType() != VType::Unknown) {
            retCt.args.push_back(CType::fromVType(getReturnArrayElemType()));
        }
        e.registerFunctionReturnType(name,         retCt);
        e.registerFunctionReturnType(originalName, retCt);
    }

    e.emitGlobalDecl("VyneValue fn_" + name + "(int arg_count, VyneValue* args);");
    e.pushFunctionContext();
    e.enterFunction(name);
    e.emit("// fn (aliased): " + mangledName);
    e.emitBlockOpen("VyneValue fn_" + name + "(int arg_count, VyneValue* args) {");

    emitFunctionBody(e, parameters, body, name);

    e.emitBlockClose();
    e.emit("");

    e.exitFunction();
    e.popFunctionContext();
}

std::string FunctionNode::getCExpr(C_Emitter& e) const {
    compile(e);
    std::string name = originalName;
    std::replace(name.begin(), name.end(), '.', '_');
    if (!targetModule.empty()) {
        name = targetModule + "_" + name;
    }
    return "fn_" + name;
}

