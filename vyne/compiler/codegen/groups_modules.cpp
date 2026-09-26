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
            e.emit("VyneValue " + mangled + ";");
            e.popGlobalContext();
            std::string val = assign->getRHS()->getCExpr(e);
            e.emit(mangled + " = " + e.boxAny(val) + ";");
            e.pushGlobalContext();
                } else if (stmt->type() == NodeType::FUNCTION) {
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

