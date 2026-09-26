#include "detail/codegen_helpers.h"

// If/while and return/break/continue; preserves deferred cleanup control flow.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// CONTROL FLOW
// ============================================================

void IfNode::compile(C_Emitter& e) const {
    std::string cond = e.boxAny(condition->getCExpr(e));
    e.emitBlockOpen("if (vyne_is_truthy(" + cond + ")) {");
    if (body) body->compile(e);
    e.emitBlockClose();
    if (elseBody) {
        e.emitBlockOpen("else {");
        elseBody->compile(e);
        e.emitBlockClose();
    }
}

std::string IfNode::getCExpr(C_Emitter& e) const {
    std::string temp = e.newTemp("ifres");
    e.emit("VyneValue " + temp + " = vyne_null();");

    std::string cond = e.boxAny(condition->getCExpr(e));
    e.emitBlockOpen("if (vyne_is_truthy(" + cond + ")) {");
    if (body) {
        std::string bv = e.boxAny(body->getCExpr(e));
        e.emit(temp + " = " + bv + ";");
    }
    e.emitBlockClose();

    if (elseBody) {
        e.emitBlockOpen("else {");
        std::string ev = e.boxAny(elseBody->getCExpr(e));
        e.emit(temp + " = " + ev + ";");
        e.emitBlockClose();
    }

    return temp;
}

void WhileNode::compile(C_Emitter& e) const {
    e.emitBlockOpen("while (1) {");
    std::string cond = e.boxAny(condition->getCExpr(e));
    e.emit("if (!vyne_is_truthy(" + cond + ")) break;");
    if (body) body->compile(e);
    e.emitBlockClose();
}

std::string WhileNode::getCExpr(C_Emitter& e) const {
    compile(e);
    return "vyne_null()";
}

void ReturnNode::compile(C_Emitter& e) const {
    std::string expr = expression ? e.boxAny(expression->getCExpr(e))
                                  : "vyne_null()";

    // Every region we're lexically inside at the point of this return.
    // A `return` exits all of them; the question is whether we can safely
    // rewind the arena on the way out.
    size_t nRegions = e.getRegionStack().size();

    // Only primitives survive a rewind: Int64 / Float64 / Bool / Null are
    // copied by value. Array / Map / String / Struct are references into
    // the arena and would dangle.
    //
    // VType::Unknown means the static type isn't provable — treat it as
    // unsafe, matching the "box on uncertainty" rule elsewhere in this file.
    VType retType = expression ? expression->getStaticType() : VType::Null;
    bool primitiveSafe =
        (retType == VType::Int64  || retType == VType::Float64 ||
         retType == VType::Bool   || retType == VType::Null);

    auto emitRegionCleanup = [&]() {
        if (nRegions == 0) return;
        if (primitiveSafe) {
            e.emitRegionUnwind();
        } else {
            e.emit("vmem_runtime_pop_checkpoints(" +
                   std::to_string(nRegions) + ");");
        }
    };

    if (e.hasTryCleanup() && e.hasReturnVars()) {
        e.emit(e.getReturnVar() + " = " + expr + ";");
        e.emit(e.getReturningVar() + " = 1;");
        emitRegionCleanup();
        e.emit("goto " + e.currentTryCleanup() + ";");
    } else if (e.hasDeferContext() && e.hasReturnVars()) {
        e.emit(e.getReturnVar() + " = " + expr + ";");
        emitRegionCleanup();
        e.emit("goto " + e.getDeferCleanupLabel() + ";");
    } else {
        if (nRegions > 0 && primitiveSafe) {
            // Capture the boxed RHS in a local before unwinding, so the
            // rewind cannot free anything the RHS still references.
            std::string slot = e.newTemp("ret_val");
            e.emit("VyneValue " + slot + " = " + expr + ";");
            e.emitRegionUnwind();
            e.emit("return " + slot + ";");
        } else {
            emitRegionCleanup();
            e.emit("return " + expr + ";");
        }
    }
}

std::string ReturnNode::getCExpr(C_Emitter& e) const {
    compile(e);
    return "vyne_null()";
}

void BreakNode::compile(C_Emitter& e) const {
    if (e.hasTryCleanup()) {
        throw std::runtime_error(
            "Compile Error: 'break' inside try/catch/finally is not supported by "
            "the C backend (line " + std::to_string(lineNumber) + "). "
            "Use a flag variable and break outside the try.");
    }
    e.emitRegionUnwind(); 
    e.emit("break;");
}
std::string BreakNode::getCExpr(C_Emitter& e) const { return "vyne_null()"; }

void ContinueNode::compile(C_Emitter& e) const {
    if (e.hasTryCleanup()) {
        throw std::runtime_error(
            "Compile Error: 'continue' inside try/catch/finally is not supported by "
            "the C backend (line " + std::to_string(lineNumber) + ").");
    }
    e.emitRegionUnwind();
    e.emit("continue;");
}
std::string ContinueNode::getCExpr(C_Emitter& e) const { return "vyne_null()"; }

