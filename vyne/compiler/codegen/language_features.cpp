#include "detail/codegen_helpers.h"

// Enums, defer, module lifecycle, null coalescing, membership and pipelines.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// ENUM, DEFER, DISMISS, DEPLOY
// ============================================================

std::string EnumNode::getCExpr(C_Emitter& e) const { return "vyne_null()"; }

void EnumNode::compile(C_Emitter& e) const {
    e.registerGroup(enumName);

    // 1. Declare each member as a global VyneValue
    for (const auto& [name, value] : members) {
        std::string mangled = "v_" + enumName + "_" + name;
        std::replace(mangled.begin(), mangled.end(), '.', '_');
        e.emitGlobalDecl("VyneValue " + mangled + ";");
        e.registerDeclaration(mangled);
    }

    // 2. Initialize in main
    e.pushMainContext();
    for (const auto& [name, value] : members) {
        std::string mangled = "v_" + enumName + "_" + name;
        std::replace(mangled.begin(), mangled.end(), '.', '_');
        e.emit(mangled + " = vyne_int(" + std::to_string(value) + ");");
    }
    e.popMainContext();
}

void DeferNode::compile(C_Emitter& e) const {
    if (isCollected()) {
        return;
    }

    throw std::runtime_error(
        "Compile Error: 'defer' is only supported at the top level of a function body "
        "in the C backend (line " + std::to_string(lineNumber) + "). "
        "Move the 'defer' to the function's top level, or use the interpreter "
        "with --interp.");
}

std::string DeferNode::getCExpr(C_Emitter& e) const { return "vyne_null()"; }

void DismissNode::compile(C_Emitter& e) const {
    e.emit("vyne_dismiss_module(\"" + originalName + "\");");
}
std::string DismissNode::getCExpr(C_Emitter& e) const { return "vyne_null()"; }

void DeployNode::compile(C_Emitter& e) const {
    e.emit("vyne_deploy_module(\"" + moduleName + "\");");
}
std::string DeployNode::getCExpr(C_Emitter& e) const {
    compile(e);
    return "vyne_null()";
}

// ============================================================
// NULL COALESCE ASSIGNMENT
// ============================================================

void NullCoalesceAssignmentNode::compile(C_Emitter& e) const {
    std::string cVar = "v_" + this->varName;
    std::replace(cVar.begin(), cVar.end(), '.', '_');

    if (e.isGlobalContext()) {
        if (e.getGlobalVars().count(cVar) == 0) {
            e.registerDeclaration(cVar);
            e.emitGlobalDecl("VyneValue " + cVar + ";");
        }
        e.pushMainContext();
        std::string val = e.boxAny(rhs->getCExpr(e));
        e.emit("if (" + cVar + ".type == V_NULL) {");
        e.emit("    " + cVar + " = " + val + ";");
        e.emit("}");
        e.popMainContext();
    } else {
        if (!e.isLocalDeclared(cVar)) {
            e.registerDeclaration(cVar);
            std::string val = e.boxAny(rhs->getCExpr(e));
            e.emit("VyneValue " + cVar + " = vyne_null();");
            e.emit("if (" + cVar + ".type == V_NULL) {");
            e.emit("    " + cVar + " = " + val + ";");
            e.emit("}");
        } else {
            std::string val = e.boxAny(rhs->getCExpr(e));
            e.emit("if (" + cVar + ".type == V_NULL) {");
            e.emit("    " + cVar + " = " + val + ";");
            e.emit("}");
        }
    }
}

std::string NullCoalesceAssignmentNode::getCExpr(C_Emitter& e) const {
    std::string cVar = "v_" + this->varName;
    std::replace(cVar.begin(), cVar.end(), '.', '_');
    return cVar;
}

// ============================================================
// NULL COALESCE MEMBER ASSIGNMENT
// ============================================================

void NullCoalesceMemberAssignmentNode::compile(C_Emitter& e) const {
    std::string recv = receiver->getCExpr(e);
    std::string val = e.boxAny(rhs->getCExpr(e));
    uint32_t fid = StringPool::intern(memberName);

    e.emit("{");
    e.emit("    VyneValue _field = vyne_struct_get(" + recv + ", " + std::to_string(fid) + ");");
    e.emit("    if (_field.type == V_NULL) {");
    e.emit("        vyne_struct_set(" + recv + ", " + std::to_string(fid) + ", \"" + memberName + "\", " + val + ");");
    e.emit("    }");
    e.emit("}");
}

