#include "detail/codegen_helpers.h"
#include "ctype.h"

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

// ============================================================
// Region escape check (Phase 1)
// ------------------------------------------------------------
// Rejects the pattern:
//
//     outer = <value allocated inside the current region>;
//
// where `outer` was declared at a shallower region depth than
// the current one. The value would dangle after the region's
// rewind.
//
// Safe cases:
//   - RHS has a primitive static type (Int64/Float64/Bool/Null):
//     copied by value, no arena involvement.
//   - RHS is a variable declared at the same or shallower depth.
//   - RHS is a variable that has been committed via region.commit.
//   - LHS is a fresh declaration: it dies with the region, no leak.
//
// Unsafe cases (rejected):
//   - Any other assignment where LHS is a live outer variable.
//
// This is deliberately syntactic. §6.4 of the paper names the
// patterns the check cannot see (indirect escape through a
// function return, escape through a container, etc.).
// ============================================================

static void checkRegionEscape(C_Emitter& e,
                              const std::string& lhsVarName,
                              const std::string& lhsDisplayName,
                              const ASTNode* rhs,
                              int lineNumber)
{
    if (!rhs) return;
    if (!e.hasRegion()) return;

    int lhsDepth = e.lookupLocalRegionDepth(lhsVarName);
    // Globals and variables we can't find are treated as depth 0.
    // A global declared at the top level is at depth 0 by definition.
    if (lhsDepth < 0) lhsDepth = 0;

    int curDepth = e.currentRegionDepth();
    if (lhsDepth >= curDepth) return;  // LHS is as deep or deeper — safe

    // Primitive RHS: copied by value, always safe to escape.
    VType st = rhs->getStaticType();
    if (st == VType::Int64 || st == VType::Float64 ||
        st == VType::Bool  || st == VType::Null) {
        return;
    }

    if (rhs->type() == NodeType::FUNCTION_CALL ||
        rhs->type() == NodeType::METHOD_CALL) {

        std::string name;
        if (rhs->type() == NodeType::FUNCTION_CALL) {
            name = static_cast<const FunctionCallNode*>(rhs)->getOriginalName();
        } else {
            name = static_cast<const MethodCallNode*>(rhs)->getMethodName();
        }

        auto primitiveReturn = [&](const std::string& n) -> bool {
            const CType* retCt = e.getFunctionReturnType(n);
            return retCt && retCt->isPrimitive();
        };

        if (primitiveReturn(name)) return;

        std::string mangled = name;
        std::replace(mangled.begin(), mangled.end(), '.', '_');
        if (primitiveReturn(mangled)) return;
    }

    // Variable RHS: safe if the source is also at a shallower depth,
    // or if it has been committed.
    if (rhs->type() == NodeType::VARIABLE) {
        auto* var = static_cast<const VariableNode*>(rhs);
        std::string rs = var->getOriginalName();
        std::replace(rs.begin(), rs.end(), '.', '_');
        std::string prefix = e.getActiveFunctionPrefix();
        std::string rname = prefix.empty()
            ? ("v_" + rs)
            : ("v_" + prefix + "_" + rs);
        int rhsDepth = e.lookupLocalRegionDepth(rname);
        if (rhsDepth >= 0 && rhsDepth <= lhsDepth) return;
        // Not a tracked local — could be a global, or a name we lost.
        // Treat unresolved as unsafe.
    }

    throw std::runtime_error(
        "Escape Error (VNE-070): variable '" + lhsDisplayName +
        "' is declared outside the current region (depth " +
        std::to_string(lhsDepth) + ") but is being assigned a value "
        "allocated inside a region (current depth " +
        std::to_string(curDepth) + ") at line " +
        std::to_string(lineNumber) + ".\n"
        "  The value would dangle after the region's rewind.\n"
        "  Fix one of these ways:\n"
        "    - declare '" + lhsDisplayName + "' inside the region, or\n"
        "    - copy the value out with region.commit(tmp) and assign "
        "from tmp, or\n"
        "    - move the assignment to before the region.");
}

// ============================================================
// Shape-typed scratch store
// ------------------------------------------------------------
// Lower `scratch_dst = rhs` into an element-wise copy. Three
// cases, dispatched on the static type of `rhs`:
//
//   1. rhs is another scratch of matching shape and element kind
//        -> memcpy, no per-element work
//   2. rhs is a typed array (VyneArray_f64 / VyneArray_i64) of
//      matching element kind
//        -> element loop, one load and one store per element,
//           no runtime tag check
//   3. rhs is boxed (VyneValue)
//        -> runtime shape check, then per-element tag check and
//           numeric coercion
//
// The destination is a raw C array (double v_x[N] / int64_t
// v_x[N]) declared by ScratchNode::compile. The caller guarantees
// dstType.hasShape() and dstType.args[0] is Float64 or Int64.
// ============================================================

static std::string _shapeStr(const CType& ct) {
    std::string s;
    for (size_t i = 0; i < ct.shape.size(); ++i) {
        if (i) s += ", ";
        s += std::to_string(ct.shape[i]);
    }
    return s;
}

