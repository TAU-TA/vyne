#ifndef VYNE_EMITTER_H
#define VYNE_EMITTER_H

#include <sstream>
#include <string>
#include <vector>
#include <unordered_set>
#include <unordered_map>

#include "ctype.h"
#include "native_maps.h"

class C_Emitter {
    // --- Output buffers --------------------------------------------------
    std::stringstream globalsStream;
    std::stringstream functionStream;
    std::stringstream mainStream;
    std::unordered_set<std::string> includeSet;
    std::unordered_set<std::string> systemIncludes;

    int indentLevel = 0;
    enum class EmitContext { GLOBAL, FUNCTION, MAIN };
    std::vector<EmitContext> contextStack;

    std::stringstream& currentStream() {
        if (contextStack.empty()) return mainStream;
        switch (contextStack.back()) {
            case EmitContext::FUNCTION: return functionStream;
            case EmitContext::GLOBAL:   return globalsStream;
            default:                    return mainStream;
        }
    }

    std::string getIndent() const {
        return std::string(indentLevel * 4, ' ');
    }

    // --- Name declaration tables ----------------------------------------
    std::unordered_set<std::string> declaredVars;
    std::unordered_set<std::string> references;
    std::unordered_set<std::string> globalVars;

    // --- Static type tables (M0/M1) -------------------------------------
    std::unordered_map<std::string, CType> globalTypes;
    std::unordered_map<std::string, CType> nativeTemps;
    struct LocalScope {
        std::unordered_set<std::string>        names;
        std::unordered_map<std::string, CType> types;
        std::unordered_map<std::string, int>   regionDepthAtDeclaration;
    };
    std::vector<LocalScope> localScopes = { LocalScope{} };

    // --- Interface / group registry -------------------------------------
    std::unordered_set<std::string> interfaceSet;
    std::unordered_set<std::string> groupSet;
    std::unordered_map<std::string, std::vector<std::string>> functionSignatures;
    std::unordered_map<std::string, std::vector<CType>> functionParamTypes;
    std::unordered_map<std::string, CType> functionReturnTypes;
    std::unordered_map<std::string, std::string> nativeVariants;
    CType nativeReturnType;
    std::unordered_map<std::string, std::vector<std::string>> interfaceDefaults;
    std::string groupPrefix;

    // --- M4-C1B: struct field typing ------------------------------------
    std::unordered_map<std::string,
                       std::unordered_map<std::string, VType>> interfaceArrayFields;
    std::unordered_map<std::string, std::string> localStructTypes;
    std::unordered_map<std::string, std::string> globalStructTypes;
    std::string currentInterfaceType;

    // M4-C1B (extended): scalar interface fields (Int64/Float64) that can be
    // unboxed at member access. Same key shape as interfaceArrayFields.
    std::unordered_map<std::string,
                       std::unordered_map<std::string, VType>> interfacePrimitiveFields;

    struct FieldCacheEntry { std::string temp; CType ct; };
    std::unordered_map<std::string, FieldCacheEntry> fieldCache;

    // --- M2: monomorphization cache -------------------------------------
    // key = "<mangledFnName>__<type-tuple>" ; value = emitted C name.
    std::unordered_map<std::string, std::string> instantiations;
    std::unordered_set<std::string> instantiationsInProgress;

    // --- Import / context tracking --------------------------------------
    std::unordered_set<std::string> importedFiles;
    std::string sourceDir;
    std::string activeFunctionPrefix;

    // --- Defer / try-cleanup context ------------------------------------
    struct DeferContext {
        std::string cleanupLabel;
        std::string retVar;
        bool active = false;
    };
    DeferContext deferCtx;
    std::vector<std::string> tryCleanupStack;
    std::string currentReturnVar;
    std::string currentReturningVar;

    std::vector<std::string> regionStack;
    std::unordered_set<std::string> committedVars;