std::string NullCoalesceMemberAssignmentNode::getCExpr(C_Emitter& e) const {
    compile(e);
    return "vyne_null()";
}

// ============================================================
// IN OPERATOR
// ============================================================

std::string InNode::getCExpr(C_Emitter& e) const {
    std::string leftVal = e.boxAny(left->getCExpr(e));
    std::string rightVal = e.boxAny(right->getCExpr(e));
    std::string temp = e.newTemp("in");

    e.emit("VyneValue " + temp + " = vyne_in_operator(" +
           leftVal + ", " + rightVal + ", " + (isNot ? "1" : "0") + ");");
    return temp;
}

void InNode::compile(C_Emitter& e) const { getCExpr(e); }

// ============================================================
// NULL COALESCE
// ============================================================

std::string NullCoalesceNode::getCExpr(C_Emitter& e) const {
    std::string leftVal = e.boxAny(left->getCExpr(e));
    std::string rightVal = e.boxAny(right->getCExpr(e));
    std::string temp = e.newTemp("coalesce");

    e.emit("VyneValue " + temp + " = (" + leftVal + ".type == V_NULL) ? " +
           rightVal + " : " + leftVal + ";");
    return temp;
}

void NullCoalesceNode::compile(C_Emitter& e) const { getCExpr(e); }

// ============================================================
// PIPELINE
// ============================================================

void PipelineNode::compile(C_Emitter& e) const {
    if (left) left->compile(e);
    if (right) right->compile(e);
}

std::string PipelineNode::getCExpr(C_Emitter& e) const {
    std::string leftVal = left->getCExpr(e);

    // --- Case 1: right is a FUNCTION_CALL: a |> f(b, c) -> f(a, b, c) ---
    if (right->type() == NodeType::FUNCTION_CALL) {
        auto* fc = static_cast<FunctionCallNode*>(right.get());
        const auto& args = fc->getArguments();
        int totalArgs = 1 + (int)args.size();

        std::string argArr = e.newTemp("pipe_args");
        std::string retTemp = e.newTemp("pipe_ret");

        e.emit("VyneValue* " + argArr + " = (VyneValue*)arena_alloc(sizeof(VyneValue) * " +
               std::to_string(totalArgs) + ");");
        e.emit(argArr + "[0] = " + e.boxAny(leftVal) + ";");

        for (size_t i = 0; i < args.size(); ++i) {
            std::string v = e.boxAny(args[i]->getCExpr(e));
            e.emit(argArr + "[" + std::to_string(i + 1) + "] = " + v + ";");
        }

        std::string mangledName = fc->getOriginalName();
        std::replace(mangledName.begin(), mangledName.end(), '.', '_');

        e.emit("VyneValue " + retTemp + " = fn_" + mangledName +
               "(" + std::to_string(totalArgs) + ", " + argArr + ");");
        return retTemp;
    }

    // --- Case 2: right is a METHOD_CALL: a |> obj.m(b) -> obj.m(a, b) ---
    if (right->type() == NodeType::METHOD_CALL) {
        auto* mc = static_cast<MethodCallNode*>(right.get());
        const auto& args = mc->getArguments();
        int totalArgs = 1 + (int)args.size();

        std::string recv = mc->getReceiver()->getCExpr(e);
        std::string methodName = mc->getMethodName();

        // Route through struct method call if method wasn't one of the
        // built-in array/map ones. Otherwise fall back to a struct call.
        std::string temp = e.newTemp("pipe_mret");
        std::string argArr = e.newTemp("pipe_m_args");

        e.emit("VyneValue " + temp + " = vyne_null();");
        e.emitBlockOpen("if (" + recv + ".type == V_STRUCT) {");
        e.emit("VyneValue* " + argArr + " = (VyneValue*)arena_alloc(sizeof(VyneValue) * " +
               std::to_string(totalArgs + 1) + ");");
        e.emit(argArr + "[0] = " + recv + ";");
        e.emit(argArr + "[1] = " + e.boxAny(leftVal) + ";");
        for (size_t i = 0; i < args.size(); ++i) {
            e.emit(argArr + "[" + std::to_string(i + 2) + "] = " +
                   e.boxAny(args[i]->getCExpr(e)) + ";");
        }
        e.emit(temp + " = vyne_struct_call(" + recv + ", \"" + methodName + "\", " +
               std::to_string(totalArgs + 1) + ", " + argArr + ");");
        e.emitBlockClose();
        return temp;
    }

    if (right) right->compile(e);
    return leftVal;
}

