#include "detail/codegen_helpers.h"

// Region checkpoint and commit lowering.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// A1 — LEXICAL REGIONS
// ------------------------------------------------------------
// `region name { body }` becomes:
//
//     VyneValue __cp_N = vmem_runtime_checkpoint();
//     { body }                                  // C block: locals scoped
//     vmem_runtime_rewind(__cp_N);
//
// The C block is what keeps locals declared inside the region from
// leaking into the surrounding scope — matching the lifetime
// guarantee at the source level. Nested regions work because
// vmem.h's checkpoint stack is itself a stack; every rewind pops
// its own handle and everything above it.
// ============================================================

void RegionNode::compile(C_Emitter& e) const {
    // The user may not have written `module vmem;`. Region codegen
    // depends on vmem.h's runtime helpers, so pull it in here.
    std::string base = FileUtils::getExeDir();
    std::filesystem::path moduleBase =
        std::filesystem::path(base) / "vyne" / "runtime" / "modules";
    e.addInclude((moduleBase / "vmem.h").string());

    std::string cpHandle = e.newTemp("vmem_cp");

    e.emit("// --- region: " + regionName + " ---");
    e.emit("VyneValue " + cpHandle + " = vmem_runtime_checkpoint();");

    e.pushRegion(cpHandle);
    e.emitBlockOpen("{");
    for (const auto& stmt : body) if (stmt) stmt->compile(e);
    e.emitBlockClose();
    e.popRegion();

    e.emit("vmem_runtime_rewind(" + cpHandle + ");");
}

std::string RegionNode::getCExpr(C_Emitter& e) const {
    compile(e);
    return "vyne_null()";
}

// ============================================================
// A3 — REGION COMMIT
// ------------------------------------------------------------
// Not yet implemented. A correct lowering requires hoisting the
// committed value above the checkpoint in the emitted C — which in
// turn requires the escape-analysis pass (A2) to prove the value
// has no aliases inside the region. Without that proof, any lowering
// we pick either doubles the peak (copy) or silently produces a
// dangling reference (transfer).
//
// We fail at compile time so the user sees the constraint instead of
// getting a use-after-free at runtime.
// ============================================================

void RegionCommitNode::compile(C_Emitter& e) const {
    auto* var = dynamic_cast<VariableNode*>(expression.get());
    if (!var) {
        throw std::runtime_error(
            "Compile Error: region.commit() requires an lvalue variable "
            "(line " + std::to_string(lineNumber) + ")");
    }

    // Same mangling rule as VariableNode::getCExpr. Keep them in sync.
    std::string sanitized = var->getOriginalName();
    std::replace(sanitized.begin(), sanitized.end(), '.', '_');

    std::string prefix = e.getActiveFunctionPrefix();
    std::string cVar;
    if (!prefix.empty()) {
        std::string localName = "v_" + prefix + "_" + sanitized;
        cVar = e.isLocalDeclared(localName) ? localName : ("v_" + sanitized);
    } else {
        cVar = "v_" + sanitized;
    }

        std::string tmp = e.newTemp("commit");
        e.emit("VyneValue " + tmp + " = vmem_runtime_commit(" + cVar + ");");
        e.emit(cVar + " = " + tmp + ";");

        // The variable now points into the commit arena, which survives
        // region rewinds. Its effective depth is 0.
        e.markCommitted(cVar);
}

std::string RegionCommitNode::getCExpr(C_Emitter& e) const {
    compile(e);
    return "vyne_null()";
}

