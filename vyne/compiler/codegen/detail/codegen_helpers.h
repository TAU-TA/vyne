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
    if (want == VType::Bool)
        return "((" + expr + ").as.i64 != 0)";
    return expr;
}

// Resolve the "kind" of an RHS expression without emitting any code.
// The emitter's static type table is authoritative for variables and
// typed-array index reads; the AST is a fallback for literals. BinOps
// are handled syntactically because the AST's own getStaticType() only
// resolves when every leaf is statically typed, which is rare inside a
// region.
//
// Returns VType::Unknown when nothing can prove the kind; callers
// must treat Unknown as unsafe (fail closed).
static VType resolveRHSKind(C_Emitter& e, const ASTNode* rhs) {
    if (!rhs) return VType::Null;

    // --- Literals ------------------------------------------------
    switch (rhs->type()) {
        case NodeType::NUMBER:
        case NodeType::BOOLEAN:
            return rhs->getStaticType();
        case NodeType::NULLTYPE:
            return VType::Null;
        default: break;
    }

    // --- Variables: emitter's type table is authoritative --------
    if (rhs->type() == NodeType::VARIABLE) {
        auto* var = static_cast<const VariableNode*>(rhs);
        std::string n = var->getOriginalName();
        std::replace(n.begin(), n.end(), '.', '_');
        std::string prefix = e.getActiveFunctionPrefix();
        if (!prefix.empty()) {
            if (const CType* ct = e.lookupType("v_" + prefix + "_" + n))
                return ct->toVType();
        }
        if (const CType* ct = e.lookupType("v_" + n))
            return ct->toVType();
        return VType::Unknown;
    }

    // --- Index reads on typed arrays / scratch -------------------
    if (rhs->type() == NodeType::INDEX_ACCESS) {
        auto* ia = static_cast<const IndexAccessNode*>(rhs);
        const ASTNode* baseNode = ia->getBase();
        if (!baseNode || baseNode->type() != NodeType::VARIABLE)
            return VType::Unknown;
        auto* bv = static_cast<const VariableNode*>(baseNode);
        std::string b = bv->getOriginalName();
        std::replace(b.begin(), b.end(), '.', '_');
        std::string prefix = e.getActiveFunctionPrefix();
        const CType* bct = nullptr;
        if (!prefix.empty())
            bct = e.lookupType("v_" + prefix + "_" + b);
        if (!bct) bct = e.lookupType("v_" + b);
        if (!bct) return VType::Unknown;
        if (bct->kind == CType::Kind::Array && !bct->args.empty())
            return bct->args[0].toVType();
        if (bct->hasShape() && !bct->args.empty())
            return bct->args[0].toVType();
        return VType::Unknown;
    }

    // --- Binary operations ---------------------------------------
    // `BinOpNode::op` is a public field (see ast.h). We read it
    // directly rather than adding a getOp() accessor.
    if (rhs->type() == NodeType::BINARY_OP) {
        auto* bop = static_cast<const BinOpNode*>(rhs);
        switch (bop->op) {
            case VTokenType::Double_Equals:
            case VTokenType::Not_Equal:
            case VTokenType::Greater:
            case VTokenType::Smaller:
            case VTokenType::Greater_Or_Equal:
            case VTokenType::Smaller_Or_Equal:
            case VTokenType::And:
            case VTokenType::Or:
                return VType::Bool;
            case VTokenType::Substract:
            case VTokenType::Multiply:
            case VTokenType::Division:
            case VTokenType::Floor_Divide:
            case VTokenType::Modulo:
            case VTokenType::Power:
                // These operators are numeric-only in Vyne: the interpreter
                // raises on non-numeric operands, and the runtime's binop
                // dispatch only reaches them through the float or int branch.
                // A `+` never appears here because it is overloaded for
                // strings and arrays; it falls to the default below.
                return VType::Float64;
            default:
                return VType::Unknown;
        }
    }

    return VType::Unknown;
}