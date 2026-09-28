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
    if (e.getNativeReturnType().isPrimitive()) {
        VType retVT = e.getNativeReturnType().toVType();
        std::string raw = expression ? expression->getCExpr(e) : "vyne_null()";
        std::string native = coerceToNative(e, expression.get(), raw, retVT);
        if (e.hasRegion()) {
            e.emit("vmem_runtime_pop_checkpoints(" +
            std::to_string(e.getRegionStack().size()) + ");");
        } else {
            e.emitRegionUnwind();   // no-op if stack is empty anyway
        }
        e.emit("return " + native + ";");
        return;
    }

    // --- Native Array<T> return -------------------------------------
    // A native variant declared to return Array<Float64> or Array<Int64>
    // emits a C function whose return type is VyneArray_f64 / VyneArray_i64.
    // The body, however, was lowered by AssignmentNode::compile, which does
    // not yet know that the enclosing function is a native-array producer —
    // it produces a boxed VyneValue. Convert at the return boundary using
    // the same runtime helper MemberAccessNode uses to unbox Array<Float64>
    // fields on a struct. If the expression already has a typed-array
    // CType in the emitter's table, pass it through unchanged.
    {
        const CType& retCt = e.getNativeReturnType();
        if (retCt.kind == CType::Kind::Array && !retCt.args.empty()) {
            VType elem = retCt.args[0].toVType();
            std::string raw = expression
                ? expression->getCExpr(e)
                : "vyne_array_create(0)";

            const CType* got = e.lookupType(raw);
            std::string native;
            if (got && got->kind == CType::Kind::Array &&
                !got->args.empty() &&
                got->args[0].toVType() == elem) {
                // Already a typed container — use it directly.
                native = raw;
            } else {
                // Boxed VyneValue — unbox at the ABI boundary.
                const char* fn = (elem == VType::Float64)
                    ? "vyne_value_to_array_f64"
                    : "vyne_value_to_array_i64";
                native = std::string(fn) + "(" + e.boxAny(raw) + ")";
            }

            e.emitRegionUnwind();
            e.emit("return " + native + ";");
            return;
        }
    }
    // --- end native Array<T> return ---------------------------------

    std::string expr = expression ? e.boxAny(expression->getCExpr(e))
                                  : "vyne_null()";

    // ... rest of the existing function unchanged ...

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

