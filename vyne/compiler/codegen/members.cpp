#include "detail/codegen_helpers.h"

// Member access and assignment.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// MEMBER ACCESS / ASSIGNMENT
// ============================================================

std::string MemberAccessNode::getCExpr(C_Emitter& e) const {
    // --- Existing native-module / group resolution -------------------
    if (receiver->type() == NodeType::VARIABLE) {
        auto* var = static_cast<VariableNode*>(receiver.get());
        std::string modName = var->getOriginalName();

        std::string native = e.getNativeMapping(modName, memberName, false);
        if (native.find("v_" + modName) == std::string::npos) {
            return native;
        }

        if (e.isGroup(modName)) {
            std::string name = "v_" + modName + "_" + memberName;
            std::replace(name.begin(), name.end(), '.', '_');
            return name;
        }
    }

    if (receiver->type() == NodeType::VARIABLE) {
        auto* var = static_cast<VariableNode*>(receiver.get());
        std::string recvName = var->getOriginalName();

        std::string typeName;
        if (recvName == "self") {
            typeName = e.getCurrentInterfaceType();
        } else {
            std::string prefix = e.getActiveFunctionPrefix();
            std::string lookupKey = prefix.empty()
                ? ("v_" + recvName)
                : ("v_" + prefix + "_" + recvName);
            if (const std::string* t = e.lookupLocalStructType(lookupKey))
                typeName = *t;
            else if (const std::string* t = e.lookupGlobalStructType("v_" + recvName))
                typeName = *t;
        }

        if (!typeName.empty()) {
            VType elem = e.getInterfaceArrayElem(typeName, memberName);
            if (elem == VType::Int64 || elem == VType::Float64) {
                std::string cacheKey = recvName + "." + memberName;
                if (const auto* cached = e.getFieldCache(cacheKey))
                    return cached->temp;

                std::string recv = e.boxAny(receiver->getCExpr(e));
                uint32_t fid = StringPool::intern(memberName);
                std::string temp = e.newTemp("fld");
                const char* cName = (elem == VType::Float64)
                    ? "VyneArray_f64" : "VyneArray_i64";
                const char* fn = (elem == VType::Float64)
                    ? "vyne_value_to_array_f64" : "vyne_value_to_array_i64";

                e.emit(std::string(cName) + " " + temp + " = " + fn +
                       "(vyne_struct_get(" + recv + ", " +
                       std::to_string(fid) + "));");

                CType ct;
                ct.kind = CType::Kind::Array;
                ct.args.push_back(CType::fromVType(elem));
                e.declareNativeTemp(temp, ct);
                e.setFieldCache(cacheKey, temp, ct);
                return temp;
            }
        }
    }

    // --- Boxed fallback ----------------------------------------------
    std::string recv = e.boxAny(receiver->getCExpr(e));
    uint32_t fid = StringPool::intern(memberName);
    return "vyne_struct_get(" + recv + ", " + std::to_string(fid) + ")";
}

void MemberAccessNode::compile(C_Emitter& e) const {
    // Bare member access as statement — no-op
}

void MemberAssignmentNode::compile(C_Emitter& e) const {
    // Any write invalidates all cached unboxes for this function.
    e.clearFieldCache();

    std::string val = e.boxAny(rhs->getCExpr(e));

    if (receiver->type() == NodeType::VARIABLE) {
        auto* var = static_cast<VariableNode*>(receiver.get());
        std::string modName = var->getOriginalName();

        if (e.isGroup(modName)) {
            std::string name = "v_" + modName + "_" + memberName;
            std::replace(name.begin(), name.end(), '.', '_');
            e.emit(name + " = " + val + ";");
            return;
        }

        if (modName == "self") {
            uint32_t fid = StringPool::intern(memberName);
            e.emit("vyne_struct_set(v_self, " + std::to_string(fid) +
                   ", \"" + memberName + "\", " + val + ");");
            return;
        }
    }

    std::string recv = e.boxAny(receiver->getCExpr(e));
    uint32_t fid = StringPool::intern(memberName);
    e.emit("vyne_struct_set(" + recv + ", " + std::to_string(fid) +
           ", \"" + memberName + "\", " + val + ");");
}

std::string MemberAssignmentNode::getCExpr(C_Emitter& e) const {
    compile(e);
    if (receiver->type() == NodeType::VARIABLE) {
        auto* var = static_cast<VariableNode*>(receiver.get());
        std::string name = "v_" + var->getOriginalName() + "_" + memberName;
        std::replace(name.begin(), name.end(), '.', '_');
        return name;
    }
    return receiver->getCExpr(e) + "_" + memberName;
}

