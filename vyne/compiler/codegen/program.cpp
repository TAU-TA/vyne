#include "detail/codegen_helpers.h"

// Program and block emission, plus ternary expressions.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// PROGRAM / BLOCK
// ============================================================

void ProgramNode::compile(C_Emitter& e) const {
    for (const auto& stmt : statements) {
        if (stmt && stmt->type() == NodeType::FUNCTION) {
            auto* fn = static_cast<FunctionNode*>(stmt.get());

            std::vector<std::string> paramNames;
            std::vector<CType> paramTypes;
            bool allNativeCallable = true;

            for (const auto& p : fn->getParameters()) {
                paramNames.push_back(p.name);
                CType ct = CType::fromVType(p.type);

                // Carry the element type for Array<Float64> / Array<Int64> so the
                // native dispatcher can match the argument's typed-array CType.
                if (p.type == VType::Array && p.arrayElemType != VType::Unknown) {
                    ct.args.push_back(CType::fromVType(p.arrayElemType));
                }
                paramTypes.push_back(ct);

                bool paramOK = ct.isPrimitive() ||
                            (ct.kind == CType::Kind::Array && !ct.args.empty());
                if (!paramOK || p.isReference) allNativeCallable = false;
            }

            CType retCt = CType::fromVType(fn->getReturnType());
            if (fn->getReturnType() == VType::Array &&
                fn->getReturnArrayElemType() != VType::Unknown) {
                retCt.args.push_back(CType::fromVType(fn->getReturnArrayElemType()));
            }
            bool retNative = retCt.isPrimitive() ||
                            (retCt.kind == CType::Kind::Array && !retCt.args.empty());

            // Conservative: reject functions with top-level defer or try/catch.
            bool hasDeferOrTry = false;
            for (const auto& s : fn->getBody()) {
                if (s && (s->type() == NodeType::DEFER ||
                        s->type() == NodeType::TRY_CATCH)) {
                    hasDeferOrTry = true;
                    break;
                }
            }

            e.registerFunctionSignature(fn->getOriginalName(),
                                         std::move(paramNames));
            e.registerFunctionParamTypes(fn->getOriginalName(),
                                        std::move(paramTypes));
            {
                std::string orig = fn->getOriginalName();
                std::string mangled = orig;
                std::replace(mangled.begin(), mangled.end(), '.', '_');
                e.registerFunctionReturnType(orig,    retCt);
                e.registerFunctionReturnType(mangled, retCt);
            }

            if (allNativeCallable && retNative && !hasDeferOrTry) {
                std::string orig = fn->getOriginalName();
                std::string mangled = orig;
                std::replace(mangled.begin(), mangled.end(), '.', '_');
                std::string moduleMangled = mangled;
                if (!fn->getTargetModule().empty())
                    moduleMangled = fn->getTargetModule() + "_" + mangled;

                // Primary: the module-qualified name. External callers
                // (`vfft.fft_kernel(...)` from another module) look this up.
                e.registerNativeVariant(moduleMangled,
                                        moduleMangled + "_native");

                // Secondary: the bare name. Calls from inside the same
                // module (`fft_kernel(...)` inside forward/inverse) go
                // through FunctionCallNode::getCExpr, which has no prefix
                // at hand and can only query the bare name. Without this,
                // intra-module calls silently fall back to the boxed ABI,
                // producing `fn_vfft_fft_kernel(7, args)` instead of the
                // native call.
                if (moduleMangled != mangled) {
                    e.registerNativeVariant(mangled,
                                            moduleMangled + "_native");
                }
            }
        }
    }

    for (const auto& stmt : statements)
        if (stmt) stmt->compile(e);
}

