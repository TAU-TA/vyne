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

void FunctionNode::compile(C_Emitter& e) const {
    std::string mangledName = originalName;
    std::replace(mangledName.begin(), mangledName.end(), '.', '_');

    if (!targetModule.empty()) {
        mangledName = targetModule + "_" + mangledName;
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
}

void FunctionNode::compileAs(C_Emitter& e, const std::string& mangledName) const {
    std::string name = mangledName;
    std::replace(name.begin(), name.end(), '.', '_');

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

