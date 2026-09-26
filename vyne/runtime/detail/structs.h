#pragma once
#include "collections.h"
// ============================================================================
// STRUCT OPERATIONS
// ============================================================================

static inline VyneValue vyne_struct_get(VyneValue s_val, uint32_t field_id) {
    if (s_val.type != V_STRUCT) return vyne_null();
    VyneStruct* s = s_val.as.strct;
    for (int i = 0; i < s->field_count; i++) {
        if (s->fields[i].id == field_id) return s->fields[i].value;
    }
    return vyne_null();
}

static inline void vyne_struct_set(VyneValue s_val, uint32_t field_id,
                                   const char* field_name, VyneValue val) {
    if (s_val.type != V_STRUCT) return;
    VyneStruct* s = s_val.as.strct;

    for (int i = 0; i < s->field_count; i++) {
        if (s->fields[i].id == field_id) {
            s->fields[i].value = val;
            return;
        }
    }

    VyneField* new_fields = (VyneField*)arena_alloc(sizeof(VyneField) * (s->field_count + 1));
    if (s->fields && s->field_count > 0) {
        memcpy(new_fields, s->fields, sizeof(VyneField) * s->field_count);
    }
    new_fields[s->field_count].id = field_id;
    new_fields[s->field_count].name = field_name;
    new_fields[s->field_count].value = val;
    s->fields = new_fields;
    s->field_count++;
}

static inline void vyne_register_method(const char* type, const char* method, VyneMethodFn fn) {
    if (g_method_count < VYNE_MAX_METHODS) {
        g_method_table[g_method_count].type_name = type;
        g_method_table[g_method_count].method_name = method;
        g_method_table[g_method_count].fn = fn;
        g_method_count++;
    }
}

static inline VyneValue vyne_struct_call(VyneValue self, const char* method, int argc, VyneValue* args) {
    if (self.type != V_STRUCT) return vyne_null();
    const char* type_name = self.as.strct->type_name;
    for (int i = 0; i < g_method_count; i++) {
        if (strcmp(g_method_table[i].type_name, type_name) == 0 &&
            strcmp(g_method_table[i].method_name, method) == 0) {
            return g_method_table[i].fn(argc, args);
        }
    }
    return vyne_null();
}