    // Active @pool context. The pool's own C variable name lives here
    // so `pool_alloc()` / `pool_free()` — intercepted in
    // FunctionCallNode::getCExpr — can emit `&<handle>` without
    // recomputing the mangling. Only the innermost pool is visible to
    // the body; nested @pool regions shadow cleanly via LIFO.
    struct PoolContext {
        std::string handle;          // C variable name of the VynePool struct
        VType       elemType;        // Float64 or Int64
        int64_t     elemsPerSlot;    // buffer length per allocation
    };
    std::vector<PoolContext> poolStack;

    // Active @speculative context. Tracks the C variable name of the
    // per-region commit flag so `region.commit_if(pred)` — intercepted
    // in RegionCommitIfNode::compile — knows which flag to assign. Only
    // the innermost is visible; nested speculative regions shadow via
    // LIFO, matching every other region-scoped construct.
    struct SpeculativeContext {
        std::string commitFlag;      // C variable name of the int flag
    };
    std::vector<SpeculativeContext> speculativeStack;

    bool scratchBoundsEnabled = true;
    bool blasEnabled          = false;
    bool poolRuntimeEmitted   = false;
    int tempVarCount = 0;

public:
    // --- Context management ---------------------------------------------
    bool isAlreadyImported(const std::string& path) const {
        return importedFiles.count(path) > 0;
    }
    void markImported(const std::string& path) { importedFiles.insert(path); }
    std::string getSourceDir() const { return sourceDir; }
    void setSourceDir(const std::string& dir) { sourceDir = dir; }

    const std::unordered_set<std::string>& getGlobalVars() const { return globalVars; }
    void enterFunction(const std::string& prefix) { activeFunctionPrefix = prefix; }
    void exitFunction() { activeFunctionPrefix.clear(); }
    const std::string& getActiveFunctionPrefix() const { return activeFunctionPrefix; }

    void pushMainContext() {
        contextStack.emplace_back(EmitContext::MAIN);
        indentLevel = 1;
    }
    void popMainContext() {
        if (!contextStack.empty()) contextStack.pop_back();
        indentLevel = 0;
    }

    void pushGlobalContext() {
        contextStack.emplace_back(EmitContext::GLOBAL);
        indentLevel = 0;
    }
    void popGlobalContext() {
        if (!contextStack.empty()) contextStack.pop_back();
        indentLevel = 1;
    }

    bool isGlobalContext() {
        return contextStack.empty() || contextStack.back() == EmitContext::GLOBAL;
    }

    bool isTopLevelOfMain() const {
        bool inMain = contextStack.empty() || contextStack.back() == EmitContext::MAIN;
        return inMain && localScopes.size() <= 1;
    }

    bool isGlobalDeclared(const std::string& name) const {
        return globalVars.count(name) > 0;
    }
    bool isLocalDeclared(const std::string& name) const {
        for (auto it = localScopes.rbegin(); it != localScopes.rend(); ++it)
            if (it->names.count(name)) return true;
        return false;
    }
    bool isLocalVarsEmpty() const {
        return localScopes.empty() || localScopes.back().names.empty();
    }
    bool isAlreadyDeclared(const std::string& name) const {
        return isLocalDeclared(name) || isGlobalDeclared(name);
    }

    void registerDeclaration(const std::string& name) {
        bool atBaseScope = localScopes.size() <= 1;
        if (isGlobalContext() && atBaseScope) {
            globalVars.insert(name);
        } else {
            if (localScopes.empty()) localScopes.emplace_back();
            localScopes.back().names.insert(name);
            // Record the region depth so the escape check can distinguish
            // a local declared inside a region from one declared outside
            // it. Without this, lookupLocalRegionDepth returns -1 for every
            // boxed local and the check treats it as a depth-0 escape.
            localScopes.back().regionDepthAtDeclaration[name] =
                (int)regionStack.size();
        }
    }

