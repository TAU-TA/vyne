#pragma once
#include "conversions.h"

static inline bool vyne_values_equal(VyneValue a, VyneValue b) {
    if (a.type != b.type) {
        if ((a.type == V_INT64 || a.type == V_FLOAT64) &&
            (b.type == V_INT64 || b.type == V_FLOAT64)) {
            double av = (a.type == V_FLOAT64) ? a.as.f64 : (double)a.as.i64;
            double bv = (b.type == V_FLOAT64) ? b.as.f64 : (double)b.as.i64;
            return av == bv;
        }
        return false;
    }
    switch (a.type) {
        case V_NULL:    return true;
        case V_BOOL:
        case V_INT64:   return a.as.i64 == b.as.i64;
        case V_FLOAT64: return a.as.f64 == b.as.f64;
        case V_STRING:  return strcmp(a.as.str, b.as.str) == 0;
        case V_MAP: {
            VyneMap* am = a.as.map;
            VyneMap* bm = b.as.map;
            if (am == bm) return true;
            if (am->size != bm->size) return false;
            int checked = 0;
            for (int i = 0; i < am->capacity && checked < am->size; i++) {
                const char* key = am->entries[i].key;
                if (key == NULL || key == VYNE_TOMBSTONE) continue;
                int idx = _vyne_map_find(bm, key);
                if (idx < 0) return false;
                if (!vyne_values_equal(am->entries[i].value, bm->entries[idx].value))
                    return false;
                checked++;
            }
            return true;
        }
        default:        return false;
    }
}

// ============================================================================
