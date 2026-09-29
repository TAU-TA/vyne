#include "detail/codegen_helpers.h"

// ============================================================================
// Native-ABI dispatch
// ----------------------------------------------------------------------------
// The one place that decides whether a call lowers to its native variant
// (bare `double*` parameters, no boxing, no arena traffic per argument)
// or to the boxed `(int argc, VyneValue* argv)` ABI.
//
// Both FunctionCallNode and MethodCallNode's group branch funnel through
// here. The FunctionCallNode's older inline copy was correct; this
// extraction is behavior-preserving for it and new capability for the
// group branch.
//
// Callers capture their arguments once before invoking this, and reuse
// the same captures if the helper returns nullopt and they fall through
// to the boxed path. No argument is evaluated twice.
// ============================================================================

std::optional<std::string> tryEmitNativeCall(
    C_Emitter& e,
    const std::string& mangledCallee,
    const std::string& lookupName,
    const std::vector<ASTNode*>& orderedArgs,
    const std::vector<std::string>& argCExprs,
    const std::vector<VType>& argVTypes,
    const std::vector<const CType*>& argCTypes)
{
    const std::string* nativeName = e.lookupNativeVariant(mangledCallee);
    if (!nativeName) return std::nullopt;

    const std::vector<CType>* paramTypes = e.getFunctionParamTypes(lookupName);
    const CType* retCt = e.getFunctionReturnType(lookupName);
    if (!paramTypes || !retCt) return std::nullopt;
    if (paramTypes->size() != orderedArgs.size()) return std::nullopt;

    bool retIsNative = retCt->isPrimitive() ||
                       (retCt->kind == CType::Kind::Array &&
                        !retCt->args.empty());
    if (!retIsNative) return std::nullopt;

    // Every argument must match the declared parameter type.
    // Int64 → Float64 widening is permitted (matches the interpreter's
    // convertIfNeeded). Array element types must match exactly.
    for (size_t i = 0; i < orderedArgs.size(); ++i) {
        const CType& want = (*paramTypes)[i];

        if (want.kind == CType::Kind::Array && !want.args.empty()) {
            const CType* have = argCTypes[i];
            if (!have || have->kind != CType::Kind::Array ||
                have->args.empty() ||
                have->args[0].toVType() != want.args[0].toVType()) {
                return std::nullopt;
            }
        } else {
            VType wantVT = want.toVType();
            bool ok = (argVTypes[i] == wantVT) ||
                      (wantVT == VType::Float64 &&
                       argVTypes[i] == VType::Int64);
            if (!ok) return std::nullopt;
        }
    }

    // Build the direct call. Array params pass `.data` (the raw T*);
    // scalars go through coerceToNative which handles the C cast.
    std::string argList;
    for (size_t i = 0; i < orderedArgs.size(); ++i) {
        if (i > 0) argList += ", ";
        const CType& want = (*paramTypes)[i];

        if (want.kind == CType::Kind::Array && !want.args.empty()) {
            argList += argCExprs[i] + ".data";
        } else {
            argList += coerceToNative(e, orderedArgs[i], argCExprs[i],
                                      want.toVType());
        }
    }

    std::string retCName;
    if (retCt->kind == CType::Kind::Array && !retCt->args.empty()) {
        VType elem = retCt->args[0].toVType();
        retCName = (elem == VType::Float64) ? "VyneArray_f64"
                                            : "VyneArray_i64";
    } else {
        retCName = retCt->cTypeName();
    }

    std::string nret = e.newTemp("nret");
    e.emit(retCName + " " + nret + " = fn_" + *nativeName +
           "(" + argList + ");");
    e.declareNativeTemp(nret, *retCt);
    return nret;
}