    // regionDepth defaults to the current region stack depth at the
    // moment of declaration. Callers that want to override (e.g. for
    // parameters, which are conceptually at depth 0) can pass an
    // explicit value.
    void declareLocal(const std::string& name, const CType& ct,
                      int regionDepth = -1) {
        if (localScopes.empty()) localScopes.emplace_back();
        localScopes.back().names.insert(name);
        localScopes.back().types[name] = ct;
        if (regionDepth < 0) regionDepth = (int)regionStack.size();
        localScopes.back().regionDepthAtDeclaration[name] = regionDepth;
    }
    void declareGlobal(const std::string& name, const CType& ct) {
        globalVars.insert(name);
        globalTypes[name] = ct;
    }

    const CType* lookupLocalType(const std::string& name) const {
        for (auto it = localScopes.rbegin(); it != localScopes.rend(); ++it) {
            auto t = it->types.find(name);
            if (t != it->types.end()) return &t->second;
        }
        return nullptr;
    }
    // Effective region depth of a variable: 0 if committed (survives
    // rewind), otherwise the depth at declaration. Returns -1 if the
    // name is not a tracked local.
    int lookupLocalRegionDepth(const std::string& name) const {
        if (committedVars.count(name)) return 0;
        for (auto it = localScopes.rbegin(); it != localScopes.rend(); ++it) {
            auto r = it->regionDepthAtDeclaration.find(name);
            if (r != it->regionDepthAtDeclaration.end()) return r->second;
        }
        return -1;
    }

    int currentRegionDepth() const { return (int)regionStack.size(); }

    void markCommitted(const std::string& name) { committedVars.insert(name); }
    bool isCommitted(const std::string& name) const {
        return committedVars.count(name) > 0;
    }
    const CType* lookupGlobalType(const std::string& name) const {
        auto it = globalTypes.find(name);
        return it == globalTypes.end() ? nullptr : &it->second;
    }

    const CType* lookupType(const std::string& name) const {
        auto it = nativeTemps.find(name);
        if (it != nativeTemps.end()) return &it->second;
        if (auto lt = lookupLocalType(name)) return lt;
        return lookupGlobalType(name);
    }

    const CType* lookupAnyType(const std::string& name) const {
        return lookupType(name);
    }

    void declareNativeTemp(const std::string& name, const CType& ct) {
        nativeTemps[name] = ct;
    }

    // Filtered view: non-null only for provably-primitive types.
    // (Behaviorally identical to the old version — it also returned any
    // nativeTemp entry, primitive or not, thanks to the early return.
    // This preserves that.)
    const CType* exprNativeType(const std::string& expr) const {
        const CType* ct = lookupType(expr);
        return (ct && ct->isPrimitive()) ? ct : nullptr;
    }
    std::string boxIfNative(const std::string& expr) const {
        const CType* ct = exprNativeType(expr);
        return ct ? ct->box(expr) : expr;
    }
    std::string boxAny(const std::string& expr) const {
        const CType* ct = lookupType(expr);
        if (ct && ct->kind == CType::Kind::Array && !ct->args.empty()) {
            VType elem = ct->args[0].toVType();
            if (elem == VType::Float64)
                return "vyne_array_f64_to_value(&" + expr + ")";
            if (elem == VType::Int64)
                return "vyne_array_i64_to_value(&" + expr + ")";
        }
        return boxIfNative(expr);
    }
    std::string nativeRead(const std::string& expr, VType kind) const {
        const CType* ct = exprNativeType(expr);
        CType want = CType::fromVType(kind);
        if (ct && ct->kind == want.kind) return expr;
        return want.unbox(boxIfNative(expr));
    }

    // --- References ------------------------------------------------------
    void registerReference(const std::string name) { references.insert(std::move(name)); }
    bool isReference(const std::string name) const {
        return references.count(std::move(name)) > 0;
    }

