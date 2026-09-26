#include "detail/codegen_helpers.h"

// Variable reads and assignments, including typed native initialization and boxing boundaries.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// VARIABLES AND ASSIGNMENTS
// ============================================================

std::string VariableNode::getCExpr(C_Emitter& e) const {
    std::string sanitized = originalName;
    std::replace(sanitized.begin(), sanitized.end(), '.', '_');

    std::string prefix = e.getActiveFunctionPrefix();
    std::string resolved;

    if (!prefix.empty()) {
        std::string localName = "v_" + prefix + "_" + sanitized;
        if (e.isLocalDeclared(localName)) {
            resolved = localName;
        } else {
            resolved = "v_" + sanitized;
        }
    } else {
        resolved = "v_" + sanitized;
    }

    if (e.isReference(resolved)) {
        return "(*" + resolved + ")";
    }
    return resolved;
}

void VariableNode::compile(C_Emitter& e) const {
    // Bare variable reference as a statement is a no-op in C
}

std::string AssignmentNode::getCExpr(C_Emitter& e) const {
    std::string name = "v_" + originalName;
    std::replace(name.begin(), name.end(), '.', '_');
    return name;
}

// M1 (issue #79): build the initializer expression for a native-typed local
// declaration or assignment of static type `declared`.
//
//   - NumberNode literal → raw numeric literal (C implicitly widens int → double)
//   - Existing native expression of the same kind → used directly
//   - Anything else (boxed VyneValue) → runtime-checked coercion into the
//     native type, mirroring the ForNode bound conversion and the
//     interpreter's convertIfNeeded semantics.
static std::string nativeInit(C_Emitter& e, const ASTNode* rhs,
                              const std::string& val, const CType& declared) {
    if (rhs->type() == NodeType::NUMBER) {
        auto* num = static_cast<const NumberNode*>(rhs);
        if ((declared.kind == CType::Kind::Int64 &&
             num->getStaticType() == VType::Int64) ||
            (declared.kind == CType::Kind::Float64)) {
            return num->nativeLiteral();
        }
    }
    if (rhs->type() == NodeType::BOOLEAN &&
        declared.kind == CType::Kind::Bool) {
        return static_cast<const BooleanNode*>(rhs)->nativeLiteral();
    }

    const CType* vt = e.exprNativeType(val);
    if (vt && vt->isPrimitive()) {
        // Native value already in hand → same kind directly, other numeric
        // kind via a C cast (mirrors the interpreter's convertIfNeeded).
        if (vt->kind == declared.kind) return val;
        if (declared.kind == CType::Kind::Float64 && vt->kind == CType::Kind::Int64)
            return "(double)(" + val + ")";
        if (declared.kind == CType::Kind::Int64 && vt->kind == CType::Kind::Float64)
            return "(int64_t)(" + val + ")";
        return val;
    }

    switch (declared.kind) {
        case CType::Kind::Int64:
            return "((" + val + ").type == V_INT64) ? (" + val +
                   ").as.i64 : (int64_t)(" + val + ").as.f64";
        case CType::Kind::Float64:
            return "((" + val + ").type == V_FLOAT64) ? (" + val +
                   ").as.f64 : (double)(" + val + ").as.i64";
        case CType::Kind::Bool:
            return "((" + val + ").as.i64 != 0)";
        default:
            return val;
    }
}

