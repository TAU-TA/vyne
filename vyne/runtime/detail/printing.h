#pragma once
#include "structs.h"
// ============================================================================
// VALUE UTILITIES
// ============================================================================

static inline bool vyne_is_truthy(VyneValue v) {
    if (v.type == V_NULL) return false;
    if (v.type == V_BOOL || v.type == V_INT64) return v.as.i64 != 0;
    if (v.type == V_FLOAT64) return v.as.f64 != 0.0;
    return true;
}

static inline void _vyne_print_internal(VyneValue v) {
    switch (v.type) {
        case V_INT64:   printf("%lld", v.as.i64); break;
        case V_BOOL:    printf("%s", v.as.i64 ? "true" : "false"); break;
        case V_NULL:    printf("null"); break;
        case V_STRING:  printf("%s", v.as.str ? v.as.str : "null"); break;
        case V_FLOAT64: {
            char buf[64];
            sprintf(buf, "%g", v.as.f64);
            if (strchr(buf, '.') == NULL && strchr(buf, 'e') == NULL)
                strcat(buf, ".0");
            printf("%s", buf);
            break;
        }
        case V_ARRAY: {
            printf("[");
            VyneArray* arr = v.as.arr;
            for (int i = 0; i < arr->size; i++) {
                _vyne_print_internal(arr->elements[i]);
                if (i < arr->size - 1) printf(", ");
            }
            printf("]");
            break;
        }
        case V_MAP: {
            VyneMap* m = v.as.map;
            printf("{");
            int printed = 0;
            for (int i = 0; i < m->capacity && printed < m->size; i++) {
                const char* key = m->entries[i].key;
                if (key == NULL || key == VYNE_TOMBSTONE) continue;
                if (printed > 0) printf(", ");
                printf("\"%s\": ", key);
                _vyne_print_internal(m->entries[i].value);
                printed++;
            }
            printf("}");
            break;
        }
        case V_STRUCT: {
            VyneStruct* s = v.as.strct;
            printf("%s { ", s->type_name);
            for (int i = 0; i < s->field_count; i++) {
                printf("%s: ", s->fields[i].name);
                _vyne_print_internal(s->fields[i].value);
                if (i < s->field_count - 1) printf(", ");
            }
            printf(" }");
            break;
        }
        default: printf("<unknown>");
    }
}

static inline void vyne_out(VyneValue v) {
    _vyne_print_internal(v);
    printf("\n");
    fflush(stdout);
}