    // --- Function-context stack (clears every per-fn table) -------------
    void pushFunctionContext() {
        contextStack.emplace_back(EmitContext::FUNCTION);
        indentLevel = 0;
        localStructTypes.clear();
        fieldCache.clear();
        currentInterfaceType.clear();
        regionStack.clear();
        poolStack.clear();            // paired with regionStack: both are per-function
        speculativeStack.clear();
        committedVars.clear();
        nativeReturnType = CType{};
        localScopes.clear();
        localScopes.emplace_back();
    }
    void popFunctionContext() {
        if (!contextStack.empty()) contextStack.pop_back();
        localScopes.clear();
        localScopes.emplace_back();
        localStructTypes.clear();
        fieldCache.clear();
        currentInterfaceType.clear();
        indentLevel = 1;
    }
    void setFunctionContext(bool inside) {
        if (inside) pushFunctionContext(); else popFunctionContext();
    }

    // --- Indentation / emission -----------------------------------------
    void indent() { indentLevel++; }
    void dedent() { if (indentLevel > 0) indentLevel--; }

    void emit(const std::string& code) {
        currentStream() << getIndent() << code << "\n";
    }
    void emitGlobalDecl(const std::string& code) { globalsStream << code << "\n"; }

    void emitBlockOpen(const std::string& line) {
        localScopes.emplace_back();
        emit(line);
        indent();
    }
    void emitBlockClose(const std::string& suffix = "") {
        dedent();
        emit("}" + suffix);
        if (localScopes.size() > 1) localScopes.pop_back();
        fieldCache.clear();
    }

    std::string newTemp(const std::string& prefix = "t") {
        return prefix + "_" + std::to_string(tempVarCount++);
    }
    void addInclude(const std::string& header) { includeSet.insert(header); }
    void addSystemInclude(const std::string& header) { systemIncludes.insert(header); }

    void setBlasEnabled(bool v) { blasEnabled = v; }
    bool isBlasEnabled() const { return blasEnabled; }
    

    // --- M4-C1B: interface field typing ---------------------------------
    void registerInterfaceArrayField(const std::string& iface,
                                     const std::string& field,
                                     VType elem) {
        if (elem == VType::Int64 || elem == VType::Float64)
            interfaceArrayFields[iface][field] = elem;
    }
    VType getInterfaceArrayElem(const std::string& iface,
                                const std::string& field) const {
        auto probe = [&](const std::string& k) -> VType {
            auto it = interfaceArrayFields.find(k);
            if (it == interfaceArrayFields.end()) return VType::Unknown;
            auto f = it->second.find(field);
            return f == it->second.end() ? VType::Unknown : f->second;
        };
        VType v = probe(iface);
        if (v != VType::Unknown) return v;
        std::string tmp = iface;
        size_t dot;
        while ((dot = tmp.find('.')) != std::string::npos) {
            tmp = tmp.substr(dot + 1);
            v = probe(tmp);
            if (v != VType::Unknown) return v;
        }
        return VType::Unknown;
    }

    void registerInterfacePrimitiveField(const std::string& iface,
                                         const std::string& field,
                                         VType t) {
        if (t == VType::Int64 || t == VType::Float64)
            interfacePrimitiveFields[iface][field] = t;
    }
    VType getInterfacePrimitiveField(const std::string& iface,
                                     const std::string& field) const {
        auto probe = [&](const std::string& k) -> VType {
            auto it = interfacePrimitiveFields.find(k);
            if (it == interfacePrimitiveFields.end()) return VType::Unknown;
            auto f = it->second.find(field);
            return f == it->second.end() ? VType::Unknown : f->second;
        };
        VType v = probe(iface);
        if (v != VType::Unknown) return v;
        std::string tmp = iface;
        size_t dot;
        while ((dot = tmp.find('.')) != std::string::npos) {
            tmp = tmp.substr(dot + 1);
            v = probe(tmp);
            if (v != VType::Unknown) return v;
        }
        return VType::Unknown;
    }

    void setLocalStructType(const std::string& var, const std::string& t) {
        localStructTypes[var] = t;
    }
    
