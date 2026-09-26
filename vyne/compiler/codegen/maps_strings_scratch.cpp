#include "detail/codegen_helpers.h"

// Map and interpolated-string expressions; region-bound typed scratch storage.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// MAP LITERAL
// ============================================================

std::string MapNode::getCExpr(C_Emitter& e) const {
    std::string temp = e.newTemp("map");
    e.emit("VyneValue " + temp + " = vyne_map_create();");
    for (const auto& [keyNode, valNode] : pairs) {
        std::string k = e.boxAny(keyNode->getCExpr(e));
        std::string v = e.boxAny(valNode->getCExpr(e));
        e.emit("vyne_map_set(" + temp + ", " + k + ", " + v + ");");
    }
    return temp;
}

void MapNode::compile(C_Emitter& e) const { getCExpr(e); }

// ============================================================
// INTERPOLATED STRING
// ============================================================

std::string InterpolatedStringNode::getCExpr(C_Emitter& e) const {
    std::string acc = "vyne_string(\"\")";
    size_t exprIdx = 0;

    for (const auto& [part, isExpr] : parts) {
        std::string piece;
        if (isExpr) {
            if (exprIdx >= exprNodes.size()) break;
            std::string v = e.boxAny(exprNodes[exprIdx++]->getCExpr(e));
            piece = e.newTemp("is");
            e.emit("VyneValue " + piece + " = vyne_to_string(" + v + ");");
        } else {
            std::string esc;
            esc.reserve(part.size());
            for (char c : part) {
                if      (c == '\\') esc += "\\\\";
                else if (c == '"')  esc += "\\\"";
                else if (c == '\n') esc += "\\n";
                else if (c == '\t') esc += "\\t";
                else                esc += c;
            }
            piece = "vyne_string(\"" + esc + "\")";
        }

        std::string next = e.newTemp("icc");
        e.emit("VyneValue " + next + " = vyne_binop(" + acc + ", " + piece + ", 29);");
        acc = next;
    }
    return acc;
}

void InterpolatedStringNode::compile(C_Emitter& e) const { getCExpr(e); }

// ============================================================
// SHAPE-TYPED SCRATCH
// ============================================================

void ScratchNode::compile(C_Emitter& e) const {
    if (!e.hasRegion()) {
        throw std::runtime_error(
            "Compile Error: 'scratch' is only valid inside a 'region' block "
            "(line " + std::to_string(lineNumber) + ").");
    }

    std::string sanitized = varName;
    std::replace(sanitized.begin(), sanitized.end(), '.', '_');

    std::string prefix = e.getActiveFunctionPrefix();
    std::string cName = prefix.empty()
        ? ("v_" + sanitized)
        : ("v_" + prefix + "_" + sanitized);

    CType arrType;
    arrType.kind = CType::Kind::Array;
    arrType.args.push_back(CType::fromVType(elemType));
    arrType.shape = shape;
    arrType.nativeName = CType::elemCName(elemType);

    // C declaration: double v_grad_w1[64*16];
    int64_t n = arrType.numElements();
    e.emit(std::string(CType::elemCName(elemType)) + " " + cName +
           "[" + std::to_string(n) + "];");

    // Register as a scoped local with shape, so later accesses see it.
    e.declareLocal(cName, arrType);

    if (initializer) {
        throw std::runtime_error(
            "Compile Error: scratch initializers are not yet supported "
            "(line " + std::to_string(lineNumber) + ").");
    }
}
std::string ScratchNode::getCExpr(C_Emitter&) const {
    throw std::runtime_error("scratch is a declaration, not an expression");
}

static std::string scratchFlatIndex(C_Emitter& e,
                                    const CType& arrType,
                                    const std::vector<std::unique_ptr<ASTNode>>& idxNodes) {
    if ((int)idxNodes.size() != (int)arrType.shape.size()) {
        throw std::runtime_error(
            "Shape Error: expected " + std::to_string(arrType.shape.size()) +
            " index(es) for shape [" + [&]{
                std::string s;
                for (size_t i = 0; i < arrType.shape.size(); ++i) {
                    if (i) s += ", ";
                    s += std::to_string(arrType.shape[i]);
                }
                return s;
            }() + "], got " + std::to_string(idxNodes.size()) +
            " [ line " + std::to_string(idxNodes.empty() ? 0 : idxNodes[0]->lineNumber) + " ]");
    }

    auto strides = arrType.strides();
    std::string flat;
    for (size_t k = 0; k < idxNodes.size(); ++k) {
        std::string raw = idxNodes[k]->getCExpr(e);
        std::string idx = coerceToNative(e, idxNodes[k].get(), raw, VType::Int64);
        if (k) flat += " + ";
        if (strides[k] == 1) flat += "(" + idx + ")";
        else                 flat += "(" + idx + ") * " + std::to_string(strides[k]);
    }
    if (flat.empty()) flat = "0";
    return flat;
}

std::string ScratchIndexNode::getCExpr(C_Emitter& e) const {
    std::string baseExpr = base->getCExpr(e);
    const CType* bt = e.lookupAnyType(baseExpr);

    // Fall back to plain single-index path if we somehow lost the shape.
    if (!bt || !bt->hasShape()) {
        // Reconstruct a classic IndexAccessNode and let it run.
        return "(/*scratch fallback*/ 0)";
    }

    std::string flat = scratchFlatIndex(e, *bt, indices);
    VType elem = bt->args.empty() ? VType::Float64 : bt->args[0].toVType();

    std::string tmp = e.newTemp("sid");
    e.emit(std::string(CType::elemCName(elem)) + " " + tmp + " = " +
           baseExpr + "[" + flat + "];");
    e.declareNativeTemp(tmp, CType::fromVType(elem));
    return tmp;
}

void ScratchIndexNode::compile(C_Emitter& e) const { getCExpr(e); }

void ScratchStoreNode::compile(C_Emitter& e) const {
    std::string baseExpr = base->getCExpr(e);
    const CType* bt = e.lookupAnyType(baseExpr);
    if (!bt || !bt->hasShape()) {
        throw std::runtime_error(
            "Compile Error: scratch store requires a shaped-array base "
            "(line " + std::to_string(lineNumber) + ").");
    }

    std::string flat = scratchFlatIndex(e, *bt, indices);
    VType elem = bt->args.empty() ? VType::Float64 : bt->args[0].toVType();

    std::string rawRhs = rhs->getCExpr(e);
    std::string val = coerceToNative(e, rhs.get(), rawRhs, elem);

    e.emit(baseExpr + "[" + flat + "] = " + val + ";");
}

std::string ScratchStoreNode::getCExpr(C_Emitter& e) const {
    compile(e);
    return "vyne_null()";
}