void ProgramNode::compileAliased(C_Emitter& e, const std::string& alias) const {
    e.registerGroup(alias);
    e.pushGlobalContext();
    e.emit("// --- import as " + alias + " ---");

    for (const auto& stmt : statements) {
        if (!stmt) continue;

        if (stmt->type() == NodeType::FUNCTION) {
            auto* fn = static_cast<FunctionNode*>(stmt.get());
            e.popGlobalContext();
            fn->compileAs(e, alias + "_" + fn->getOriginalName());
            e.pushGlobalContext();
        }
        else if (stmt->type() == NodeType::ASSIGNMENT) {
            auto* assign = static_cast<AssignmentNode*>(stmt.get());
            std::string mangled = "v_" + alias + "_" + assign->getOriginalName();
            std::replace(mangled.begin(), mangled.end(), '.', '_');

            CType declared = CType::fromVType(assign->getExpectedType());

            if (declared.isPrimitive()) {
                e.declareGlobal(mangled, declared);
                e.emitGlobalDecl(declared.cTypeName() + " " + mangled + " = 0;");
            } else {
                e.registerDeclaration(mangled);
                e.emitGlobalDecl("VyneValue " + mangled + ";");
            }

            e.popGlobalContext();
            std::string val = assign->getRHS()->getCExpr(e);
            if (declared.isPrimitive()) {
                std::string init = coerceToNative(
                    e, assign->getRHS(), val, declared.toVType());
                e.emit(mangled + " = " + init + ";");
            } else {
                e.emit(mangled + " = " + e.boxAny(val) + ";");
            }
            e.pushGlobalContext();
        }
        else if (stmt->type() == NodeType::IMPORT) {
            continue;
        }
        else {
            e.popGlobalContext();
            stmt->compile(e);
            e.pushGlobalContext();
        }
    }
    e.popGlobalContext();

    std::string modVirtualVar = "v_" + alias;
    std::replace(modVirtualVar.begin(), modVirtualVar.end(), '.', '_');

    if (e.getGlobalVars().count(modVirtualVar) == 0) {
        e.registerDeclaration(modVirtualVar);
        e.emitGlobalDecl("VyneValue " + modVirtualVar + ";");
    }

    e.pushMainContext();
    e.emit("// Virtual Module registration for " + alias);
    e.emitBlockOpen("{");
    std::string tempS = e.newTemp("mod_s");
    e.emit("VyneStruct* " + tempS + " = (VyneStruct*)arena_alloc(sizeof(VyneStruct));");
    e.emit(tempS + "->type_name = \"" + alias + "\";");
    e.emit(tempS + "->field_count = 0;");
    e.emit(tempS + "->fields = NULL;");
    e.emit(tempS + "->methods = NULL;");
    e.emit(tempS + "->method_count = 0;");
    e.emit(modVirtualVar + ".type = V_STRUCT; " + modVirtualVar + ".as.strct = " + tempS + ";");

    for (const auto& stmt : statements) {
        if (stmt && stmt->type() == NodeType::FUNCTION) {
            auto* fn = static_cast<FunctionNode*>(stmt.get());
            std::string fnOrigName = fn->getOriginalName();
            std::string fnRealCName = "fn_" + alias + "_" + fnOrigName;
            std::replace(fnRealCName.begin(), fnRealCName.end(), '.', '_');

            std::string wrapperName = "wrap_" + alias + "_" + fnOrigName;
            std::replace(wrapperName.begin(), wrapperName.end(), '.', '_');

            e.pushFunctionContext();
            e.emitGlobalDecl("VyneValue " + wrapperName + "(int arg_count, VyneValue* args);");
            e.emitBlockOpen("VyneValue " + wrapperName + "(int arg_count, VyneValue* args) {");
            e.emit("if (arg_count > 0) {");
            e.emit("    return " + fnRealCName + "(arg_count - 1, args + 1);");
            e.emit("}");
            e.emit("return " + fnRealCName + "(arg_count, args);");
            e.emitBlockClose();
            e.popFunctionContext();

            e.emit("vyne_register_method(\"" + alias + "\", \"" +
                   fnOrigName + "\", " + wrapperName + ");");
        }
    }
    e.emitBlockClose();
    e.popMainContext();
}

std::string ProgramNode::getCExpr(C_Emitter& e) const {
    compile(e);
    return "vyne_null()";
}

void BlockNode::compile(C_Emitter& e) const {
    e.emitBlockOpen("{");
    for (const auto& stmt : statements)
        if (stmt) stmt->compile(e);
    e.emitBlockClose();
}

std::string BlockNode::getCExpr(C_Emitter& e) const {
    if (statements.empty()) return "vyne_null()";

    if (statements.size() == 1) {
        return statements[0]->getCExpr(e);
    }

    for (size_t i = 0; i + 1 < statements.size(); ++i) {
        if (statements[i]) statements[i]->compile(e);
    }
    return statements.back()->getCExpr(e);
}
// ============================================================
// TERNARY
// ============================================================

std::string TernaryNode::getCExpr(C_Emitter& e) const {
    std::string cond = e.boxAny(condition->getCExpr(e));
    std::string tVal = e.boxAny(trueExpr->getCExpr(e));
    std::string fVal = e.boxAny(falseExpr->getCExpr(e));
    std::string temp = e.newTemp("tern");
    e.emit("VyneValue " + temp + " = vyne_is_truthy(" + cond + ") ? " +
           tVal + " : " + fVal + ";");
    return temp;
}

void TernaryNode::compile(C_Emitter& e) const { getCExpr(e); }