    const std::string* lookupLocalStructType(const std::string& var) const {
        auto it = localStructTypes.find(var);
        return it == localStructTypes.end() ? nullptr : &it->second;
    }
    void setGlobalStructType(const std::string& var, const std::string& t) {
        globalStructTypes[var] = t;
    }
    const std::string* lookupGlobalStructType(const std::string& var) const {
        auto it = globalStructTypes.find(var);
        return it == globalStructTypes.end() ? nullptr : &it->second;
    }

    void setCurrentInterfaceType(const std::string& t) { currentInterfaceType = t; }
    const std::string& getCurrentInterfaceType() const { return currentInterfaceType; }

    const FieldCacheEntry* getFieldCache(const std::string& key) const {
        auto it = fieldCache.find(key);
        return it == fieldCache.end() ? nullptr : &it->second;
    }
    void setFieldCache(const std::string& key, const std::string& temp,
                       const CType& ct) {
        fieldCache[key] = { temp, ct };
    }
    void clearFieldCache() { fieldCache.clear(); }

    // --- M2: monomorphization cache -------------------------------------
    // Cache-hit lookup. Callers compute the fully-qualified instantiation
    // key (e.g. "fn_max_of__i64"); a non-null return means the C symbol
    // has already been emitted and can be referenced directly.
    const std::string* lookupInstantiation(const std::string& key) const {
        auto it = instantiations.find(key);
        return it == instantiations.end() ? nullptr : &it->second;
    }
    // Mark a name as in-progress so recursive instantiations terminate.
    bool beginInstantiation(const std::string& key) {
        if (instantiations.count(key)) return false;
        if (instantiationsInProgress.count(key)) return false;
        instantiationsInProgress.insert(key);
        return true;
    }
    void finishInstantiation(const std::string& key, const std::string& cName) {
        instantiationsInProgress.erase(key);
        instantiations[key] = cName;
    }

    // --- Native module lookup -------------------------------------------
    const NativeMapEntry* findNative(const std::string& module,
                                     const std::string& member) const {
        if (module == "vcore")
            for (const auto& m : VCORE_MAP) if (member == m.vyneName) return &m;
        if (module == "vmath")
            for (const auto& m : VMATH_MAP) if (member == m.vyneName) return &m;
        if (module == "vmem")                                       
            for (const auto& m : VMEM_MAP)  if (member == m.vyneName) return &m;
        return nullptr;
    }
    std::string getNativeMapping(const std::string& module,
                                 const std::string& member,
                                 bool asFunctionCall) {
        const NativeMapEntry* e = findNative(module, member);
        if (!e) return "v_" + module + "_" + member;
        if (e->isProperty) return e->cName;
        return asFunctionCall ? e->cName : std::string(e->cName) + "()";
    }

    // --- Interface / group registry -------------------------------------
    void registerInterface(const std::string& name) { interfaceSet.insert(name); }
    void registerGroup(const std::string& name)     { groupSet.insert(name); }
    bool isInterface(const std::string& name) const { return interfaceSet.count(name) > 0; }
    bool isGroup(const std::string& name) const     { return groupSet.count(name) > 0; }

    void registerFunctionSignature(const std::string& name,
                                   std::vector<std::string> params) {
        functionSignatures[name] = std::move(params);
    }
    void registerFunctionParamTypes(const std::string& name,
                                std::vector<CType> types) {
        functionParamTypes[name] = std::move(types);
    }
    void registerFunctionReturnType(const std::string& name, const CType& ct) {
        functionReturnTypes[name] = ct;
    }
    const CType* getFunctionReturnType(const std::string& name) const {
        auto it = functionReturnTypes.find(name);
        return it == functionReturnTypes.end() ? nullptr : &it->second;
    }

    // Read-only view of the whole table. Used by the region escape
    // check as a last-resort fuzzy lookup, and by the diagnostic
    // dump when the check fires. Do not mutate through this accessor.
    const std::unordered_map<std::string, CType>&
    getAllFunctionReturnTypes() const {
        return functionReturnTypes;
    }
    const std::vector<CType>* getFunctionParamTypes(const std::string& name) const {
        auto it = functionParamTypes.find(name);
        return it == functionParamTypes.end() ? nullptr : &it->second;
    }