static void emitScratchStore(C_Emitter& e,
                             const std::string& dstName,
                             const CType& dstType,
                             const ASTNode* rhsNode,
                             int lineNumber) {
    VType elem = dstType.args.empty()
               ? VType::Float64
               : dstType.args[0].toVType();
    int64_t n = dstType.numElements();
    const char* elemCName = (elem == VType::Float64) ? "double" : "int64_t";

    std::string src = rhsNode->getCExpr(e);
    const CType* rt = e.lookupType(src);

    // ---- Case 1: scratch-to-scratch, same element kind ----
    if (rt && rt->hasShape() && !rt->args.empty() &&
        rt->args[0].toVType() == elem) {
        if (!rt->sameShape(dstType)) {
            throw std::runtime_error(
                "Shape Error: cannot assign scratch of shape [" +
                _shapeStr(*rt) + "] to scratch of shape [" +
                _shapeStr(dstType) + "] (line " +
                std::to_string(lineNumber) + ").");
        }
        e.emit("memcpy(" + dstName + ", " + src + ", " +
               std::to_string(n) + " * sizeof(" + elemCName + "));");
        return;
    }

    // ---- Case 2: typed array (VyneArray_f64 / _i64) -> scratch ----
    if (rt && rt->kind == CType::Kind::Array && !rt->args.empty() &&
        rt->args[0].toVType() == elem) {
        std::string k = e.newTemp("k");
        e.emitBlockOpen("for (int64_t " + k + " = 0; " + k +
                        " < " + std::to_string(n) + "; ++" + k + ") {");
        e.emit(dstName + "[" + k + "] = " + src + ".data[" + k + "];");
        e.emitBlockClose();
        return;
    }

    // ---- Case 3: boxed source ----
    // Shape is a runtime property here. If the src is a scratch or
    // typed array we'd have hit case 1 or 2; anything else is a
    // VyneValue, and we validate at runtime.
    std::string srcVar = e.newTemp("src");
    e.emit("VyneValue " + srcVar + " = " + e.boxAny(src) + ";");
    e.emit("if (" + srcVar + ".type != V_ARRAY || " +
           srcVar + ".as.arr->size != " + std::to_string(n) + ") {");
    e.emit("    fprintf(stderr, \"Runtime error: shape mismatch "
           "assigning to a scratch of " + std::to_string(n) +
           " elements\\n\"); exit(1);");
    e.emit("}");

    std::string k = e.newTemp("k");
    e.emitBlockOpen("for (int64_t " + k + " = 0; " + k +
                    " < " + std::to_string(n) + "; ++" + k + ") {");
    std::string cell = srcVar + ".as.arr->elements[" + k + "]";
    if (elem == VType::Float64) {
        e.emit(dstName + "[" + k + "] = ((" + cell +
               ").type == V_FLOAT64) ? (" + cell +
               ").as.f64 : (double)(" + cell + ").as.i64;");
    } else {
        e.emit(dstName + "[" + k + "] = ((" + cell +
               ").type == V_INT64) ? (" + cell +
               ").as.i64 : (int64_t)(" + cell + ").as.f64;");
    }
    e.emitBlockClose();
}

void AssignmentNode::compile(C_Emitter& e) const {
    if (isReference) {
        throw std::runtime_error(
            "Compile Error: Reference variables are not supported by the C backend "
            "(line " + std::to_string(lineNumber) + "). Use the interpreter instead.");
    }

    // --- Region escape check (Phase 1) --------------------------------
    // Only checks reassignments to already-declared variables. A fresh
    // declaration inside a region dies with the region, no leak.
    {
        std::string sanitized = originalName;
        std::replace(sanitized.begin(), sanitized.end(), '.', '_');
        std::string prefix = e.getActiveFunctionPrefix();
        std::string bareName = "v_" + sanitized;
        std::string localName = prefix.empty()
            ? bareName
            : ("v_" + prefix + "_" + sanitized);

        bool isExisting = e.isLocalDeclared(localName) ||
                          e.isGlobalDeclared(bareName);
        bool useGlobalHere = e.getGlobalVars().count(bareName) > 0;

        if (isExisting) {
            std::string target = useGlobalHere ? bareName : localName;
            checkRegionEscape(e, target, originalName, rhs.get(), lineNumber);
        }
    }
    // --- end escape check ---------------------------------------------

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
            if (isDeclaration && declared.isPrimitive()) {
                e.declareGlobal(bareName, declared);
                e.emitGlobalDecl(declared.cTypeName() + " " + bareName + " = 0;");
            } else {
                e.declareGlobal(bareName, CType::fromKind(CType::Kind::Unknown));
                e.emitGlobalDecl("VyneValue " + bareName + ";");
            }
        }

        const CType* reg = e.lookupGlobalType(bareName);
        if (reg && reg->isPrimitive()) {
            std::string val = rhs->getCExpr(e);
            std::string init = nativeInit(e, rhs.get(), val, *reg);
            e.emit(bareName + " = " + init + ";");
        } else {
            std::string val = rhs->getCExpr(e);
            e.emit(bareName + " = " + e.boxAny(val) + ";");
        }
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

    // --- shape-typed scratch reassignment: rhs is copied element-wise
    //     into the destination's raw C array ---
    if (existing && existing->hasShape()) {
        emitScratchStore(e, varName, *existing, rhs.get(), lineNumber);
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

