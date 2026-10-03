#include "detail/codegen_helpers.h"

// Method calls, including specialized collection and native methods.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// METHOD CALL
// ============================================================

std::string MethodCallNode::getCExpr(C_Emitter& e) const {
    // Resolve a dotted path for the receiver, e.g. "vmath", "vlinalg.Types",
    // or a plain variable name. Used to look up interfaces / groups.
    std::string recvPath;
    if (receiver->type() == NodeType::VARIABLE) {
        recvPath = static_cast<VariableNode*>(receiver.get())->getOriginalName();
    } else if (receiver->type() == NodeType::MEMBER_ACCESS) {
        recvPath = static_cast<MemberAccessNode*>(receiver.get())->getFullPath();
    }

    // ----------------------------------------------------------------
    // Native module dispatch (bare module name only, e.g. vmath.sqrt).
    // ----------------------------------------------------------------
    if (receiver->type() == NodeType::VARIABLE) {
        const NativeMapEntry* entry = e.findNative(recvPath, methodName);

        // A native module property is a zero-argument getter whose cName
        // is a full C expression ("vmath_inf()", "vcore_get_version()").
        // The user wrote `mod.prop()`, so the expression is exactly what
        // we want to return. Falling through emits fn_vmath_inf(0, args),
        // which is undefined.
        if (entry && entry->isProperty) {
            return entry->cName;
        }

        if (entry && !entry->isProperty) {
            std::string resTemp = e.newTemp("n_ret");

            if (entry->usesArgv) {
                // ---- variadic: emit (argc, argv) --------------------
                int n = (int)arguments.size();
                std::string argArr = e.newTemp("n_args");
                e.emit("VyneValue* " + argArr +
                       " = (VyneValue*)arena_alloc(sizeof(VyneValue) * " +
                       std::to_string(n > 0 ? n : 1) + ");");
                for (int i = 0; i < n; ++i) {
                    e.emit(argArr + "[" + std::to_string(i) + "] = " +
                           e.boxAny(arguments[i]->getCExpr(e)) + ";");
                }
                e.emit("VyneValue " + resTemp + " = " + entry->cName +
                       "(" + std::to_string(n) + ", " + argArr + ");");
                return resTemp;
            }

            // M5: native _f64 dispatch when every arg is a provable double.
            if (entry->nativeF64 && !arguments.empty()) {
                bool allF64 = true;
                for (const auto& a : arguments) {
                    std::string raw = a->getCExpr(e);   // may emit
                    const CType* ct = e.exprNativeType(raw);
                    if (!ct || ct->kind != CType::Kind::Float64) { allF64 = false; break; }
                }
                if (allF64) {
                    std::string argStr;
                    for (size_t i = 0; i < arguments.size(); ++i) {
                        if (i > 0) argStr += ", ";
                        std::string raw = arguments[i]->getCExpr(e);
                        argStr += raw;
                    }
                    std::string resTemp = e.newTemp("n_ret");
                    e.emit("double " + resTemp + " = " + entry->nativeF64 +
                           "(" + argStr + ");");
                    e.declareNativeTemp(resTemp, CType::fromKind(CType::Kind::Float64));
                    return resTemp;
                }
            }

            // ---- fixed arity: emit (arg1, arg2, ...) ----------------
            std::string argStr;
            for (size_t i = 0; i < arguments.size(); ++i) {
                if (i > 0) argStr += ", ";
                argStr += e.boxAny(arguments[i]->getCExpr(e));
            }
            e.emit("VyneValue " + resTemp + " = " + entry->cName +
                   "(" + argStr + ");");
            return resTemp;
        }
    }

    // ----------------------------------------------------------------
    // Interface constructor via a dotted path: a.b.Ctor(...)
    //
    // Try the full path first, then progressively shorter suffixes,
    // then the bare method name. `InterfaceNode::compile` registers
    // each interface under its bare name and its immediate module
    // prefix, so "vlinalg.Types.Matrix" resolves via the "Types.Matrix"
    // candidate.
    // ----------------------------------------------------------------
    if (!recvPath.empty()) {
        std::vector<std::string> candidates;
        candidates.push_back(recvPath);
        {
            std::string tmp = recvPath;
            size_t dot;
            while ((dot = tmp.find('.')) != std::string::npos) {
                tmp = tmp.substr(dot + 1);
                candidates.push_back(tmp);
            }
        }
        candidates.push_back("");  // bare method name

        for (const auto& base : candidates) {
            std::string dotted  = base.empty() ? methodName
                                              : (base + "." + methodName);
            std::string mangled = base.empty() ? methodName
                                               : (base + "_" + methodName);
            std::replace(mangled.begin(), mangled.end(), '.', '_');

            if (!e.isInterface(dotted) && !e.isInterface(mangled)) continue;

            const std::vector<std::string>* defaults =
                e.getInterfaceDefaults(dotted);
            if (!defaults) defaults = e.getInterfaceDefaults(mangled);
            if (!defaults) defaults = e.getInterfaceDefaults(methodName);

            std::vector<std::string> argStrs;
            argStrs.reserve(arguments.size());
            for (const auto& a : arguments)
                argStrs.push_back(e.boxAny(a->getCExpr(e)));
            if (defaults) {
                for (size_t i = argStrs.size(); i < defaults->size(); ++i) {
                    argStrs.push_back((*defaults)[i]);
                }
            }

            std::string directArgs;
            for (size_t i = 0; i < argStrs.size(); ++i) {
                if (i > 0) directArgs += ", ";
                directArgs += argStrs[i];
            }

            std::string resTemp = e.newTemp("g_iface");
            e.emit("VyneValue " + resTemp + " = struct_" + mangled +
                   "(" + directArgs + ");");
            return resTemp;
        }
    }

    // ----------------------------------------------------------------
    // Group call: module.add(...) / module.sub.method(...)
    // ----------------------------------------------------------------
    if (!recvPath.empty() && e.isGroup(recvPath)) {
        if (auto blas = tryEmitBlasCall(e, recvPath, methodName, arguments)) {
            return *blas;
        }

        int argSize = (int)arguments.size();

        // Capture each argument's C expression and static type once.
        // Reused by both the native dispatch and (on fall-through) the
        // boxed path, so no argument is evaluated twice.
        std::vector<ASTNode*> orderedArgs;
        orderedArgs.reserve(arguments.size());
        for (const auto& a : arguments) orderedArgs.push_back(a.get());

        std::vector<std::string> argCExprs;
        std::vector<VType>       argVTypes;
        std::vector<const CType*> argCTypes;
        argCExprs.reserve(orderedArgs.size());
        argVTypes.reserve(orderedArgs.size());
        argCTypes.reserve(orderedArgs.size());

        for (auto* a : orderedArgs) {
            std::string s = a->getCExpr(e);
            const CType* fullCt = e.lookupType(s);
            const CType* primCt = e.exprNativeType(s);
            VType t = primCt ? primCt->toVType() : a->getStaticType();
            argCExprs.push_back(std::move(s));
            argVTypes.push_back(t);
            argCTypes.push_back(fullCt);
        }

        // --- Native-ABI dispatch -------------------------------------
        // Same lowering the function-call path already has. Every
        // kernel in vlin/Kernels.vy (k_add, k_sum, k_matmul, ...) now
        // lowers to its native variant when the argument types match.
        // That collapses the boxed args array + arena alloc +
        // per-element tag check into a direct call like
        //   fn_vlin_k_add_native(out.data, a.data, b.data, n).
        std::string gMethodName = recvPath + "_" + methodName;
        std::replace(gMethodName.begin(), gMethodName.end(), '.', '_');

        if (auto native = tryEmitNativeCall(
                e, gMethodName, methodName,
                orderedArgs, argCExprs, argVTypes, argCTypes)) {
            return *native;
        }
        // --- end native-ABI dispatch ---------------------------------

        // --- Boxed fallback (reuses argCExprs) -----------------------
        std::string argArr = e.newTemp("g_args");
        if (argSize > 0) {
            e.emit("VyneValue* " + argArr +
                   " = (VyneValue*)arena_alloc(sizeof(VyneValue) * " +
                   std::to_string(argSize) + ");");
            for (int i = 0; i < argSize; ++i) {
                e.emit(argArr + "[" + std::to_string(i) + "] = " +
                       e.boxAny(argCExprs[i]) + ";");
            }
        } else {
            e.emit("VyneValue* " + argArr + " = NULL;");
        }

        std::string resTemp = e.newTemp("g_ret");
        e.emit("VyneValue " + resTemp + " = fn_" + gMethodName +
               "(" + std::to_string(argSize) + ", " + argArr + ");");
        return resTemp;
    }

    // ----------------------------------------------------------------
    // Everything else: struct method call / built-in array / string /
    // map methods on a runtime value.
    // ----------------------------------------------------------------
    std::string recvRaw = receiver->getCExpr(e);

    // Array methods: push — try the typed-array fast path BEFORE boxing
    // the receiver. The old order boxed unconditionally, which put a
    // vyne_array_f64_to_value(...) call inside every push loop.
    if (methodName == "push") {
        const CType* rt = e.lookupType(recvRaw);
        if (rt && rt->kind == CType::Kind::Array && !rt->args.empty()) {
            VType elem = rt->args[0].toVType();
            std::string pushFn = (elem == VType::Float64)
                ? "vyne_array_f64_push" : "vyne_array_i64_push";
            for (const auto& argNode : arguments) {
                std::string rawVal = argNode->getCExpr(e);
                std::string val = coerceToNative(e, argNode.get(), rawVal, elem);
                e.emit(pushFn + "(&" + recvRaw + ", " + val + ");");
            }
            return recvRaw;
        }
        // Boxed fallback — box the receiver only on this path.
        std::string recvBoxed = e.newTemp("m_recv");
        e.emit("VyneValue " + recvBoxed + " = " + e.boxAny(recvRaw) + ";");
        for (const auto& argNode : arguments) {
            e.emit("vyne_array_push(" + recvBoxed + ", " +
                e.boxAny(argNode->getCExpr(e)) + ");");
        }
        return recvBoxed;
    }

    // Every branch below needs a boxed receiver — box it once, here.
    std::string recv = e.newTemp("m_recv");
    e.emit("VyneValue " + recv + " = " + e.boxAny(recvRaw) + ";");
    if (methodName == "pop") {
        std::string temp = e.newTemp("pop");
        e.emit("VyneValue " + temp + " = vyne_array_pop(" + recv + ");");
        return temp;
    }
    if (methodName == "reverse") {
        e.emit("vyne_array_reverse(" + recv + ");");
        return recv;
    }

    // If the receiver is a statically-known struct/interface type, its own
    // registered methods win over built-ins that share the name (length,
    // size, has, keys, values, push, pop, ...). Let the struct-method
    // dispatch at the bottom of this function handle it.
    bool receiverIsStruct = false;
    if (receiver->type() == NodeType::VARIABLE) {
        auto* var = static_cast<VariableNode*>(receiver.get());
        std::string recvName = var->getOriginalName();
        std::string prefix   = e.getActiveFunctionPrefix();
        std::string lookupKey = prefix.empty()
            ? ("v_" + recvName)
            : ("v_" + prefix + "_" + recvName);

        const std::string* typeName = e.lookupLocalStructType(lookupKey);
        if (!typeName) typeName = e.lookupGlobalStructType("v_" + recvName);

        if (typeName &&
            *typeName != "String" && *typeName != "Int64"
            && *typeName != "Float64" && *typeName != "Bool"
            && *typeName != "Array" && *typeName != "Map"
            && *typeName != "Null") {
            receiverIsStruct = true;
        }
    }
    if (!receiverIsStruct && (methodName == "length" || methodName == "size")) {
        std::string temp = e.newTemp("len");
        e.emit("VyneValue " + temp + " = vyne_int(vyne_get_sizeof(" + recv + "));");
        return temp;
    }
    if (methodName == "pop_front") {
        std::string temp = e.newTemp("pf");
        e.emit("VyneValue " + temp + " = vyne_array_pop_front(" + recv + ");");
        return temp;
    }
    if (methodName == "back") {
        std::string temp = e.newTemp("bk");
        e.emit("VyneValue " + temp + " = vyne_array_back(" + recv + ");");
        return temp;
    }
    if (methodName == "delete_at") {
        std::string idx = e.boxAny(arguments[0]->getCExpr(e));
        std::string temp = e.newTemp("delat");
        e.emit("VyneValue " + temp + " = vyne_array_delete_at(" + recv +
               ", (" + idx + ").as.i64);");
        return temp;
    }
    if (methodName == "sort") {
        e.emit("vyne_array_sort(" + recv + ");");
        return recv;
    }
    if (methodName == "place_all") {
        std::string v = e.boxAny(arguments[0]->getCExpr(e));
        std::string c = e.boxAny(arguments[1]->getCExpr(e));
        e.emit("vyne_array_place_all(" + recv + ", " + v +
               ", (" + c + ").as.i64);");
        return recv;
    }

    // --- String methods ---
    if (methodName == "substr") {
        if (arguments.empty()) {
            throw std::runtime_error(
                "Compile Error: substr() requires at least 1 argument (line " +
                std::to_string(lineNumber) + ")");
        }
        std::string s = e.boxAny(arguments[0]->getCExpr(e));
        std::string c = (arguments.size() >= 2) ? e.boxAny(arguments[1]->getCExpr(e)) : "vyne_int(-1)";
        std::string temp = e.newTemp("substr");
        e.emit("VyneValue " + temp + " = vyne_string_substr(" + recv +
               ", (" + s + ").as.i64, (" + c + ").as.i64);");
        return temp;
    }
    if (methodName == "find") {
        if (arguments.empty()) {
            throw std::runtime_error(
                "Compile Error: find() requires 1 argument (line " +
                std::to_string(lineNumber) + ")");
        }
        std::string target = e.boxAny(arguments[0]->getCExpr(e));
        std::string temp = e.newTemp("find");
        e.emit("VyneValue " + temp + " = vyne_string_find(" + recv + ", " + target + ");");
        return temp;
    }
    if (methodName == "uppercase") {
        std::string temp = e.newTemp("up");
        e.emit("VyneValue " + temp + " = vyne_string_uppercase(" + recv + ");");
        return temp;
    }
    if (methodName == "lowercase") {
        std::string temp = e.newTemp("lo");
        e.emit("VyneValue " + temp + " = vyne_string_lowercase(" + recv + ");");
        return temp;
    }
    if (methodName == "trim") {
        std::string temp = e.newTemp("tr");
        e.emit("VyneValue " + temp + " = vyne_string_trim(" + recv + ");");
        return temp;
    }
    if (methodName == "replace") {
        if (arguments.size() < 2) {
            throw std::runtime_error(
                "Compile Error: replace() requires 2 arguments (line " +
                std::to_string(lineNumber) + ")");
        }
        std::string o = e.boxAny(arguments[0]->getCExpr(e));
        std::string n = e.boxAny(arguments[1]->getCExpr(e));
        std::string temp = e.newTemp("rep");
        e.emit("VyneValue " + temp + " = vyne_string_replace(" + recv +
               ", " + o + ", " + n + ");");
        return temp;
    }

    if (methodName == "fields") {
        std::string temp = e.newTemp("flds");
        e.emit("VyneValue " + temp + " = vyne_array_create(0);");
        e.emitBlockOpen("if (" + recv + ".type == V_STRUCT) {");
        e.emit("VyneStruct* __s = " + recv + ".as.strct;");
        e.emitBlockOpen("for (int __i = 0; __i < __s->field_count; __i++) {");
        e.emit("vyne_array_push(" + temp + ", vyne_string(__s->fields[__i].name));");
        e.emitBlockClose();
        e.emitBlockClose();
        return temp;
    }

    if (methodName == "has") {
        std::string arg = e.boxAny(arguments[0]->getCExpr(e));
        std::string temp = e.newTemp("has");
        e.emit("VyneValue " + temp + " = vyne_bool(vyne_map_has(" + recv + ", " + arg + "));");
        return temp;
    }
    if (methodName == "keys") {
        std::string temp = e.newTemp("keys");
        e.emit("VyneValue " + temp + " = vyne_map_keys(" + recv + ");");
        return temp;
    }
    if (methodName == "values") {
        std::string temp = e.newTemp("vals");
        e.emit("VyneValue " + temp + " = vyne_map_values(" + recv + ");");
        return temp;
    }
    if (methodName == "set") {
        std::string k = e.boxAny(arguments[0]->getCExpr(e));
        std::string v = e.boxAny(arguments[1]->getCExpr(e));
        e.emit("vyne_map_set(" + recv + ", " + k + ", " + v + ");");
        return v;
    }
    if (methodName == "delete") {
        std::string k = e.boxAny(arguments[0]->getCExpr(e));
        std::string temp = e.newTemp("del");
        e.emit("VyneValue " + temp + " = vyne_delete_any(" + recv + ", " + k + ");");
        return temp;
    }
    if (methodName == "clear") {
        e.emit("vyne_clear_any(" + recv + ");");
        return recv;
    }

    // Struct method call (last resort — user-defined methods on struct
    // values that were not caught by the interface / group branches).
    {
        std::string temp = e.newTemp("mret");
        int argSize = (int)arguments.size();
        std::string argArr = e.newTemp("m_args");

        e.emit("VyneValue " + temp + " = vyne_null();");
        e.emitBlockOpen("if (" + recv + ".type == V_STRUCT) {");
        e.emit("VyneValue* " + argArr + " = (VyneValue*)arena_alloc(sizeof(VyneValue) * " +
               std::to_string(argSize + 1) + ");");
        e.emit(argArr + "[0] = " + recv + ";");
        for (int i = 0; i < argSize; ++i) {
            e.emit(argArr + "[" + std::to_string(i + 1) + "] = " +
                   e.boxAny(arguments[i]->getCExpr(e)) + ";");
        }
        e.emit(temp + " = vyne_struct_call(" + recv + ", \"" + methodName + "\", " +
               std::to_string(argSize + 1) + ", " + argArr + ");");
        e.emitBlockClose();
        return temp;
    }

    return "vyne_null()";
}

void MethodCallNode::compile(C_Emitter& e) const { getCExpr(e); }

