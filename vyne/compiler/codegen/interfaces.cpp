#include "detail/codegen_helpers.h"

// Interface declarations, field typing, and method registration.
// Keep expressions that emit statements in evaluation order; see README.md.
// ============================================================
// INTERFACE / STRUCT
// ============================================================

void InterfaceNode::compile(C_Emitter& e) const {
    // Determine the effective module: explicit moduleName wins, else use
    // the currently active group prefix (set by GroupNode::compile).
    std::string effectiveModule = moduleName;
    if (effectiveModule.empty()) effectiveModule = e.getGroupPrefix();

    std::string fullName = effectiveModule.empty()
        ? interfaceName
        : (effectiveModule + "." + interfaceName);

    std::string cStructName = effectiveModule.empty()
        ? interfaceName
        : (effectiveModule + "_" + interfaceName);
    std::replace(cStructName.begin(), cStructName.end(), '.', '_');
    std::replace(cStructName.begin(), cStructName.end(), '_', '_');

    // Register the interface under its bare name, dotted name, and
    // underscore-mangled name so that every calling convention resolves.
    e.registerInterface(interfaceName);
    if (!effectiveModule.empty()) {
        e.registerInterface(effectiveModule + "." + interfaceName);
        e.registerInterface(effectiveModule + "_" + interfaceName);
    }

    for (const auto& m : members) {
        e.registerInterfaceArrayField(fullName, m.name, m.arrayElemType);
        e.registerInterfaceArrayField(interfaceName, m.name, m.arrayElemType);
    }

    // Per-field defaults (used to pad short constructor calls).
    {
        std::vector<std::string> defaults;
        defaults.reserve(members.size());
        for (const auto& m : members) {
            switch (m.type) {
                case VType::String:  defaults.push_back("vyne_string(\"\")"); break;
                case VType::Int64:   defaults.push_back("vyne_int(0)");        break;
                case VType::Float64: defaults.push_back("vyne_float(0.0)");    break;
                case VType::Array:   defaults.push_back("vyne_array_create(0)"); break;
                case VType::Map:     defaults.push_back("vyne_map_create()");   break;
                default:             defaults.push_back("vyne_null()");         break;
            }
        }
        e.registerInterfaceDefaults(interfaceName, defaults);
        if (!effectiveModule.empty()) {
            e.registerInterfaceDefaults(effectiveModule + "." + interfaceName, defaults);
            e.registerInterfaceDefaults(effectiveModule + "_" + interfaceName, defaults);
        }
    }

    e.pushFunctionContext();

    e.emit("// interface: " + fullName);
    std::string params;
    for (size_t i = 0; i < members.size(); ++i) {
        if (i > 0) params += ", ";
        params += "VyneValue v_" + members[i].name;
    }

    e.emitBlockOpen("VyneValue struct_" + cStructName + "(" + params + ") {");

    std::string temp = e.newTemp("s");
    e.emit("VyneStruct* " + temp + " = (VyneStruct*)arena_alloc(sizeof(VyneStruct));");
    e.emit(temp + "->type_name = \"" + fullName + "\";");
    e.emit(temp + "->field_count = " + std::to_string(members.size()) + ";");
    e.emit(temp + "->fields = (VyneField*)arena_alloc(sizeof(VyneField) * " +
           std::to_string(members.size()) + ");");
    e.emit(temp + "->methods = NULL;");
    e.emit(temp + "->method_count = 0;");

    for (size_t i = 0; i < members.size(); ++i) {
        uint32_t fid = StringPool::intern(members[i].name);
        e.emit(temp + "->fields[" + std::to_string(i) + "].id = " + std::to_string(fid) + ";");
        e.emit(temp + "->fields[" + std::to_string(i) + "].name = \"" + members[i].name + "\";");
        e.emit(temp + "->fields[" + std::to_string(i) + "].value = v_" + members[i].name + ";");
    }

    e.emit("VyneValue res; res.type = V_STRUCT; res.as.strct = " + temp + ";");
    e.emit("return res;");
    e.emitBlockClose();
    e.emit("");

    for (const auto& method : methods) {
        if (!method) continue;
        auto* fn = static_cast<FunctionNode*>(method.get());
        std::string methodName = cStructName + "_" + fn->getOriginalName();
        std::replace(methodName.begin(), methodName.end(), '.', '_');

        // Register this interface method's return type under every
        // spelling the region escape check (assignments.cpp:
        // checkRegionEscape) might query with. Interface methods are
        // emitted inline by this function and never routed through
        // FunctionNode::compile, so without this block the emitter's
        // functionReturnTypes table has no entry for them — every
        // `x = iface.method(...)` inside a region then looked like an
        // untyped, non-primitive RHS and tripped VNE-070. The
        // `vlin.cross_entropy(...)` case in ml_seq.vy is exactly this:
        // cross_entropy is declared with a `-> Float64` return type,
        // but nothing ever wrote that type into the emitter's table.
        {
            CType retCt = CType::fromVType(fn->getReturnType());
            if (fn->getReturnType() == VType::Array &&
                fn->getReturnArrayElemType() != VType::Unknown) {
                retCt.args.push_back(
                    CType::fromVType(fn->getReturnArrayElemType()));
            }

            std::string orig = fn->getOriginalName();
            std::string mangled = orig;
            std::replace(mangled.begin(), mangled.end(), '.', '_');

            // Bare name and dotted/mangled forms.
            e.registerFunctionReturnType(orig,       retCt);
            e.registerFunctionReturnType(mangled,    retCt);
            e.registerFunctionReturnType(methodName, retCt);

            // Receiver-qualified forms. `vlin.cross_entropy(...)` has
            // recvPath = "vlin"; checkRegionEscape will query
            // "vlin_cross_entropy" and "vlin.cross_entropy".
            if (!effectiveModule.empty()) {
                e.registerFunctionReturnType(
                    effectiveModule + "_" + mangled, retCt);
                e.registerFunctionReturnType(
                    effectiveModule + "." + orig,    retCt);
            }
            // Also under the interface's own name, so
            // `Matrix.multiply(...)` style calls resolve too.
            if (interfaceName != effectiveModule) {
                e.registerFunctionReturnType(
                    interfaceName + "_" + mangled, retCt);
                e.registerFunctionReturnType(
                    interfaceName + "." + orig,    retCt);
            }
        }

        e.emitGlobalDecl("VyneValue fn_" + methodName + "(int arg_count, VyneValue* args);");
        e.pushFunctionContext();
        e.enterFunction(methodName); 
        e.setCurrentInterfaceType(fullName);
        e.emitBlockOpen("VyneValue fn_" + methodName + "(int arg_count, VyneValue* args) {");

        e.emit("VyneValue v_self = (arg_count > 0) ? args[0] : vyne_null();");

        const auto& params2 = fn->getParameters();
        for (size_t i = 0; i < params2.size(); ++i) {
            std::string paramName = "v_" + params2[i].name;
            std::replace(paramName.begin(), paramName.end(), '.', '_');
            e.emit("VyneValue " + paramName +
                   " = (arg_count > " + std::to_string(i + 1) +
                   ") ? args[" + std::to_string(i + 1) + "] : vyne_null();");
        }

        for (const auto& stmt : fn->getBody())
            if (stmt) stmt->compile(e);

        e.emit("return vyne_null();");
        e.emitBlockClose();
        e.emit("");
        e.exitFunction();
        e.popFunctionContext();

        e.pushMainContext();
        e.emit("vyne_register_method(\"" + fullName + "\", \"" +
               fn->getOriginalName() + "\", fn_" + methodName + ");");
        e.popMainContext();
    }

    e.popFunctionContext();
}

std::string InterfaceNode::getCExpr(C_Emitter& e) const { return "vyne_null()"; }

