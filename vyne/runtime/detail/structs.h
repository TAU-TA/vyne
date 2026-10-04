// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Tuncay Gafarli
//
// This file is part of the Vyne runtime library, distributed under the
// MIT License. See LICENSE-MIT at the repository root for the full text.

#pragma once
#include "collections.h"
// ============================================================================
// STRUCT OPERATIONS
// ============================================================================

static inline VyneValue vyne_struct_get(VyneValue s_val, uint32_t field_id) {
    if (s_val.type != V_STRUCT) return vyne_null();
    VyneStruct* s = s_val.as.strct;
    int fc = s->field_count;
    if (VYNE_UNLIKELY(fc == 0)) return vyne_null();

    int16_t* c = s->field_cache;

    // Fast path: hit in one of the four cache slots. On hit at slot
    // k, move the entry to the front (true MRU), shifting 0..k-1
    // down by one. Slots hold indices into fields[]; a stale index
    // fails either the bounds check or the id check and falls
    // through to the scan below.
    for (int k = 0; k < 4; ++k) {
        int16_t idx = c[k];
        if (idx >= 0 && idx < fc && s->fields[idx].id == field_id) {
            for (int j = k; j > 0; --j) c[j] = c[j - 1];
            c[0] = idx;
            return s->fields[idx].value;
        }
    }

    // Slow path: linear scan. Insert at MRU, drop LRU.
    for (int i = 0; i < fc; ++i) {
        if (s->fields[i].id == field_id) {
            c[3] = c[2];
            c[2] = c[1];
            c[1] = c[0];
            c[0] = (int16_t)i;
            return s->fields[i].value;
        }
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
    // Loud on overflow. The previous silent-drop turned "why doesn't my
    // method dispatch?" into a debugging session: the call still compiled,
    // still ran, and returned vyne_null() with no diagnostic. If you hit
    // this, raise VYNE_MAX_METHODS — do NOT reduce the number of registered
    // methods, because that means a module silently vanished from the table.
    if (VYNE_UNLIKELY(g_method_count >= VYNE_MAX_METHODS)) {
        fprintf(stderr,
                "Runtime error (VNE-100): method table full (%d entries). "
                "Registration of %s.%s failed. Raise VYNE_MAX_METHODS.\n",
                VYNE_MAX_METHODS, type, method);
        exit(1);
    }
    g_method_table[g_method_count].type_name   = type;
    g_method_table[g_method_count].method_name = method;
    g_method_table[g_method_count].fn          = fn;
    g_method_count++;
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