    void registerNativeVariant(const std::string& boxedMangled,
                            const std::string& nativeMangled) {
        nativeVariants[boxedMangled] = nativeMangled;
    }
    const std::string* lookupNativeVariant(const std::string& boxedMangled) const {
        auto it = nativeVariants.find(boxedMangled);
        return it == nativeVariants.end() ? nullptr : &it->second;
    }

    void setNativeReturnType(const CType& ct) { nativeReturnType = ct; }
    void clearNativeReturnType() { nativeReturnType = CType{}; }
    const CType& getNativeReturnType() const { return nativeReturnType; }
    const std::vector<std::string>* getFunctionSignature(const std::string& name) const {
        auto it = functionSignatures.find(name);
        return it == functionSignatures.end() ? nullptr : &it->second;
    }

    void setGroupPrefix(const std::string& p) { groupPrefix = p; }
    void clearGroupPrefix() { groupPrefix.clear(); }
    const std::string& getGroupPrefix() const { return groupPrefix; }

    void setScratchBoundsEnabled(bool v) { scratchBoundsEnabled = v; }
    bool isScratchBoundsEnabled() const { return scratchBoundsEnabled; }

    void registerInterfaceDefaults(const std::string& name,
                                   std::vector<std::string> defaults) {
        interfaceDefaults[name] = std::move(defaults);
    }
    const std::vector<std::string>* getInterfaceDefaults(const std::string& name) const {
        auto it = interfaceDefaults.find(name);
        return it == interfaceDefaults.end() ? nullptr : &it->second;
    }

    // --- Try / defer context --------------------------------------------
    void pushTryCleanup(const std::string& label) { tryCleanupStack.push_back(label); }
    void popTryCleanup() { if (!tryCleanupStack.empty()) tryCleanupStack.pop_back(); }
    bool hasTryCleanup() const { return !tryCleanupStack.empty(); }
    const std::string& currentTryCleanup() const { return tryCleanupStack.back(); }

    // --- Region emitters --------------------------------------------
    void pushRegion(const std::string& cpHandle) { regionStack.push_back(cpHandle); }
    void popRegion() { if (!regionStack.empty()) regionStack.pop_back(); }
    bool hasRegion() const { return !regionStack.empty(); }
    const std::vector<std::string>& getRegionStack() const { return regionStack; }

    // Emit rewind calls for every live region, innermost first.
    // Used by BreakNode / ContinueNode / ReturnNode before the transfer.
    void emitRegionUnwind() {
        for (auto it = regionStack.rbegin(); it != regionStack.rend(); ++it)
            emit("vmem_runtime_rewind(" + *it + ");");
    }

    // --- Pool context ------------------------------------------------
    // The pool is purely a lookup layer over regionStack. A @pool region
    // checkpoints on entry and rewinds on exit exactly like a bump
    // region; the pool struct's arena chunk sits above the checkpoint
    // so the rewind reclaims it. Early returns/breaks/continues rewind
    // through the same emitRegionUnwind() path as bump regions.
    void pushPool(const PoolContext& p) { poolStack.push_back(p); }
    void popPool()  { if (!poolStack.empty()) poolStack.pop_back(); }
    bool hasPool() const { return !poolStack.empty(); }
    const PoolContext& currentPool() const { return poolStack.back(); }

    // Idempotent include emit for vyne_pool_runtime.h — set on the
    // first @pool region, no-op thereafter.
    bool isPoolRuntimeEmitted() const { return poolRuntimeEmitted; }
    void markPoolRuntimeEmitted()      { poolRuntimeEmitted = true; }