void AssignmentNode::compile(C_Emitter& e) const {
    if (isReference) {
        throw std::runtime_error(
            "Compile Error: Reference variables are not supported by the C backend "
            "(line " + std::to_string(lineNumber) + "). Use the interpreter instead.");
    }

    std::string sanitized = originalName;
    std::replace(sanitized.begin(), sanitized.end(), '.', '_');

    std::string prefix = e.getActiveFunctionPrefix();
    std::string bareName = "v_" + sanitized;
    bool hasGlobal = e.getGlobalVars().count(bareName) > 0;
    bool isDeclaration = (expectedType != VType::Unknown);

    bool useGlobal;
    if (prefix.empty()) {
        useGlobal = hasGlobal || e.isTopLevelOfMain();
    } else if (!isDeclaration && hasGlobal) {
        useGlobal = true;
    } else {
        useGlobal = false;
    }

    std::string varName;
    if (prefix.empty() || useGlobal) {
        varName = bareName;
    } else {
        varName = "v_" + prefix + "_" + sanitized;
    }

    if (useGlobal) {
        CType declared = CType::fromVType(expectedType);

        if (isDeclaration && declared.kind == CType::Kind::Array) {
            VType elem = inferArrayElemType(rhs.get());
            if (elem != VType::Unknown) {
                std::string val = rhs->getCExpr(e);
                const CType* rt = e.lookupType(val);
                if (rt && rt->kind == CType::Kind::Array && !rt->args.empty()) {
                    if (!hasGlobal) {
                        CType arrType;
                        arrType.kind = CType::Kind::Array;
                        arrType.args.push_back(CType::fromVType(elem));
                        e.declareGlobal(bareName, arrType);
                        e.emitGlobalDecl(CType::arrayContainerName(elem) + " " +
                                         bareName + ";");
                    }
                    e.emit(bareName + " = " + val + ";");
                    return;
                }
            }
        }

        const CType* existing = e.lookupGlobalType(bareName);
        if (existing && existing->kind == CType::Kind::Array &&
            !existing->args.empty()) {
            VType elem = existing->args[0].toVType();
            std::string val = rhs->getCExpr(e);
            const CType* rt = e.lookupType(val);
            if (rt && rt->kind == CType::Kind::Array && !rt->args.empty() &&
                rt->args[0].toVType() == elem) {
                e.emit(bareName + " = " + val + ";");
            } else {
                throw std::runtime_error(
                    "Compile Error: cannot reassign typed-array global '" +
                    originalName +
                    "' from a value of a different element type (line " +
                    std::to_string(lineNumber) + ").");
            }
            return;
        }

        if (!hasGlobal) {
            e.declareGlobal(bareName, CType::fromKind(CType::Kind::Unknown));
            e.emitGlobalDecl("VyneValue " + bareName + ";");
        }
        std::string val = rhs->getCExpr(e);
        e.emit(bareName + " = " + e.boxAny(val) + ";");
        return;
    }

    if (!declaredTypeName.empty()) {
        if (useGlobal) e.setGlobalStructType(bareName, declaredTypeName);
        else           e.setLocalStructType(varName, declaredTypeName);
    }

    // --- fresh local declaration ---
    if (!e.isLocalDeclared(varName)) {
        CType declared = CType::fromVType(expectedType);

        if (isDeclaration && declared.kind == CType::Kind::Array) {
            VType elem = inferArrayElemType(rhs.get());
            if (elem != VType::Unknown) {
                std::string val = rhs->getCExpr(e);
                const CType* rt = e.lookupType(val);
                if (rt && rt->kind == CType::Kind::Array && !rt->args.empty()) {
                    CType arrType;
                    arrType.kind = CType::Kind::Array;
                    arrType.args.push_back(CType::fromVType(elem));
                    e.declareLocal(varName, arrType);
                    e.emit(CType::arrayContainerName(elem) + " " + varName +
                           " = " + val + ";");
                    return;
                }
                // RHS didn't materialize as a typed array — box it.
                e.registerDeclaration(varName);
                e.emit("VyneValue " + varName + " = " +
                       e.boxAny(val)+ ";");
                return;
            }
        }

        if (isDeclaration && declared.isPrimitive()) {
            std::string val = rhs->getCExpr(e);
            std::string init = nativeInit(e, rhs.get(), val, declared);
            e.declareLocal(varName, declared);
            e.emit(declared.cTypeName() + " " + varName + " = " + init + ";");
        } else {
            e.registerDeclaration(varName);
            std::string val = rhs->getCExpr(e);
            e.emit("VyneValue " + varName + " = " +
                   e.boxAny(val) + ";");
        }
        return;
    }

    // --- reassignment to an existing local ---
    const CType* existing = e.lookupLocalType(varName);

    if (existing && existing->isPrimitive()) {
        std::string val = rhs->getCExpr(e);
        std::string init = nativeInit(e, rhs.get(), val, *existing);
        e.emit(varName + " = " + init + ";");
        return;
    }

    // --- shape-typed scratch local: RHS must be copied element-wise,
    //     because scratch lives as a raw C array, not a VyneArray struct ---
    if (existing && existing->hasShape()) {
        VType elem = existing->args.empty()
                   ? VType::Float64
                   : existing->args[0].toVType();
        int64_t n  = existing->numElements();
        const char* ctName = (elem == VType::Float64) ? "double" : "int64_t";

        std::string src = rhs->getCExpr(e);
        const CType* rt = e.lookupType(src);

        if (rt && rt->hasShape() && !rt->args.empty() &&
            rt->args[0].toVType() == elem) {
            e.emit("memcpy(" + varName + ", " + src + ", " +
                   std::to_string(n) + " * sizeof(" + ctName + "));");
            return;
        }

        if (rt && rt->kind == CType::Kind::Array && !rt->args.empty() &&
            rt->args[0].toVType() == elem) {
            std::string k = e.newTemp("k");
            e.emitBlockOpen("for (int64_t " + k + " = 0; " + k +
                            " < " + std::to_string(n) + "; ++" + k + ") {");
            e.emit(varName + "[" + k + "] = " + src + ".data[" + k + "];");
            e.emitBlockClose();
            return;
        }

        std::string srcVar = e.newTemp("src");
        e.emit("VyneValue " + srcVar + " = " + e.boxAny(src) + ";");
        e.emit("if (" + srcVar + ".type != V_ARRAY || " +
               srcVar + ".as.arr->size != " + std::to_string(n) + ") {");
        e.emit("    fprintf(stderr, \"shape mismatch assigning to " +
               originalName + "\\n\"); exit(1);");
        e.emit("}");
        std::string k = e.newTemp("k");
        e.emitBlockOpen("for (int64_t " + k + " = 0; " + k +
                        " < " + std::to_string(n) + "; ++" + k + ") {");
        std::string cell = srcVar + ".as.arr->elements[" + k + "]";
        if (elem == VType::Float64) {
            e.emit(varName + "[" + k + "] = ((" + cell + ").type == V_FLOAT64) "
                   "? (" + cell + ").as.f64 : (double)(" + cell + ").as.i64;");
        } else {
            e.emit(varName + "[" + k + "] = ((" + cell + ").type == V_INT64) "
                   "? (" + cell + ").as.i64 : (int64_t)(" + cell + ").as.f64;");
        }
        e.emitBlockClose();
        return;
    }

    if (existing && existing->kind == CType::Kind::Array &&
        !existing->args.empty()) {
        VType elem = existing->args[0].toVType();
        std::string val = rhs->getCExpr(e);
        const CType* rt = e.lookupType(val);
        if (rt && rt->kind == CType::Kind::Array && !rt->args.empty() &&
            rt->args[0].toVType() == elem) {
            e.emit(varName + " = " + val + ";");
        } else {
            throw std::runtime_error(
                "Compile Error: cannot reassign typed array '" + originalName +
                "' from a value of a different element type (line " +
                std::to_string(lineNumber) + ").");
        }
        return;
    }

    // --- boxed local ---
    std::string val = rhs->getCExpr(e);
    e.emit(varName + " = " + e.boxAny(val)+ ";");
}

