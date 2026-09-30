#include "detail/codegen_helpers.h"

// Group and module statements and deployment includes.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// GROUP
// ============================================================

void GroupNode::compile(C_Emitter& e) const {
    e.registerGroup(groupName);
    e.pushGlobalContext();
    e.emit("// --- Group: " + groupName + " ---");

    for (const auto& stmt : statements) {
        if (!stmt) continue;
        if (stmt->type() == NodeType::ASSIGNMENT) {
            auto* assign = static_cast<AssignmentNode*>(stmt.get());
            std::string mangled = "v_" + groupName + "_" + assign->getOriginalName();
            std::replace(mangled.begin(), mangled.end(), '.', '_');

            CType declared = CType::fromVType(assign->getExpectedType());

            if (declared.isPrimitive()) {
                e.declareGlobal(mangled, declared);
                e.emitGlobalDecl(declared.cTypeName() + " " + mangled + " = 0;");
            } else {
                e.registerDeclaration(mangled);
                e.emitGlobalDecl("VyneValue " + mangled + ";");
            }

            e.popGlobalContext();
            std::string val = assign->getRHS()->getCExpr(e);
            if (declared.isPrimitive()) {
                std::string init = coerceToNative(
                    e, assign->getRHS(), val, declared.toVType());
                e.emit(mangled + " = " + init + ";");
            } else {
                e.emit(mangled + " = " + e.boxAny(val) + ";");
            }
            e.pushGlobalContext();
        } else if (stmt->type() == NodeType::FUNCTION) {
            auto* fn = static_cast<FunctionNode*>(stmt.get());

            // Register this group member's return type under every
            // spelling the escape check might query with. Group functions
            // were previously never registered — only top-level ones in
            // ProgramNode::compile were — so every `x = group.fn(...)`
            // inside a region looked like an untyped, non-primitive RHS
            // and tripped VNE-070. `lossN = vlin.cross_entropy(...)` is
            // the case that exposed it.
            CType retCt = CType::fromVType(fn->getReturnType());
            if (fn->getReturnType() == VType::Array &&
                fn->getReturnArrayElemType() != VType::Unknown) {
                retCt.args.push_back(
                    CType::fromVType(fn->getReturnArrayElemType()));
            }

            std::string orig = fn->getOriginalName();
            std::string mangled = orig;
            std::replace(mangled.begin(), mangled.end(), '.', '_');

            std::string groupMangled = groupName + "_" + mangled;
            std::replace(groupMangled.begin(), groupMangled.end(), '.', '_');

            std::string groupDotted = groupName + "." + orig;

            e.registerFunctionReturnType(orig,         retCt);
            e.registerFunctionReturnType(mangled,      retCt);
            e.registerFunctionReturnType(groupMangled, retCt);
            e.registerFunctionReturnType(groupDotted,  retCt);

            e.popGlobalContext();
            stmt->compile(e);
            e.pushGlobalContext();
        } else if (stmt->type() == NodeType::INTERFACE) {
            e.popGlobalContext();
            e.setGroupPrefix(groupName);
            stmt->compile(e);
            e.clearGroupPrefix();
            e.pushGlobalContext();
        }
    }
    e.popGlobalContext();
}

std::string GroupNode::getCExpr(C_Emitter& e) const {
    compile(e);
    return "vyne_null()";
}

// ============================================================
// MODULE
// ============================================================

void ModuleNode::compile(C_Emitter& e) const {
    std::string base = FileUtils::getExeDir();
    std::filesystem::path moduleBase = std::filesystem::path(base) / "vyne" / "runtime" / "modules";

    if (originalName == "vmath")  e.addInclude((moduleBase / "vmath.h").string());
    if (originalName == "vcore")  e.addInclude((moduleBase / "vcore.h").string());
    if (originalName == "vmem")   e.addInclude((moduleBase / "vmem.h").string());
    if (originalName == "vaudio") e.addInclude((moduleBase / "vaudio.h").string());
    if (originalName == "vglib")  e.addInclude((moduleBase / "vglib.h").string());

    e.registerGroup(originalName);
}

std::string ModuleNode::getCExpr(C_Emitter& e) const { return "vyne_null()"; }

