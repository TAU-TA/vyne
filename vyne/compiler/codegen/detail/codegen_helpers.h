#pragma once
#include "../codegen.h"

// Shared, translation-unit-local emission helpers from the original codegen.cpp.
// These helpers do not retain mutable state; per-compilation state lives in C_Emitter.
// ============================================================
// LITERALS
// ============================================================

static std::string floatLit(double v) {
    char buf[32];
    auto [p, ec] = std::to_chars(buf, buf + sizeof(buf), v,
                                 std::chars_format::general);
    if (ec != std::errc{}) return "0.0";
    return std::string(buf, p);
}

static VType inferArrayElemType(const ASTNode* node) {
    if (!node || node->type() != NodeType::ARRAY) return VType::Unknown;
    auto* arr = static_cast<const ArrayNode*>(node);
    const auto& elems = arr->getElements();
    if (elems.empty()) return VType::Unknown;

    VType common = VType::Unknown;
    for (const auto& el : elems) {
        VType et = el->getStaticType();
        if (et != VType::Int64 && et != VType::Float64) return VType::Unknown;
        if (common == VType::Unknown) {
            common = et;
        } else if (common != et) {
            if ((common == VType::Int64   && et == VType::Float64) ||
                (common == VType::Float64 && et == VType::Int64)) {
                common = VType::Float64;
            } else {
                return VType::Unknown;
            }
        }
    }
    return common;
}
// Coerce a C expression string to a native C value of static type `want`.
// Same shape as the `operand` lambda in BinOpNode::getCExpr.
static std::string coerceToNative(C_Emitter& e, const ASTNode* node,
                                  const std::string& expr, VType want) {
    if (node && node->type() == NodeType::NUMBER) {
        auto* num = static_cast<const NumberNode*>(node);
        if ((want == VType::Int64 && num->getStaticType() == VType::Int64) ||
            (want == VType::Float64)) {
            return num->nativeLiteral();
        }
    }
    if (node && node->type() == NodeType::BOOLEAN && want == VType::Bool) {
        return static_cast<const BooleanNode*>(node)->nativeLiteral();
    }
    const CType* ct = e.exprNativeType(expr);
    if (ct && ct->isPrimitive()) {
        if (ct->toVType() == want) return expr;
        if (want == VType::Float64 && ct->kind == CType::Kind::Int64)
            return "(double)(" + expr + ")";
        if (want == VType::Int64 && ct->kind == CType::Kind::Float64)
            return "(int64_t)(" + expr + ")";
        return expr;
    }
    if (want == VType::Float64)
        return "((" + expr + ").type == V_FLOAT64) ? (" + expr +
               ").as.f64 : (double)(" + expr + ").as.i64";
    if (want == VType::Int64)
        return "((" + expr + ").type == V_INT64) ? (" + expr +
               ").as.i64 : (int64_t)(" + expr + ").as.f64";
    return expr;
}