    // --- Speculative context -----------------------------------------
    // Pushed by compileSpeculativeRegion, read by RegionCommitIfNode.
    // A speculative region still goes on regionStack; the speculative
    // stack only carries the commit flag's C name.
    void pushSpeculative(const SpeculativeContext& s) { speculativeStack.push_back(s); }
    void popSpeculative() { if (!speculativeStack.empty()) speculativeStack.pop_back(); }
    bool hasSpeculative() const { return !speculativeStack.empty(); }
    const SpeculativeContext& currentSpeculative() const { return speculativeStack.back(); }

    void setReturnVars(const std::string& rv, const std::string& rf) {
        currentReturnVar = rv; currentReturningVar = rf;
    }
    void clearReturnVars() { currentReturnVar.clear(); currentReturningVar.clear(); }
    bool hasReturnVars() const { return !currentReturnVar.empty(); }
    const std::string& getReturnVar() const { return currentReturnVar; }
    const std::string& getReturningVar() const { return currentReturningVar; }

    void pushDeferContext(const std::string& label, const std::string& retVar) {
        deferCtx = {label, retVar, true};
    }
    void popDeferContext() { deferCtx = {"", "", false}; }
    bool hasDeferContext() const { return deferCtx.active; }
    const std::string& getDeferCleanupLabel() const { return deferCtx.cleanupLabel; }
    const std::string& getDeferRetVar() const { return deferCtx.retVar; }

    // --- Output assembly -------------------------------------------------
    std::string finalize(const std::string& runtimeHeader = "vyne_runtime.h") {
        std::stringstream out;
        out << "#include \"" << runtimeHeader << "\"\n";
        for (const auto& inc : includeSet)
            out << "#include \"" << inc << "\"\n";
        for (const auto& inc : systemIncludes)
            out << "#include <" << inc << ">\n";
        out << "\n";

        std::string globals = globalsStream.str();
        if (!globals.empty()) out << "// --- Globals ---\n" << globals << "\n";

        std::string funcs = functionStream.str();
        if (!funcs.empty()) out << "// --- Functions ---\n" << funcs << "\n";

        out << "int main(void) {\n";
        out << mainStream.str();
        out << "    arena_free_all();\n";
        out << "    return 0;\n";
        out << "}\n";
        return out.str();
    }

    std::string getFunctionCode() { return functionStream.str(); }
    std::string getBodyCode()     { return mainStream.str(); }
    std::string getIncludes() {
        std::string res;
        for (const auto& inc : includeSet)
            res += "#include \"" + inc + "\"\n";
        return res;
    }

    // --- Full reset (between programs) ----------------------------------
    void reset() {
        globalsStream.str("");  globalsStream.clear();
        functionStream.str(""); functionStream.clear();
        mainStream.str("");     mainStream.clear();
        includeSet.clear();
        systemIncludes.clear();
        interfaceDefaults.clear();
        contextStack.clear();
        groupPrefix.clear();
        interfaceSet.clear();
        groupSet.clear();
        declaredVars.clear();
        references.clear();
        importedFiles.clear();
        functionSignatures.clear();
        sourceDir.clear();
        activeFunctionPrefix.clear();
        tryCleanupStack.clear();
        deferCtx = {};
        regionStack.clear(); 
        committedVars.clear();
        poolStack.clear();
        speculativeStack.clear();
        poolRuntimeEmitted   = false;
        scratchBoundsEnabled = true;
        blasEnabled          = false;
        currentReturnVar.clear();
        currentReturningVar.clear();
        localScopes.clear();
        localScopes.emplace_back();
        globalTypes.clear();
        nativeTemps.clear();

        functionParamTypes.clear();
        functionReturnTypes.clear();
        nativeVariants.clear();
        nativeReturnType = CType{};

        interfaceArrayFields.clear();
        interfacePrimitiveFields.clear();
        localStructTypes.clear();
        globalStructTypes.clear();
        currentInterfaceType.clear();
        fieldCache.clear();

        instantiations.clear();
        instantiationsInProgress.clear();

        tempVarCount = 0;
        indentLevel  = 1;
    }
};

#endif