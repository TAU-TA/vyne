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
            for (const auto& p : fn->getParameters()) paramNames.push_back(p.name);
            e.registerFunctionSignature(fn->getOriginalName(), std::move(paramNames));
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
            e.emit("VyneValue " + mangled + ";");
            e.popGlobalContext();
            std::string val = assign->getRHS()->getCExpr(e);
            e.emit(mangled + " = " + e.boxAny(val) + ";");
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

